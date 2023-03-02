//
//  LJLiveHelper.m
//  Woohoo
//
//  Created by M2-mini on 2021/8/24.
//

#import "LJLiveHelper.h"
#import <LGLiveKit/LGLiveKit-Swift.h>
#import "LJLiveThrottle.h"

@interface LJLiveHelper ()

/// 礼物定时器
@property (nonatomic, strong) NSTimer *giftTimer;
/// 直播间常驻定时
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger sec;
/// 上一次送的礼物
@property (nonatomic, strong) LJLiveGift * __nullable lastGift;
/// 礼物连击
@property (nonatomic, assign) NSInteger giftCombo;

/// 小窗拖动
@property (nonatomic, assign) CGPoint point;

@property (nonatomic, strong) LJLiveThrottle *throttle;

@end

@implementation LJLiveHelper

+ (LJLiveHelper *)helper
{
    static LJLiveHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[LJLiveHelper alloc] init];
    });
    return helper;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self lj_config];
        _throttle = [[LJLiveThrottle alloc] init];
        _throttle.threshold = 2.0;
    }
    return self;
}

#pragma mark - Init

- (void)lj_config
{
    self.pkInTimeUp = -1;
    self.pkTimeUpEnd = -1;
    self.pkInEnd = -1;
}

- (void)lj_openLiveTiemrs
{
    self.liveInOut = 0;
    self.sec = 3;
    
    kLJWeakSelf;
    // 直播间计时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
        LJLog(@"live debug - live countdown: %ld", weakSelf.liveInOut);
        //
        if (weakSelf.liveInOut > 20 * 60) weakSelf.homeReloadTag = YES;
        // 60s弹窗关注
        if (weakSelf.liveInOut == 60 && weakSelf.followAutoTipBlock) weakSelf.followAutoTipBlock();
        // PK送礼统计
        [weakSelf lj_pkEventsGifts1To5MinIfBeforeEnding:NO];
        // 计时
        if (weakSelf.pkInTimeUp != -1) weakSelf.pkInTimeUp ++;
        if (weakSelf.pkTimeUpEnd != -1) weakSelf.pkTimeUpEnd ++;
        if (weakSelf.pkInEnd != -1) weakSelf.pkInEnd ++;
        weakSelf.liveInOut ++;
        
    } repeats:YES];

    // 礼物定时器（combo）
    self.giftTimer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
        LJLog(@"live debug - gift countdown: %ld", weakSelf.sec);
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
- (void)lj_openLiveWith:(NSArray<LJLiveRoom *> *)rooms
                 atIndex:(NSInteger)index
                 success:(LJLiveObjectBlock)success
                 failure:(LJLiveVoidBlock)failure
{
    kLJWeakSelf;
    NSLog(@"加入房间1");
    [self.throttle doAction:^{
        NSLog(@"加入房间2");
        LJLiveRoom *room = rooms[index];
        if (room == nil) return;
        // 加入rtc
        [kLJLiveAgoraHelper lj_initAgoraRtc];
        [kLJLiveAgoraHelper lj_joinAgoraRtcWithAgoraRoomId:room.agoraRoomId completion:nil];
        // 加入net
        
        [LJLiveNetworkHelper lj_joinRoomByHostId:room.hostAccountId success:^(id  _Nullable object) {
            LJLiveRoom *room = (LJLiveRoom *)object;
            if (room == nil) {
                failure();
                [weakSelf lj_joinFailWithRoom:room];
                return;
            }
            // 更新数据
            [weakSelf.data lj_updateWith:room operationBlock:^LJLiveDataOperation(NSInteger index, LJLiveRoom * _Nullable old) {
                return LJLiveDataOperationReplaceAdd;
            } completionBlock:^(NSInteger index, LJLiveRoom * _Nullable old) {
            }];
            success(room);
            // 加入rtm
            [kLJLiveAgoraHelper lj_initAgoraRtm];
            [kLJLiveAgoraHelper lj_joinAgoraRtmWithAgoraRoomId:room.agoraRoomId completion:nil];
            // 统计
            [weakSelf lj_pkEventsJoined];
            
        } failure:^{
            failure();
            [weakSelf lj_joinFailWithRoom:room];
        }];
        //
        weakSelf.inARoom = YES;
        weakSelf.barrageMute = NO;
        weakSelf.homeReloadTag = NO;
        // 开启计时
        [weakSelf lj_openLiveTiemrs];
        // 计时事件
        LJLiveThinking(LJLiveThinkingEventTypeTimeEvent, LJLiveThinkingEventTimeForOneLive, nil);
    }];
}

- (void)lj_openLiveByHostId:(NSInteger)hostAccountId
                     success:(LJLiveObjectBlock)success
                     failure:(LJLiveVoidBlock)failure
{
    kLJWeakSelf;
    [self.throttle doAction:^{
        // 加入net
        [LJLiveNetworkHelper lj_joinRoomByHostId:hostAccountId success:^(id  _Nullable object) {
            LJLiveRoom *room = (LJLiveRoom *)object;
            if (room == nil) {
                failure();
                [weakSelf lj_joinFailWithRoom:room];
                return;
            }
            success(room);
            // 加入rtc
            [kLJLiveAgoraHelper lj_initAgoraRtc];
            [kLJLiveAgoraHelper lj_joinAgoraRtcWithAgoraRoomId:room.agoraRoomId completion:nil];
            // 加入rtm
            [kLJLiveAgoraHelper lj_initAgoraRtm];
            [kLJLiveAgoraHelper lj_joinAgoraRtmWithAgoraRoomId:room.agoraRoomId completion:nil];
            // 统计
            [weakSelf lj_pkEventsJoined];
            
        } failure:^{
            failure();
            [weakSelf lj_joinFailWithRoom:nil];
        }];
        //
        weakSelf.inARoom = YES;
        weakSelf.barrageMute = NO;
        weakSelf.homeReloadTag = NO;
        // 开启计时
        [self lj_openLiveTiemrs];
        // 计时事件
        LJLiveThinking(LJLiveThinkingEventTypeTimeEvent, LJLiveThinkingEventTimeForOneLive, nil);
        
    }];
}

/// 切换房间
/// @param index 下标
/// @param success 完成
/// @param failure 失败
- (void)lj_switchToIndex:(NSInteger)index
                  success:(LJLiveObjectBlock)success
                  failure:(LJLiveVoidBlock)failure
{
    LJLiveRoom *room = self.data.rooms[index];
    if (room == nil) return;
    // 加入net
    kLJWeakSelf;
    [LJLiveNetworkHelper lj_joinRoomByHostId:room.hostAccountId success:^(id  _Nullable object) {
        
        LJLiveRoom *current = (LJLiveRoom *)object;
        if (room.hostAccountId == current.hostAccountId) {
            // 数据先行
            [weakSelf.data lj_updateWith:current operationBlock:^LJLiveDataOperation(NSInteger index, LJLiveRoom * _Nullable old) {
                return LJLiveDataOperationReplaceAdd;
            } completionBlock:^(NSInteger index, LJLiveRoom * _Nullable old) {
            }];
            success(current);
            // 加入rtm
            [kLJLiveAgoraHelper lj_joinAgoraRtmWithAgoraRoomId:current.agoraRoomId completion:^{
            }];
            // 统计
            [weakSelf lj_pkEventsJoined];
        }
    } failure:^{
        failure();
    }];

    kLJLiveAgoraHelper.videoView.frame = kLJLiveHelper.ui.homeVideoRect;
    
    kLJLiveHelper.inARoom = YES;
    kLJLiveHelper.barrageMute = NO;
    kLJLiveHelper.liveInOut = 0;
    // 计时事件
    LJLiveThinking(LJLiveThinkingEventTypeTimeEvent, LJLiveThinkingEventTimeForOneLive, nil);
}

/// 滑动切换房间退出当前
/// @param index 下标
- (void)lj_switchLeaveFromIndex:(NSInteger)index
{
    LJLiveRoom *room = self.data.rooms[index];
    // 接口退出
    if (room) {
        [LJLiveNetworkHelper lj_leaveRoomWithRoomId:room.roomId success:^(LJLiveRoom * _Nullable room) {
        } failure:^{
        }];
    }
    // rtm退出（rtc直接在滑动加入房间时调用切换频道）
    [kLJLiveAgoraHelper lj_leaveRtmChannelWithCompletion:nil];
    
    // 统计
    [self lj_pkEventsEndingProcess];
    LJEvent(@"lj_LiveBetweenEnterAndClose", @{@"duration": @(self.liveInOut)});
    
//    BOOL flag = (kLJLiveManager.inside.account.abTestFlag & 550) > 0;
    LJLiveThinking(LJLiveThinkingEventTypeEvent, LJLiveThinkingEventTimeForOneLive, (@{
        LJLiveThinkingKeyFrom: kLJLiveManager.inside.fromJoin ?: @""
//        @"abTestFlag": flag ? @"A" : @"B"
    }));
    kLJLiveManager.inside.fromJoin = nil;
    
    self.pkInSendCoins = 0;
    self.last15SendCoins = 0;
    
    self.giftCombo = 0;
    [self.giftTimer setFireDate:[NSDate distantFuture]];
    //
    kLJLiveHelper.comboing = -1;
    [LJLiveComboViewManager.shared lj_removeCurrentViewFromSuperView];
    [LJLiveComboAnimator.shared stopComboAnimationWithImmediately:YES];
    UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
}

/// 其他功能需要关闭直播的处理
- (void)lj_close
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!self.inARoom) return;
        //
        kLJLiveHelper.comboing = -1;
        [LJLiveComboViewManager.shared lj_removeCurrentViewFromSuperView];
        [LJLiveComboAnimator.shared stopComboAnimationWithImmediately:YES];
        UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;

        //
        LJLiveRoom *room = self.data.current;
        // rtc rtm
        [kLJLiveAgoraHelper lj_leaveRtmRtcWithAgoraRoomId:room ? room.agoraRoomId : nil];
        // net
        if (room) {
            [LJLiveNetworkHelper lj_leaveRoomWithRoomId:room.roomId success:^(LJLiveRoom * _Nullable room) {
            } failure:^{
            }];
        }
        if (self.isMinimize) {
            // 最小化
            self.isMinimize = NO;
            //
            [self.minimizeRemoteView removeFromSuperview];
            // 定时器及UI清理
            [self.liveVc lj_clean];
            
            self.liveVc = nil;
            // 统计
            LJEvent(@"lj_LiveCloseRoomInMinimize", nil);
        } else {
            // pop
            UIViewController *vc = [LJLiveMethods lj_currentViewController];
            if ([vc isKindOfClass:[LJLiveViewController class]]) {
                // 定时器及UI清理
                [(LJLiveViewController *)vc lj_clean];
                [vc.navigationController popViewControllerAnimated:YES];
            }
        }
        self.inARoom = NO;
        self.fullScreenByMinimize = NO;
//        self.data = nil;
        LJLog(@"live debug room: close: %ld", self.data.rooms.count);
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
        [self lj_pkEventsEndingProcess];
        LJEvent(@"lj_LiveBetweenEnterAndClose", @{@"duration": @(self.liveInOut)});
        
//        BOOL flag = (kLJLiveManager.inside.account.abTestFlag & 550) > 0;
        LJLiveThinking(LJLiveThinkingEventTypeEvent, LJLiveThinkingEventTimeForOneLive, (@{
            LJLiveThinkingKeyFrom: kLJLiveManager.inside.fromJoin ?: @""
//            @"abTestFlag": flag ? @"A" : @"B"
        }));
        kLJLiveManager.inside.fromJoin = nil;
        
        self.pkInSendCoins = 0;
        self.last15SendCoins = 0;
    });
}

- (void)lj_joinFailWithRoom:(LJLiveRoom * __nullable )room;
{
    // rtc rtm
    [kLJLiveAgoraHelper lj_leaveRtmRtcWithAgoraRoomId:room ? room.agoraRoomId : nil];
    // net
    if (room) {
        [LJLiveNetworkHelper lj_leaveRoomWithRoomId:room.roomId success:^(LJLiveRoom * _Nullable room) {
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
- (void)lj_sendGift:(LJLiveGift *)config isFast:(BOOL)isFast
{
    self.sec = 3;
    [self.giftTimer setFireDate:[NSDate distantPast]];
    kLJWeakSelf;
    [LJLiveNetworkHelper lj_userSendGiftWithGiftId:config.giftId roomId:self.data.current.roomId success:^(LJLiveRoomDiamond * _Nullable diamond) {
        LJLiveBarrage *barrage;
        if (weakSelf.lastGift.giftId == diamond.giftId) {
            weakSelf.giftCombo ++;
        } else {
            weakSelf.giftCombo = 1;
        }
        if (config.isBlindBox) {
            weakSelf.lastGift = [LJLiveGift new];
            weakSelf.lastGift.giftId = diamond.giftId;
            // 加入自己的弹幕队列
            barrage = [LJLiveBarrage messageWithGift:config combo:weakSelf.giftCombo];
            // 替换成盲盒Id
            barrage.giftId = diamond.giftId;
            barrage.isblindBox = YES;
            // 统计
            LJEvent(@"lj_liveBlindboxSendSuccess", nil);
        } else {
            weakSelf.lastGift = config;
            barrage = [LJLiveBarrage messageWithGift:config combo:weakSelf.giftCombo];
        }
        // 加入自己的弹幕队列
        if (kLJLiveAgoraHelper.receiveBarrageBlock) kLJLiveAgoraHelper.receiveBarrageBlock(barrage);
        // 接口成功再通知给别人
        [kLJLiveAgoraHelper lj_sendLiveMessageBarrage:barrage completion:nil];
        // 发送至RTM通知别人更新房间信息
        [self lj_updateMemberRankListWithGiftConfig:config];
        
        NSInteger coins = kLJLiveManager.inside.account.coins;
        // 扣款成功
        kLJLiveManager.inside.account.coins = diamond.leftDiamond;
        kLJLiveManager.inside.coinsUpdate(diamond.leftDiamond);
        // 统计
        LJEvent(@"lj_LiveTouchSendGiftSuccess", nil);
        // Firbase精细化打点
        NSInteger value = coins - kLJLiveManager.inside.account.coins;
        LJFirbase(LJLiveFirbaseEventTypeSpendCurrency, (@{@"way":@"sendGift", @"value":@(value)}));
        // Thinking
        LJLiveThinking(LJLiveThinkingEventTypeEvent, LJLiveThinkingEventSendGiftSuccess, (@{
            LJLiveThinkingKeyGiftId: @(config.giftId).stringValue,
            LJLiveThinkingKeyGiftName: config.giftName,
            LJLiveThinkingKeyGiftCoins: @(config.giftPrice),
            LJLiveThinkingKeyIsLuckyBox: @(config.isBlindBox),
            LJLiveThinkingKeyFrom: LJLiveThinkingValueLive,
            LJLiveThinkingKeyIsFast: @(isFast)
        }));
    } failure:^{
        LJTipError(kLJLocalString(@"Failed to send the gift."));
    }];
    //
    kLJLiveManager.inside.account.coins = MAX(kLJLiveManager.inside.account.coins, 0);
}

/// 送礼刷新排行榜
/// @param config 礼物
- (void)lj_updateMemberRankListWithGiftConfig:(LJLiveGift *)config
{
    // 发送至RTM通知别人更新房间信息
    LJLiveRoom *room = kLJLiveHelper.data.current;
    for (LJLiveRoomMember *member in room.videoChatRoomMembers) {
        if (member.accountId == kLJLiveManager.inside.account.accountId) {
            member.giftCost += config.giftPrice;
            // 重排
            NSMutableArray *marr = [NSMutableArray arrayWithArray:room.videoChatRoomMembers];
            [marr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                LJLiveRoomMember *m1 = (LJLiveRoomMember *)obj1;
                LJLiveRoomMember *m2 = (LJLiveRoomMember *)obj2;
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
            LJLiveBarrage *barrage = [LJLiveBarrage messageWithMembers:marr];
            // 送礼，发给别人，更新排行榜
            [kLJLiveAgoraHelper lj_sendLiveMessageBarrage:barrage completion:nil];
            // 加入自己的弹幕队列
            if (kLJLiveAgoraHelper.receiveBarrageBlock) kLJLiveAgoraHelper.receiveBarrageBlock(barrage);
            break;
        }
    }
}

/// 获取房间内封禁信息
/// @param roomId agoraId
- (void)lj_getMutedMembersAndChannelAttributesWithAgoraRoomId:(NSString *)roomId
{
    // 老版本禁言 + PK对方音视频状态
    [kLJLiveAgoraHelper lj_getChannelAttributesWithRoomId:roomId];
    // 新版本禁言
    [LJLiveNetworkHelper lj_getMutedMembersWithAgoraRoomId:roomId success:^(NSArray * _Nullable arrayValue) {
        // 加入自己的弹幕队列
        LJLiveBarrage *barrage = [[LJLiveBarrage alloc] init];
        barrage.type = LJLiveBarrageTypeMutedMembers;
        barrage.content = [arrayValue mj_JSONString];
        if (kLJLiveAgoraHelper.receiveBarrageBlock) kLJLiveAgoraHelper.receiveBarrageBlock(barrage);
        
    } failure:^{
    }];
}

#pragma mark - Public Methods

- (void)lj_fullScreenAndLoading:(LJLiveVoidBlock)loadingBlock
{
    // 打开Live，移除最小化
    self.isMinimize = NO;
    self.fullScreenByMinimize = YES;
    [self.minimizeRemoteView removeFromSuperview];
    
    // 推出控制器
    if (loadingBlock) loadingBlock();
    
    // 重新设置全屏幕布
    [kLJLiveAgoraHelper lj_setupFullRemoteVideoWithUid:self.data.current.hostAccountId];
    
    // 完成之后移除
    self.liveVc = nil;
    //
    LJEvent(@"lj_LiveEnterRoomByMinimize", nil);
}

#pragma mark - 统计

- (void)lj_pkEventsJoined
{
    LJLiveRoom *room = self.data.current;
    // 统计
    if (room.pking) {
        if (room.pkData.pkLeftTime > 0) {
            // PK中
            self.pkInTimeUp = room.pkData.pkMaxDuration - room.pkData.pkLeftTime;
//            [kLJThreeEvents lj_PKBetweenMatchAndTimeUp:0];
        } else {
            // 惩罚状态
            self.pkTimeUpEnd = 0;
//            [kLJThreeEvents lj_PKBetweenTimeUpAndEnd:0];
        }
        self.pkInEnd = 0;
        // 计时事件
//        [kLJThreeEvents lj_PKBetweenJoinAndEnd:0];
        LJLiveThinking(LJLiveThinkingEventTypeTimeEvent, LJLiveThinkingEventTimeForOnePk, nil);
    }
}

/// PK中送礼统计
/// @param beforeEnding 倒计时结束之前触发
- (void)lj_pkEventsGifts1To5MinIfBeforeEnding:(BOOL)beforeEnding
{
    if (self.pkInSendCoins > 0 && self.pkInTimeUp > 0) {
        // 1~5分钟
        if (self.pkInTimeUp % 60 == 0 || (beforeEnding && self.pkInTimeUp <= 60 * 5 && self.pkInTimeUp > 0)) {
            NSInteger index = self.pkInTimeUp / 60 - 1;
            if (index >= 0 && index < 5) {
                NSArray *arr = @[LJLiveThinkingEventSendGiftsWithin1minInPk,
                                 LJLiveThinkingEventSendGiftsWithin2minInPk,
                                 LJLiveThinkingEventSendGiftsWithin3minInPk,
                                 LJLiveThinkingEventSendGiftsWithin4minInPk,
                                 LJLiveThinkingEventSendGiftsWithin5minInPk];
                NSString *event = arr[index];
                LJLiveThinking(LJLiveThinkingEventTypeEvent, event, (@{
                    LJLiveThinkingKeyCoins: @(self.pkInSendCoins)
                }));
                self.pkInSendCoins = 0;
            }
        }
    }
    // 在最后15秒钟赠送
    if (self.last15SendCoins > 0) {
        if (self.data.current.pkData.pkMaxDuration - self.pkInTimeUp == 0 || (beforeEnding && self.data.current.pkData.pkMaxDuration - self.pkInTimeUp < 15)) {
            LJLiveThinking(LJLiveThinkingEventTypeEvent, LJLiveThinkingEventSendGiftsLast15secInPk, (@{
                LJLiveThinkingKeyCoins: @(self.last15SendCoins)
            }));
            self.last15SendCoins = 0;
        }
    }
}

/// 结束PK进程时触发的统计
- (void)lj_pkEventsEndingProcess
{
    if (self.pkInTimeUp != -1) {
        LJEvent(@"lj_PKBetweenMatchAndTimeUp", @{@"duration": @(self.pkInTimeUp)});
        [kLJLiveHelper lj_pkEventsGifts1To5MinIfBeforeEnding:YES];
        self.pkInTimeUp = -1;
    }
    if (self.pkTimeUpEnd != -1) {
        LJEvent(@"lj_PKBetweenTimeUpAndEnd", @{@"duration": @(self.pkTimeUpEnd)});
        self.pkTimeUpEnd = -1;
    }
    if (self.pkInEnd != -1) {
        NSInteger min = self.pkInEnd / 60 + self.pkInEnd % 60 > 0;
        LJEvent(@"lj_PKBetweenJoinAndEnd", @{@"duration": @(min)});
        LJLiveThinking(LJLiveThinkingEventTypeEvent, LJLiveThinkingEventTimeForOnePk, nil);
        self.pkInEnd = -1;
    }
}

#pragma mark - SVG

- (void)lj_downloadSvgs
{
//    NSMutableArray *giftConfigs = [@[] mutableCopy];
//    [giftConfigs addObjectsFromArray:kLJLiveManager.inside.accountConfig.liveConfig.giftConfigs];
//    for (LJGiftConfig *config in giftConfigs) {
//        if (config.svgUrl.length == 0) {
//        } else {
//            NSString *svgname = [self lj_svgsPathWithGiftId:config.giftId];
//            // 下载路径
//            NSString *filepath = [LJFileManager svgaPathWithSvgaName:svgname inFolder:kLJFolderNameLiveSvgs];
//            if ([kLJFileManager fileExistsAtPath:filepath]) {
//            } else {
//                [LJNetworkHelper lj_downloadFileWithUrl:config.svgUrl folderName:kLJFolderNameLiveSvgs customName:nil progressBlock:^(float floatValue) {
//                } completionBlock:^(NSString *stringValue) {
//                }];
//            }
//        }
//    }
}

/// 根据giftid索引本地svga文件
/// @param giftId 礼物id
- (NSString * __nullable )lj_svgsPathWithGiftId:(NSInteger)giftId
{
    NSString *svgPath;
    NSMutableArray *giftConfigs = [@[] mutableCopy];
    [giftConfigs addObjectsFromArray:kLJLiveManager.inside.accountConfig.liveConfig.giftConfigs];
    for (LJLiveGift *config in giftConfigs) {
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
- (void)lj_svgaPlayer:(SVGAPlayer *)player
               parser:(SVGAParser *)parser
     playSvgaWithGift:(LJLiveGift *)gift
              success:(LJLiveVoidBlock)success
              failure:(LJLiveVoidBlock)failure
{
//    NSString *svganame = [self lj_svgsPathWithGiftId:gift.giftId];
//    NSString *filepath = [LJFileManager svgaPathWithSvgaName:svganame inFolder:kLJFolderNameLiveSvgs];
//    NSData *svgaData = [kLJFileManager contentsAtPath:filepath];
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
        SVGAVideoEntity *cacheItem = [SVGAVideoEntity readCache:[gift.svgUrl lj_md5Hash].uppercaseString];
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
- (void)lj_svgaPlayer:(SVGAPlayer *)player
               parser:(SVGAParser *)parser
   playWithBundleSvga:(NSString *)svga
              success:(LJLiveVoidBlock)success
              failure:(LJLiveVoidBlock)failure
{
    [parser parseWithNamed:svga inBundle:kLJLiveBundle completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
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
            if (x + self.minimizeRemoteView.width/2 < kLJScreenWidth/2) {
                // 贴近左边
                if (y < kLJStatusBarHeight) {
                    y = kLJStatusBarHeight;
                }
                if (y > kLJScreenHeight - kLJBottomSafeHeight - self.minimizeRemoteView.height) {
                    y = kLJScreenHeight - kLJBottomSafeHeight - self.minimizeRemoteView.height;
                }
                [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:12 initialSpringVelocity:0.95 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.minimizeRemoteView.x = 0;
                    self.minimizeRemoteView.y = y;
                } completion:^(BOOL finished) {
                    self.point = self.minimizeRemoteView.origin;
                }];
            } else {
                // 贴近右边
                if (y < kLJStatusBarHeight) {
                    y = kLJStatusBarHeight;
                }
                if (y > kLJScreenHeight - kLJBottomSafeHeight - self.minimizeRemoteView.height) {
                    y = kLJScreenHeight - kLJBottomSafeHeight - self.minimizeRemoteView.height;
                }
                [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:12 initialSpringVelocity:0.95 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.minimizeRemoteView.x = kLJScreenWidth - self.minimizeRemoteView.width;
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

- (LJLiveDataManager *)data
{
    if (!_data) {
        _data = [[LJLiveDataManager alloc] init];
    }
    return _data;
}

- (LJLiveUIHelper *)ui
{
    if (!_ui) {
        _ui = [[LJLiveUIHelper alloc] init];
    }
    return _ui;
}

- (LJLiveRemoteView *)minimizeRemoteView
{
    if (!_minimizeRemoteView) {
        CGFloat width = kLJWidthScale(100);
        CGFloat height = kLJWidthScale(160);
        _minimizeRemoteView = [[LJLiveRemoteView alloc] initWithFrame:CGRectMake(kLJScreenWidth - width, kLJScreenHeight - height - kLJBottomSafeHeight - 100, width, height)];
        [_minimizeRemoteView.backgroudImageView setImage:[kLJLiveManager.config.avatar imageByBlurDark]];
        _minimizeRemoteView.closeButton.hidden = NO;
        _minimizeRemoteView.maskButton.hidden = NO;
        _minimizeRemoteView.layer.cornerRadius = 4;
        kLJWeakSelf;
        _minimizeRemoteView.closeBlock = ^{
            // 关闭Live
            [kLJLiveHelper lj_close];
            // 移除最小化
            [weakSelf.minimizeRemoteView removeFromSuperview];
            //
            LJLiveThinking(LJLiveThinkingEventTypeEvent, LJLiveThinkingEventCloseLiveByMinimize, nil);
        };
        _minimizeRemoteView.maskBlock = ^{
            // 打开Live，移除最小化
            [weakSelf lj_fullScreenAndLoading:^{
                weakSelf.liveVc.modalPresentationStyle = UIModalPresentationFullScreen;
                [[LJLiveMethods lj_currentViewController].navigationController pushViewController:weakSelf.liveVc animated:YES];
            }];
            LJLiveThinking(LJLiveThinkingEventTypeEvent, LJLiveThinkingEventReturnLiveByMinimize, nil);
        };
        kLJLiveAgoraHelper.receivedMininizeVideoBlock = ^(UIView * _Nonnull videoView) {
            weakSelf.minimizeRemoteView.videoView = videoView;
        };
        kLJLiveAgoraHelper.receivePkVideoBlock = ^(UIView * _Nullable videoView) {
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

- (void)setLiveVc:(LJLiveViewController *)liveVc
{
    _liveVc = liveVc;
    if (liveVc) {
        // 设置最小化
        // 高斯模糊背景
        kLJWeakSelf;
        [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:self.data.current.roomCover] options:SDWebImageDelayPlaceholder progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            UIImage *blureImage = image ?: kLJLiveManager.config.avatar;
            [weakSelf.minimizeRemoteView.backgroudImageView setImage:[blureImage imageByBlurDark]];
        }];
        // 重设最小化幕布
        [kLJLiveAgoraHelper lj_setupMininzeRemoteVideoWithUid:self.data.current.hostAccountId];
        // 加入UI
        [[UIApplication sharedApplication].keyWindow addSubview:self.minimizeRemoteView];
        //
        self.isMinimize = YES;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!self.data.current.beActive) [self lj_close];
        });
    }
}

//- (void)setRemindAgain:(BOOL)remindAgain
//{
//    [kLJUserDefaults setBool:remindAgain forKey:@"LJLiveRemindAgain"];
//}
//
//- (BOOL)remindAgain
//{
//    return [kLJUserDefaults boolForKey:@"LJLiveRemindAgain"];
//}

@end
