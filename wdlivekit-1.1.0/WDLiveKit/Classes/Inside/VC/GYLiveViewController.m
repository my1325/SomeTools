//
//  GYLiveViewController.m
//  Woohoo
//
//  Created by M2-mini on 2021/8/24.
//

#import "GYLiveViewController.h"
#import "GYLiveMainItemCell.h"
#import "GYLiveRankPopView.h"
#import "GYLiveControlGiftsView.h"
#import "GYLiveGiftPrivateView.h"
#import "GYLivePkRankView.h"
#import "GYLiveControlMenuView.h"
#import "GYLiveAnchorPopView.h"
#import <WDLiveKit/WDLiveKit-Swift.h>

@class GYLivePersonalDataAnchorView;

static NSString *const kCellID = @"GYLiveViewControllerCellID";

@interface GYLiveViewController () <UITableViewDelegate, UITableViewDataSource>

/// 直播间列表
@property (nonatomic, strong) UITableView *tableView;
/// 排行榜
@property (nonatomic, strong) GYLiveRankPopView *rankView;
/// 礼物
@property (nonatomic, strong) GYLiveControlGiftsView *giftsView;
/// 私聊带走
@property (nonatomic, strong) GYLiveGiftPrivateView *privateView;
/// 菜单
@property (nonatomic, strong) GYLiveControlMenuView *menuView;
///
@property (nonatomic, strong) GYLiveMainItemCell *current;

@property (nonatomic, assign) BOOL keyboardFlag;
/// 切换房间中（滑动停止 -> 加入房间回调成功）
@property (nonatomic, assign) BOOL isDragging;
///
@property (nonatomic, assign) BOOL cleanBySystem;
///
@property (nonatomic, strong) GYLiveRoom *otherRefreshWithRoom;
///
@property (nonatomic, assign) BOOL closeFlag;
///
@property (nonatomic, assign) BOOL acceptSseEnable;

@end

@implementation GYLiveViewController

#pragma mark - Life Cycle

- (instancetype)initWithHostAccountId:(NSInteger)hostAccountId
{
    self = [super init];
    if (self) {
        [GYLiveInside fb_loading];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            kGYWeakSelf;
            [kGYLiveHelper fb_openLiveByHostId:hostAccountId success:^(id  _Nullable object) {
                
                GYLiveRoom *room = (GYLiveRoom *)object;
                [kGYLiveHelper.data fb_initWithRooms:@[room] atIndex:0];
                [self.tableView reloadData];
                
                GYLiveMainItemCell *current = weakSelf.current;
                current.myHostStatus = room.roomStatus;
                current.joinedRender = room;
                weakSelf.otherRefreshWithRoom = room;
                // 获取更多房间
                weakSelf.acceptSseEnable = YES;
                [kGYLiveHelper.data fb_reloadDataWithSuccess:^(NSArray<GYLiveRoom *> * _Nonnull rooms) {
                    if (rooms.count) {
                        // reload insert
                        [weakSelf.tableView beginUpdates];
                        NSInteger lastCount = kGYLiveHelper.data.rooms.count;
                        for (int i = 0; i < rooms.count; i++) {
                            GYLiveRoom *room = rooms[i];
                            [kGYLiveHelper.data fb_updateWith:room operationBlock:^GYLiveDataOperation(NSInteger index, GYLiveRoom * _Nullable old) {
                                return (index == -1 || index != kGYLiveHelper.data.index) ? GYLiveDataOperationReplaceAdd : GYLiveDataOperationNone;
                            } completionBlock:^(NSInteger index, GYLiveRoom * _Nullable old) {
                            }];
                        }
                        // insert
                        NSInteger count = kGYLiveHelper.data.rooms.count;
                        if (count-lastCount > 0) {
                            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(lastCount, count-lastCount)];
                            [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                            GYLog(@"live debug - reload data insert %ld-%ld all: %ld", lastCount, count-lastCount, count);
                        }
                        [weakSelf.tableView endUpdates];
                    }
                    weakSelf.acceptSseEnable = NO;
                } failure:^{
                    weakSelf.acceptSseEnable = NO;
                }];
                [GYLiveInside fb_hideLoading];
            } failure:^{
                [GYLiveInside fb_hideLoading];
                GYTip(kGYLocalString(@"Failed to join the Livestream, please try again."), GYLiveTipStatusError, 3);
                //
                weakSelf.closeFlag = YES;
                kGYLiveHelper.homeReloadTag = YES;
                if (weakSelf.navigationController) [weakSelf.navigationController popViewControllerAnimated:YES];
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }];
        });
    }
    return self;
}

- (instancetype)initWithRooms:(NSArray<GYLiveRoom *> *)rooms atIndex:(NSInteger)index
{
    self = [super init];
    if (self) {
        // 加入房间
        [GYLiveInside fb_loading];
        // 延迟加入，避免快速销毁及初始化agora失败
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [kGYLiveHelper.data fb_initWithRooms:rooms atIndex:index];
            [self.tableView reloadData];
            [self.tableView setContentOffset:CGPointMake(0, kGYScreenHeight * index) animated:NO];
            GYLog(@"live debug room: initWithRooms: %ld, index: %ld", kGYLiveHelper.data.rooms.count, index);
            
            kGYWeakSelf;
            [kGYLiveHelper fb_openLiveWith:rooms atIndex:index success:^(id  _Nullable object) {
                
                GYLiveRoom *room = (GYLiveRoom *)object;
                // 渲染UI
                GYLiveMainItemCell *current = weakSelf.current;
                current.myHostStatus = room.roomStatus;
                current.joinedRender = room;
                weakSelf.otherRefreshWithRoom = room;
                GYLog(@"live debug room: fb_openLiveWith: %ld", kGYLiveHelper.data.rooms.count);
                // 获取更多房间
                weakSelf.acceptSseEnable = YES;
                [kGYLiveHelper.data fb_reloadDataWithSuccess:^(NSArray<GYLiveRoom *> * _Nonnull rooms) {
                    if (rooms.count) {
                        // reload insert
                        [weakSelf.tableView beginUpdates];
                        NSInteger lastCount = kGYLiveHelper.data.rooms.count;
                        for (int i = 0; i < rooms.count; i++) {
                            GYLiveRoom *room = rooms[i];
                            [kGYLiveHelper.data fb_updateWith:room operationBlock:^GYLiveDataOperation(NSInteger index, GYLiveRoom * _Nullable old) {
                                return (index == -1 || index != kGYLiveHelper.data.index) ? GYLiveDataOperationReplaceAdd : GYLiveDataOperationNone;
                            } completionBlock:^(NSInteger index, GYLiveRoom * _Nullable old) {
                            }];
                        }
                        GYLog(@"live debug room: fb_reloadData: %ld", kGYLiveHelper.data.rooms.count);
                        // insert
                        NSInteger count = kGYLiveHelper.data.rooms.count;
                        if (count-lastCount > 0) {
                            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(lastCount, count-lastCount)];
                            [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                            GYLog(@"live debug - reload data insert %ld-%ld all: %ld", lastCount, count-lastCount, count);
                        }
                        [weakSelf.tableView endUpdates];
                    }
                    weakSelf.acceptSseEnable = NO;
                } failure:^{
                    weakSelf.acceptSseEnable = NO;
                }];
                [GYLiveInside fb_hideLoading];
            } failure:^{
                [GYLiveInside fb_hideLoading];
                GYTip(kGYLocalString(@"Failed to join the Livestream, please try again."), GYLiveTipStatusError, 3);
                //
                weakSelf.closeFlag = YES;
                kGYLiveHelper.homeReloadTag = YES;
                if (weakSelf.navigationController) [weakSelf.navigationController popViewControllerAnimated:YES];
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }];
        });
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    self.navigationController.navigationBar.hidden = YES;
    if (kGYLiveHelper.fullScreenByMinimize) {
        GYLiveMainItemCell *current = self.current;
        GYLiveRoom *room = kGYLiveHelper.data.current;
        // 更新关注状态
        current.myHostStatus = room.roomStatus;
        if (room.isHostFollowed) [current fb_event:GYLiveEventFollow withObj:@[@(room.hostAccountId), @(1)]];
    }
    // 开启返回手势
    if ([[GYLiveMethods fb_currentNavigationController] respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        [GYLiveMethods fb_currentNavigationController].interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    if (parent == nil) {
        // 返回默认最小化
        if (self.closeFlag) {
        } else {
            if (!kGYLiveHelper.isMinimize) [self fb_recieveEvent:GYLiveEventMinimize obj:nil];
        }
        // 刷新列表
        if (!kGYLiveHelper.data.current.beActive) kGYLiveHelper.homeReloadTag = YES;
        if (kGYLiveHelper.homeReloadTag) [GYLiveInside fb_reloadHomeList];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fb_addObservers];
    [self fb_setupBlocks];
    [self fb_setupViews];
    // 下载资源
//    [kGYLiveHelper fb_downloadSvgs];
}

#pragma mark - Init

- (void)fb_addObservers
{
    kGYNTFAdd(kGYLiveDestroyed, @selector(fb_liveDestroyed:));
    kGYNTFAdd(kGYLivePrivateChatFlagChanged, @selector(fb_livePrivateChatFlagChanged:));
    kGYNTFAdd(kGYLiveOldClosed, @selector(fb_liveOldClosed:));
    kGYNTFAdd(kGYLiveNewCreated, @selector(fb_liveNewCreated:));
    kGYNTFAdd(kGYLiveFeatureClosed, @selector(fb_liveFeatureClosed:));
    kGYNTFAdd(kGYLiveResumed, @selector(fb_liveResumed:));
    //
    kGYNTFAdd(kGYLiveFollowStatusUpdate,@selector(fb_liveFollowStatusUpdate:));
    // 目标
    kGYNTFAdd(kGYLiveGoalUpdated, @selector(fb_liveGoalUpdate:));
    kGYNTFAdd(kGYLiveGoalDone, @selector(fb_liveGoalDone:));
    // 监听键盘弹起
    kGYNTFAdd(UIKeyboardWillShowNotification, @selector(keyboardWillShowNoti:));
    kGYNTFAdd(UIKeyboardWillHideNotification, @selector(keyboardWillHideNoti:));
}

- (void)fb_setupViews
{
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = UIColor.blackColor;
    [self.view addSubview:self.tableView];
    //
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)fb_setupBlocks
{
    kGYWeakSelf;
    // 事件操作
    self.giftsView.eventBlock = ^(GYLiveEvent event, id object) {
        [weakSelf fb_recieveEvent:event obj:object];
    };
    // 收到弹幕
    kGYLiveAgoraHelper.receiveBarrageBlock = ^(GYLiveBarrage *barrage) {
        [weakSelf fb_receivedMessage:barrage];
    };
    // 获取禁言状态
    kGYLiveAgoraHelper.receiveUpdateBlock = ^(NSArray<GYLiveAttributeUpdate *> *updates) {
        [weakSelf fb_updateLiveAttributesFromUpdates:updates];
    };
    // 收到幕布/禁止视频流
    kGYLiveAgoraHelper.receivedVideoBlock = ^(UIView * _Nonnull videoView) {
        // 视频
        weakSelf.current.myHostVideo = videoView;
        //
        if (kGYLiveHelper.data.current.beActive){
            [GYLiveUIHelper fb_waitOrMoreDismiss:weakSelf.view];
        }
    };
    // 收到PK流
    kGYLiveAgoraHelper.receivePkVideoBlock = ^(UIView * _Nonnull videoView) {
        GYLiveMainItemCell *current = weakSelf.current;
        current.pkHostVideo = videoView;
        // 接收到的PK视频流，更改布局
        [current fb_event:GYLiveEventPKReceiveVideo withObj:nil];
        // 关闭私聊功能
        GYLivePrivateChatFlagMsg *msg = [[GYLivePrivateChatFlagMsg alloc] init];
        msg.roomId = kGYLiveHelper.data.current.roomId;
        msg.privateChatFlag = 2;
        [current fb_event:GYLiveEventUpdatePrivateChat withObj:msg];
        [weakSelf.privateView fb_dismiss];
    };
    // 60s自动弹窗关注
    kGYLiveHelper.followAutoTipBlock = ^{
        if (!kGYLiveHelper.data.current.isHostFollowed) [weakSelf fb_followTipAuto];
    };
}

#pragma mark - Notifacation

- (void)keyboardWillShowNoti:(NSNotification *)not
{
    CGRect keyBoardRect = [[not.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyBoardRect.size.height;
    self.current.keyboardChangedHeight = keyboardHeight - kGYBottomSafeHeight - 9;
    self.keyboardFlag = YES;
}

- (void)keyboardWillHideNoti:(NSNotification *)not
{
    self.current.keyboardChangedHeight = 0;
    self.keyboardFlag = NO;
}

#pragma mark - Received Events

/// 收到消息
/// @param barrage barrage
- (void)fb_receivedMessage:(GYLiveBarrage *)barrage
{
    kGYWeakSelf;
    GYLiveMainItemCell *current = self.current;
    GYLiveRoom *room = kGYLiveHelper.data.current;
    if (current == nil || room == nil) return;
    //
    switch (barrage.type) {
        case GYLiveBarrageTypeHint:
        {
            // 通过rtm同步给房间内其他用户
            [kGYLiveAgoraHelper fb_sendLiveMessageBarrage:[GYLiveBarrage messageWithLive:room] completion:nil];
            // 更新至内部弹幕
            [current fb_event:GYLiveEventReceivedBarrage withObj:barrage];
            // 获取禁言信息 + PK对方音视频状态
            [kGYLiveHelper fb_getMutedMembersAndChannelAttributesWithAgoraRoomId:room.agoraRoomId];
            // PK倒计时结束
            if (kGYLiveHelper.pkTimeUpEnd >= 0) [current fb_event:GYLiveEventReceivedBarrage withObj:[GYLiveBarrage pkEndMessage]];
            // 读取房间历史弹幕
            for (int i = 0;i < room.latestBarrages.count; i++) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((i * 0.5 + 1) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    GYLiveBarrage *b = room.latestBarrages[room.latestBarrages.count - i -1];
                    b.type = GYLiveBarrageTypeTextMessage;
                    [current fb_event:GYLiveEventReceivedBarrage withObj:b];
                });
            }
        }
            break;
            
        case GYLiveBarrageTypeLiveRoomInfo:
        {
            // 刷新房间信息
            if (barrage.content.length == 0) {
                return;
            }
            NSDictionary *dict = [NSDictionary fb_dictionaryWithJsonString:barrage.content];
            GYLiveRoom *obj = [[GYLiveRoom alloc] initWithDictionary:dict];
            // 同步信息
            if (obj.hostAccountId == room.hostAccountId) {
                // 收到的最新的房间消息是已结束PK
                if (room.pking && obj.pkData == nil) {
                    
                    [current fb_event:GYLiveEventPKEnded withObj:nil];
                    // 统计
                    [kGYLiveHelper fb_pkEventsGifts1To5MinIfBeforeEnding:YES];
                    [kGYLiveHelper fb_pkEventsEndingProcess];
                }
                // 更新数据源
                [kGYLiveHelper.data fb_updateWith:obj operationBlock:^GYLiveDataOperation(NSInteger index, GYLiveRoom * _Nullable old) {
                    if (index == -1) {
                    } else {
                        obj.gifts = old.gifts;
                        obj.privateChatFlag = old.privateChatFlag;
                        obj.isHostFollowed = old.isHostFollowed;
                        obj.hostCallPrice = old.hostCallPrice;
                        if (!obj.roomGoal) obj.roomGoal = old.roomGoal;
                        obj.turntableFlag = old.turntableFlag;
                        obj.turntableTitle = old.turntableTitle;
                        obj.turntableItems = old.turntableItems;
                    }
                    return GYLiveDataOperationReplaceAdd;
                } completionBlock:^(NSInteger index, GYLiveRoom * _Nullable old) {
                    //
                    current.refreshRender = obj;
                    current.myHostStatus = obj.roomStatus;
                    weakSelf.privateView.liveRoom = obj;
                    [weakSelf.rankView fb_reloadData];
                }];
            }
        }
            break;
            
        case GYLiveBarrageTypeMembersInfo:
        {
            // 刷新排行榜
            NSData *jsonData = [barrage.content dataUsingEncoding:NSUTF8StringEncoding];
            NSObject *obj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            if ([obj isKindOfClass:[NSArray class]]) {
                NSMutableArray *marr = [@[] mutableCopy];
                for (NSDictionary *dict in (NSArray *)obj) {
                    GYLiveRoomMember *member = [[GYLiveRoomMember alloc] initWithDictionary:dict];
                    [marr addObject:member];
                }
                room.videoChatRoomMembers = marr;
                // 刷新排行
                weakSelf.rankView.members = [room.videoChatRoomMembers mutableCopy];
                current.refreshRender = room;
            }
        }
            break;
            
        case GYLiveBarrageTypeTakeAnchor:
        {
            // 主播被带走
            if (barrage.userId == kGYLiveManager.inside.account.accountId) {
                // 自己则不弹窗
            } else {
                // 绿色账号，不显示动画
                if (kGYLiveManager.inside.account.isGreen) {
                    // 最小化进入更新文案
                    current.myHostStatus = 3;
                    // 刷新标记
                    kGYLiveHelper.homeReloadTag = YES;
                    return;
                }
                // 主播被别的用户带走
                GYLiveRoomMember *member = [[GYLiveRoomMember alloc] init];
                member.avatar = barrage.avatar;
                member.nickName = barrage.userName;
                // 配对成功弹窗
                [GYLiveUIHelper fb_matchingSuccessedByUser:member inView:self.view withDelayDismiss:^{
                    // 最小化进入更新文案
                    current.myHostStatus = 3;
                    room.privateChatFlag = 2;
                    room.roomStatus = 3;
                    // 清理combo动画
                    kGYLiveHelper.comboing = -1;
                    [GYLiveComboViewManager.shared fb_removeCurrentViewFromSuperView];
                    UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
                    // 弹窗
                    [GYLiveUIHelper fb_waitOrMore:weakSelf.view withWait:^{
                        // 统计
                        GYEvent(@"fb_LiveHostPrivatedTouchWait", nil);
                    } more:^{
                        kGYLiveHelper.homeReloadTag = YES;
                        [weakSelf fb_recieveEvent:GYLiveEventClose obj:nil];
                        // 统计
                        GYEvent(@"fb_LiveHostPrivatedTouchMore", nil);
                    }];
                }];
            }
            // 更新文案
            current.myHostStatus = 3;
            room.privateChatFlag = 2;
        }
            break;
            
        case GYLiveBarrageTypeGift:
        {
            // 更新至内部弹幕
            [current fb_event:GYLiveEventReceivedBarrage withObj:barrage];
        }
            break;
            
        case GYLiveBarrageTypeJoinLive:
        case GYLiveBarrageTypeTextMessage:
        case GYLiveBarrageTypeBeMute:
        case GYLiveBarrageTypeCancelMute:
        {
            // 更新至内部弹幕
            [current fb_event:GYLiveEventReceivedBarrage withObj:barrage];
        }
            break;

        case GYLiveBarrageTypePKPrivateFlagChange:
        {
            // PK中收到
            if (room.pking) return;
            // 更新私聊按钮状态
            GYLivePrivateChatFlagMsg *msg = [[GYLivePrivateChatFlagMsg alloc] initWithDictionary:[NSDictionary fb_dictionaryWithJsonString:barrage.content]];
            if (msg.roomId == room.roomId) {
                // 更新UI
                [current fb_event:GYLiveEventUpdatePrivateChat withObj:msg];
                // 主播已关闭私聊功能
                if (msg.privateChatFlag == 2) [self.privateView fb_dismiss];
                // 同步
                room.privateChatFlag = msg.privateChatFlag;
            }
        }
            break;
            
        case GYLiveBarrageTypePKMatchSuccessed:
        {
            // PK配对成功
            // 刷新数据
            GYLivePkData *pkData = [[GYLivePkData alloc] initWithDictionary:[NSDictionary fb_dictionaryWithJsonString:barrage.content]];
            if (pkData.homePlayer.hostAccountId == room.hostAccountId) {
                room.pkData = pkData;
                [current fb_event:GYLiveEventPKReceiveMatchSuccessed withObj:pkData];
                current.refreshRender = room;
            }
            // 关闭私聊功能
            GYLivePrivateChatFlagMsg *msg = [[GYLivePrivateChatFlagMsg alloc] init];
            msg.roomId = room.roomId;
            msg.privateChatFlag = 2;
            [current fb_event:GYLiveEventUpdatePrivateChat withObj:msg];
            [self.privateView fb_dismiss];
            // once more的情况
            if (kGYLiveHelper.pkTimeUpEnd != -1) {
                GYEvent(@"fb_PKBetweenTimeUpAndEnd", @{@"duration": @(kGYLiveHelper.pkTimeUpEnd)});
                kGYLiveHelper.pkTimeUpEnd = -1;
            }
            // 开始计时
            kGYLiveHelper.pkInTimeUp = pkData.pkMaxDuration - pkData.pkLeftTime;
            kGYLiveHelper.pkInEnd = 0;
            // 计时事件
//            [kGYThreeEvents fb_PKBetweenMatchAndTimeUp:0];
//            [kGYThreeEvents fb_PKBetweenJoinAndEnd:0];
            GYLiveThinking(GYLiveThinkingEventTypeTimeEvent, GYLiveThinkingEventTimeForOnePk, nil);
        }
            break;
            
        case GYLiveBarrageTypePKPointUpdated:
        {
            // PK分数更新
            GYLivePkPointUpdatedMsg *msg = [[GYLivePkPointUpdatedMsg alloc] initWithDictionary:[NSDictionary fb_dictionaryWithJsonString:barrage.content]];
            room.pkData.homePoint = msg.homePoint;
            room.pkData.awayPoint = msg.awayPoint;
            [current fb_event:GYLiveEventPKReceivePointUpdate withObj:msg];
        }
            break;
        
        case GYLiveBarrageTypePKTimeUp:
        {
            // PK事件结束
            GYLivePkWinner *winner = [[GYLivePkWinner alloc] initWithDictionary:[NSDictionary fb_dictionaryWithJsonString:barrage.content]];
            room.pkData.pkLeftTime = 0;
            room.pkData.winner = winner;
            [current fb_event:GYLiveEventPKReceiveTimeUp withObj:winner];
            [current fb_event:GYLiveEventReceivedBarrage withObj:[GYLiveBarrage pkEndMessage]];
            // 统计
            [kGYLiveHelper fb_pkEventsGifts1To5MinIfBeforeEnding:YES];
            
            if (kGYLiveHelper.pkInTimeUp != -1) {
                GYEvent(@"fb_PKBetweenMatchAndTimeUp", @{@"duration": @(kGYLiveHelper.pkInTimeUp)});
                kGYLiveHelper.pkInTimeUp = -1;
            }
            
//            [kGYThreeEvents fb_PKBetweenTimeUpAndEnd:0];
            kGYLiveHelper.pkTimeUpEnd = 0;
        }
            break;
        
        case GYLiveBarrageTypePKOnceMore:
        {
            // 再来一次
            NSInteger hostAccountId = [barrage.content integerValue];
            [current fb_event:GYLiveEventPKReceiveReady withObj:@(hostAccountId)];
        }
            break;
            
        case GYLiveBarrageTypePKEnded:
        {
            // PK结束
            [current fb_event:GYLiveEventPKEnded withObj:nil];
            if (room.pkData.pkLeftTime > 0){
                // 提示
                GYTipWarning(kGYLocalString(@"The host quit, you lost this turn!"));
            }
            
            room.pkData = nil;

            // 统计
            GYEvent(@"fb_PKBetweenTimeUpAndEnd", @{@"duration": @(kGYLiveHelper.pkTimeUpEnd)});
            kGYLiveHelper.pkTimeUpEnd = -1;
            
            NSInteger min = kGYLiveHelper.pkInEnd / 60 + kGYLiveHelper.pkInEnd % 60 > 0;
            GYEvent(@"fb_PKBetweenJoinAndEnd", @{@"duration": @(min)});
            GYLiveThinking(GYLiveThinkingEventTypeEvent, GYLiveThinkingEventTimeForOnePk, nil);
            kGYLiveHelper.pkInEnd = -1;
        }
            break;
            
        case GYLiveBarrageTypePKRunAway:
        {
            // PK逃跑，恢复UI
            [current fb_event:GYLiveEventPKEnded withObj:nil];
            room.pkData = nil;
            // 提示
            GYTipWarning(kGYLocalString(@"The other host quit, congrats, you win this turn!"));
            // 统计
            GYEvent(@"fb_PKBetweenMatchAndTimeUp", @{@"duration": @(kGYLiveHelper.pkInTimeUp)});
            [kGYLiveHelper fb_pkEventsGifts1To5MinIfBeforeEnding:YES];
            kGYLiveHelper.pkInTimeUp = -1;
            
            NSInteger min = kGYLiveHelper.pkInEnd / 60 + kGYLiveHelper.pkInEnd % 60 > 0;
            GYEvent(@"fb_PKBetweenJoinAndEnd", @{@"duration": @(min)});
            GYLiveThinking(GYLiveThinkingEventTypeEvent, GYLiveThinkingEventTimeForOnePk, nil);
            kGYLiveHelper.pkInEnd = -1;
        }
            break;
            
        case GYLiveBarrageTypeTurntableInfo:
        {
            // 更新转盘信息以及转盘结果
            NSData *jsonData = [barrage.content dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            // 接收到主播数据后发送给view处理
            [current fb_event:GYLiveEventTurnPlateUpdate withObj:dict];
        }
            break;
            
        case GYLiveBarrageTypeMutedMembers:
        {
            NSData *jsonData = [barrage.content dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *mutedArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            BOOL flag = [mutedArr containsObject:@(kGYLiveManager.inside.account.accountId)];
            if (flag) {
                // 有自己的信息，禁言
                if (!kGYLiveHelper.barrageMute) {
                    // 未被禁言，禁言
                    GYTipWarning(kGYLocalString(@"You have been muted."));
                    kGYLiveHelper.barrageMute = YES;
                }
            } else {
                // 已被禁言，解禁
                if (kGYLiveHelper.barrageMute) {
                    GYTipWarning(kGYLocalString(@"You have been unmuted."));
                    kGYLiveHelper.barrageMute = NO;
                }
            }
            kGYLiveHelper.barrageMute = flag;
        }
            break;
            
        default:
            break;
    }
}

/// 操作事件
/// @param receiveEvent 操作
/// @param obj 对象
- (void)fb_recieveEvent:(GYLiveEvent)receiveEvent obj:(id)obj
{
    kGYWeakSelf;
    GYLiveMainItemCell *current = self.current;
    GYLiveRoom *room = kGYLiveHelper.data.current;
    switch (receiveEvent) {
        case GYLiveEventMinimize:
        {
            if (!room.beActive) {
                [self fb_recieveEvent:GYLiveEventClose obj:nil];
                return;
            }
            // 设置最小化窗口
            kGYLiveHelper.liveVc = self;
            // 关闭房间（最小化）
            if (self.navigationController) [self.navigationController popViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
            
            kGYLiveHelper.comboing = -1;
            [GYLiveComboViewManager.shared fb_removeCurrentViewFromSuperView];
            UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
        }
            break;
            
        case GYLiveEventClose:
        {
            [kGYLiveHelper fb_close];
        }
            break;
            
        case GYLiveEventMembers:
        {
            // 排行榜
            [self.rankView fb_showInView:self.view];
            // 取消键盘
            current.keyboardChangedHeight = 0;
            self.keyboardFlag = NO;
            // 清理combo动画
            kGYLiveHelper.comboing = -1;
            [GYLiveComboViewManager.shared fb_removeCurrentViewFromSuperView];
            UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
        }
            break;
            
        case GYLiveEventGifts:
        {
            // 礼物列表
            [self.giftsView fb_showInView:self.view];
            // 取消键盘
            current.keyboardChangedHeight = 0;
            self.keyboardFlag = NO;
            // 禁用返回手势
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.enabled = NO;
            }
        }
            break;
            
        case GYLiveEventWallet:
        {
            // 打开钱包
            [kGYLiveManager.delegate fb_buyViewOpenAt:self.view];
            // 取消键盘
            current.keyboardChangedHeight = 0;
            self.keyboardFlag = NO;
            // 清理combo动画
            kGYLiveHelper.comboing = -1;
            [GYLiveComboViewManager.shared fb_removeCurrentViewFromSuperView];
            UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
        }
            break;
            
        case GYLiveEventSendBarrage:
        {
            if (kGYLiveHelper.barrageMute) {
                GYTipWarning(kGYLocalString(@"You have been muted."));
                return;
            }
            if (kGYLiveManager.inside.networkStatus == 0) {
                GYTipError(kGYLocalString(@"Please check your network."));
                return;
            }
            // 发送弹幕消息
            if ([obj isKindOfClass:[GYLiveBarrage class]]) {
                // 发给频道其他人
                GYLiveBarrage *barrage = (GYLiveBarrage *)obj;
                [kGYLiveAgoraHelper fb_sendLiveMessageBarrage:barrage completion:nil];
                // 加到自己的弹幕中
                if (kGYLiveAgoraHelper.receiveBarrageBlock) kGYLiveAgoraHelper.receiveBarrageBlock(barrage);
                // 接口记录
                if (barrage.type == GYLiveBarrageTypeTextMessage && !room.isUgc) {
                    [GYLiveNetworkHelper fb_sendTextMessage:barrage.content roomId:room.roomId success:^{
                    } failure:^{
                    }];
                }
            }
            //
            if (!room.beActive) GYEvent(@"fb_LiveHostLeaveSendBarrage", nil);
            GYLiveThinking(GYLiveThinkingEventTypeEvent, GYLiveThinkingEventSendBarrageInLive, nil);
        }
            break;
            
        case GYLiveEventSendGift:
        case GYLiveEventFastGift:
        {
            if (kGYLiveManager.inside.networkStatus == 0) {
                GYTipError(kGYLocalString(@"Please check your network."));
                return;
            }
            // 送礼
            if ([obj isKindOfClass:[GYLiveGift class]]) {
                GYLiveGift *config = (GYLiveGift *)obj;
                if ([self fb_enoughAutoWalletForConfig:config showTip:YES]) {
                    // 送礼（接口 + RTM + 扣费）
                    [kGYLiveHelper fb_sendGift:config isFast:receiveEvent == GYLiveEventFastGift];
                    // 统计
                    if (!room.beActive) GYEvent(@"fb_LiveHostLeaveSendGift", nil);
                    if (room.pking) {
                        NSInteger min = kGYLiveHelper.pkInTimeUp / 60 + 1;
                        if (min == 1) {
                            // 在第一分钟送礼
                            GYEvent(@"fb_PKSendGiftsWithin1Min", nil);
                            GYEvent(@"fb_PKSendGiftsPriceWithin1Min", @{@"price": @(config.giftPrice).stringValue});
                        }
                        if (min == 2) {
                            // 在第二分钟送礼
                            GYEvent(@"fb_PKSendGiftsWithin2Min", nil);
                            GYEvent(@"fb_PKSendGiftsPriceWithin2Min", @{@"price": @(config.giftPrice).stringValue});
                        }
                        if (min == 3) {
                            // 在第三分钟送礼
                            GYEvent(@"fb_PKSendGiftsWithin3Min", nil);
                            GYEvent(@"fb_PKSendGiftsPriceWithin3Min", @{@"price": @(config.giftPrice).stringValue});
                        }
                        if (min == 4) {
                            // 在第四分钟送礼
                            GYEvent(@"fb_PKSendGiftsWithin4Min", nil);
                            GYEvent(@"fb_PKSendGiftsPriceWithin4Min", @{@"price": @(config.giftPrice).stringValue});
                        }
                        if (min == 5) {
                            // 在第五分钟送礼
                            GYEvent(@"fb_PKSendGiftsWithin5Min", nil);
                            GYEvent(@"fb_PKSendGiftsPriceWithin5Min", @{@"price": @(config.giftPrice).stringValue});
                        }
                        // 在最后15秒钟赠送
                        NSInteger sec = room.pkData.pkMaxDuration - kGYLiveHelper.pkInTimeUp;
                        if (sec <= 15 && sec >= 0 && kGYLiveHelper.pkInTimeUp > 0) {
                            GYEvent(@"fb_PKSendGiftsInLast15s", nil);
                            GYEvent(@"fb_PKSendGiftsPriceInLast15s", @{@"price": @(config.giftPrice).stringValue});
                            kGYLiveHelper.last15SendCoins += config.giftPrice;
                        }
                        if (min >= 1 && min <= 5 && kGYLiveHelper.pkInTimeUp > 0) {
                            kGYLiveHelper.pkInSendCoins += config.giftPrice;
                        }
                    }
                } else {
                    [self.giftsView fb_dismiss];
                }
            }
        }
            break;
            
        case GYLiveEventPrivateChat:
        {
            if (kGYLiveManager.inside.networkStatus == 0) {
                GYTipError(kGYLocalString(@"Please check your network."));
                return;
            }
            // 私聊带走
            if (kGYLiveHelper.barrageMute) {
                // 被拉黑了，不能带走主播
                GYTipWarning(kGYLocalString(@"You have been muted."));
                return;
            }
            self.privateView.liveRoom = room;
            [self.privateView fb_showInView:self.view];
            // 取消键盘
            current.keyboardChangedHeight = 0;
            self.keyboardFlag = NO;
        }
            break;
            
        case GYLiveEventPersonalData:
        {
            if (kGYLiveManager.inside.networkStatus == 0) {
                GYTipError(kGYLocalString(@"Please check your network."));
                return;
            }
            // 个人详情
            if ([obj isKindOfClass:[GYLiveRoomAnchor class]]) {
                // 主播信息
                [self fb_personalDataWithAnchor:(GYLiveRoomAnchor *)obj];
            }
            if ([obj isKindOfClass:[GYLiveRoomMember class]]) {
                // 成员（主播 + 用户）
                GYLiveRoomMember *member = (GYLiveRoomMember *)obj;
                // PK相关
                NSInteger roomId = member.pkRoomId > 0 ? member.pkRoomId : room.roomId;
                // ugc
                if (room.isUgc && member.accountId == room.hostAccountId) member.roleType = GYLiveRoleTypeUser;
                //
                if (member.roleType == GYLiveRoleTypeUser) {
                    // 请求用户详情
                    [GYLiveInside fb_loading];
                    [GYLiveNetworkHelper fb_getLiveUserInfoWithUserId:member.accountId roomId:roomId success:^(GYLiveRoomUser * _Nullable user) {
                        [GYLiveInside fb_hideLoading];
                        [weakSelf fb_personalDataWithUser:user];
                    } failure:^{
                        [GYLiveInside fb_hideLoading];
                    }];
                } else {
                    // == 2 请求主播详情
                    [GYLiveInside fb_loading];
                    [GYLiveNetworkHelper fb_getLiveAnchorInfoWithAnchorId:member.accountId roomId:roomId success:^(GYLiveRoomAnchor * _Nullable anchor) {
                        [GYLiveInside fb_hideLoading];
                        [weakSelf fb_personalDataWithAnchor:anchor];
                    } failure:^{
                        [GYLiveInside fb_hideLoading];
                    }];
                }
            }
            // 取消键盘
            current.keyboardChangedHeight = 0;
            self.keyboardFlag = NO;
        }
            break;
        
        case GYLiveEventFollow:
        {
            // 关注
            if ([obj isKindOfClass:[NSArray class]]) {
                NSArray *array = (NSArray *)obj;
                NSInteger accountId = [array.firstObject integerValue];
                BOOL follow = [array.lastObject boolValue];
                if (follow) {
                    // 关注
                    [GYLiveNetworkHelper fb_followByTargetAccountId:accountId success:^{
                        if (accountId == room.hostAccountId) {
                            [current fb_event:GYLiveEventFollow withObj:@[@(accountId), @(1)]];
                            // 更新数据
                            room.isHostFollowed = YES;
                        }
                    } failure:^{
                        GYTipError(kGYLocalString(@"Failed to follow."));
                    }];
                } else {
                    // 取消关注
                    [GYLiveNetworkHelper fb_cancelFollowByTargetAccountId:accountId success:^{
                        if (accountId == room.hostAccountId) {
                            [current fb_event:GYLiveEventFollow withObj:@[@(accountId), @(0)]];
                            // 更新数据
                            room.isHostFollowed = NO;
                        }
                    } failure:^{
                    }];
                }
            }
            kGYLiveHelper.homeReloadTag = YES;
        }
            break;
            
        case GYLiveEventPKOpenAwayRoom:
        {
            // 跳转房间
            GYLivePkPlayer *awayPlayer = (GYLivePkPlayer *)obj;
            GYLiveRoom *model = [[GYLiveRoom alloc] init];
            model.hostAccountId = awayPlayer.hostAccountId;
            [kGYLiveHelper.data fb_updateWith:model operationBlock:^GYLiveDataOperation(NSInteger index, GYLiveRoom * _Nullable old) {
                if (index == -1) {
                    // 没有该房间，请求数据加入
                    [GYLiveInside fb_loading];
                    [GYLiveNetworkHelper fb_getLiveInfoWithRoomId:awayPlayer.roomId success:^(GYLiveRoom * _Nullable room) {
                        if (room) {
                            [weakSelf.tableView beginUpdates];
                            [kGYLiveHelper.data fb_updateWith:room operationBlock:^GYLiveDataOperation(NSInteger index, GYLiveRoom * _Nullable old) {
                                return GYLiveDataOperationReplaceAdd;
                            } completionBlock:^(NSInteger index, GYLiveRoom * _Nullable old) {
                                if (index == -1) {
                                    // 再次执行跳转
                                    [weakSelf.tableView insertSection:kGYLiveHelper.data.rooms.count-1 withRowAnimation:UITableViewRowAnimationNone];
                                }
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [weakSelf fb_recieveEvent:GYLiveEventPKOpenAwayRoom obj:awayPlayer];
                                });
                            }];
                            [weakSelf.tableView endUpdates];
                        }
                    } failure:^{
                        [GYLiveInside fb_hideLoading];
                    }];
                } else {
                    // 离开当前
                    [weakSelf fb_switchLeaveAtIndex:kGYLiveHelper.data.index];
                    // 跳转
                    [weakSelf.tableView reloadData];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf.tableView setContentOffset:CGPointMake(0, kGYScreenHeight * index) animated:NO];
                        // 加入（数据先行）
                        [weakSelf fb_switchJoinToIndex:index];
                        // 切换rtc
                        [kGYLiveAgoraHelper fb_switchAgoraRtcWithAgoraRoomId:old.agoraRoomId completion:nil];
                    });

                    if (kGYLiveManager.inside.joinFlag) {
                        kGYLiveManager.inside.fromJoin = GYLiveThinkingValueBroadcast;
                        kGYLiveManager.inside.joinFlag = NO;
                    }
                    [GYLiveInside fb_hideLoading];
                }
                return GYLiveDataOperationNone;
            } completionBlock:^(NSInteger index, GYLiveRoom * _Nullable old) {
            }];
            //
            GYEvent(@"fb_PKClickOppositeButton", nil);
        }
            break;
            
        case GYLiveEventPKOpenHomeRank:
        {
            // 打开PK粉丝榜
            if (room.pking) {
                [GYLiveInside fb_loading];
                [GYLiveNetworkHelper fb_getLiveTopFansWithRoomId:room.roomId
                                                               hostId:room.hostAccountId
                                                              success:^(NSArray<GYLivePkTopFan *> * _Nonnull fans) {
                    //
                    GYLivePkRankView *pkRankView = [GYLivePkRankView fb_pkRankView];
                    pkRankView.eventBlock = ^(GYLiveEvent event, id object) {
                        [weakSelf fb_recieveEvent:event obj:object];
                        GYEvent(@"fb_PKFansContributionListClickDetail", nil);
                    };
                    pkRankView.isHome = YES;
                    pkRankView.fans = fans;
                    [pkRankView fb_pkRankOpenInView:weakSelf.view];
                    [GYLiveInside fb_hideLoading];
                } failure:^{
                    [GYLiveInside fb_hideLoading];
                }];
                //
                GYEvent(@"fb_PKClickFansContributionList", nil);
                GYLiveThinking(GYLiveThinkingEventTypeEvent, GYLiveThinkingEventClickGiftRankInPk, nil);
            }
        }
            break;
            
        case GYLiveEventPKOpenAwayRank:
        {
            // 打开PK粉丝榜
            if (room.pking) {
                [GYLiveInside fb_loading];
                [GYLiveNetworkHelper fb_getLiveTopFansWithRoomId:room.roomId
                                                               hostId:room.pkData.awayPlayer.hostAccountId
                                                              success:^(NSArray<GYLivePkTopFan *> * _Nonnull fans) {
                    //
                    GYLivePkRankView *pkRankView = [GYLivePkRankView fb_pkRankView];
                    pkRankView.eventBlock = ^(GYLiveEvent event, id object) {
                        [weakSelf fb_recieveEvent:event obj:object];
                        GYEvent(@"fb_PKFansContributionListClickDetail", nil);
                    };
                    pkRankView.isHome = NO;
                    pkRankView.fans = fans;
                    [pkRankView fb_pkRankOpenInView:weakSelf.view];
                    [GYLiveInside fb_hideLoading];
                } failure:^{
                    [GYLiveInside fb_hideLoading];
                }];
                //
                GYEvent(@"fb_PKClickFansContributionList", nil);
                GYLiveThinking(GYLiveThinkingEventTypeEvent, GYLiveThinkingEventClickGiftRankInPk, nil);
            }
        }
            break;
            
        case GYLiveEventPKReceiveAudioMuted:
        {
            [current fb_event:GYLiveEventPKReceiveAudioMuted withObj:obj];
        }
            break;
        
        case GYLiveEventPKReceiveVideoMuted:
        {
            [current fb_event:GYLiveEventPKReceiveVideoMuted withObj:obj];
        }
            break;
            
        case GYLiveEventReport:
        {
            // 底部控制栏举报
            [GYLiveUIHelper fb_reportInView:weakSelf.view submit:^(NSString * _Nonnull content, NSArray * _Nonnull images) {
                [weakSelf fb_reportWithAccountId:room.hostAccountId content:content images:images success:^{
                    if (room.isUgc) {
                        kGYLiveHelper.homeReloadTag = YES;
                        [weakSelf fb_recieveEvent:GYLiveEventClose obj:nil];
                    }
                } failure:^{
                }];
            }];
        }
            break;
            
        case GYLiveEventOpenMenu:
        {
            [self.menuView fb_showInView:self.view];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.keyboardFlag) self.current.keyboardChangedHeight = 0;
    self.isDragging = YES;
    
    NSInteger index = self.tableView.contentOffset.y / kGYScreenHeight;
    //
    kGYLiveHelper.comboing = -1;
    [GYLiveComboViewManager.shared fb_removeCurrentViewFromSuperView];
    UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
    
    GYLog(@"live scroll - will begin: %ld", index);
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGPoint point = CGPointMake(targetContentOffset->x, targetContentOffset->y);
    NSInteger index = point.y / kGYScreenHeight;
 
    if (labs(index - kGYLiveHelper.data.index) >= 2) {
        // 滑动超过2个cell，系统会自动清理掉cell，这时退出该房间
        [kGYLiveAgoraHelper fb_logoutAgoraRtcWithCompletion:nil];
        [self fb_switchLeaveAtIndex:kGYLiveHelper.data.index];
        self.cleanBySystem = YES;
    }
    
    GYLog(@"live scroll - will end: %ld", index);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 切换房间
    __block NSInteger nextIndex = scrollView.contentOffset.y / kGYScreenHeight;
    NSInteger oldIndex = kGYLiveHelper.data.index;
    // 如果滑动没有触发系统的清理cell，则nextindex == index不做处理
    if (!self.cleanBySystem && nextIndex == oldIndex) {
        return;
    }
    GYLiveRoom *next = kGYLiveHelper.data.rooms[nextIndex];
    GYLiveRoom *current = kGYLiveHelper.data.current;
    // 退出上一个房间
    if (!self.cleanBySystem) [self fb_switchLeaveAtIndex:oldIndex];
    // 移除异常房间
    if (current.beActive) {
    } else {
        kGYWeakSelf;
        [self.tableView beginUpdates];
        [kGYLiveHelper.data fb_updateWith:current operationBlock:^GYLiveDataOperation(NSInteger index, GYLiveRoom * _Nullable old) {
            return GYLiveDataOperationRemove;
        } completionBlock:^(NSInteger index, GYLiveRoom * _Nullable old) {
            if (index == -1) {
            } else {
                [weakSelf.tableView deleteSection:index withRowAnimation:UITableViewRowAnimationNone];
                [weakSelf.tableView endUpdates];
                GYLog(@"live debug - reload data delete %ld all: %ld", index, kGYLiveHelper.data.rooms.count);
                if (nextIndex > oldIndex) {
                    [weakSelf.tableView setContentOffset:CGPointMake(0, kGYScreenHeight * index) animated:NO];
                    nextIndex -= 1;
                }
            }
        }];
    }
    // 加入下一个房间（数据先行）
    [self fb_switchJoinToIndex:nextIndex];
    // rtc
    if (self.cleanBySystem) {
        [kGYLiveAgoraHelper fb_joinAgoraRtcWithAgoraRoomId:next.agoraRoomId completion:nil];
    } else {
        [kGYLiveAgoraHelper fb_switchAgoraRtcWithAgoraRoomId:next.agoraRoomId completion:nil];
    }
    self.cleanBySystem = NO;
    
    self.isDragging = NO;
    GYLog(@"live scroll - did end: %ld", nextIndex);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = kGYLiveHelper.data.rooms.count;
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYLiveMainItemCell *main = [tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];
    if (main == nil) {
        main = [[GYLiveMainItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
    }
    GYLiveRoom *room = kGYLiveHelper.data.rooms[indexPath.section];
    main.room = room;
    // 清理UI
    NSInteger index = kGYLiveHelper.data.index;
    if (indexPath.section == index) {
    } else {
        main.joinedRender = nil;
    }
    
    kGYWeakSelf;
    main.eventBlock = ^(GYLiveEvent event, id object) {
        [weakSelf fb_recieveEvent:event obj:object];
    };
    // 高斯模糊背景
    [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:room.roomCover]
                                              options:SDWebImageRetryFailed
                                             progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        UIImage *blureImage = image ?: kGYLiveManager.config.avatar;
        [main.remoteView.backgroudImageView setImage:blureImage];
    }];
    if (room.pking) {
        [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:room.pkData.awayPlayer.roomCover]
                                                  options:SDWebImageRetryFailed
                                                 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            UIImage *blureImage = image ?: kGYLiveManager.config.avatar;
            [main.pkRemoteView.backgroudImageView setImage:blureImage];
        }];
    }
    return main;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kGYScreenHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - Public Methods

- (void)fb_switchLeaveAtIndex:(NSInteger)index
{
    // 清理房间UI
    GYLiveMainItemCell *cell = (GYLiveMainItemCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
    [cell fb_event:GYLiveEventRoomLeave withObj:nil];
    // 退出RTM + NET
    [kGYLiveHelper fb_switchLeaveFromIndex:index];
}

- (void)fb_switchJoinToIndex:(NSInteger)toIndex
{
    [GYLiveInside fb_loading];
    // 下一个房间
    kGYLiveHelper.data.index = toIndex;
    // 加入RTM + NET
    kGYWeakSelf;
    [kGYLiveHelper fb_switchToIndex:toIndex success:^(id  _Nullable object) {
        GYLiveRoom *obj = (GYLiveRoom *)object;
        GYLiveMainItemCell *current = weakSelf.current;
        current.joinedRender = obj;
        current.myHostStatus = obj.roomStatus;
        weakSelf.otherRefreshWithRoom = obj;
        [GYLiveInside fb_hideLoading];
    } failure:^{
        [GYLiveInside fb_hideLoading];
        // 提示
        GYTip(kGYLocalString(@"Failed to join the Livestream, please try again."), GYLiveTipStatusError, 3);
        // 统计
        GYEvent(@"fb_LiveEnterErrorRoom", nil);
    }];
}

/// 没有足够的金币
/// @param config 礼物
- (BOOL)fb_enoughAutoWalletForConfig:(GYLiveGift *)config showTip:(BOOL)showTip
{
    if (kGYLiveManager.inside.account.coins < config.giftPrice) {
        // 金币不足，跳转钱包
        if (showTip) GYTipWarning(kGYLocalString(@"You don't have enough coins."));
        [self fb_recieveEvent:GYLiveEventWallet obj:nil];
        return NO;
    }
    return YES;
}

- (void)fb_clean
{
    [self.current fb_event:GYLiveEventRoomLeave withObj:nil];
    self.closeFlag = YES;
}

- (void)fb_reloadMyCoins
{
    [self.giftsView fb_reloadMyCoins];
    
    GYLiveMainItemCell *current = self.current;
    [current.containerView fb_event:GYLiveEventRechargeSuccess withObj:nil];
}

#pragma mark - Events

/// 从RTM信息中更新自己的封禁状态
/// @param updates RTM
- (void)fb_updateLiveAttributesFromUpdates:(NSArray *)updates
{
//    NSString *accountId = @(kGYLiveManager.inside.account.accountId).stringValue;
    for (GYLiveAttributeUpdate *update in updates) {
        NSString *key = update.key;
        // 观众的禁言状态
//        if ([key isEqualToString:accountId]) {
//        }
        // PK对方的音频状态
        if ([key isEqualToString:kGYLiveAttributeKeyMuteOpAudio]) {
            BOOL isMuted = update.attribute.isMuted;
            [self fb_recieveEvent:GYLiveEventPKReceiveAudioMuted obj:@(isMuted)];
        }
        // PK对方的视频状态
        if ([key isEqualToString:kGYLiveAttributeKeyMuteOpVideo]) {
            BOOL isMuted = update.attribute.isMuted;
            [self fb_recieveEvent:GYLiveEventPKReceiveVideoMuted obj:@(isMuted)];
        }
    }
}

/// 带走
/// @param giftConfig 礼物
- (void)fb_privateChatWithGift:(GYLiveGift *)giftConfig
{
    // 私聊带走
    if (kGYLiveHelper.barrageMute) {
        // 被拉黑了，不能带走主播
        GYTipWarning(kGYLocalString(@"You have been muted."));
        return;
    }
    if (![self fb_enoughAutoWalletForConfig:giftConfig showTip:YES]) return;
    kGYWeakSelf;
    GYLiveRoom *room = kGYLiveHelper.data.current;
    GYLiveMainItemCell *current = self.current;
    // 带走接口
    [GYLiveInside fb_loading];
    [GYLiveNetworkHelper fb_userTakeHostWithRoomId:room.roomId
                                            giftId:giftConfig.giftId
                                           success:^(GYLivePrivate * _Nullable privateChat) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // Firbase精细化打点
            NSInteger value = kGYLiveManager.inside.account.coins - privateChat.leftDiamond;
            GYFirbase(GYLiveFirbaseEventTypeSpendCurrency, (@{@"way":@"live-private", @"value":@(value)}));
            // 扣金币
            kGYLiveManager.inside.account.coins = privateChat.leftDiamond;
            kGYLiveManager.inside.coinsUpdate(privateChat.leftDiamond);
            // RTM
            GYLiveBarrage *barrage = [GYLiveBarrage messageWithPrivateGift:giftConfig privateRoom:privateChat];
            [kGYLiveAgoraHelper fb_sendLiveMessageBarrage:barrage completion:nil];
            //
            current.remoteView.videoView = nil;
            // 禁用返回手势
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.enabled = NO;
            }
            // 倒计时
            [GYLiveUIHelper fb_matchingSuccessedAndCountdownByMyselfInView:weakSelf.view withDelayDismiss:^{
                // 退出当前房间
                [weakSelf fb_recieveEvent:GYLiveEventClose obj:nil];
                // 开启返回手势
                if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // 跳转私聊
                    [kGYLiveManager.delegate fb_jumpToPrivate:privateChat];
                    // 统计
                    GYLiveThinking(GYLiveThinkingEventTypeEvent, GYLiveThinkingEventPrivateSuccessInLive, nil);
                    GYEvent(@"fb_LiveEnterPrivateSuccess", nil);
                });
//                kGYLiveHelper.homeReloadTag = YES;
            }];
            [GYLiveInside fb_hideLoading];
        });
    } failure:^{
        [GYLiveInside fb_hideLoading];
    }];
    //
    GYEvent(@"fb_LiveTouchPrivateSend", nil);
    GYLiveThinking(GYLiveThinkingEventTypeEvent, GYLiveThinkingEventClickPrivateButtonInLive, nil);
}

/// 打开anchor个人信息
/// @param anchor anchor
- (void)fb_personalDataWithAnchor:(GYLiveRoomAnchor *)anchor
{
    //
    kGYLiveHelper.comboing = -1;
    [GYLiveComboViewManager.shared fb_removeCurrentViewFromSuperView];
    UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
    
    GYLiveAccount *a = [[GYLiveAccount alloc] init];
    a.nickName = anchor.anchorName;
    a.displayAccountId = anchor.displayAccountId;
    a.avatar = anchor.avatar;
    a.accountId = anchor.accountId;
    GYLiveRoom *room = kGYLiveHelper.data.current;
    kGYWeakSelf;
    [GYLiveUIHelper fb_anchorDataWithAnchor:anchor inView:self.view report:^{
        // 举报
        [GYLiveUIHelper fb_reportInView:weakSelf.view submit:^(NSString * _Nonnull content, NSArray * _Nonnull images) {
            [weakSelf fb_reportWithAccountId:anchor.accountId content:content images:images success:^{
                if (room.isUgc && room.hostAccountId == anchor.accountId) {
                    kGYLiveHelper.homeReloadTag = YES;
                    [weakSelf fb_recieveEvent:GYLiveEventClose obj:nil];
                }
            } failure:^{
            }];
        }];
    } block:^{
        // 拉黑
        if (room.isUgc && room.hostAccountId == anchor.accountId) {
            // ugc调举报接口
            [GYLiveInside fb_loading];
            [GYLiveNetworkHelper fb_reportWithAccountId:anchor.accountId content:@"block" images:@[] success:^{
                [GYLiveInside fb_hideLoading];
                GYTipSuccess(kGYLocalString(@"Block Successfully."));
                // ugc
                kGYLiveHelper.homeReloadTag = YES;
                [weakSelf fb_recieveEvent:GYLiveEventClose obj:nil];
            } failure:^{
                [GYLiveInside fb_hideLoading];
            }];
        } else {
           //在view中处理
        }
    } avatar:^{
        [weakSelf fb_recieveEvent:GYLiveEventMinimize obj:nil];
        //
        [kGYLiveManager.delegate fb_jumpDetailWithRoleType:GYLiveRoleTypeAnchor account:a];
    } message:^{
        [weakSelf fb_recieveEvent:GYLiveEventMinimize obj:nil];
        //
        [kGYLiveManager.delegate fb_jumpConversationWithRoleType:GYLiveRoleTypeAnchor account:a];
        //
        GYEvent(@"fb_LiveHostInfoTouchMessage", nil);
    } follow:^(BOOL boolValue) {
        kGYLiveManager.inside.from = GYLiveThinkingValueLive;
        kGYLiveManager.inside.fromDetail = GYLiveThinkingValueDetailAnchorInfoWindow;
        [weakSelf fb_recieveEvent:GYLiveEventFollow obj:@[@(anchor.accountId), @(boolValue ? 1 : 0)]];
        GYEvent(@"fb_LiveInfoTouchFollow", nil);
    }];
}

/// 打开user个人信息
/// @param user user
- (void)fb_personalDataWithUser:(GYLiveRoomUser *)user
{
    kGYLiveHelper.comboing = -1;
    [GYLiveComboViewManager.shared fb_removeCurrentViewFromSuperView];
    UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
    
    GYLiveAccount *a = [[GYLiveAccount alloc] init];
    a.nickName = user.userName;
    a.displayAccountId = user.displayAccountId;
    a.avatar = user.avatar;
    a.accountId = user.accountId;
    GYLiveRoom *room = kGYLiveHelper.data.current;
    kGYWeakSelf;
    [GYLiveUIHelper fb_userDataWithUser:user inView:self.view report:^{
        // 举报
        [GYLiveUIHelper fb_reportInView:weakSelf.view submit:^(NSString * _Nonnull content, NSArray * _Nonnull images) {
            [weakSelf fb_reportWithAccountId:user.accountId content:content images:images success:^{
                if (room.isUgc && room.hostAccountId == user.accountId) {
                    kGYLiveHelper.homeReloadTag = YES;
                    [weakSelf fb_recieveEvent:GYLiveEventClose obj:nil];
                }
            } failure:^{
            }];
        }];
    } block:^{
        // 拉黑
        if (room.isUgc && room.hostAccountId == user.accountId) {
            // ugc调举报接口
            [GYLiveInside fb_loading];
            [GYLiveNetworkHelper fb_reportWithAccountId:user.accountId content:@"block" images:@[] success:^{
                [GYLiveInside fb_hideLoading];
                GYTipSuccess(kGYLocalString(@"Block Successfully."));
                // ugc
                kGYLiveHelper.homeReloadTag = YES;
                [weakSelf fb_recieveEvent:GYLiveEventClose obj:nil];
            } failure:^{
                [GYLiveInside fb_hideLoading];
            }];
        } else {
            GYTipSuccess(kGYLocalString(@"Block Successfully."));
        }
    } avatar:^{
        [weakSelf fb_recieveEvent:GYLiveEventMinimize obj:nil];
        //
        [kGYLiveManager.delegate fb_jumpDetailWithRoleType:GYLiveRoleTypeUser account:a];
    }];
}

/// 举报
/// @param accountId ID
/// @param content 文案
/// @param images 图片
- (void)fb_reportWithAccountId:(NSInteger)accountId
                       content:(NSString *)content
                        images:(NSArray *)images
                       success:(GYLiveVoidBlock)success
                       failure:(GYLiveVoidBlock)failure
{
    [GYLiveInside fb_loading];
    if (images.count == 0) {
        // 举报
        [GYLiveNetworkHelper fb_reportWithAccountId:accountId content:content images:@[] success:^{
            [GYLiveInside fb_hideLoading];
            GYTipSuccess(kGYLocalString(@"Thank you for your report, we will solve it as soon as possible"));
            if (success) success();
            //
            GYEvent(@"fb_LiveReportSuccess", nil);
        } failure:^{
            [GYLiveInside fb_hideLoading];
            GYTipError(kGYLocalString(@"Failed to report, please try again."));
            if (failure) failure();
        }];
    } else {
        NSMutableArray *marr = [@[] mutableCopy];
        for (UIImage *image in images) {
            [kGYLiveManager.delegate fb_uploadImage:image success:^(NSString * _Nonnull imageURL) {
                [marr addObject:imageURL];
                if (marr.count == images.count) {
                    // 举报
                    [GYLiveNetworkHelper fb_reportWithAccountId:accountId content:content images:marr success:^{
                        [GYLiveInside fb_hideLoading];
                        GYTipSuccess(kGYLocalString(@"We have received your report and will solve it ASAP."));
                        if (success) success();
                        //
                        GYEvent(@"fb_LiveReportSuccess", nil);
                    } failure:^{
                        [GYLiveInside fb_hideLoading];
                        GYTipError(kGYLocalString(@"Failed to report, please try again."));
                        if (failure) failure();
                    }];
                }
            } failure:^{
            }];
        }
        //
        GYEvent(@"fb_LiveReportInputImage", nil);
    }
}

/// 自动关注弹窗
- (void)fb_followTipAuto
{
    GYLiveRoom *room = kGYLiveHelper.data.current;
    if (room.isUgc) return;
    kGYWeakSelf;
    kGYLiveHelper.comboing = -1;
    [GYLiveComboViewManager.shared fb_removeCurrentViewFromSuperView];
    UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
    
    [GYLiveUIHelper fb_autoFollowingWithAvatar:room.hostAvatar
                                        nickname:room.hostName
                                        followed:NO
                                          inView:self.view
                                     avatarBlock:^{
        // 头像
        GYLiveRoomMember *host = [[GYLiveRoomMember alloc] init];
        host.accountId = room.hostAccountId;
        host.roleType = 2;
        [weakSelf fb_recieveEvent:GYLiveEventPersonalData obj:host];
        
    } followBlock:^(BOOL boolValue) {
        // 关注
        kGYLiveManager.inside.from = GYLiveThinkingValueLive;
        kGYLiveManager.inside.fromDetail = GYLiveThinkingValueDetailAutoFollowWindow;
        [weakSelf fb_recieveEvent:GYLiveEventFollow obj:@[@(room.hostAccountId), @(1)]];
    } dismissBlock:^{
    }];
}

#pragma mark - Observers

/// 房间销毁
/// @param not not
- (void)fb_liveDestroyed:(NSNotification *)not
{
    if ([not.object isKindOfClass:[GYLiveDestroyMsg class]]) {
        // 销毁房间：主播关闭房间，用户还在，需要替换接口逻辑roomId
        GYLiveDestroyMsg *msg = (GYLiveDestroyMsg *)not.object;
        GYLiveRoom *room = kGYLiveHelper.data.current;
        if (room.hostAccountId == msg.destroyedRoom.hostAccountId) {
            room.roomId = msg.roomNew.roomId;
            room.roomStatus = msg.roomNew.roomStatus;
            // 如果还在PK中，则退出PK界面，再更新文案
            dispatch_async(dispatch_get_main_queue(), ^{
                if (room.pking) {
                    // 退出PK的UI
                    [self.current fb_event:GYLiveEventPKEnded withObj:nil];
                    GYTipWarning(kGYLocalString(@"The host quit, you lost this turn!"));
                    // 统计
                    [kGYLiveHelper fb_pkEventsGifts1To5MinIfBeforeEnding:YES];
                    [kGYLiveHelper fb_pkEventsEndingProcess];
                }
                // 最小化幕布处理
                if (kGYLiveHelper.isMinimize) kGYLiveHelper.minimizeRemoteView.videoView = nil;
                // 更新文案
                self.current.myHostStatus = room.roomStatus;
            });
        }
        // 刷新列表
//        if (kGYLiveHelper.isMinimize) {
//            [GYLiveInside fb_reloadHomeList];
//        } else {
            kGYLiveHelper.homeReloadTag = YES;
//        }
    }
}

/// 私聊开关状态
/// @param not not
- (void)fb_livePrivateChatFlagChanged:(NSNotification *)not
{
    if ([not.object isKindOfClass:[GYLivePrivateChatFlagMsg class]]) {
        GYLivePrivateChatFlagMsg *msg = (GYLivePrivateChatFlagMsg *)not.object;
        GYLiveRoom *room = kGYLiveHelper.data.current;
        // PK中不处理
        if (room.pking) return;
        if (msg.roomId == room.roomId && !self.isDragging) {
            // 私聊功能是否开启
            dispatch_async(dispatch_get_main_queue(), ^{
                room.privateChatFlag = msg.privateChatFlag;
                // 更新UI
                [self.current fb_event:GYLiveEventUpdatePrivateChat withObj:msg];
                // 主播已关闭私聊功能
                if (msg.privateChatFlag == 2) [self.privateView fb_dismiss];
            });
        }
    }
}

/// 老房间关闭
/// @param not not
- (void)fb_liveOldClosed:(NSNotification *)not
{
    if (self.acceptSseEnable) return;
    if ([not.object isKindOfClass:[GYLiveRoom class]]) {
        // 只有ID的房间信息
        GYLiveRoom *room = (GYLiveRoom *)not.object;
        // 同步数据
        kGYWeakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [kGYLiveHelper.data fb_updateWith:room operationBlock:^GYLiveDataOperation(NSInteger index, GYLiveRoom * _Nullable old) {
                old.roomId = room.roomId;
                old.roomStatus = room.roomStatus;
                if (weakSelf.isDragging) return GYLiveDataOperationNone;
                [weakSelf.tableView beginUpdates];
                return index > kGYLiveHelper.data.index ? GYLiveDataOperationRemove : GYLiveDataOperationNone;
            } completionBlock:^(NSInteger index, GYLiveRoom * _Nullable old) {
                if (index > kGYLiveHelper.data.index && !weakSelf.isDragging) {
                    GYLog(@"live debug - c old close delete %ld all: %ld", index, kGYLiveHelper.data.rooms.count);
                    [weakSelf.tableView deleteSection:index withRowAnimation:UITableViewRowAnimationNone];
                }
            }];
            [self.tableView endUpdates];
        });
    }
}

/// 新开了一个房间
/// @param not not
- (void)fb_liveNewCreated:(NSNotification *)not
{
    if (self.acceptSseEnable) return;
    if ([not.object isKindOfClass:[GYLiveRoom class]]) {
        GYLiveRoom *room = (GYLiveRoom *)not.object;
        // 刷新数据源
        kGYWeakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView beginUpdates];
            [kGYLiveHelper.data fb_updateWith:room operationBlock:^GYLiveDataOperation(NSInteger index, GYLiveRoom * _Nullable old) {
                return GYLiveDataOperationReplaceAdd;
            } completionBlock:^(NSInteger index, GYLiveRoom * _Nullable old) {
                NSInteger count = kGYLiveHelper.data.rooms.count - 1;
                if (index == -1) {
                    GYLog(@"live debug - c new create insert %ld all: %ld", count, kGYLiveHelper.data.rooms.count);
                    [weakSelf.tableView insertSection:count withRowAnimation:UITableViewRowAnimationNone];
                }
            }];
            [self.tableView endUpdates];
        });
    }
}

/// 直播功能关闭
/// @param not not
- (void)fb_liveFeatureClosed:(NSNotification *)not
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fb_recieveEvent:GYLiveEventClose obj:nil];
    });
}

/// 直播恢复
/// @param not not
- (void)fb_liveResumed:(NSNotification *)not
{
    if ([not.object isKindOfClass:[GYLiveRoom class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            GYLiveRoom *resume = (GYLiveRoom *)not.object;
            GYLiveMainItemCell *current = self.current;
            GYLiveRoom *room = kGYLiveHelper.data.current;
            kGYWeakSelf;
            [kGYLiveHelper.data fb_updateWith:resume operationBlock:^GYLiveDataOperation(NSInteger index, GYLiveRoom * _Nullable old) {
                if (index == -1) {
                    return GYLiveDataOperationNone;
                } else {
                    resume.isHostFollowed = old.isHostFollowed;
                    resume.videoChatRoomMembers = old.videoChatRoomMembers;
                    resume.gifts = old.gifts;
                    return GYLiveDataOperationReplaceAdd;
                }
            } completionBlock:^(NSInteger index, GYLiveRoom * _Nullable old) {
                if (index == kGYLiveHelper.data.index) {
                    current.myHostStatus = 2;
                    current.refreshRender = resume;
                    weakSelf.otherRefreshWithRoom = resume;
                    // PK中
                    if (room.pking) {
                        // 退出PK的UI
                        [current fb_event:GYLiveEventPKEnded withObj:nil];
                        GYTipWarning(kGYLocalString(@"The host quit, you lost this turn!"));
                        // 统计
                        [kGYLiveHelper fb_pkEventsGifts1To5MinIfBeforeEnding:YES];
                        [kGYLiveHelper fb_pkEventsEndingProcess];
                    }
                }
            }];
        });
    }
}

- (void)fb_liveFollowStatusUpdate:(NSNotification *)not
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // 别的页面关注之后，更新当前直播间信息
        GYLiveRoom *room = kGYLiveHelper.data.current;
        NSArray *update = not.object;
        NSInteger targetAccountId = [update.firstObject integerValue];
        NSInteger followStatus = [update.lastObject integerValue];
        if (targetAccountId == room.hostAccountId) {
            room.isHostFollowed = followStatus == 1;
            [self.current fb_event:GYLiveEventFollow withObj:@[@(targetAccountId), @(followStatus)]];
            for (UIView *subview in self.view.subviews) {
                if ([subview isKindOfClass:[GYLiveAnchorPopView class]]) {
                    GYLiveAnchorPopView *anchorView = (GYLiveAnchorPopView *)subview;
                    if (anchorView.anchor.accountId == targetAccountId) {
                        anchorView.followed = followStatus == 1;
                        break;
                    }
                }
            }
        }
    });
}

- (void)fb_liveGoalUpdate:(NSNotification *)note
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.current fb_event:GYLiveGoalUpdate withObj:note.object];
    });
}
- (void)fb_liveGoalDone:(NSNotification *)note
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.current fb_playerLiveGoalDone];
    });
}

#pragma mark - Getter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:kGYScreenBounds style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.pagingEnabled = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollsToTop = NO;
        _tableView.estimatedRowHeight = kGYScreenHeight;
        // 低版本机型会闪退
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView registerClass:[GYLiveMainItemCell class] forCellReuseIdentifier:kCellID];
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kGYScreenWidth, 0.01)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kGYScreenWidth, 0.01)];
    }
    return _tableView;
}

- (GYLiveRankPopView *)rankView
{
    if (!_rankView) {
        _rankView = [GYLiveRankPopView rankView];
        kGYWeakSelf;
        _rankView.eventBlock = ^(GYLiveEvent event, id object) {
            [weakSelf fb_recieveEvent:event obj:object];
        };
    }
    return _rankView;
}

- (GYLiveControlGiftsView *)giftsView
{
    if (!_giftsView) {
        _giftsView = [[GYLiveControlGiftsView alloc] initWithFrame:kGYScreenBounds];
    }
    return _giftsView;
}

- (GYLiveGiftPrivateView *)privateView
{
    if (!_privateView) {
        _privateView = [GYLiveGiftPrivateView privateView];
        kGYWeakSelf;
        _privateView.privateBlock = ^(id  _Nullable object) {
            GYLiveGift *config = (GYLiveGift *)object;
            [weakSelf fb_privateChatWithGift:config];
        };
    }
    return _privateView;
}

- (GYLiveMainItemCell *)current
{
    NSInteger index = kGYLiveHelper.data.index;
    GYLiveMainItemCell *item = (GYLiveMainItemCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
    return item;
}

- (GYLiveControlMenuView *)menuView
{
    if (!_menuView) {
        _menuView = [[GYLiveControlMenuView alloc] initWithFrame:self.view.bounds];
        kGYWeakSelf;
        _menuView.eventBlock = ^(GYLiveEvent event, id object) {
            [weakSelf fb_recieveEvent:event obj:object];
        };
    }
    return _menuView;
}

- (void)setOtherRefreshWithRoom:(GYLiveRoom *)otherRefreshWithRoom
{
    _otherRefreshWithRoom = otherRefreshWithRoom;
    //
    self.rankView.members = [otherRefreshWithRoom.videoChatRoomMembers mutableCopy];
    self.privateView.liveRoom = otherRefreshWithRoom;
    self.giftsView.configs = otherRefreshWithRoom.gifts;
}

@end
