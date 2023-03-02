//
//  LJLiveManager.m
//  Woohoo
//
//  Created by M1-mini on 2022/4/24.
//  Copyright © 2022 tt. All rights reserved.
//

#import "LJLiveManager.h"
#import "LJLiveRadioGift.h"
#import "LJLiveThrottle.h"

@interface LJSSEResponse : LJLiveBaseObject

/// 业务数据
/// 操作结果码
/// 操作码
/// 子操作码
/// 操作结果描述
@property (nonatomic, assign) NSInteger subCode;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) NSInteger opCode;
@property (nonatomic, assign) NSInteger retCode;
@property (nonatomic, strong) NSDictionary *data;
@end

@interface LJLiveManager ()
@property (nonatomic, strong) LJLiveThrottle *throttle;
@end

@implementation LJLiveManager

+ (LJLiveManager *)sharedManager
{
    static LJLiveManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[LJLiveManager alloc] init];
    });
    return _manager;
}



#pragma mark - 直播间对外接口












#pragma mark - 数据传递（外部通知直播模块）




#pragma mark - SSE


/// @param uniqueTag 标签
/// 通过ID加入房间（画面出现相对较慢）
/// @param status 是否关注（0：未关注，1：已关注）
/// 初始化直播模块
/// 外部金币更新，通知内部
/// @param index 在rooms中的下标
/// 外部关注某人，通知内部
/// @param targetAccountId ID
/// @param delegate 代理
/// 加入房间
/// @param dataSource 代理
/// @param rooms 字典数组或者对象数组（内部会调用MJ转换，单个room至少含有hostAccountId及agoraRoomId）
/// @param agoraAppId 声网ID
/// 最小化房间
/// 外部选中标签，通知直播间
/// @param operation 操作（推出vc）
/// 退出直播模块
/// @param leftDiamond 最新余额
/// 接收sse推送
/// 关闭房间
/// @param hostAccountId ID
/// @param operation 操作（推出vc）
/// @param eventData SSEResponse
- (void)lj_sseEventData:(NSDictionary *)eventData
{
    LJSSEResponse *sseResObj = [[LJSSEResponse alloc] initWithDictionary:eventData];
    switch (sseResObj.opCode) {
        case 2:
        {
            // room
        }
            break;
        case 3:
        {
            // push
            switch (sseResObj.subCode) {
                case 32:
                {
                    // 开启新的语聊室（刷新列表）
                }
                    break;
                case 33:
                {
                    // 关闭老的语聊室（刷新列表）
                }
                    break;
                case 34:
                {
                    // 开放直播间功能【用来动态调整首页标签顺序】
                }
                    break;
                case 35:
                {
                    // 关闭直播间功能【用来动态调整首页标签顺序】
                    [self lj_close];
                    LJTip(kLJLocalString(@"The livestream function has been turned off."), LJLiveTipStatusWarning, 4);
                }
                    break;
                case 36:
                {
                    // 老直播间关闭
                    LJLiveRoom *room = [[LJLiveRoom alloc] initWithDictionary:sseResObj.data];
                    kLJNTFPost(kLJLiveOldClosed, room);
                }
                    break;
                case 37:
                {
                    // 新直播间开启
                    LJLiveRoom *room = [[LJLiveRoom alloc] initWithDictionary:sseResObj.data];
                    kLJNTFPost(kLJLiveNewCreated, room);
                }
                    break;
                case 38:
                {
                    // 直播间恢复
                    LJLiveRoom *room = [[LJLiveRoom alloc] initWithDictionary:sseResObj.data];
                    kLJNTFPost(kLJLiveResumed, room);
                }
                    break;
                case 39:
                {
                    // 直播间编辑
                    LJLiveRoom *room = [[LJLiveRoom alloc] initWithDictionary:sseResObj.data];
                    kLJNTFPost(kLJLiveEdited, room);
                }
                    break;
                case 40:
                {
                    // 直播间解散
                    LJLiveDestroyMsg *msg = [[LJLiveDestroyMsg alloc] initWithDictionary:sseResObj.data];
                    kLJNTFPost(kLJLiveDestroyed, msg);
                }
                    break;
                case 41:
                {
                    // 直播间私聊开关改变
                    LJLivePrivateChatFlagMsg *private = [[LJLivePrivateChatFlagMsg alloc] initWithDictionary:sseResObj.data];
                    kLJNTFPost(kLJLivePrivateChatFlagChanged, private);
                }
                    break;
                case 43:
                {
                    // 直播间主持人被带走（走了RTM）
                }
                    break;
                case 45:
                {
                    // 直播间主持人收到礼物
                }
                    break;
                case 48:
                {
                    // 被直播间主持人踢出
                }
                    break;
                case 61:
                {
                    // 直播间目标更新
                    kLJNTFPost(kLJLiveGoalUpdated, sseResObj.data);
                }
                    break;
                case 63:
                {
                    // 直播间目标达成
                    kLJNTFPost(kLJLiveGoalDone, sseResObj.data);
                }
                    break;
                case 66:
                {
                    // 新UGC视频聊天室开启
                    LJLiveRoom *room = [[LJLiveRoom alloc] initWithDictionary:sseResObj.data];
                    kLJNTFPost(kLJLiveNewCreated, room);
                }
                    break;
                case 67:
                {
                    // UGC视频聊天室恢复
                    LJLiveRoom *room = [[LJLiveRoom alloc] initWithDictionary:sseResObj.data];
                    kLJNTFPost(kLJLiveResumed, room);
                }
                    break;
                case 68:
                {
                    // UGC被踢出
                    LJLiveDestroyMsg *msg = [[LJLiveDestroyMsg alloc] initWithDictionary:sseResObj.data];
                    kLJNTFPost(kLJLiveDestroyed, msg);
                }
                    break;
                case 69:
                {
                    // 老UGC视频聊天室关闭
                    LJLiveRoom *room = [[LJLiveRoom alloc] initWithDictionary:sseResObj.data];
                    kLJNTFPost(kLJLiveOldClosed, room);
                }
                    break;
                case 70:
                {
                    // Ugc视频聊天室编辑
                    LJLiveRoom *room = [[LJLiveRoom alloc] initWithDictionary:sseResObj.data];
                    kLJNTFPost(kLJLiveEdited, room);
                }
                    break;
                case 75:
                {
                    // 横幅
                    [LJLiveRadioGift.shared lj_receiveRtmRespone:eventData];
                }
                    break;
            }
        }
            break;
        case 5:
        {
            // chatroom
        }
            break;
            
        default:
            break;
    }
}
- (void)lj_outsideCoinsUpdate:(NSInteger)leftDiamond
{
    self.inside.account.coins = leftDiamond;
    //
    UIViewController *vc = [LJLiveMethods lj_currentViewController];
    if ([vc isKindOfClass:[LJLiveViewController class]]) {
        [(LJLiveViewController *)vc lj_reloadMyCoins];
    }
}
- (void)lj_joinRoomWith:(NSArray *)rooms
                atIndex:(NSInteger)index
                   from:(LJLiveJoinFrom)from
              operation:(void(^) (UIViewController *vc))operation
{
    [self.throttle doAction:^{
        NSMutableArray *marr = [@[] mutableCopy];
        for (id obj in rooms) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                LJLiveRoom *room = [[LJLiveRoom alloc] initWithDictionary:(NSDictionary *)obj];
                [marr addObject:room];
            } else {
                NSObject *object = obj;
                LJLiveRoom *room = [[LJLiveRoom alloc] initWithDictionary:object.mj_keyValues];
                [marr addObject:room];
            }
        }
        LJLiveRoom *room = marr[index];
        if (kLJLiveHelper.isMinimize) {
            // 最小化
            if ([room.agoraRoomId isEqualToString:kLJLiveHelper.data.current.agoraRoomId]) {
                [kLJLiveHelper lj_fullScreenAndLoading:^{
                    operation(kLJLiveHelper.liveVc);
                }];
            } else {
                // 先退出
                [kLJLiveHelper lj_close];
                // 再加入
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    LJLiveViewController *vc = [[LJLiveViewController alloc] initWithRooms:marr atIndex:index];
                    operation(vc);
                });
                //            // 统计
                //            LJLiveThinking(LJLiveThinkingEventTypeEvent, LJLiveThinkingEventEnterLive, (@{
                //                LJLiveThinkingKeyRoomId: @(room.roomId).stringValue,
                //                LJLiveThinkingKeyFrom: LJLiveThinkingValueHomeList
                //            }));
            }
        } else {
            // 进入
            LJLiveViewController *vc = [[LJLiveViewController alloc] initWithRooms:marr atIndex:index];
            operation(vc);
            //        // 统计
            //        LJLiveThinking(LJLiveThinkingEventTypeEvent, LJLiveThinkingEventEnterLive, (@{
            //            LJLiveThinkingKeyRoomId: @(room.roomId).stringValue,
            //            LJLiveThinkingKeyFrom: LJLiveThinkingValueHomeList
            //        }));
            
            if (from == LJLiveJoinFromBroadcast) {
                kLJLiveManager.inside.fromJoin = LJLiveThinkingValueBroadcast;
            } else {
                kLJLiveManager.inside.fromJoin = nil;
            }
        }
        //    // 统计
        //    if (room.pking) LJEvent(@"lj_LiveListClickPKTabEnter", nil);
    }];
}
- (void)lj_outsideDidSelectedUniqueTag:(LJUniqueTag *)uniqueTag
{
    self.inside.accountConfig.defaultEventLabel = uniqueTag;
}
- (void)lj_joinRoomByHostAccountId:(NSInteger)hostAccountId
                              from:(LJLiveJoinFrom)from
                         operation:(void(^) (UIViewController *vc))operation
{
    [self.throttle doAction:^{
        if (kLJLiveHelper.isMinimize) {
            // 最小化
            if (hostAccountId == kLJLiveHelper.data.current.hostAccountId) {
                [kLJLiveHelper lj_fullScreenAndLoading:^{
                    operation(kLJLiveHelper.liveVc);
                }];
            } else {
                // 先退出
                [kLJLiveHelper lj_close];
                // 再加入
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    LJLiveViewController *vc = [[LJLiveViewController alloc] initWithHostAccountId:hostAccountId];
                    operation(vc);
                });
                //            // 统计
                //            LJLiveThinking(LJLiveThinkingEventTypeEvent, LJLiveThinkingEventEnterLive, (@{
                //                LJLiveThinkingKeyRoomId: @(hostAccountId).stringValue,
                //                LJLiveThinkingKeyFrom: LJLiveThinkingValueHomeList
                //            }));
            }
        } else {
            // 加入
            LJLiveViewController *vc = [[LJLiveViewController alloc] initWithHostAccountId:hostAccountId];
            operation(vc);
            //        // 统计
            //        LJLiveThinking(LJLiveThinkingEventTypeEvent, LJLiveThinkingEventEnterLive, (@{
            //            LJLiveThinkingKeyRoomId: @(hostAccountId).stringValue,
            //            LJLiveThinkingKeyFrom: LJLiveThinkingValueHomeList
            //        }));
            
            if (from == LJLiveJoinFromBroadcast) {
                kLJLiveManager.inside.fromJoin = LJLiveThinkingValueBroadcast;
            } else {
                kLJLiveManager.inside.fromJoin = nil;
            }
        }
    }];
}
- (void)lj_logout
{
//    [kLJLiveAgoraHelper lj_logoutAgoraRtmWithCompletion:^{
//    }];
}
- (LJLiveRoom *)room
{
    return kLJLiveHelper.data.current ?: nil;
}
- (void)lj_close
{
    [kLJLiveHelper lj_close];
}
- (void)lj_minimize
{
    UIViewController *vc = LJLiveMethods.lj_currentViewController;
    if ([vc isKindOfClass:[LJLiveViewController class]]) {
        if (vc.navigationController) [vc.navigationController popViewControllerAnimated:YES];
        [vc dismissViewControllerAnimated:YES completion:nil];
    }
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _throttle = [[LJLiveThrottle alloc] init];
        _throttle.threshold = 2.0;
    }
    return self;
}
- (void)lj_outsideFollowStatus:(NSInteger)status targetAccountId:(NSInteger)targetAccountId
{
    NSArray *array = @[@(targetAccountId), @(status)];
    kLJNTFPost(kLJLiveFollowStatusUpdate, array);
}
- (BOOL)inARoom
{
    return kLJLiveHelper.inARoom;
}
- (BOOL)inModule
{
    return kLJLiveHelper.inARoom;
}
- (void)lj_initWithAgoraAppId:(NSString *)agoraAppId
                 configuration:(LJLiveConfiguration * __nullable )configuration
                    dataSource:(id<LJLiveManagerDataSource>)dataSource
                      delegate:(id<LJLiveManagerDelegate>)delegate
{
    
    self.agoraAppId = agoraAppId;
    self.delegate = delegate;
    self.dataSource = dataSource;
    //
    self.inside = [[LJLiveInside alloc] init];
    self.config = configuration ?: [[LJLiveConfiguration alloc] init];
//    // 登录RTM
//    [kLJLiveAgoraHelper lj_loginAgoraRtmWithCompletion:^{
//    }];
}
- (BOOL)isMinimize
{
    return kLJLiveHelper.isMinimize;
}
- (AgoraRtcEngineKit *)agoraKit
{
    return kLJLiveAgoraHelper.rtcKit ?: nil;
}
@end

#pragma mark - SSEResponse

@implementation LJSSEResponse

@end
