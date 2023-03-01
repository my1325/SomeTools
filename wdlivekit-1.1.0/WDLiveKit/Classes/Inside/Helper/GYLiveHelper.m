//
//  GYLiveHelper.m
//  Woohoo
//
//  Created by M2-mini on 2021/8/24.
//

#import "GYLiveHelper.h"
#import <WDLiveKit/WDLiveKit-Swift.h>
#import "GYLiveThrottle.h"

@interface GYLiveHelper ()

/// 礼物定时器
@property (nonatomic, strong) NSTimer *giftTimer;
/// 直播间常驻定时
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger sec;
/// 上一次送的礼物
@property (nonatomic, strong) GYLiveGift * __nullable lastGift;
/// 礼物连击
@property (nonatomic, assign) NSInteger giftCombo;

/// 小窗拖动
@property (nonatomic, assign) CGPoint point;

@property (nonatomic, strong) GYLiveThrottle *throttle;

@end

@implementation GYLiveHelper

+ (GYLiveHelper *)helper
{
    static GYLiveHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[GYLiveHelper alloc] init];
    });
    return helper;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self fb_config];
        _throttle = [[GYLiveThrottle alloc] init];
        _throttle.threshold = 2.0;
    }
    return self;
}

#pragma mark - Init

- (void)fb_config
{
    self.pkInTimeUp = -1;
    self.pkTimeUpEnd = -1;
    self.pkInEnd = -1;
}

- (void)fb_openLiveTiemrs
{
    self.liveInOut = 0;
    self.sec = 3;
    
    kGYWeakSelf;
    // 直播间计时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
        GYLog(@"live debug - live countdown: %ld", weakSelf.liveInOut);
        //
        if (weakSelf.liveInOut > 20 * 60) weakSelf.homeReloadTag = YES;
        // 60s弹窗关注
        if (weakSelf.liveInOut == 60 && weakSelf.followAutoTipBlock) weakSelf.followAutoTipBlock();
        // PK送礼统计
        [weakSelf fb_pkEventsGifts1To5MinIfBeforeEnding:NO];
        // 计时
        if (weakSelf.pkInTimeUp != -1) weakSelf.pkInTimeUp ++;
        if (weakSelf.pkTimeUpEnd != -1) weakSelf.pkTimeUpEnd ++;
        if (weakSelf.pkInEnd != -1) weakSelf.pkInEnd ++;
        weakSelf.liveInOut ++;
        
    } repeats:YES];

    // 礼物定时器（combo）
    self.giftTimer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
        GYLog(@"live debug - gift countdown: %ld", weakSelf.sec);
        // 礼物combo消失，暂停定时器
        if (weakSelf.sec == 0) {
            [weakSelf.giftTimer setFireDate:[NSDate distantFuture]];
            weakSelf.lastGift = nil;
        }
        weakSelf.sec--;
        
    } repeats:YES];
    [self.giftTimer setFireDate:[NSDate distantFuture]];
}

#pragma mark - Agora Network Join Leave

/// 加入房间
/// @param rooms 房间数组
/// @param index 下标
/// @param success 成功
/// @param failure 失败
- (void)fb_openLiveWith:(NSArray<GYLiveRoom *> *)rooms
                 atIndex:(NSInteger)index
                 success:(GYLiveObjectBlock)success
                 failure:(GYLiveVoidBlock)failure
{
    kGYWeakSelf;
    NSLog(@"加入房间1");
    [self.throttle doAction:^{
        NSLog(@"加入房间2");
        GYLiveRoom *room = rooms[index];
        if (room == nil) return;
        // 加入rtc
        [kGYLiveAgoraHelper fb_initAgoraRtc];
        [kGYLiveAgoraHelper fb_joinAgoraRtcWithAgoraRoomId:room.agoraRoomId completion:nil];
        // 加入net
        
        [GYLiveNetworkHelper fb_joinRoomByHostId:room.hostAccountId success:^(id  _Nullable object) {
            GYLiveRoom *room = (GYLiveRoom *)object;
            if (room == nil) {
                failure();
                [weakSelf fb_joinFailWithRoom:room];
                return;
            }
            // 更新数据
            [weakSelf.data fb_updateWith:room operationBlock:^GYLiveDataOperation(NSInteger index, GYLiveRoom * _Nullable old) {
                return GYLiveDataOperationReplaceAdd;
            } completionBlock:^(NSInteger index, GYLiveRoom * _Nullable old) {
            }];
            success(room);
            // 加入rtm
            [kGYLiveAgoraHelper fb_initAgoraRtm];
            [kGYLiveAgoraHelper fb_joinAgoraRtmWithAgoraRoomId:room.agoraRoomId completion:nil];
            // 统计
            [weakSelf fb_pkEventsJoined];
            
        } failure:^{
            failure();
            [weakSelf fb_joinFailWithRoom:room];
        }];
        //
        weakSelf.inARoom = YES;
        weakSelf.barrageMute = NO;
        weakSelf.homeReloadTag = NO;
        // 开启计时
        [weakSelf fb_openLiveTiemrs];
        // 计时事件
        GYLiveThinking(GYLiveThinkingEventTypeTimeEvent, GYLiveThinkingEventTimeForOneLive, nil);
    }];
}

- (void)fb_openLiveByHostId:(NSInteger)hostAccountId
                     success:(GYLiveObjectBlock)success
                     failure:(GYLiveVoidBlock)failure
{
    kGYWeakSelf;
    [self.throttle doAction:^{
        // 加入net
        [GYLiveNetworkHelper fb_joinRoomByHostId:hostAccountId success:^(id  _Nullable object) {
            GYLiveRoom *room = (GYLiveRoom *)object;
            if (room == nil) {
                failure();
                [weakSelf fb_joinFailWithRoom:room];
                return;
            }
            success(room);
            // 加入rtc
            [kGYLiveAgoraHelper fb_initAgoraRtc];
            [kGYLiveAgoraHelper fb_joinAgoraRtcWithAgoraRoomId:room.agoraRoomId completion:nil];
            // 加入rtm
            [kGYLiveAgoraHelper fb_initAgoraRtm];
            [kGYLiveAgoraHelper fb_joinAgoraRtmWithAgoraRoomId:room.agoraRoomId completion:nil];
            // 统计
            [weakSelf fb_pkEventsJoined];
            
        } failure:^{
            failure();
            [weakSelf fb_joinFailWithRoom:nil];
        }];
        //
        weakSelf.inARoom = YES;
        weakSelf.barrageMute = NO;
        weakSelf.homeReloadTag = NO;
        // 开启计时
        [self fb_openLiveTiemrs];
        // 计时事件
        GYLiveThinking(GYLiveThinkingEventTypeTimeEvent, GYLiveThinkingEventTimeForOneLive, nil);
        
    }];
}

/// 切换房间
/// @param index 下标
/// @param success 完成
/// @param failure 失败
- (void)fb_switchToIndex:(NSInteger)index
                  success:(GYLiveObjectBlock)success
                  failure:(GYLiveVoidBlock)failure
{
    GYLiveRoom *room = self.data.rooms[index];
    if (room == nil) return;
    // 加入net
    kGYWeakSelf;
    [GYLiveNetworkHelper fb_joinRoomByHostId:room.hostAccountId success:^(id  _Nullable object) {
        
        GYLiveRoom *current = (GYLiveRoom *)object;
        if (room.hostAccountId == current.hostAccountId) {
            // 数据先行
            [weakSelf.data fb_updateWith:current operationBlock:^GYLiveDataOperation(NSInteger index, GYLiveRoom * _Nullable old) {
                return GYLiveDataOperationReplaceAdd;
            } completionBlock:^(NSInteger index, GYLiveRoom * _Nullable old) {
            }];
            success(current);
            // 加入rtm
            [kGYLiveAgoraHelper fb_joinAgoraRtmWithAgoraRoomId:current.agoraRoomId completion:^{
            }];
            // 统计
            [weakSelf fb_pkEventsJoined];
        }
    } failure:^{
        failure();
    }];

    kGYLiveAgoraHelper.videoView.frame = kGYLiveHelper.ui.homeVideoRect;
    
    kGYLiveHelper.inARoom = YES;
    kGYLiveHelper.barrageMute = NO;
    kGYLiveHelper.liveInOut = 0;
    // 计时事件
    GYLiveThinking(GYLiveThinkingEventTypeTimeEvent, GYLiveThinkingEventTimeForOneLive, nil);
}

/// 滑动切换房间退出当前
/// @param index 下标
- (void)fb_switchLeaveFromIndex:(NSInteger)index
{
    GYLiveRoom *room = self.data.rooms[index];
    // 接口退出
    if (room) {
        [GYLiveNetworkHelper fb_leaveRoomWithRoomId:room.roomId success:^(GYLiveRoom * _Nullable room) {
        } failure:^{
        }];
    }
    // rtm退出（rtc直接在滑动加入房间时调用切换频道）
    [kGYLiveAgoraHelper fb_leaveRtmChannelWithCompletion:nil];
    
    // 统计
    [self fb_pkEventsEndingProcess];
    GYEvent(@"fb_LiveBetweenEnterAndClose", @{@"duration": @(self.liveInOut)});
    
//    BOOL flag = (kGYLiveManager.inside.account.abTestFlag & 550) > 0;
    GYLiveThinking(GYLiveThinkingEventTypeEvent, GYLiveThinkingEventTimeForOneLive, (@{
        GYLiveThinkingKeyFrom: kGYLiveManager.inside.fromJoin ?: @""
//        @"abTestFlag": flag ? @"A" : @"B"
    }));
    kGYLiveManager.inside.fromJoin = nil;
    
    self.pkInSendCoins = 0;
    self.last15SendCoins = 0;
    
    self.giftCombo = 0;
    [self.giftTimer setFireDate:[NSDate distantFuture]];
    //
    kGYLiveHelper.comboing = -1;
    [GYLiveComboViewManager.shared fb_removeCurrentViewFromSuperView];
    [GYLiveComboAnimator.shared stopComboAnimationWithImmediately:YES];
    UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
}

/// 其他功能需要关闭直播的处理
- (void)fb_close
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!self.inARoom) return;
        //
        kGYLiveHelper.comboing = -1;
        [GYLiveComboViewManager.shared fb_removeCurrentViewFromSuperView];
        [GYLiveComboAnimator.shared stopComboAnimationWithImmediately:YES];
        UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;

        //
        GYLiveRoom *room = self.data.current;
        // rtc rtm
        [kGYLiveAgoraHelper fb_leaveRtmRtcWithAgoraRoomId:room ? room.agoraRoomId : nil];
        // net
        if (room) {
            [GYLiveNetworkHelper fb_leaveRoomWithRoomId:room.roomId success:^(GYLiveRoom * _Nullable room) {
            } failure:^{
            }];
        }
        if (self.isMinimize) {
            // 最小化
            self.isMinimize = NO;
            //
            [self.minimizeRemoteView removeFromSuperview];
            // 定时器及UI清理
            [self.liveVc fb_clean];
            
            self.liveVc = nil;
            // 统计
            GYEvent(@"fb_LiveCloseRoomInMinimize", nil);
        } else {
            // pop
            UIViewController *vc = [GYLiveMethods fb_currentViewController];
            if ([vc isKindOfClass:[GYLiveViewController class]]) {
                // 定时器及UI清理
                [(GYLiveViewController *)vc fb_clean];
                [vc.navigationController popViewControllerAnimated:YES];
            }
        }
        self.inARoom = NO;
        self.fullScreenByMinimize = NO;
//        self.data = nil;
        GYLog(@"live debug room: close: %ld", self.data.rooms.count);
        // 定时器销毁
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        if (self.giftTimer) {
            [self.giftTimer invalidate];
            self.giftTimer = nil;
        }
        // 统计
        [self fb_pkEventsEndingProcess];
        GYEvent(@"fb_LiveBetweenEnterAndClose", @{@"duration": @(self.liveInOut)});
        
//        BOOL flag = (kGYLiveManager.inside.account.abTestFlag & 550) > 0;
        GYLiveThinking(GYLiveThinkingEventTypeEvent, GYLiveThinkingEventTimeForOneLive, (@{
            GYLiveThinkingKeyFrom: kGYLiveManager.inside.fromJoin ?: @""
//            @"abTestFlag": flag ? @"A" : @"B"
        }));
        kGYLiveManager.inside.fromJoin = nil;
        
        self.pkInSendCoins = 0;
        self.last15SendCoins = 0;
    });
}

- (void)fb_joinFailWithRoom:(GYLiveRoom * __nullable )room;
{
    // rtc rtm
    [kGYLiveAgoraHelper fb_leaveRtmRtcWithAgoraRoomId:room ? room.agoraRoomId : nil];
    // net
    if (room) {
        [GYLiveNetworkHelper fb_leaveRoomWithRoomId:room.roomId success:^(GYLiveRoom * _Nullable room) {
        } failure:^{
        }];
    }
    self.inARoom = NO;
    // 定时器销毁
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if (self.giftTimer) {
        [self.giftTimer invalidate];
        self.giftTimer = nil;
    }
}

#pragma mark - Agora Network Other Methods

/// 礼物combo
/// @param config 礼物
- (void)fb_sendGift:(GYLiveGift *)config isFast:(BOOL)isFast
{
    self.sec = 3;
    [self.giftTimer setFireDate:[NSDate distantPast]];
    kGYWeakSelf;
    [GYLiveNetworkHelper fb_userSendGiftWithGiftId:config.giftId roomId:self.data.current.roomId success:^(GYLiveRoomDiamond * _Nullable diamond) {
        GYLiveBarrage *barrage;
        if (weakSelf.lastGift.giftId == diamond.giftId) {
            weakSelf.giftCombo ++;
        } else {
            weakSelf.giftCombo = 1;
        }
        if (config.isBlindBox) {
            weakSelf.lastGift = [GYLiveGift new];
            weakSelf.lastGift.giftId = diamond.giftId;
            // 加入自己的弹幕队列
            barrage = [GYLiveBarrage messageWithGift:config combo:weakSelf.giftCombo];
            // 替换成盲盒Id
            barrage.giftId = diamond.giftId;
            barrage.isblindBox = YES;
            // 统计
            GYEvent(@"fb_liveBlindboxSendSuccess", nil);
        } else {
            weakSelf.lastGift = config;
            barrage = [GYLiveBarrage messageWithGift:config combo:weakSelf.giftCombo];
        }
        // 加入自己的弹幕队列
        if (kGYLiveAgoraHelper.receiveBarrageBlock) kGYLiveAgoraHelper.receiveBarrageBlock(barrage);
        // 接口成功再通知给别人
        [kGYLiveAgoraHelper fb_sendLiveMessageBarrage:barrage completion:nil];
        // 发送至RTM通知别人更新房间信息
        [self fb_updateMemberRankListWithGiftConfig:config];
        
        NSInteger coins = kGYLiveManager.inside.account.coins;
        // 扣款成功
        kGYLiveManager.inside.account.coins = diamond.leftDiamond;
        kGYLiveManager.inside.coinsUpdate(diamond.leftDiamond);
        // 统计
        GYEvent(@"fb_LiveTouchSendGiftSuccess", nil);
        // Firbase精细化打点
        NSInteger value = coins - kGYLiveManager.inside.account.coins;
        GYFirbase(GYLiveFirbaseEventTypeSpendCurrency, (@{@"way":@"sendGift", @"value":@(value)}));
        // Thinking
        GYLiveThinking(GYLiveThinkingEventTypeEvent, GYLiveThinkingEventSendGiftSuccess, (@{
            GYLiveThinkingKeyGiftId: @(config.giftId).stringValue,
            GYLiveThinkingKeyGiftName: config.giftName,
            GYLiveThinkingKeyGiftCoins: @(config.giftPrice),
            GYLiveThinkingKeyIsLuckyBox: @(config.isBlindBox),
            GYLiveThinkingKeyFrom: GYLiveThinkingValueLive,
            GYLiveThinkingKeyIsFast: @(isFast)
        }));
    } failure:^{
        GYTipError(kGYLocalString(@"Failed to send the gift."));
    }];
    //
    kGYLiveManager.inside.account.coins = MAX(kGYLiveManager.inside.account.coins, 0);
}

/// 送礼刷新排行榜
/// @param config 礼物
- (void)fb_updateMemberRankListWithGiftConfig:(GYLiveGift *)config
{
    // 发送至RTM通知别人更新房间信息
    GYLiveRoom *room = kGYLiveHelper.data.current;
    for (GYLiveRoomMember *member in room.videoChatRoomMembers) {
        if (member.accountId == kGYLiveManager.inside.account.accountId) {
            member.giftCost += config.giftPrice;
            // 重排
            NSMutableArray *marr = [NSMutableArray arrayWithArray:room.videoChatRoomMembers];
            [marr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                GYLiveRoomMember *m1 = (GYLiveRoomMember *)obj1;
                GYLiveRoomMember *m2 = (GYLiveRoomMember *)obj2;
                if (m1.giftCost > m2.giftCost) {
                    return NSOrderedAscending;
                } else if (m1.giftCost < m2.giftCost) {
                    return NSOrderedDescending;
                } else{
                    if (m1.accountId > m2.accountId){
                        return NSOrderedAscending;
                    }else{
                        return NSOrderedDescending;
                    }
                }
            }];
            GYLiveBarrage *barrage = [GYLiveBarrage messageWithMembers:marr];
            // 送礼，发给别人，更新排行榜
            [kGYLiveAgoraHelper fb_sendLiveMessageBarrage:barrage completion:nil];
            // 加入自己的弹幕队列
            if (kGYLiveAgoraHelper.receiveBarrageBlock) kGYLiveAgoraHelper.receiveBarrageBlock(barrage);
            break;
        }
    }
}

/// 获取房间内封禁信息
/// @param roomId agoraId
- (void)fb_getMutedMembersAndChannelAttributesWithAgoraRoomId:(NSString *)roomId
{
    // 老版本禁言 + PK对方音视频状态
    [kGYLiveAgoraHelper fb_getChannelAttributesWithRoomId:roomId];
    // 新版本禁言
    [GYLiveNetworkHelper fb_getMutedMembersWithAgoraRoomId:roomId success:^(NSArray * _Nullable arrayValue) {
        // 加入自己的弹幕队列
        GYLiveBarrage *barrage = [[GYLiveBarrage alloc] init];
        barrage.type = GYLiveBarrageTypeMutedMembers;
        barrage.content = [arrayValue mj_JSONString];
        if (kGYLiveAgoraHelper.receiveBarrageBlock) kGYLiveAgoraHelper.receiveBarrageBlock(barrage);
        
    } failure:^{
    }];
}

#pragma mark - Public Methods

- (void)fb_fullScreenAndLoading:(GYLiveVoidBlock)loadingBlock
{
    // 打开Live，移除最小化
    self.isMinimize = NO;
    self.fullScreenByMinimize = YES;
    [self.minimizeRemoteView removeFromSuperview];
    
    // 推出控制器
    if (loadingBlock) loadingBlock();
    
    // 重新设置全屏幕布
    [kGYLiveAgoraHelper fb_setupFullRemoteVideoWithUid:self.data.current.hostAccountId];
    
    // 完成之后移除
    self.liveVc = nil;
    //
    GYEvent(@"fb_LiveEnterRoomByMinimize", nil);
}

#pragma mark - 统计

- (void)fb_pkEventsJoined
{
    GYLiveRoom *room = self.data.current;
    // 统计
    if (room.pking) {
        if (room.pkData.pkLeftTime > 0) {
            // PK中
            self.pkInTimeUp = room.pkData.pkMaxDuration - room.pkData.pkLeftTime;
//            [kGYThreeEvents fb_PKBetweenMatchAndTimeUp:0];
        } else {
            // 惩罚状态
            self.pkTimeUpEnd = 0;
//            [kGYThreeEvents fb_PKBetweenTimeUpAndEnd:0];
        }
        self.pkInEnd = 0;
        // 计时事件
//        [kGYThreeEvents fb_PKBetweenJoinAndEnd:0];
        GYLiveThinking(GYLiveThinkingEventTypeTimeEvent, GYLiveThinkingEventTimeForOnePk, nil);
    }
}

/// PK中送礼统计
/// @param beforeEnding 倒计时结束之前触发
- (void)fb_pkEventsGifts1To5MinIfBeforeEnding:(BOOL)beforeEnding
{
    if (self.pkInSendCoins > 0 && self.pkInTimeUp > 0) {
        // 1~5分钟
        if (self.pkInTimeUp % 60 == 0 || (beforeEnding && self.pkInTimeUp <= 60 * 5 && self.pkInTimeUp > 0)) {
            NSInteger index = self.pkInTimeUp / 60 - 1;
            if (index >= 0 && index < 5) {
                NSArray *arr = @[GYLiveThinkingEventSendGiftsWithin1minInPk,
                                 GYLiveThinkingEventSendGiftsWithin2minInPk,
                                 GYLiveThinkingEventSendGiftsWithin3minInPk,
                                 GYLiveThinkingEventSendGiftsWithin4minInPk,
                                 GYLiveThinkingEventSendGiftsWithin5minInPk];
                NSString *event = arr[index];
                GYLiveThinking(GYLiveThinkingEventTypeEvent, event, (@{
                    GYLiveThinkingKeyCoins: @(self.pkInSendCoins)
                }));
                self.pkInSendCoins = 0;
            }
        }
    }
    // 在最后15秒钟赠送
    if (self.last15SendCoins > 0) {
        if (self.data.current.pkData.pkMaxDuration - self.pkInTimeUp == 0 || (beforeEnding && self.data.current.pkData.pkMaxDuration - self.pkInTimeUp < 15)) {
            GYLiveThinking(GYLiveThinkingEventTypeEvent, GYLiveThinkingEventSendGiftsLast15secInPk, (@{
                GYLiveThinkingKeyCoins: @(self.last15SendCoins)
            }));
            self.last15SendCoins = 0;
        }
    }
}

/// 结束PK进程时触发的统计
- (void)fb_pkEventsEndingProcess
{
    if (self.pkInTimeUp != -1) {
        GYEvent(@"fb_PKBetweenMatchAndTimeUp", @{@"duration": @(self.pkInTimeUp)});
        [kGYLiveHelper fb_pkEventsGifts1To5MinIfBeforeEnding:YES];
        self.pkInTimeUp = -1;
    }
    if (self.pkTimeUpEnd != -1) {
        GYEvent(@"fb_PKBetweenTimeUpAndEnd", @{@"duration": @(self.pkTimeUpEnd)});
        self.pkTimeUpEnd = -1;
    }
    if (self.pkInEnd != -1) {
        NSInteger min = self.pkInEnd / 60 + self.pkInEnd % 60 > 0;
        GYEvent(@"fb_PKBetweenJoinAndEnd", @{@"duration": @(min)});
        GYLiveThinking(GYLiveThinkingEventTypeEvent, GYLiveThinkingEventTimeForOnePk, nil);
        self.pkInEnd = -1;
    }
}

#pragma mark - SVG

- (void)fb_downloadSvgs
{
//    NSMutableArray *giftConfigs = [@[] mutableCopy];
//    [giftConfigs addObjectsFromArray:kGYLiveManager.inside.accountConfig.liveConfig.giftConfigs];
//    for (GYGiftConfig *config in giftConfigs) {
//        if (config.svgUrl.length == 0) {
//        } else {
//            NSString *svgname = [self fb_svgsPathWithGiftId:config.giftId];
//            // 下载路径
//            NSString *filepath = [GYFileManager svgaPathWithSvgaName:svgname inFolder:kGYFolderNameLiveSvgs];
//            if ([kGYFileManager fileExistsAtPath:filepath]) {
//            } else {
//                [GYNetworkHelper fb_downloadFileWithUrl:config.svgUrl folderName:kGYFolderNameLiveSvgs customName:nil progressBlock:^(float floatValue) {
//                } completionBlock:^(NSString *stringValue) {
//                }];
//            }
//        }
//    }
}

/// 根据giftid索引本地svga文件
/// @param giftId 礼物id
- (NSString * __nullable )fb_svgsPathWithGiftId:(NSInteger)giftId
{
    NSString *svgPath;
    NSMutableArray *giftConfigs = [@[] mutableCopy];
    [giftConfigs addObjectsFromArray:kGYLiveManager.inside.accountConfig.liveConfig.giftConfigs];
    for (GYLiveGift *config in giftConfigs) {
        if (config.giftId == giftId) {
            if (config.svgUrl.length == 0) {
            } else {
                svgPath = [[config.svgUrl componentsSeparatedByString:@"/"] lastObject];
            }
            return svgPath;
        }
    }
    return svgPath;
}

/// 礼物svga
/// @param player 播放器
/// @param parser parser
/// @param gift 礼物
/// @param success 成功
/// @param failure 失败
- (void)fb_svgaPlayer:(SVGAPlayer *)player
               parser:(SVGAParser *)parser
     playSvgaWithGift:(GYLiveGift *)gift
              success:(GYLiveVoidBlock)success
              failure:(GYLiveVoidBlock)failure
{
//    NSString *svganame = [self fb_svgsPathWithGiftId:gift.giftId];
//    NSString *filepath = [GYFileManager svgaPathWithSvgaName:svganame inFolder:kGYFolderNameLiveSvgs];
//    NSData *svgaData = [kGYFileManager contentsAtPath:filepath];
//    if (svgaData) {
//        [parser parseWithData:svgaData cacheKey:@(gift.giftId).stringValue completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
//            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//            if (videoItem != nil) {
//                player.videoItem = videoItem;
//                [player startAnimation];
//            }
//            if (success) success();
//        } failureBlock:^(NSError * _Nonnull error) {
//            if (failure) failure();
//        }];
//    } else {
    if (gift.svgUrl.length == 0) {
    } else {
        SVGAVideoEntity *cacheItem = [SVGAVideoEntity readCache:[gift.svgUrl fb_md5Hash].uppercaseString];
        if (cacheItem) {
            player.videoItem = cacheItem;
            [player startAnimation];
            if (success) success();
        } else {
            [parser parseWithURL:[NSURL URLWithString:gift.svgUrl] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
                if (videoItem != nil) {
                    player.videoItem = videoItem;
                    [player startAnimation];
                }
                if (success) success();
            } failureBlock:^(NSError * _Nonnull error) {
                if (failure) failure();
            }];
        }
    }
//    }
}

/// 播放本地svga文件
/// @param player player
/// @param parser parser
/// @param svga 文件
- (void)fb_svgaPlayer:(SVGAPlayer *)player
               parser:(SVGAParser *)parser
   playWithBundleSvga:(NSString *)svga
              success:(GYLiveVoidBlock)success
              failure:(GYLiveVoidBlock)failure
{
    [parser parseWithNamed:svga inBundle:kGYLiveBundle completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
        if (videoItem != nil) {
            player.videoItem = videoItem;
            [player startAnimation];
        }
        if (success) success();
    } failureBlock:^(NSError * _Nonnull error) {
        if (failure) failure();
    }];
}

#pragma mark - UIPanGestureRecognizer

- (void)panGes:(UIPanGestureRecognizer *)ges
{
    UIWindow *fullView = [UIApplication sharedApplication].keyWindow;
    switch (ges.state) {
        case UIGestureRecognizerStateChanged:
        {
            CGPoint move = [ges translationInView:fullView];
            CGFloat x = move.x + self.point.x;
            CGFloat y = move.y + self.point.y;
            self.minimizeRemoteView.x = x;
            self.minimizeRemoteView.y = y;
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            // 动画
            CGFloat x = self.minimizeRemoteView.x;
            CGFloat y = self.minimizeRemoteView.y;
            if (x + self.minimizeRemoteView.width/2 < kGYScreenWidth/2) {
                // 贴近左边
                if (y < kGYStatusBarHeight) {
                    y = kGYStatusBarHeight;
                }
                if (y > kGYScreenHeight - kGYBottomSafeHeight - self.minimizeRemoteView.height) {
                    y = kGYScreenHeight - kGYBottomSafeHeight - self.minimizeRemoteView.height;
                }
                [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:12 initialSpringVelocity:0.95 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.minimizeRemoteView.x = 0;
                    self.minimizeRemoteView.y = y;
                } completion:^(BOOL finished) {
                    self.point = self.minimizeRemoteView.origin;
                }];
            } else {
                // 贴近右边
                if (y < kGYStatusBarHeight) {
                    y = kGYStatusBarHeight;
                }
                if (y > kGYScreenHeight - kGYBottomSafeHeight - self.minimizeRemoteView.height) {
                    y = kGYScreenHeight - kGYBottomSafeHeight - self.minimizeRemoteView.height;
                }
                [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:12 initialSpringVelocity:0.95 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.minimizeRemoteView.x = kGYScreenWidth - self.minimizeRemoteView.width;
                    self.minimizeRemoteView.y = y;
                } completion:^(BOOL finished) {
                    self.point = self.minimizeRemoteView.origin;
                }];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - Getter

- (GYLiveDataManager *)data
{
    if (!_data) {
        _data = [[GYLiveDataManager alloc] init];
    }
    return _data;
}

- (GYLiveUIHelper *)ui
{
    if (!_ui) {
        _ui = [[GYLiveUIHelper alloc] init];
    }
    return _ui;
}

- (GYLiveRemoteView *)minimizeRemoteView
{
    if (!_minimizeRemoteView) {
        CGFloat width = kGYWidthScale(100);
        CGFloat height = kGYWidthScale(160);
        _minimizeRemoteView = [[GYLiveRemoteView alloc] initWithFrame:CGRectMake(kGYScreenWidth - width, kGYScreenHeight - height - kGYBottomSafeHeight - 100, width, height)];
        [_minimizeRemoteView.backgroudImageView setImage:[kGYLiveManager.config.avatar imageByBlurDark]];
        _minimizeRemoteView.closeButton.hidden = NO;
        _minimizeRemoteView.maskButton.hidden = NO;
        _minimizeRemoteView.layer.cornerRadius = 4;
        kGYWeakSelf;
        _minimizeRemoteView.closeBlock = ^{
            // 关闭Live
            [kGYLiveHelper fb_close];
            // 移除最小化
            [weakSelf.minimizeRemoteView removeFromSuperview];
            //
            GYLiveThinking(GYLiveThinkingEventTypeEvent, GYLiveThinkingEventCloseLiveByMinimize, nil);
        };
        _minimizeRemoteView.maskBlock = ^{
            // 打开Live，移除最小化
            [weakSelf fb_fullScreenAndLoading:^{
                weakSelf.liveVc.modalPresentationStyle = UIModalPresentationFullScreen;
                [[GYLiveMethods fb_currentViewController].navigationController pushViewController:weakSelf.liveVc animated:YES];
            }];
            GYLiveThinking(GYLiveThinkingEventTypeEvent, GYLiveThinkingEventReturnLiveByMinimize, nil);
        };
        kGYLiveAgoraHelper.receivedMininizeVideoBlock = ^(UIView * _Nonnull videoView) {
            weakSelf.minimizeRemoteView.videoView = videoView;
        };
        kGYLiveAgoraHelper.receivePkVideoBlock = ^(UIView * _Nullable videoView) {
            weakSelf.minimizeRemoteView.pkVideoView = videoView;
        };
        // 拖动
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGes:)];
        [_minimizeRemoteView addGestureRecognizer:panGes];
        self.point = self.minimizeRemoteView.origin;
    }
    return _minimizeRemoteView;
}

#pragma mark - Setter

- (void)setLiveVc:(GYLiveViewController *)liveVc
{
    _liveVc = liveVc;
    if (liveVc) {
        // 设置最小化
        // 高斯模糊背景
        kGYWeakSelf;
        [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:self.data.current.roomCover] options:SDWebImageDelayPlaceholder progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            UIImage *blureImage = image ?: kGYLiveManager.config.avatar;
            [weakSelf.minimizeRemoteView.backgroudImageView setImage:[blureImage imageByBlurDark]];
        }];
        // 重设最小化幕布
        [kGYLiveAgoraHelper fb_setupMininzeRemoteVideoWithUid:self.data.current.hostAccountId];
        // 加入UI
        [[UIApplication sharedApplication].keyWindow addSubview:self.minimizeRemoteView];
        //
        self.isMinimize = YES;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!self.data.current.beActive) [self fb_close];
        });
    }
}

//- (void)setRemindAgain:(BOOL)remindAgain
//{
//    [kGYUserDefaults setBool:remindAgain forKey:@"GYLiveRemindAgain"];
//}
//
//- (BOOL)remindAgain
//{
//    return [kGYUserDefaults boolForKey:@"GYLiveRemindAgain"];
//}

@end
