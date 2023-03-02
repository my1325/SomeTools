//
//  LJLiveViewController.m
//  Woohoo
//
//  Created by M2-mini on 2021/8/24.
//

#import "LJLiveViewController.h"
#import "LJLiveMainItemCell.h"
#import "LJLiveRankPopView.h"
#import "LJLiveControlGiftsView.h"
#import "LJLiveGiftPrivateView.h"
#import "LJLivePkRankView.h"
#import "LJLiveControlMenuView.h"
#import "LJLiveAnchorPopView.h"
#import <LGLiveKit/LGLiveKit-Swift.h>

@class LJLivePersonalDataAnchorView;

static NSString *const kCellID = @"LJLiveViewControllerCellID";

@interface LJLiveViewController () <UITableViewDelegate, UITableViewDataSource>

/// 直播间列表
@property (nonatomic, strong) UITableView *tableView;
/// 排行榜
@property (nonatomic, strong) LJLiveRankPopView *rankView;
/// 礼物
@property (nonatomic, strong) LJLiveControlGiftsView *giftsView;
/// 私聊带走
@property (nonatomic, strong) LJLiveGiftPrivateView *privateView;
/// 菜单
@property (nonatomic, strong) LJLiveControlMenuView *menuView;
///
@property (nonatomic, strong) LJLiveMainItemCell *current;

@property (nonatomic, assign) BOOL keyboardFlag;
/// 切换房间中（滑动停止 -> 加入房间回调成功）
@property (nonatomic, assign) BOOL isDragging;
///
@property (nonatomic, assign) BOOL cleanBySystem;
///
@property (nonatomic, strong) LJLiveRoom *otherRefreshWithRoom;
///
@property (nonatomic, assign) BOOL closeFlag;
///
@property (nonatomic, assign) BOOL acceptSseEnable;

@end

@implementation LJLiveViewController

#pragma mark - Life Cycle

- (instancetype)initWithHostAccountId:(NSInteger)hostAccountId
{
    self = [super init];
    if (self) {
        [LJLiveInside lj_loading];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            kLJWeakSelf;
            [kLJLiveHelper lj_openLiveByHostId:hostAccountId success:^(id  _Nullable object) {
                
                LJLiveRoom *room = (LJLiveRoom *)object;
                [kLJLiveHelper.data lj_initWithRooms:@[room] atIndex:0];
                [self.tableView reloadData];
                
                LJLiveMainItemCell *current = weakSelf.current;
                current.myHostStatus = room.roomStatus;
                current.joinedRender = room;
                weakSelf.otherRefreshWithRoom = room;
                // 获取更多房间
                weakSelf.acceptSseEnable = YES;
                [kLJLiveHelper.data lj_reloadDataWithSuccess:^(NSArray<LJLiveRoom *> * _Nonnull rooms) {
                    if (rooms.count) {
                        // reload insert
                        [weakSelf.tableView beginUpdates];
                        NSInteger lastCount = kLJLiveHelper.data.rooms.count;
                        for (int i = 0; i < rooms.count; i++) {
                            LJLiveRoom *room = rooms[i];
                            [kLJLiveHelper.data lj_updateWith:room operationBlock:^LJLiveDataOperation(NSInteger index, LJLiveRoom * _Nullable old) {
                                return (index == -1 || index != kLJLiveHelper.data.index) ? LJLiveDataOperationReplaceAdd : LJLiveDataOperationNone;
                            } completionBlock:^(NSInteger index, LJLiveRoom * _Nullable old) {
                            }];
                        }
                        // insert
                        NSInteger count = kLJLiveHelper.data.rooms.count;
                        if (count-lastCount > 0) {
                            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(lastCount, count-lastCount)];
                            [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                            LJLog(@"live debug - reload data insert %ld-%ld all: %ld", lastCount, count-lastCount, count);
                        }
                        [weakSelf.tableView endUpdates];
                    }
                    weakSelf.acceptSseEnable = NO;
                } failure:^{
                    weakSelf.acceptSseEnable = NO;
                }];
                [LJLiveInside lj_hideLoading];
            } failure:^{
                [LJLiveInside lj_hideLoading];
                LJTip(kLJLocalString(@"Failed to join the Livestream, please try again."), LJLiveTipStatusError, 3);
                //
                weakSelf.closeFlag = YES;
                kLJLiveHelper.homeReloadTag = YES;
                if (weakSelf.navigationController) [weakSelf.navigationController popViewControllerAnimated:YES];
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }];
        });
    }
    return self;
}

- (instancetype)initWithRooms:(NSArray<LJLiveRoom *> *)rooms atIndex:(NSInteger)index
{
    self = [super init];
    if (self) {
        // 加入房间
        [LJLiveInside lj_loading];
        // 延迟加入，避免快速销毁及初始化agora失败
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [kLJLiveHelper.data lj_initWithRooms:rooms atIndex:index];
            [self.tableView reloadData];
            [self.tableView setContentOffset:CGPointMake(0, kLJScreenHeight * index) animated:NO];
            LJLog(@"live debug room: initWithRooms: %ld, index: %ld", kLJLiveHelper.data.rooms.count, index);
            
            kLJWeakSelf;
            [kLJLiveHelper lj_openLiveWith:rooms atIndex:index success:^(id  _Nullable object) {
                
                LJLiveRoom *room = (LJLiveRoom *)object;
                // 渲染UI
                LJLiveMainItemCell *current = weakSelf.current;
                current.myHostStatus = room.roomStatus;
                current.joinedRender = room;
                weakSelf.otherRefreshWithRoom = room;
                LJLog(@"live debug room: lj_openLiveWith: %ld", kLJLiveHelper.data.rooms.count);
                // 获取更多房间
                weakSelf.acceptSseEnable = YES;
                [kLJLiveHelper.data lj_reloadDataWithSuccess:^(NSArray<LJLiveRoom *> * _Nonnull rooms) {
                    if (rooms.count) {
                        // reload insert
                        [weakSelf.tableView beginUpdates];
                        NSInteger lastCount = kLJLiveHelper.data.rooms.count;
                        for (int i = 0; i < rooms.count; i++) {
                            LJLiveRoom *room = rooms[i];
                            [kLJLiveHelper.data lj_updateWith:room operationBlock:^LJLiveDataOperation(NSInteger index, LJLiveRoom * _Nullable old) {
                                return (index == -1 || index != kLJLiveHelper.data.index) ? LJLiveDataOperationReplaceAdd : LJLiveDataOperationNone;
                            } completionBlock:^(NSInteger index, LJLiveRoom * _Nullable old) {
                            }];
                        }
                        LJLog(@"live debug room: lj_reloadData: %ld", kLJLiveHelper.data.rooms.count);
                        // insert
                        NSInteger count = kLJLiveHelper.data.rooms.count;
                        if (count-lastCount > 0) {
                            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(lastCount, count-lastCount)];
                            [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                            LJLog(@"live debug - reload data insert %ld-%ld all: %ld", lastCount, count-lastCount, count);
                        }
                        [weakSelf.tableView endUpdates];
                    }
                    weakSelf.acceptSseEnable = NO;
                } failure:^{
                    weakSelf.acceptSseEnable = NO;
                }];
                [LJLiveInside lj_hideLoading];
            } failure:^{
                [LJLiveInside lj_hideLoading];
                LJTip(kLJLocalString(@"Failed to join the Livestream, please try again."), LJLiveTipStatusError, 3);
                //
                weakSelf.closeFlag = YES;
                kLJLiveHelper.homeReloadTag = YES;
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
    if (kLJLiveHelper.fullScreenByMinimize) {
        LJLiveMainItemCell *current = self.current;
        LJLiveRoom *room = kLJLiveHelper.data.current;
        // 更新关注状态
        current.myHostStatus = room.roomStatus;
        if (room.isHostFollowed) [current lj_event:LJLiveEventFollow withObj:@[@(room.hostAccountId), @(1)]];
    }
    // 开启返回手势
    if ([[LJLiveMethods lj_currentNavigationController] respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        [LJLiveMethods lj_currentNavigationController].interactivePopGestureRecognizer.enabled = YES;
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
            if (!kLJLiveHelper.isMinimize) [self lj_recieveEvent:LJLiveEventMinimize obj:nil];
        }
        // 刷新列表
        if (!kLJLiveHelper.data.current.beActive) kLJLiveHelper.homeReloadTag = YES;
        if (kLJLiveHelper.homeReloadTag) [LJLiveInside lj_reloadHomeList];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self lj_addObservers];
    [self lj_setupBlocks];
    [self lj_setupViews];
    // 下载资源
//    [kLJLiveHelper lj_downloadSvgs];
}

#pragma mark - Init

- (void)lj_addObservers
{
    kLJNTFAdd(kLJLiveDestroyed, @selector(lj_liveDestroyed:));
    kLJNTFAdd(kLJLivePrivateChatFlagChanged, @selector(lj_livePrivateChatFlagChanged:));
    kLJNTFAdd(kLJLiveOldClosed, @selector(lj_liveOldClosed:));
    kLJNTFAdd(kLJLiveNewCreated, @selector(lj_liveNewCreated:));
    kLJNTFAdd(kLJLiveFeatureClosed, @selector(lj_liveFeatureClosed:));
    kLJNTFAdd(kLJLiveResumed, @selector(lj_liveResumed:));
    //
    kLJNTFAdd(kLJLiveFollowStatusUpdate,@selector(lj_liveFollowStatusUpdate:));
    // 目标
    kLJNTFAdd(kLJLiveGoalUpdated, @selector(lj_liveGoalUpdate:));
    kLJNTFAdd(kLJLiveGoalDone, @selector(lj_liveGoalDone:));
    // 监听键盘弹起
    kLJNTFAdd(UIKeyboardWillShowNotification, @selector(keyboardWillShowNoti:));
    kLJNTFAdd(UIKeyboardWillHideNotification, @selector(keyboardWillHideNoti:));
}

- (void)lj_setupViews
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

- (void)lj_setupBlocks
{
    kLJWeakSelf;
    // 事件操作
    self.giftsView.eventBlock = ^(LJLiveEvent event, id object) {
        [weakSelf lj_recieveEvent:event obj:object];
    };
    // 收到弹幕
    kLJLiveAgoraHelper.receiveBarrageBlock = ^(LJLiveBarrage *barrage) {
        [weakSelf lj_receivedMessage:barrage];
    };
    // 获取禁言状态
    kLJLiveAgoraHelper.receiveUpdateBlock = ^(NSArray<LJLiveAttributeUpdate *> *updates) {
        [weakSelf lj_updateLiveAttributesFromUpdates:updates];
    };
    // 收到幕布/禁止视频流
    kLJLiveAgoraHelper.receivedVideoBlock = ^(UIView * _Nonnull videoView) {
        // 视频
        weakSelf.current.myHostVideo = videoView;
        //
        if (kLJLiveHelper.data.current.beActive){
            [LJLiveUIHelper lj_waitOrMoreDismiss:weakSelf.view];
        }
    };
    // 收到PK流
    kLJLiveAgoraHelper.receivePkVideoBlock = ^(UIView * _Nonnull videoView) {
        LJLiveMainItemCell *current = weakSelf.current;
        current.pkHostVideo = videoView;
        // 接收到的PK视频流，更改布局
        [current lj_event:LJLiveEventPKReceiveVideo withObj:nil];
        // 关闭私聊功能
        LJLivePrivateChatFlagMsg *msg = [[LJLivePrivateChatFlagMsg alloc] init];
        msg.roomId = kLJLiveHelper.data.current.roomId;
        msg.privateChatFlag = 2;
        [current lj_event:LJLiveEventUpdatePrivateChat withObj:msg];
        [weakSelf.privateView lj_dismiss];
    };
    // 60s自动弹窗关注
    kLJLiveHelper.followAutoTipBlock = ^{
        if (!kLJLiveHelper.data.current.isHostFollowed) [weakSelf lj_followTipAuto];
    };
}

#pragma mark - Notifacation

- (void)keyboardWillShowNoti:(NSNotification *)not
{
    CGRect keyBoardRect = [[not.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyBoardRect.size.height;
    self.current.keyboardChangedHeight = keyboardHeight - kLJBottomSafeHeight - 9;
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
- (void)lj_receivedMessage:(LJLiveBarrage *)barrage
{
    kLJWeakSelf;
    LJLiveMainItemCell *current = self.current;
    LJLiveRoom *room = kLJLiveHelper.data.current;
    if (current == nil || room == nil) return;
    //
    switch (barrage.type) {
        case LJLiveBarrageTypeHint:
        {
            // 通过rtm同步给房间内其他用户
            [kLJLiveAgoraHelper lj_sendLiveMessageBarrage:[LJLiveBarrage messageWithLive:room] completion:nil];
            // 更新至内部弹幕
            [current lj_event:LJLiveEventReceivedBarrage withObj:barrage];
            // 获取禁言信息 + PK对方音视频状态
            [kLJLiveHelper lj_getMutedMembersAndChannelAttributesWithAgoraRoomId:room.agoraRoomId];
            // PK倒计时结束
            if (kLJLiveHelper.pkTimeUpEnd >= 0) [current lj_event:LJLiveEventReceivedBarrage withObj:[LJLiveBarrage pkEndMessage]];
            // 读取房间历史弹幕
            for (int i = 0;i < room.latestBarrages.count; i++) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((i * 0.5 + 1) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    LJLiveBarrage *b = room.latestBarrages[room.latestBarrages.count - i -1];
                    b.type = LJLiveBarrageTypeTextMessage;
                    [current lj_event:LJLiveEventReceivedBarrage withObj:b];
                });
            }
        }
            break;
            
        case LJLiveBarrageTypeLiveRoomInfo:
        {
            // 刷新房间信息
            if (barrage.content.length == 0) {
                return;
            }
            NSDictionary *dict = [NSDictionary lj_dictionaryWithJsonString:barrage.content];
            LJLiveRoom *obj = [[LJLiveRoom alloc] initWithDictionary:dict];
            // 同步信息
            if (obj.hostAccountId == room.hostAccountId) {
                // 收到的最新的房间消息是已结束PK
                if (room.pking && obj.pkData == nil) {
                    
                    [current lj_event:LJLiveEventPKEnded withObj:nil];
                    // 统计
                    [kLJLiveHelper lj_pkEventsGifts1To5MinIfBeforeEnding:YES];
                    [kLJLiveHelper lj_pkEventsEndingProcess];
                }
                // 更新数据源
                [kLJLiveHelper.data lj_updateWith:obj operationBlock:^LJLiveDataOperation(NSInteger index, LJLiveRoom * _Nullable old) {
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
                    return LJLiveDataOperationReplaceAdd;
                } completionBlock:^(NSInteger index, LJLiveRoom * _Nullable old) {
                    //
                    current.refreshRender = obj;
                    current.myHostStatus = obj.roomStatus;
                    weakSelf.privateView.liveRoom = obj;
                    [weakSelf.rankView lj_reloadData];
                }];
            }
        }
            break;
            
        case LJLiveBarrageTypeMembersInfo:
        {
            // 刷新排行榜
            NSData *jsonData = [barrage.content dataUsingEncoding:NSUTF8StringEncoding];
            NSObject *obj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            if ([obj isKindOfClass:[NSArray class]]) {
                NSMutableArray *marr = [@[] mutableCopy];
                for (NSDictionary *dict in (NSArray *)obj) {
                    LJLiveRoomMember *member = [[LJLiveRoomMember alloc] initWithDictionary:dict];
                    [marr addObject:member];
                }
                room.videoChatRoomMembers = marr;
                // 刷新排行
                weakSelf.rankView.members = [room.videoChatRoomMembers mutableCopy];
                current.refreshRender = room;
            }
        }
            break;
            
        case LJLiveBarrageTypeTakeAnchor:
        {
            // 主播被带走
            if (barrage.userId == kLJLiveManager.inside.account.accountId) {
                // 自己则不弹窗
            } else {
                // 绿色账号，不显示动画
                if (kLJLiveManager.inside.account.isGreen) {
                    // 最小化进入更新文案
                    current.myHostStatus = 3;
                    // 刷新标记
                    kLJLiveHelper.homeReloadTag = YES;
                    return;
                }
                // 主播被别的用户带走
                LJLiveRoomMember *member = [[LJLiveRoomMember alloc] init];
                member.avatar = barrage.avatar;
                member.nickName = barrage.userName;
                // 配对成功弹窗
                [LJLiveUIHelper lj_matchingSuccessedByUser:member inView:self.view withDelayDismiss:^{
                    // 最小化进入更新文案
                    current.myHostStatus = 3;
                    room.privateChatFlag = 2;
                    room.roomStatus = 3;
                    // 清理combo动画
                    kLJLiveHelper.comboing = -1;
                    [LJLiveComboViewManager.shared lj_removeCurrentViewFromSuperView];
                    UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
                    // 弹窗
                    [LJLiveUIHelper lj_waitOrMore:weakSelf.view withWait:^{
                        // 统计
                        LJEvent(@"lj_LiveHostPrivatedTouchWait", nil);
                    } more:^{
                        kLJLiveHelper.homeReloadTag = YES;
                        [weakSelf lj_recieveEvent:LJLiveEventClose obj:nil];
                        // 统计
                        LJEvent(@"lj_LiveHostPrivatedTouchMore", nil);
                    }];
                }];
            }
            // 更新文案
            current.myHostStatus = 3;
            room.privateChatFlag = 2;
        }
            break;
            
        case LJLiveBarrageTypeGift:
        {
            // 更新至内部弹幕
            [current lj_event:LJLiveEventReceivedBarrage withObj:barrage];
        }
            break;
            
        case LJLiveBarrageTypeJoinLive:
        case LJLiveBarrageTypeTextMessage:
        case LJLiveBarrageTypeBeMute:
        case LJLiveBarrageTypeCancelMute:
        {
            // 更新至内部弹幕
            [current lj_event:LJLiveEventReceivedBarrage withObj:barrage];
        }
            break;

        case LJLiveBarrageTypePKPrivateFlagChange:
        {
            // PK中收到
            if (room.pking) return;
            // 更新私聊按钮状态
            LJLivePrivateChatFlagMsg *msg = [[LJLivePrivateChatFlagMsg alloc] initWithDictionary:[NSDictionary lj_dictionaryWithJsonString:barrage.content]];
            if (msg.roomId == room.roomId) {
                // 更新UI
                [current lj_event:LJLiveEventUpdatePrivateChat withObj:msg];
                // 主播已关闭私聊功能
                if (msg.privateChatFlag == 2) [self.privateView lj_dismiss];
                // 同步
                room.privateChatFlag = msg.privateChatFlag;
            }
        }
            break;
            
        case LJLiveBarrageTypePKMatchSuccessed:
        {
            // PK配对成功
            // 刷新数据
            LJLivePkData *pkData = [[LJLivePkData alloc] initWithDictionary:[NSDictionary lj_dictionaryWithJsonString:barrage.content]];
            if (pkData.homePlayer.hostAccountId == room.hostAccountId) {
                room.pkData = pkData;
                [current lj_event:LJLiveEventPKReceiveMatchSuccessed withObj:pkData];
                current.refreshRender = room;
            }
            // 关闭私聊功能
            LJLivePrivateChatFlagMsg *msg = [[LJLivePrivateChatFlagMsg alloc] init];
            msg.roomId = room.roomId;
            msg.privateChatFlag = 2;
            [current lj_event:LJLiveEventUpdatePrivateChat withObj:msg];
            [self.privateView lj_dismiss];
            // once more的情况
            if (kLJLiveHelper.pkTimeUpEnd != -1) {
                LJEvent(@"lj_PKBetweenTimeUpAndEnd", @{@"duration": @(kLJLiveHelper.pkTimeUpEnd)});
                kLJLiveHelper.pkTimeUpEnd = -1;
            }
            // 开始计时
            kLJLiveHelper.pkInTimeUp = pkData.pkMaxDuration - pkData.pkLeftTime;
            kLJLiveHelper.pkInEnd = 0;
            // 计时事件
//            [kLJThreeEvents lj_PKBetweenMatchAndTimeUp:0];
//            [kLJThreeEvents lj_PKBetweenJoinAndEnd:0];
            LJLiveThinking(LJLiveThinkingEventTypeTimeEvent, LJLiveThinkingEventTimeForOnePk, nil);
        }
            break;
            
        case LJLiveBarrageTypePKPointUpdated:
        {
            // PK分数更新
            LJLivePkPointUpdatedMsg *msg = [[LJLivePkPointUpdatedMsg alloc] initWithDictionary:[NSDictionary lj_dictionaryWithJsonString:barrage.content]];
            room.pkData.homePoint = msg.homePoint;
            room.pkData.awayPoint = msg.awayPoint;
            [current lj_event:LJLiveEventPKReceivePointUpdate withObj:msg];
        }
            break;
        
        case LJLiveBarrageTypePKTimeUp:
        {
            // PK事件结束
            LJLivePkWinner *winner = [[LJLivePkWinner alloc] initWithDictionary:[NSDictionary lj_dictionaryWithJsonString:barrage.content]];
            room.pkData.pkLeftTime = 0;
            room.pkData.winner = winner;
            [current lj_event:LJLiveEventPKReceiveTimeUp withObj:winner];
            [current lj_event:LJLiveEventReceivedBarrage withObj:[LJLiveBarrage pkEndMessage]];
            // 统计
            [kLJLiveHelper lj_pkEventsGifts1To5MinIfBeforeEnding:YES];
            
            if (kLJLiveHelper.pkInTimeUp != -1) {
                LJEvent(@"lj_PKBetweenMatchAndTimeUp", @{@"duration": @(kLJLiveHelper.pkInTimeUp)});
                kLJLiveHelper.pkInTimeUp = -1;
            }
            
//            [kLJThreeEvents lj_PKBetweenTimeUpAndEnd:0];
            kLJLiveHelper.pkTimeUpEnd = 0;
        }
            break;
        
        case LJLiveBarrageTypePKOnceMore:
        {
            // 再来一次
            NSInteger hostAccountId = [barrage.content integerValue];
            [current lj_event:LJLiveEventPKReceiveReady withObj:@(hostAccountId)];
        }
            break;
            
        case LJLiveBarrageTypePKEnded:
        {
            // PK结束
            [current lj_event:LJLiveEventPKEnded withObj:nil];
            if (room.pkData.pkLeftTime > 0){
                // 提示
                LJTipWarning(kLJLocalString(@"The host quit, you lost this turn!"));
            }
            
            room.pkData = nil;

            // 统计
            LJEvent(@"lj_PKBetweenTimeUpAndEnd", @{@"duration": @(kLJLiveHelper.pkTimeUpEnd)});
            kLJLiveHelper.pkTimeUpEnd = -1;
            
            NSInteger min = kLJLiveHelper.pkInEnd / 60 + kLJLiveHelper.pkInEnd % 60 > 0;
            LJEvent(@"lj_PKBetweenJoinAndEnd", @{@"duration": @(min)});
            LJLiveThinking(LJLiveThinkingEventTypeEvent, LJLiveThinkingEventTimeForOnePk, nil);
            kLJLiveHelper.pkInEnd = -1;
        }
            break;
            
        case LJLiveBarrageTypePKRunAway:
        {
            // PK逃跑，恢复UI
            [current lj_event:LJLiveEventPKEnded withObj:nil];
            room.pkData = nil;
            // 提示
            LJTipWarning(kLJLocalString(@"The other host quit, congrats, you win this turn!"));
            // 统计
            LJEvent(@"lj_PKBetweenMatchAndTimeUp", @{@"duration": @(kLJLiveHelper.pkInTimeUp)});
            [kLJLiveHelper lj_pkEventsGifts1To5MinIfBeforeEnding:YES];
            kLJLiveHelper.pkInTimeUp = -1;
            
            NSInteger min = kLJLiveHelper.pkInEnd / 60 + kLJLiveHelper.pkInEnd % 60 > 0;
            LJEvent(@"lj_PKBetweenJoinAndEnd", @{@"duration": @(min)});
            LJLiveThinking(LJLiveThinkingEventTypeEvent, LJLiveThinkingEventTimeForOnePk, nil);
            kLJLiveHelper.pkInEnd = -1;
        }
            break;
            
        case LJLiveBarrageTypeTurntableInfo:
        {
            // 更新转盘信息以及转盘结果
            NSData *jsonData = [barrage.content dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            // 接收到主播数据后发送给view处理
            [current lj_event:LJLiveEventTurnPlateUpdate withObj:dict];
        }
            break;
            
        case LJLiveBarrageTypeMutedMembers:
        {
            NSData *jsonData = [barrage.content dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *mutedArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            BOOL flag = [mutedArr containsObject:@(kLJLiveManager.inside.account.accountId)];
            if (flag) {
                // 有自己的信息，禁言
                if (!kLJLiveHelper.barrageMute) {
                    // 未被禁言，禁言
                    LJTipWarning(kLJLocalString(@"You have been muted."));
                    kLJLiveHelper.barrageMute = YES;
                }
            } else {
                // 已被禁言，解禁
                if (kLJLiveHelper.barrageMute) {
                    LJTipWarning(kLJLocalString(@"You have been unmuted."));
                    kLJLiveHelper.barrageMute = NO;
                }
            }
            kLJLiveHelper.barrageMute = flag;
        }
            break;
            
        default:
            break;
    }
}

/// 操作事件
/// @param receiveEvent 操作
/// @param obj 对象
- (void)lj_recieveEvent:(LJLiveEvent)receiveEvent obj:(id)obj
{
    kLJWeakSelf;
    LJLiveMainItemCell *current = self.current;
    LJLiveRoom *room = kLJLiveHelper.data.current;
    switch (receiveEvent) {
        case LJLiveEventMinimize:
        {
            if (!room.beActive) {
                [self lj_recieveEvent:LJLiveEventClose obj:nil];
                return;
            }
            // 设置最小化窗口
            kLJLiveHelper.liveVc = self;
            // 关闭房间（最小化）
            if (self.navigationController) [self.navigationController popViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
            
            kLJLiveHelper.comboing = -1;
            [LJLiveComboViewManager.shared lj_removeCurrentViewFromSuperView];
            UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
        }
            break;
            
        case LJLiveEventClose:
        {
            [kLJLiveHelper lj_close];
        }
            break;
            
        case LJLiveEventMembers:
        {
            // 排行榜
            [self.rankView lj_showInView:self.view];
            // 取消键盘
            current.keyboardChangedHeight = 0;
            self.keyboardFlag = NO;
            // 清理combo动画
            kLJLiveHelper.comboing = -1;
            [LJLiveComboViewManager.shared lj_removeCurrentViewFromSuperView];
            UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
        }
            break;
            
        case LJLiveEventGifts:
        {
            // 礼物列表
            [self.giftsView lj_showInView:self.view];
            // 取消键盘
            current.keyboardChangedHeight = 0;
            self.keyboardFlag = NO;
            // 禁用返回手势
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.enabled = NO;
            }
        }
            break;
            
        case LJLiveEventWallet:
        {
            // 打开钱包
            [kLJLiveManager.delegate lj_buyViewOpenAt:self.view];
            // 取消键盘
            current.keyboardChangedHeight = 0;
            self.keyboardFlag = NO;
            // 清理combo动画
            kLJLiveHelper.comboing = -1;
            [LJLiveComboViewManager.shared lj_removeCurrentViewFromSuperView];
            UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
        }
            break;
            
        case LJLiveEventSendBarrage:
        {
            if (kLJLiveHelper.barrageMute) {
                LJTipWarning(kLJLocalString(@"You have been muted."));
                return;
            }
            if (kLJLiveManager.inside.networkStatus == 0) {
                LJTipError(kLJLocalString(@"Please check your network."));
                return;
            }
            // 发送弹幕消息
            if ([obj isKindOfClass:[LJLiveBarrage class]]) {
                // 发给频道其他人
                LJLiveBarrage *barrage = (LJLiveBarrage *)obj;
                [kLJLiveAgoraHelper lj_sendLiveMessageBarrage:barrage completion:nil];
                // 加到自己的弹幕中
                if (kLJLiveAgoraHelper.receiveBarrageBlock) kLJLiveAgoraHelper.receiveBarrageBlock(barrage);
                // 接口记录
                if (barrage.type == LJLiveBarrageTypeTextMessage && !room.isUgc) {
                    [LJLiveNetworkHelper lj_sendTextMessage:barrage.content roomId:room.roomId success:^{
                    } failure:^{
                    }];
                }
            }
            //
            if (!room.beActive) LJEvent(@"lj_LiveHostLeaveSendBarrage", nil);
            LJLiveThinking(LJLiveThinkingEventTypeEvent, LJLiveThinkingEventSendBarrageInLive, nil);
        }
            break;
            
        case LJLiveEventSendGift:
        case LJLiveEventFastGift:
        {
            if (kLJLiveManager.inside.networkStatus == 0) {
                LJTipError(kLJLocalString(@"Please check your network."));
                return;
            }
            // 送礼
            if ([obj isKindOfClass:[LJLiveGift class]]) {
                LJLiveGift *config = (LJLiveGift *)obj;
                if ([self lj_enoughAutoWalletForConfig:config showTip:YES]) {
                    // 送礼（接口 + RTM + 扣费）
                    [kLJLiveHelper lj_sendGift:config isFast:receiveEvent == LJLiveEventFastGift];
                    // 统计
                    if (!room.beActive) LJEvent(@"lj_LiveHostLeaveSendGift", nil);
                    if (room.pking) {
                        NSInteger min = kLJLiveHelper.pkInTimeUp / 60 + 1;
                        if (min == 1) {
                            // 在第一分钟送礼
                            LJEvent(@"lj_PKSendGiftsWithin1Min", nil);
                            LJEvent(@"lj_PKSendGiftsPriceWithin1Min", @{@"price": @(config.giftPrice).stringValue});
                        }
                        if (min == 2) {
                            // 在第二分钟送礼
                            LJEvent(@"lj_PKSendGiftsWithin2Min", nil);
                            LJEvent(@"lj_PKSendGiftsPriceWithin2Min", @{@"price": @(config.giftPrice).stringValue});
                        }
                        if (min == 3) {
                            // 在第三分钟送礼
                            LJEvent(@"lj_PKSendGiftsWithin3Min", nil);
                            LJEvent(@"lj_PKSendGiftsPriceWithin3Min", @{@"price": @(config.giftPrice).stringValue});
                        }
                        if (min == 4) {
                            // 在第四分钟送礼
                            LJEvent(@"lj_PKSendGiftsWithin4Min", nil);
                            LJEvent(@"lj_PKSendGiftsPriceWithin4Min", @{@"price": @(config.giftPrice).stringValue});
                        }
                        if (min == 5) {
                            // 在第五分钟送礼
                            LJEvent(@"lj_PKSendGiftsWithin5Min", nil);
                            LJEvent(@"lj_PKSendGiftsPriceWithin5Min", @{@"price": @(config.giftPrice).stringValue});
                        }
                        // 在最后15秒钟赠送
                        NSInteger sec = room.pkData.pkMaxDuration - kLJLiveHelper.pkInTimeUp;
                        if (sec <= 15 && sec >= 0 && kLJLiveHelper.pkInTimeUp > 0) {
                            LJEvent(@"lj_PKSendGiftsInLast15s", nil);
                            LJEvent(@"lj_PKSendGiftsPriceInLast15s", @{@"price": @(config.giftPrice).stringValue});
                            kLJLiveHelper.last15SendCoins += config.giftPrice;
                        }
                        if (min >= 1 && min <= 5 && kLJLiveHelper.pkInTimeUp > 0) {
                            kLJLiveHelper.pkInSendCoins += config.giftPrice;
                        }
                    }
                } else {
                    [self.giftsView lj_dismiss];
                }
            }
        }
            break;
            
        case LJLiveEventPrivateChat:
        {
            if (kLJLiveManager.inside.networkStatus == 0) {
                LJTipError(kLJLocalString(@"Please check your network."));
                return;
            }
            // 私聊带走
            if (kLJLiveHelper.barrageMute) {
                // 被拉黑了，不能带走主播
                LJTipWarning(kLJLocalString(@"You have been muted."));
                return;
            }
            self.privateView.liveRoom = room;
            [self.privateView lj_showInView:self.view];
            // 取消键盘
            current.keyboardChangedHeight = 0;
            self.keyboardFlag = NO;
        }
            break;
            
        case LJLiveEventPersonalData:
        {
            if (kLJLiveManager.inside.networkStatus == 0) {
                LJTipError(kLJLocalString(@"Please check your network."));
                return;
            }
            // 个人详情
            if ([obj isKindOfClass:[LJLiveRoomAnchor class]]) {
                // 主播信息
                [self lj_personalDataWithAnchor:(LJLiveRoomAnchor *)obj];
            }
            if ([obj isKindOfClass:[LJLiveRoomMember class]]) {
                // 成员（主播 + 用户）
                LJLiveRoomMember *member = (LJLiveRoomMember *)obj;
                // PK相关
                NSInteger roomId = member.pkRoomId > 0 ? member.pkRoomId : room.roomId;
                // ugc
                if (room.isUgc && member.accountId == room.hostAccountId) member.roleType = LJLiveRoleTypeUser;
                //
                if (member.roleType == LJLiveRoleTypeUser) {
                    // 请求用户详情
                    [LJLiveInside lj_loading];
                    [LJLiveNetworkHelper lj_getLiveUserInfoWithUserId:member.accountId roomId:roomId success:^(LJLiveRoomUser * _Nullable user) {
                        [LJLiveInside lj_hideLoading];
                        [weakSelf lj_personalDataWithUser:user];
                    } failure:^{
                        [LJLiveInside lj_hideLoading];
                    }];
                } else {
                    // == 2 请求主播详情
                    [LJLiveInside lj_loading];
                    [LJLiveNetworkHelper lj_getLiveAnchorInfoWithAnchorId:member.accountId roomId:roomId success:^(LJLiveRoomAnchor * _Nullable anchor) {
                        [LJLiveInside lj_hideLoading];
                        [weakSelf lj_personalDataWithAnchor:anchor];
                    } failure:^{
                        [LJLiveInside lj_hideLoading];
                    }];
                }
            }
            // 取消键盘
            current.keyboardChangedHeight = 0;
            self.keyboardFlag = NO;
        }
            break;
        
        case LJLiveEventFollow:
        {
            // 关注
            if ([obj isKindOfClass:[NSArray class]]) {
                NSArray *array = (NSArray *)obj;
                NSInteger accountId = [array.firstObject integerValue];
                BOOL follow = [array.lastObject boolValue];
                if (follow) {
                    // 关注
                    [LJLiveNetworkHelper lj_followByTargetAccountId:accountId success:^{
                        if (accountId == room.hostAccountId) {
                            [current lj_event:LJLiveEventFollow withObj:@[@(accountId), @(1)]];
                            // 更新数据
                            room.isHostFollowed = YES;
                        }
                    } failure:^{
                        LJTipError(kLJLocalString(@"Failed to follow."));
                    }];
                } else {
                    // 取消关注
                    [LJLiveNetworkHelper lj_cancelFollowByTargetAccountId:accountId success:^{
                        if (accountId == room.hostAccountId) {
                            [current lj_event:LJLiveEventFollow withObj:@[@(accountId), @(0)]];
                            // 更新数据
                            room.isHostFollowed = NO;
                        }
                    } failure:^{
                    }];
                }
            }
            kLJLiveHelper.homeReloadTag = YES;
        }
            break;
            
        case LJLiveEventPKOpenAwayRoom:
        {
            // 跳转房间
            LJLivePkPlayer *awayPlayer = (LJLivePkPlayer *)obj;
            LJLiveRoom *model = [[LJLiveRoom alloc] init];
            model.hostAccountId = awayPlayer.hostAccountId;
            [kLJLiveHelper.data lj_updateWith:model operationBlock:^LJLiveDataOperation(NSInteger index, LJLiveRoom * _Nullable old) {
                if (index == -1) {
                    // 没有该房间，请求数据加入
                    [LJLiveInside lj_loading];
                    [LJLiveNetworkHelper lj_getLiveInfoWithRoomId:awayPlayer.roomId success:^(LJLiveRoom * _Nullable room) {
                        if (room) {
                            [weakSelf.tableView beginUpdates];
                            [kLJLiveHelper.data lj_updateWith:room operationBlock:^LJLiveDataOperation(NSInteger index, LJLiveRoom * _Nullable old) {
                                return LJLiveDataOperationReplaceAdd;
                            } completionBlock:^(NSInteger index, LJLiveRoom * _Nullable old) {
                                if (index == -1) {
                                    // 再次执行跳转
                                    [weakSelf.tableView insertSection:kLJLiveHelper.data.rooms.count-1 withRowAnimation:UITableViewRowAnimationNone];
                                }
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [weakSelf lj_recieveEvent:LJLiveEventPKOpenAwayRoom obj:awayPlayer];
                                });
                            }];
                            [weakSelf.tableView endUpdates];
                        }
                    } failure:^{
                        [LJLiveInside lj_hideLoading];
                    }];
                } else {
                    // 离开当前
                    [weakSelf lj_switchLeaveAtIndex:kLJLiveHelper.data.index];
                    // 跳转
                    [weakSelf.tableView reloadData];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf.tableView setContentOffset:CGPointMake(0, kLJScreenHeight * index) animated:NO];
                        // 加入（数据先行）
                        [weakSelf lj_switchJoinToIndex:index];
                        // 切换rtc
                        [kLJLiveAgoraHelper lj_switchAgoraRtcWithAgoraRoomId:old.agoraRoomId completion:nil];
                    });

                    if (kLJLiveManager.inside.joinFlag) {
                        kLJLiveManager.inside.fromJoin = LJLiveThinkingValueBroadcast;
                        kLJLiveManager.inside.joinFlag = NO;
                    }
                    [LJLiveInside lj_hideLoading];
                }
                return LJLiveDataOperationNone;
            } completionBlock:^(NSInteger index, LJLiveRoom * _Nullable old) {
            }];
            //
            LJEvent(@"lj_PKClickOppositeButton", nil);
        }
            break;
            
        case LJLiveEventPKOpenHomeRank:
        {
            // 打开PK粉丝榜
            if (room.pking) {
                [LJLiveInside lj_loading];
                [LJLiveNetworkHelper lj_getLiveTopFansWithRoomId:room.roomId
                                                               hostId:room.hostAccountId
                                                              success:^(NSArray<LJLivePkTopFan *> * _Nonnull fans) {
                    //
                    LJLivePkRankView *pkRankView = [LJLivePkRankView lj_pkRankView];
                    pkRankView.eventBlock = ^(LJLiveEvent event, id object) {
                        [weakSelf lj_recieveEvent:event obj:object];
                        LJEvent(@"lj_PKFansContributionListClickDetail", nil);
                    };
                    pkRankView.isHome = YES;
                    pkRankView.fans = fans;
                    [pkRankView lj_pkRankOpenInView:weakSelf.view];
                    [LJLiveInside lj_hideLoading];
                } failure:^{
                    [LJLiveInside lj_hideLoading];
                }];
                //
                LJEvent(@"lj_PKClickFansContributionList", nil);
                LJLiveThinking(LJLiveThinkingEventTypeEvent, LJLiveThinkingEventClickGiftRankInPk, nil);
            }
        }
            break;
            
        case LJLiveEventPKOpenAwayRank:
        {
            // 打开PK粉丝榜
            if (room.pking) {
                [LJLiveInside lj_loading];
                [LJLiveNetworkHelper lj_getLiveTopFansWithRoomId:room.roomId
                                                               hostId:room.pkData.awayPlayer.hostAccountId
                                                              success:^(NSArray<LJLivePkTopFan *> * _Nonnull fans) {
                    //
                    LJLivePkRankView *pkRankView = [LJLivePkRankView lj_pkRankView];
                    pkRankView.eventBlock = ^(LJLiveEvent event, id object) {
                        [weakSelf lj_recieveEvent:event obj:object];
                        LJEvent(@"lj_PKFansContributionListClickDetail", nil);
                    };
                    pkRankView.isHome = NO;
                    pkRankView.fans = fans;
                    [pkRankView lj_pkRankOpenInView:weakSelf.view];
                    [LJLiveInside lj_hideLoading];
                } failure:^{
                    [LJLiveInside lj_hideLoading];
                }];
                //
                LJEvent(@"lj_PKClickFansContributionList", nil);
                LJLiveThinking(LJLiveThinkingEventTypeEvent, LJLiveThinkingEventClickGiftRankInPk, nil);
            }
        }
            break;
            
        case LJLiveEventPKReceiveAudioMuted:
        {
            [current lj_event:LJLiveEventPKReceiveAudioMuted withObj:obj];
        }
            break;
        
        case LJLiveEventPKReceiveVideoMuted:
        {
            [current lj_event:LJLiveEventPKReceiveVideoMuted withObj:obj];
        }
            break;
            
        case LJLiveEventReport:
        {
            // 底部控制栏举报
            [LJLiveUIHelper lj_reportInView:weakSelf.view submit:^(NSString * _Nonnull content, NSArray * _Nonnull images) {
                [weakSelf lj_reportWithAccountId:room.hostAccountId content:content images:images success:^{
                    if (room.isUgc) {
                        kLJLiveHelper.homeReloadTag = YES;
                        [weakSelf lj_recieveEvent:LJLiveEventClose obj:nil];
                    }
                } failure:^{
                }];
            }];
        }
            break;
            
        case LJLiveEventOpenMenu:
        {
            [self.menuView lj_showInView:self.view];
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
    
    NSInteger index = self.tableView.contentOffset.y / kLJScreenHeight;
    //
    kLJLiveHelper.comboing = -1;
    [LJLiveComboViewManager.shared lj_removeCurrentViewFromSuperView];
    UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
    
    LJLog(@"live scroll - will begin: %ld", index);
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGPoint point = CGPointMake(targetContentOffset->x, targetContentOffset->y);
    NSInteger index = point.y / kLJScreenHeight;
 
    if (labs(index - kLJLiveHelper.data.index) >= 2) {
        // 滑动超过2个cell，系统会自动清理掉cell，这时退出该房间
        [kLJLiveAgoraHelper lj_logoutAgoraRtcWithCompletion:nil];
        [self lj_switchLeaveAtIndex:kLJLiveHelper.data.index];
        self.cleanBySystem = YES;
    }
    
    LJLog(@"live scroll - will end: %ld", index);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 切换房间
    __block NSInteger nextIndex = scrollView.contentOffset.y / kLJScreenHeight;
    NSInteger oldIndex = kLJLiveHelper.data.index;
    // 如果滑动没有触发系统的清理cell，则nextindex == index不做处理
    if (!self.cleanBySystem && nextIndex == oldIndex) {
        return;
    }
    LJLiveRoom *next = kLJLiveHelper.data.rooms[nextIndex];
    LJLiveRoom *current = kLJLiveHelper.data.current;
    // 退出上一个房间
    if (!self.cleanBySystem) [self lj_switchLeaveAtIndex:oldIndex];
    // 移除异常房间
    if (current.beActive) {
    } else {
        kLJWeakSelf;
        [self.tableView beginUpdates];
        [kLJLiveHelper.data lj_updateWith:current operationBlock:^LJLiveDataOperation(NSInteger index, LJLiveRoom * _Nullable old) {
            return LJLiveDataOperationRemove;
        } completionBlock:^(NSInteger index, LJLiveRoom * _Nullable old) {
            if (index == -1) {
            } else {
                [weakSelf.tableView deleteSection:index withRowAnimation:UITableViewRowAnimationNone];
                [weakSelf.tableView endUpdates];
                LJLog(@"live debug - reload data delete %ld all: %ld", index, kLJLiveHelper.data.rooms.count);
                if (nextIndex > oldIndex) {
                    [weakSelf.tableView setContentOffset:CGPointMake(0, kLJScreenHeight * index) animated:NO];
                    nextIndex -= 1;
                }
            }
        }];
    }
    // 加入下一个房间（数据先行）
    [self lj_switchJoinToIndex:nextIndex];
    // rtc
    if (self.cleanBySystem) {
        [kLJLiveAgoraHelper lj_joinAgoraRtcWithAgoraRoomId:next.agoraRoomId completion:nil];
    } else {
        [kLJLiveAgoraHelper lj_switchAgoraRtcWithAgoraRoomId:next.agoraRoomId completion:nil];
    }
    self.cleanBySystem = NO;
    
    self.isDragging = NO;
    LJLog(@"live scroll - did end: %ld", nextIndex);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = kLJLiveHelper.data.rooms.count;
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LJLiveMainItemCell *main = [tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];
    if (main == nil) {
        main = [[LJLiveMainItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
    }
    LJLiveRoom *room = kLJLiveHelper.data.rooms[indexPath.section];
    main.room = room;
    // 清理UI
    NSInteger index = kLJLiveHelper.data.index;
    if (indexPath.section == index) {
    } else {
        main.joinedRender = nil;
    }
    
    kLJWeakSelf;
    main.eventBlock = ^(LJLiveEvent event, id object) {
        [weakSelf lj_recieveEvent:event obj:object];
    };
    // 高斯模糊背景
    [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:room.roomCover]
                                              options:SDWebImageRetryFailed
                                             progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        UIImage *blureImage = image ?: kLJLiveManager.config.avatar;
        [main.remoteView.backgroudImageView setImage:blureImage];
    }];
    if (room.pking) {
        [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:room.pkData.awayPlayer.roomCover]
                                                  options:SDWebImageRetryFailed
                                                 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            UIImage *blureImage = image ?: kLJLiveManager.config.avatar;
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
    return kLJScreenHeight;
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

- (void)lj_switchLeaveAtIndex:(NSInteger)index
{
    // 清理房间UI
    LJLiveMainItemCell *cell = (LJLiveMainItemCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
    [cell lj_event:LJLiveEventRoomLeave withObj:nil];
    // 退出RTM + NET
    [kLJLiveHelper lj_switchLeaveFromIndex:index];
}

- (void)lj_switchJoinToIndex:(NSInteger)toIndex
{
    [LJLiveInside lj_loading];
    // 下一个房间
    kLJLiveHelper.data.index = toIndex;
    // 加入RTM + NET
    kLJWeakSelf;
    [kLJLiveHelper lj_switchToIndex:toIndex success:^(id  _Nullable object) {
        LJLiveRoom *obj = (LJLiveRoom *)object;
        LJLiveMainItemCell *current = weakSelf.current;
        current.joinedRender = obj;
        current.myHostStatus = obj.roomStatus;
        weakSelf.otherRefreshWithRoom = obj;
        [LJLiveInside lj_hideLoading];
    } failure:^{
        [LJLiveInside lj_hideLoading];
        // 提示
        LJTip(kLJLocalString(@"Failed to join the Livestream, please try again."), LJLiveTipStatusError, 3);
        // 统计
        LJEvent(@"lj_LiveEnterErrorRoom", nil);
    }];
}

/// 没有足够的金币
/// @param config 礼物
- (BOOL)lj_enoughAutoWalletForConfig:(LJLiveGift *)config showTip:(BOOL)showTip
{
    if (kLJLiveManager.inside.account.coins < config.giftPrice) {
        // 金币不足，跳转钱包
        if (showTip) LJTipWarning(kLJLocalString(@"You don't have enough coins."));
        [self lj_recieveEvent:LJLiveEventWallet obj:nil];
        return NO;
    }
    return YES;
}

- (void)lj_clean
{
    [self.current lj_event:LJLiveEventRoomLeave withObj:nil];
    self.closeFlag = YES;
}

- (void)lj_reloadMyCoins
{
    [self.giftsView lj_reloadMyCoins];
    
    LJLiveMainItemCell *current = self.current;
    [current.containerView lj_event:LJLiveEventRechargeSuccess withObj:nil];
}

#pragma mark - Events

/// 从RTM信息中更新自己的封禁状态
/// @param updates RTM
- (void)lj_updateLiveAttributesFromUpdates:(NSArray *)updates
{
//    NSString *accountId = @(kLJLiveManager.inside.account.accountId).stringValue;
    for (LJLiveAttributeUpdate *update in updates) {
        NSString *key = update.key;
        // 观众的禁言状态
//        if ([key isEqualToString:accountId]) {
//        }
        // PK对方的音频状态
        if ([key isEqualToString:kLJLiveAttributeKeyMuteOpAudio]) {
            BOOL isMuted = update.attribute.isMuted;
            [self lj_recieveEvent:LJLiveEventPKReceiveAudioMuted obj:@(isMuted)];
        }
        // PK对方的视频状态
        if ([key isEqualToString:kLJLiveAttributeKeyMuteOpVideo]) {
            BOOL isMuted = update.attribute.isMuted;
            [self lj_recieveEvent:LJLiveEventPKReceiveVideoMuted obj:@(isMuted)];
        }
    }
}

/// 带走
/// @param giftConfig 礼物
- (void)lj_privateChatWithGift:(LJLiveGift *)giftConfig
{
    // 私聊带走
    if (kLJLiveHelper.barrageMute) {
        // 被拉黑了，不能带走主播
        LJTipWarning(kLJLocalString(@"You have been muted."));
        return;
    }
    if (![self lj_enoughAutoWalletForConfig:giftConfig showTip:YES]) return;
    kLJWeakSelf;
    LJLiveRoom *room = kLJLiveHelper.data.current;
    LJLiveMainItemCell *current = self.current;
    // 带走接口
    [LJLiveInside lj_loading];
    [LJLiveNetworkHelper lj_userTakeHostWithRoomId:room.roomId
                                            giftId:giftConfig.giftId
                                           success:^(LJLivePrivate * _Nullable privateChat) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // Firbase精细化打点
            NSInteger value = kLJLiveManager.inside.account.coins - privateChat.leftDiamond;
            LJFirbase(LJLiveFirbaseEventTypeSpendCurrency, (@{@"way":@"live-private", @"value":@(value)}));
            // 扣金币
            kLJLiveManager.inside.account.coins = privateChat.leftDiamond;
            kLJLiveManager.inside.coinsUpdate(privateChat.leftDiamond);
            // RTM
            LJLiveBarrage *barrage = [LJLiveBarrage messageWithPrivateGift:giftConfig privateRoom:privateChat];
            [kLJLiveAgoraHelper lj_sendLiveMessageBarrage:barrage completion:nil];
            //
            current.remoteView.videoView = nil;
            // 禁用返回手势
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.enabled = NO;
            }
            // 倒计时
            [LJLiveUIHelper lj_matchingSuccessedAndCountdownByMyselfInView:weakSelf.view withDelayDismiss:^{
                // 退出当前房间
                [weakSelf lj_recieveEvent:LJLiveEventClose obj:nil];
                // 开启返回手势
                if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // 跳转私聊
                    [kLJLiveManager.delegate lj_jumpToPrivate:privateChat];
                    // 统计
                    LJLiveThinking(LJLiveThinkingEventTypeEvent, LJLiveThinkingEventPrivateSuccessInLive, nil);
                    LJEvent(@"lj_LiveEnterPrivateSuccess", nil);
                });
//                kLJLiveHelper.homeReloadTag = YES;
            }];
            [LJLiveInside lj_hideLoading];
        });
    } failure:^{
        [LJLiveInside lj_hideLoading];
    }];
    //
    LJEvent(@"lj_LiveTouchPrivateSend", nil);
    LJLiveThinking(LJLiveThinkingEventTypeEvent, LJLiveThinkingEventClickPrivateButtonInLive, nil);
}

/// 打开anchor个人信息
/// @param anchor anchor
- (void)lj_personalDataWithAnchor:(LJLiveRoomAnchor *)anchor
{
    //
    kLJLiveHelper.comboing = -1;
    [LJLiveComboViewManager.shared lj_removeCurrentViewFromSuperView];
    UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
    
    LJLiveAccount *a = [[LJLiveAccount alloc] init];
    a.nickName = anchor.anchorName;
    a.displayAccountId = anchor.displayAccountId;
    a.avatar = anchor.avatar;
    a.accountId = anchor.accountId;
    LJLiveRoom *room = kLJLiveHelper.data.current;
    kLJWeakSelf;
    [LJLiveUIHelper lj_anchorDataWithAnchor:anchor inView:self.view report:^{
        // 举报
        [LJLiveUIHelper lj_reportInView:weakSelf.view submit:^(NSString * _Nonnull content, NSArray * _Nonnull images) {
            [weakSelf lj_reportWithAccountId:anchor.accountId content:content images:images success:^{
                if (room.isUgc && room.hostAccountId == anchor.accountId) {
                    kLJLiveHelper.homeReloadTag = YES;
                    [weakSelf lj_recieveEvent:LJLiveEventClose obj:nil];
                }
            } failure:^{
            }];
        }];
    } block:^{
        // 拉黑
        if (room.isUgc && room.hostAccountId == anchor.accountId) {
            // ugc调举报接口
            [LJLiveInside lj_loading];
            [LJLiveNetworkHelper lj_reportWithAccountId:anchor.accountId content:@"block" images:@[] success:^{
                [LJLiveInside lj_hideLoading];
                LJTipSuccess(kLJLocalString(@"Block Successfully."));
                // ugc
                kLJLiveHelper.homeReloadTag = YES;
                [weakSelf lj_recieveEvent:LJLiveEventClose obj:nil];
            } failure:^{
                [LJLiveInside lj_hideLoading];
            }];
        } else {
           //在view中处理
        }
    } avatar:^{
        [weakSelf lj_recieveEvent:LJLiveEventMinimize obj:nil];
        //
        [kLJLiveManager.delegate lj_jumpDetailWithRoleType:LJLiveRoleTypeAnchor account:a];
    } message:^{
        [weakSelf lj_recieveEvent:LJLiveEventMinimize obj:nil];
        //
        [kLJLiveManager.delegate lj_jumpConversationWithRoleType:LJLiveRoleTypeAnchor account:a];
        //
        LJEvent(@"lj_LiveHostInfoTouchMessage", nil);
    } follow:^(BOOL boolValue) {
        kLJLiveManager.inside.from = LJLiveThinkingValueLive;
        kLJLiveManager.inside.fromDetail = LJLiveThinkingValueDetailAnchorInfoWindow;
        [weakSelf lj_recieveEvent:LJLiveEventFollow obj:@[@(anchor.accountId), @(boolValue ? 1 : 0)]];
        LJEvent(@"lj_LiveInfoTouchFollow", nil);
    }];
}

/// 打开user个人信息
/// @param user user
- (void)lj_personalDataWithUser:(LJLiveRoomUser *)user
{
    kLJLiveHelper.comboing = -1;
    [LJLiveComboViewManager.shared lj_removeCurrentViewFromSuperView];
    UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
    
    LJLiveAccount *a = [[LJLiveAccount alloc] init];
    a.nickName = user.userName;
    a.displayAccountId = user.displayAccountId;
    a.avatar = user.avatar;
    a.accountId = user.accountId;
    LJLiveRoom *room = kLJLiveHelper.data.current;
    kLJWeakSelf;
    [LJLiveUIHelper lj_userDataWithUser:user inView:self.view report:^{
        // 举报
        [LJLiveUIHelper lj_reportInView:weakSelf.view submit:^(NSString * _Nonnull content, NSArray * _Nonnull images) {
            [weakSelf lj_reportWithAccountId:user.accountId content:content images:images success:^{
                if (room.isUgc && room.hostAccountId == user.accountId) {
                    kLJLiveHelper.homeReloadTag = YES;
                    [weakSelf lj_recieveEvent:LJLiveEventClose obj:nil];
                }
            } failure:^{
            }];
        }];
    } block:^{
        // 拉黑
        if (room.isUgc && room.hostAccountId == user.accountId) {
            // ugc调举报接口
            [LJLiveInside lj_loading];
            [LJLiveNetworkHelper lj_reportWithAccountId:user.accountId content:@"block" images:@[] success:^{
                [LJLiveInside lj_hideLoading];
                LJTipSuccess(kLJLocalString(@"Block Successfully."));
                // ugc
                kLJLiveHelper.homeReloadTag = YES;
                [weakSelf lj_recieveEvent:LJLiveEventClose obj:nil];
            } failure:^{
                [LJLiveInside lj_hideLoading];
            }];
        } else {
            LJTipSuccess(kLJLocalString(@"Block Successfully."));
        }
    } avatar:^{
        [weakSelf lj_recieveEvent:LJLiveEventMinimize obj:nil];
        //
        [kLJLiveManager.delegate lj_jumpDetailWithRoleType:LJLiveRoleTypeUser account:a];
    }];
}

/// 举报
/// @param accountId ID
/// @param content 文案
/// @param images 图片
- (void)lj_reportWithAccountId:(NSInteger)accountId
                       content:(NSString *)content
                        images:(NSArray *)images
                       success:(LJLiveVoidBlock)success
                       failure:(LJLiveVoidBlock)failure
{
    [LJLiveInside lj_loading];
    if (images.count == 0) {
        // 举报
        [LJLiveNetworkHelper lj_reportWithAccountId:accountId content:content images:@[] success:^{
            [LJLiveInside lj_hideLoading];
            LJTipSuccess(kLJLocalString(@"Thank you for your report, we will solve it as soon as possible"));
            if (success) success();
            //
            LJEvent(@"lj_LiveReportSuccess", nil);
        } failure:^{
            [LJLiveInside lj_hideLoading];
            LJTipError(kLJLocalString(@"Failed to report, please try again."));
            if (failure) failure();
        }];
    } else {
        NSMutableArray *marr = [@[] mutableCopy];
        for (UIImage *image in images) {
            [kLJLiveManager.delegate lj_uploadImage:image success:^(NSString * _Nonnull imageURL) {
                [marr addObject:imageURL];
                if (marr.count == images.count) {
                    // 举报
                    [LJLiveNetworkHelper lj_reportWithAccountId:accountId content:content images:marr success:^{
                        [LJLiveInside lj_hideLoading];
                        LJTipSuccess(kLJLocalString(@"We have received your report and will solve it ASAP."));
                        if (success) success();
                        //
                        LJEvent(@"lj_LiveReportSuccess", nil);
                    } failure:^{
                        [LJLiveInside lj_hideLoading];
                        LJTipError(kLJLocalString(@"Failed to report, please try again."));
                        if (failure) failure();
                    }];
                }
            } failure:^{
            }];
        }
        //
        LJEvent(@"lj_LiveReportInputImage", nil);
    }
}

/// 自动关注弹窗
- (void)lj_followTipAuto
{
    LJLiveRoom *room = kLJLiveHelper.data.current;
    if (room.isUgc) return;
    kLJWeakSelf;
    kLJLiveHelper.comboing = -1;
    [LJLiveComboViewManager.shared lj_removeCurrentViewFromSuperView];
    UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
    
    [LJLiveUIHelper lj_autoFollowingWithAvatar:room.hostAvatar
                                        nickname:room.hostName
                                        followed:NO
                                          inView:self.view
                                     avatarBlock:^{
        // 头像
        LJLiveRoomMember *host = [[LJLiveRoomMember alloc] init];
        host.accountId = room.hostAccountId;
        host.roleType = 2;
        [weakSelf lj_recieveEvent:LJLiveEventPersonalData obj:host];
        
    } followBlock:^(BOOL boolValue) {
        // 关注
        kLJLiveManager.inside.from = LJLiveThinkingValueLive;
        kLJLiveManager.inside.fromDetail = LJLiveThinkingValueDetailAutoFollowWindow;
        [weakSelf lj_recieveEvent:LJLiveEventFollow obj:@[@(room.hostAccountId), @(1)]];
    } dismissBlock:^{
    }];
}

#pragma mark - Observers

/// 房间销毁
/// @param not not
- (void)lj_liveDestroyed:(NSNotification *)not
{
    if ([not.object isKindOfClass:[LJLiveDestroyMsg class]]) {
        // 销毁房间：主播关闭房间，用户还在，需要替换接口逻辑roomId
        LJLiveDestroyMsg *msg = (LJLiveDestroyMsg *)not.object;
        LJLiveRoom *room = kLJLiveHelper.data.current;
        if (room.hostAccountId == msg.destroyedRoom.hostAccountId) {
            room.roomId = msg.roomNew.roomId;
            room.roomStatus = msg.roomNew.roomStatus;
            // 如果还在PK中，则退出PK界面，再更新文案
            dispatch_async(dispatch_get_main_queue(), ^{
                if (room.pking) {
                    // 退出PK的UI
                    [self.current lj_event:LJLiveEventPKEnded withObj:nil];
                    LJTipWarning(kLJLocalString(@"The host quit, you lost this turn!"));
                    // 统计
                    [kLJLiveHelper lj_pkEventsGifts1To5MinIfBeforeEnding:YES];
                    [kLJLiveHelper lj_pkEventsEndingProcess];
                }
                // 最小化幕布处理
                if (kLJLiveHelper.isMinimize) kLJLiveHelper.minimizeRemoteView.videoView = nil;
                // 更新文案
                self.current.myHostStatus = room.roomStatus;
            });
        }
        // 刷新列表
//        if (kLJLiveHelper.isMinimize) {
//            [LJLiveInside lj_reloadHomeList];
//        } else {
            kLJLiveHelper.homeReloadTag = YES;
//        }
    }
}

/// 私聊开关状态
/// @param not not
- (void)lj_livePrivateChatFlagChanged:(NSNotification *)not
{
    if ([not.object isKindOfClass:[LJLivePrivateChatFlagMsg class]]) {
        LJLivePrivateChatFlagMsg *msg = (LJLivePrivateChatFlagMsg *)not.object;
        LJLiveRoom *room = kLJLiveHelper.data.current;
        // PK中不处理
        if (room.pking) return;
        if (msg.roomId == room.roomId && !self.isDragging) {
            // 私聊功能是否开启
            dispatch_async(dispatch_get_main_queue(), ^{
                room.privateChatFlag = msg.privateChatFlag;
                // 更新UI
                [self.current lj_event:LJLiveEventUpdatePrivateChat withObj:msg];
                // 主播已关闭私聊功能
                if (msg.privateChatFlag == 2) [self.privateView lj_dismiss];
            });
        }
    }
}

/// 老房间关闭
/// @param not not
- (void)lj_liveOldClosed:(NSNotification *)not
{
    if (self.acceptSseEnable) return;
    if ([not.object isKindOfClass:[LJLiveRoom class]]) {
        // 只有ID的房间信息
        LJLiveRoom *room = (LJLiveRoom *)not.object;
        // 同步数据
        kLJWeakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [kLJLiveHelper.data lj_updateWith:room operationBlock:^LJLiveDataOperation(NSInteger index, LJLiveRoom * _Nullable old) {
                old.roomId = room.roomId;
                old.roomStatus = room.roomStatus;
                if (weakSelf.isDragging) return LJLiveDataOperationNone;
                [weakSelf.tableView beginUpdates];
                return index > kLJLiveHelper.data.index ? LJLiveDataOperationRemove : LJLiveDataOperationNone;
            } completionBlock:^(NSInteger index, LJLiveRoom * _Nullable old) {
                if (index > kLJLiveHelper.data.index && !weakSelf.isDragging) {
                    LJLog(@"live debug - c old close delete %ld all: %ld", index, kLJLiveHelper.data.rooms.count);
                    [weakSelf.tableView deleteSection:index withRowAnimation:UITableViewRowAnimationNone];
                }
            }];
            [self.tableView endUpdates];
        });
    }
}

/// 新开了一个房间
/// @param not not
- (void)lj_liveNewCreated:(NSNotification *)not
{
    if (self.acceptSseEnable) return;
    if ([not.object isKindOfClass:[LJLiveRoom class]]) {
        LJLiveRoom *room = (LJLiveRoom *)not.object;
        // 刷新数据源
        kLJWeakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView beginUpdates];
            [kLJLiveHelper.data lj_updateWith:room operationBlock:^LJLiveDataOperation(NSInteger index, LJLiveRoom * _Nullable old) {
                return LJLiveDataOperationReplaceAdd;
            } completionBlock:^(NSInteger index, LJLiveRoom * _Nullable old) {
                NSInteger count = kLJLiveHelper.data.rooms.count - 1;
                if (index == -1) {
                    LJLog(@"live debug - c new create insert %ld all: %ld", count, kLJLiveHelper.data.rooms.count);
                    [weakSelf.tableView insertSection:count withRowAnimation:UITableViewRowAnimationNone];
                }
            }];
            [self.tableView endUpdates];
        });
    }
}

/// 直播功能关闭
/// @param not not
- (void)lj_liveFeatureClosed:(NSNotification *)not
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self lj_recieveEvent:LJLiveEventClose obj:nil];
    });
}

/// 直播恢复
/// @param not not
- (void)lj_liveResumed:(NSNotification *)not
{
    if ([not.object isKindOfClass:[LJLiveRoom class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            LJLiveRoom *resume = (LJLiveRoom *)not.object;
            LJLiveMainItemCell *current = self.current;
            LJLiveRoom *room = kLJLiveHelper.data.current;
            kLJWeakSelf;
            [kLJLiveHelper.data lj_updateWith:resume operationBlock:^LJLiveDataOperation(NSInteger index, LJLiveRoom * _Nullable old) {
                if (index == -1) {
                    return LJLiveDataOperationNone;
                } else {
                    resume.isHostFollowed = old.isHostFollowed;
                    resume.videoChatRoomMembers = old.videoChatRoomMembers;
                    resume.gifts = old.gifts;
                    return LJLiveDataOperationReplaceAdd;
                }
            } completionBlock:^(NSInteger index, LJLiveRoom * _Nullable old) {
                if (index == kLJLiveHelper.data.index) {
                    current.myHostStatus = 2;
                    current.refreshRender = resume;
                    weakSelf.otherRefreshWithRoom = resume;
                    // PK中
                    if (room.pking) {
                        // 退出PK的UI
                        [current lj_event:LJLiveEventPKEnded withObj:nil];
                        LJTipWarning(kLJLocalString(@"The host quit, you lost this turn!"));
                        // 统计
                        [kLJLiveHelper lj_pkEventsGifts1To5MinIfBeforeEnding:YES];
                        [kLJLiveHelper lj_pkEventsEndingProcess];
                    }
                }
            }];
        });
    }
}

- (void)lj_liveFollowStatusUpdate:(NSNotification *)not
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // 别的页面关注之后，更新当前直播间信息
        LJLiveRoom *room = kLJLiveHelper.data.current;
        NSArray *update = not.object;
        NSInteger targetAccountId = [update.firstObject integerValue];
        NSInteger followStatus = [update.lastObject integerValue];
        if (targetAccountId == room.hostAccountId) {
            room.isHostFollowed = followStatus == 1;
            [self.current lj_event:LJLiveEventFollow withObj:@[@(targetAccountId), @(followStatus)]];
            for (UIView *subview in self.view.subviews) {
                if ([subview isKindOfClass:[LJLiveAnchorPopView class]]) {
                    LJLiveAnchorPopView *anchorView = (LJLiveAnchorPopView *)subview;
                    if (anchorView.anchor.accountId == targetAccountId) {
                        anchorView.followed = followStatus == 1;
                        break;
                    }
                }
            }
        }
    });
}

- (void)lj_liveGoalUpdate:(NSNotification *)note
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.current lj_event:LJLiveGoalUpdate withObj:note.object];
    });
}
- (void)lj_liveGoalDone:(NSNotification *)note
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.current lj_playerLiveGoalDone];
    });
}

#pragma mark - Getter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:kLJScreenBounds style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.pagingEnabled = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollsToTop = NO;
        _tableView.estimatedRowHeight = kLJScreenHeight;
        // 低版本机型会闪退
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView registerClass:[LJLiveMainItemCell class] forCellReuseIdentifier:kCellID];
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kLJScreenWidth, 0.01)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kLJScreenWidth, 0.01)];
    }
    return _tableView;
}

- (LJLiveRankPopView *)rankView
{
    if (!_rankView) {
        _rankView = [LJLiveRankPopView rankView];
        kLJWeakSelf;
        _rankView.eventBlock = ^(LJLiveEvent event, id object) {
            [weakSelf lj_recieveEvent:event obj:object];
        };
    }
    return _rankView;
}

- (LJLiveControlGiftsView *)giftsView
{
    if (!_giftsView) {
        _giftsView = [[LJLiveControlGiftsView alloc] initWithFrame:kLJScreenBounds];
    }
    return _giftsView;
}

- (LJLiveGiftPrivateView *)privateView
{
    if (!_privateView) {
        _privateView = [LJLiveGiftPrivateView privateView];
        kLJWeakSelf;
        _privateView.privateBlock = ^(id  _Nullable object) {
            LJLiveGift *config = (LJLiveGift *)object;
            [weakSelf lj_privateChatWithGift:config];
        };
    }
    return _privateView;
}

- (LJLiveMainItemCell *)current
{
    NSInteger index = kLJLiveHelper.data.index;
    LJLiveMainItemCell *item = (LJLiveMainItemCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
    return item;
}

- (LJLiveControlMenuView *)menuView
{
    if (!_menuView) {
        _menuView = [[LJLiveControlMenuView alloc] initWithFrame:self.view.bounds];
        kLJWeakSelf;
        _menuView.eventBlock = ^(LJLiveEvent event, id object) {
            [weakSelf lj_recieveEvent:event obj:object];
        };
    }
    return _menuView;
}

- (void)setOtherRefreshWithRoom:(LJLiveRoom *)otherRefreshWithRoom
{
    _otherRefreshWithRoom = otherRefreshWithRoom;
    //
    self.rankView.members = [otherRefreshWithRoom.videoChatRoomMembers mutableCopy];
    self.privateView.liveRoom = otherRefreshWithRoom;
    self.giftsView.configs = otherRefreshWithRoom.gifts;
}

@end
