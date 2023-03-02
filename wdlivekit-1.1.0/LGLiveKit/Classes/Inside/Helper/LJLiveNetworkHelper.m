//
//  LJLiveNetworkHelper.m
//  Woohoo
//
//  Created by M2-mini on 2021/10/28.
//

#import "LJLiveNetworkHelper.h"

@implementation LJLiveNetworkHelper

+ (BOOL)lj_valid:(NSDictionary *)response showTip:(BOOL)showTip
{
    NSString *tipText = @"";

    NSInteger code = [response[@"retCode"] integerValue];
    switch (code) {
        case 0:
            return YES;
        
        case -4:
        case -18:
        case -37:
            tipText = kLJLocalString(@"She's not available.");
            break;
        case -11:
            tipText = kLJLocalString(@"You can only upload maximum 7 photos.");
            break;
        case -35:
            tipText = kLJLocalString(@"Oops, no internet…try again.");
            break;
        case -3:
            tipText = kLJLocalString(@"The livestreamer is busy now. Try to leave her messages.");
            break;
        case -25:
            tipText = kLJLocalString(@"Insufficient Coins.");
            break;
        case -45:
            tipText = kLJLocalString(@"The user blocked you.");
            break;
        case -46:
            tipText = kLJLocalString(@"You blocked the user.");
            break;
        case -9:
            tipText = kLJLocalString(@"The account has been blocked.");
            break;
        case -17:
            tipText = kLJLocalString(@"Anchor doesn't exist.");
            break;
        case -5:
            tipText = kLJLocalString(@"The caller has hung up.");
            break;
        case -28:
            tipText = kLJLocalString(@"User name already exists, please login with password.");
            break;
        case -20:
            tipText = kLJLocalString(@"You can only withdraw once a day.");
            break;
        case -23:
            tipText = kLJLocalString(@"Mimimum withdraw amount: 100 dollars.");
            break;
        case -91:
            tipText = kLJLocalString(@"The nickname is already taken.");
            break;
        case -82:
            tipText = kLJLocalString(@"Please don't do anything inappropriate again.Try again in 5 minutes.");
            break;
        case -78:
            tipText = kLJLocalString(@"We have a Boss now, please try again later!");
            break;
        case -100:
            tipText = kLJLocalString(@"The video chat room is closed.");
            break;
        case -102:
            tipText = kLJLocalString(@"The host is not available now.");
            break;
        case -107:
            tipText = kLJLocalString(@"Private call is closed.");
            break;
        case -108:
            tipText = kLJLocalString(@"The host is not in the room.");
            break;
            
        default:
            break;
    }
    // 弹窗
    if (showTip && tipText.length > 0) LJTipError(tipText);
    return NO;
}

/// 加入房间
/// @param roomId 房间ID
/// @param success 成功
/// @param failure 失败
+ (void)lj_joinRoomWithRoomId:(NSInteger)roomId
                       success:(LJLiveVoidBlock)success
                       failure:(LJLiveVoidBlock)failure
{
    [kLJLiveManager.delegate lj_requestWay:LJLiveRequestMethodPost requestApi:kLJLiveApi_Room_JoinRoom query:@{
        @"session": kLJLiveManager.inside.session,
        @"roomId": @(roomId).stringValue
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (LJValidResponseObj(responseObj, NO)) {
            success();
        } else {
            if (failure) failure();
        }
    } failure:^(NSString * _Nullable error) {
        if (failure) failure();
    }];
}

/// 加入房间
/// @param hostId 主播ID
/// @param success 成功
/// @param failure 失败
+ (void)lj_joinRoomByHostId:(NSInteger)hostId
                     success:(LJLiveObjectBlock)success
                     failure:(LJLiveVoidBlock)failure
{
    NSString *api = kLJLiveApi_Room_JoinRoomByHostId;
    if (kLJLiveManager.room && kLJLiveManager.room.isUgc) api = kLJLiveApi_UgcRoom_JoinRoomByHostId;
    //
    [kLJLiveManager.delegate lj_requestWay:LJLiveRequestMethodPost requestApi:api query:@{
        @"session": kLJLiveManager.inside.session,
        @"hostId": @(hostId).stringValue
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (LJValidResponseObj(responseObj, NO)) {
            LJLiveRoom *room = [[LJLiveRoom alloc] initWithDictionary:responseObj[@"data"]];
            success(room);
        } else {
            if (failure) failure();
        }
    } failure:^(NSString * _Nullable error) {
        if (failure) failure();
    }];
}

/// 离开房间
/// @param roomId 房间ID
/// @param success 成功
/// @param failure 失败
+ (void)lj_leaveRoomWithRoomId:(NSInteger)roomId
                        success:(void(^) (LJLiveRoom * __nullable room))success
                        failure:(LJLiveVoidBlock)failure
{
    NSString *api = kLJLiveApi_Room_LeaveRoom;
    if (kLJLiveManager.room && kLJLiveManager.room.isUgc) api = kLJLiveApi_UgcRoom_LeaveRoom;
    //
    [kLJLiveManager.delegate lj_requestWay:LJLiveRequestMethodPost requestApi:api query:@{
        @"session": kLJLiveManager.inside.session,
        @"roomId": @(roomId).stringValue
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (LJValidResponseObj(responseObj, NO)) {
            LJLiveRoom *room = [[LJLiveRoom alloc] initWithDictionary:responseObj[@"data"]];
            success(room);
        } else {
            if (failure) failure();
        }
    } failure:^(NSString * _Nullable error) {
        if (failure) failure();
    }];
}

/// 送礼
/// @param giftId 礼物ID
/// @param roomId 房间ID
/// @param success 成功
/// @param failure 失败
+ (void)lj_userSendGiftWithGiftId:(NSInteger)giftId
                            roomId:(NSInteger)roomId
                           success:(void(^) (LJLiveRoomDiamond * __nullable diamond))success
                           failure:(LJLiveVoidBlock)failure
{
    NSString *api = kLJLiveApi_Room_UserSendGift;
    if (kLJLiveManager.room && kLJLiveManager.room.isUgc) api = kLJLiveApi_UgcRoom_UserSendGift;
    //
    [kLJLiveManager.delegate lj_requestWay:LJLiveRequestMethodPost requestApi:api query:@{
        @"session": kLJLiveManager.inside.session,
        @"roomId": @(roomId).stringValue,
        @"giftId": @(giftId).stringValue
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (LJValidResponseObj(responseObj, NO)) {
            LJLiveRoomDiamond *diamond = [[LJLiveRoomDiamond alloc] initWithDictionary:responseObj[@"data"]];
            success(diamond);
        } else {
            if (failure) failure();
        }
    } failure:^(NSString * _Nullable error) {
        if (failure) failure();
    }];
}

/// 获取关注的主播列表
/// @param success 成功
/// @param failure 失败
+ (void)lj_getFollowAnchorListWithSuccess:(void(^) (NSArray<LJLiveRoomAnchor *> *anchors))success
                                   failure:(LJLiveVoidBlock)failure
{
    [kLJLiveManager.delegate lj_requestWay:LJLiveRequestMethodGet requestApi:kLJLiveApi_Room_GetFollowingAnchorList query:@{
        @"session": kLJLiveManager.inside.session
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (LJValidResponseObj(responseObj, NO)) {
            NSMutableArray *marr = [@[] mutableCopy];
            for (NSDictionary *dict in responseObj[@"data"]) {
                LJLiveRoomAnchor *anchor = [[LJLiveRoomAnchor alloc] initWithDictionary:dict];
                [marr addObject:anchor];
            }
            if (success) success(marr);
        } else {
            if (failure) failure();
        }
    } failure:^(NSString * _Nullable error) {
        if (failure) failure();
    }];
}

/// 获取直播间列表
/// @param success 成功
/// @param failure 失败
+ (void)lj_getLivesWithSuccess:(void(^) (NSArray<LJLiveRoom *> *rooms))success
                        failure:(LJLiveVoidBlock)failure
{
    NSString *api = kLJLiveApi_Room_GetRoomList;
    if (kLJLiveManager.room && kLJLiveManager.room.isUgc) api = kLJLiveApi_UgcRoom_GetRoomList;
    //
    [kLJLiveManager.delegate lj_requestWay:LJLiveRequestMethodGet requestApi:api query:@{
        @"session": kLJLiveManager.inside.session
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (LJValidResponseObj(responseObj, NO)) {
            NSMutableArray *marr = [@[] mutableCopy];
            NSArray *arr = responseObj[@"data"][@"videoChatRooms"];
            for (NSDictionary *dict in arr) {
                LJLiveRoom *room = [[LJLiveRoom alloc] initWithDictionary:dict];
                [marr addObject:room];
            }
            if (success) success(marr);
        } else {
            if (failure) failure();
        }
    } failure:^(NSString * _Nullable error) {
        if (failure) failure();
    }];
}

/// 获取直播间信息
/// @param roomId 房间ID
/// @param success 成功
/// @param failure 失败
+ (void)lj_getLiveInfoWithRoomId:(NSInteger)roomId
                          success:(void(^) (LJLiveRoom * __nullable room))success
                          failure:(LJLiveVoidBlock)failure
{
    NSString *api = kLJLiveApi_Room_GetRoomInfo;
    if (kLJLiveManager.room && kLJLiveManager.room.isUgc) api = kLJLiveApi_UgcRoom_GetRoomInfo;
    //
    [kLJLiveManager.delegate lj_requestWay:LJLiveRequestMethodGet requestApi:api query:@{
        @"session": kLJLiveManager.inside.session,
        @"roomId": @(roomId).stringValue
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (LJValidResponseObj(responseObj, NO)) {
            LJLiveRoom *room = [[LJLiveRoom alloc] initWithDictionary:responseObj[@"data"]];
            if (success) success(room);
        } else {
            if (failure) failure();
        }
    } failure:^(NSString * _Nullable error) {
        if (failure) failure();
    }];
}

/// 获取直播间主播的信息
/// @param anchorId 主播ID
/// @param roomId 房间ID
/// @param success 成功
/// @param failure 失败
+ (void)lj_getLiveAnchorInfoWithAnchorId:(NSInteger)anchorId
                                   roomId:(NSInteger)roomId
                                  success:(void(^) (LJLiveRoomAnchor * __nullable anchor))success
                                  failure:(LJLiveVoidBlock)failure
{
    [kLJLiveManager.delegate lj_requestWay:LJLiveRequestMethodGet requestApi:kLJLiveApi_Room_GetVideoChatRoomAnchorInfo query:@{
        @"session": kLJLiveManager.inside.session,
        @"roomId": @(roomId).stringValue,
        @"anchorId": @(anchorId).stringValue
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (LJValidResponseObj(responseObj, NO)) {
            LJLiveRoomAnchor *anchor = [[LJLiveRoomAnchor alloc] initWithDictionary:responseObj[@"data"]];
            if (success) success(anchor);
        } else {
            if (failure) failure();
        }
    } failure:^(NSString * _Nullable error) {
        if (failure) failure();
    }];
}

/// 获取直播间用户信息
/// @param userId 用户ID
/// @param roomId 房间ID
/// @param success 成功
/// @param failure 失败
+ (void)lj_getLiveUserInfoWithUserId:(NSInteger)userId
                               roomId:(NSInteger)roomId
                              success:(void(^) (LJLiveRoomUser * __nullable user))success
                              failure:(LJLiveVoidBlock)failure
{
    NSString *api = kLJLiveApi_Room_GetVideoChatRoomUserInfo;
    if (kLJLiveManager.room && kLJLiveManager.room.isUgc) api = kLJLiveApi_UgcRoom_GetVideoChatRoomUserInfo;
    //
    [kLJLiveManager.delegate lj_requestWay:LJLiveRequestMethodGet requestApi:api query:@{
        @"session": kLJLiveManager.inside.session,
        @"roomId": @(roomId).stringValue,
        @"userId": @(userId).stringValue
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (LJValidResponseObj(responseObj, NO)) {
            LJLiveRoomUser *user = [[LJLiveRoomUser alloc] initWithDictionary:responseObj[@"data"]];
            if (success) success(user);
        } else {
            if (failure) failure();
        }
    } failure:^(NSString * _Nullable error) {
        if (failure) failure();
    }];
}

/// 私聊带走
/// @param roomId 房间ID
/// @param giftId 礼物ID
/// @param success 成功
/// @param failure 失败
+ (void)lj_userTakeHostWithRoomId:(NSInteger)roomId
                            giftId:(NSInteger)giftId
                           success:(void(^) (LJLivePrivate * __nullable privateChat))success
                           failure:(LJLiveVoidBlock)failure
{
    [kLJLiveManager.delegate lj_requestWay:LJLiveRequestMethodPost requestApi:kLJLiveApi_Room_UserTakeHost query:@{
        @"session": kLJLiveManager.inside.session,
        @"roomId": @(roomId).stringValue,
        @"giftId": @(giftId).stringValue
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (LJValidResponseObj(responseObj, YES)) {
            LJLivePrivate *private = [[LJLivePrivate alloc] initWithDictionary:responseObj[@"data"]];
            if (success) success(private);
        } else {
            if (failure) failure();
        }
    } failure:^(NSString * _Nullable error) {
        if (failure) failure();
    }];
}

/// 举报
/// @param accountId ID
/// @param content 文本
/// @param images 图片
/// @param success 成功
/// @param failure 失败
+ (void)lj_reportWithAccountId:(NSInteger)accountId
                        content:(NSString *)content
                         images:(NSArray<NSString *> *)images
                        success:(LJLiveVoidBlock)success
                        failure:(LJLiveVoidBlock)failure
{
    if (kLJLiveManager.room && kLJLiveManager.room.isUgc && accountId == kLJLiveManager.room.hostAccountId) {
        // UGC
        [kLJLiveManager.delegate lj_requestWay:LJLiveRequestMethodPost requestApi:kLJLiveApi_UgcRoom_ReportRoom query:@{
            @"session": kLJLiveManager.inside.session,
            @"roomId": @(kLJLiveManager.room.roomId).stringValue
        } body:@{
            @"images": images,
            @"content": content
        } success:^(id  _Nonnull responseObj) {
            if (LJValidResponseObj(responseObj, NO)) {
                if (success) success();
            } else {
                if (failure) failure();
            }
        } failure:^(NSString * _Nullable error) {
            if (failure) failure();
        }];
    } else {
        //
        [kLJLiveManager.delegate lj_requestWay:LJLiveRequestMethodPost requestApi:kLJLiveApi_Account_Report query:@{
            @"session": kLJLiveManager.inside.session,
            @"targetAccountId":@(accountId).stringValue
        } body:@{
            @"images": images,
            @"content": content
        } success:^(id  _Nonnull responseObj) {
            if (LJValidResponseObj(responseObj, NO)) {
                if (success) success();
            } else {
                if (failure) failure();
            }
        } failure:^(NSString * _Nullable error) {
            if (failure) failure();
        }];
    }
}

/// 获取PK排行
/// @param roomId 房间ID
/// @param hostId 主播ID
/// @param success 成功
/// @param failure 失败
+ (void)lj_getLiveTopFansWithRoomId:(NSInteger)roomId
                              hostId:(NSInteger)hostId
                             success:(void(^) (NSArray<LJLivePkTopFan *> * fans))success
                             failure:(LJLiveVoidBlock)failure
{
    [kLJLiveManager.delegate lj_requestWay:LJLiveRequestMethodGet requestApi:kLJLiveApi_Room_GetVideoChatRoomPKTopFanList query:@{
        @"session": kLJLiveManager.inside.session,
        @"roomId":@(roomId).stringValue,
        @"hostId":@(hostId).stringValue
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (LJValidResponseObj(responseObj, NO)) {
            NSMutableArray *marr = [@[] mutableCopy];
            for (NSDictionary *dict in responseObj[@"data"]) {
                LJLivePkTopFan *fan = [[LJLivePkTopFan alloc] initWithDictionary:dict];
                [marr addObject:fan];
            }
            if (success) success(marr);
        } else {
            if (failure) failure();
        }
    } failure:^(NSString * _Nullable error) {
        if (failure) failure();
    }];
}

/// 获取multi-beam及live合并之后的列表数据
/// @param success 成功
/// @param failure 失败
+ (void)lj_getMultiplayerChatRoomListWithSuccess:(void(^) (NSArray<LJLiveMultiplayerRoom *> * rooms))success
                                          failure:(LJLiveVoidBlock)failure
{
    [kLJLiveManager.delegate lj_requestWay:LJLiveRequestMethodGet requestApi:kLJLiveApi_Room_GetMultiplayerChatRoomList query:@{
        @"session": kLJLiveManager.inside.session
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (LJValidResponseObj(responseObj, NO)) {
            NSMutableArray *marr = [@[] mutableCopy];
            for (NSDictionary *dict in responseObj[@"data"]) {
                LJLiveMultiplayerRoom *room = [[LJLiveMultiplayerRoom alloc] initWithDictionary:dict];
                [marr addObject:room];
            }
            if (success) success(marr);
        } else {
            if (failure) failure();
        }
    } failure:^(NSString * _Nullable error) {
        if (failure) failure();
    }];
}

/// 获取multi-beam及live合并之后的关注的主播列表
/// @param success 成功
/// @param failure 失败
+ (void)lj_getMultiplayerChatRoomFollowingAnchorList:(void(^) (NSArray<LJLiveMultiplayerRoomAnchor *> *anchors))success
                                              failure:(LJLiveVoidBlock)failure
{
    [kLJLiveManager.delegate lj_requestWay:LJLiveRequestMethodGet requestApi:kLJLiveApi_Room_GetMultiplayerChatRoomFollowingAnchorList query:@{
        @"session": kLJLiveManager.inside.session
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (LJValidResponseObj(responseObj, NO)) {
            NSMutableArray *marr = [@[] mutableCopy];
            for (NSDictionary *dict in responseObj[@"data"]) {
                LJLiveMultiplayerRoomAnchor *anchor = [[LJLiveMultiplayerRoomAnchor alloc] initWithDictionary:dict];
                [marr addObject:anchor];
            }
            if (success) success(marr);
        } else {
            if (failure) failure();
        }
    } failure:^(NSString * _Nullable error) {
        if (failure) failure();
    }];
}

/// 阅读礼物标签
/// @param success 成功
/// @param failure 失败
+ (void)lj_setGiftViewdByTitle:(NSString *)title
                        success:(LJLiveVoidBlock __nullable)success
                        failure:(LJLiveVoidBlock __nullable)failure
{
    [kLJLiveManager.delegate lj_requestWay:LJLiveRequestMethodPost requestApi:kLJLiveApi_Room_SetGiftViewed query:@{
        @"session": kLJLiveManager.inside.session,
        @"title": title
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (LJValidResponseObj(responseObj, NO)) {
            if (success) success();
        } else {
            if (failure) failure();
        }
    } failure:^(NSString * _Nullable error) {
        if (failure) failure();
    }];
}

/// 获取禁言列表
/// @param success 成功
/// @param failure 失败
/// @param agoraRoomId 房间ID
+ (void)lj_getMutedMembersWithAgoraRoomId:(NSString *)agoraRoomId
                                   success:(LJLiveArrayBlock __nullable)success
                                   failure:(LJLiveVoidBlock __nullable)failure
{
    NSString *api = kLJLiveApi_Room_GetMutedMembers;
    if (kLJLiveManager.room && kLJLiveManager.room.isUgc) api = kLJLiveApi_UgcRoom_GetMutedMembers;
    //
    [kLJLiveManager.delegate lj_requestWay:LJLiveRequestMethodGet requestApi:api query:@{
        @"session": kLJLiveManager.inside.session,
        @"agoraRoomId": agoraRoomId
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (LJValidResponseObj(responseObj, NO)) {
            NSArray *objcs = @[];
            NSDictionary *obj = responseObj[@"data"];
            if ([[obj allKeys] containsObject:@"accountIds"]) {
                objcs = obj[@"accountIds"];
            }
            if (success) success(objcs);
        } else {
            if (failure) failure();
        }
    } failure:^(NSString * _Nullable error) {
        if (failure) failure();
    }];
}

/// 获取活动标签列表
/// @param success 成功
/// @param failure 失败
+ (void)lj_getEventLabelListSuccess:(LJLiveResponseBlock)success
                             failure:(LJLiveVoidBlock)failure
{
    [kLJLiveManager.delegate lj_requestWay:LJLiveRequestMethodGet requestApi:kLJLiveApi_Account_GetEventLabelList query:@{
        @"session": kLJLiveManager.inside.session
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (LJValidResponseObj(responseObj, NO)) {
            if (success) success(responseObj[@"data"]);
        } else {
            if (failure) failure();
        }
    } failure:^(NSString * _Nullable error) {
        if (failure) failure();
    }];
}

/// 获取活动标签列表
/// @param accountId accountId
/// @param success 成功
/// @param failure 失败
+ (void)lj_getEventLabelListWithAccountId:(NSInteger)accountId
                               success:(LJLiveResponseBlock)success
                               failure:(LJLiveVoidBlock)failure
{
    [kLJLiveManager.delegate lj_requestWay:LJLiveRequestMethodGet requestApi:kLJLiveApi_Account_GetEventLabelList query:@{
        @"session": kLJLiveManager.inside.session,
        @"accountId": @(accountId).stringValue
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (LJValidResponseObj(responseObj, NO)) {
            if (success) success(responseObj[@"data"]);
        } else {
            if (failure) failure();
        }
    } failure:^(NSString * _Nullable error) {
        if (failure) failure();
    }];
}

/// 设置活动标签顺序
/// @param data 数据
/// @param success 成功
/// @param failure 失败
+ (void)lj_setEventLabelListSequence:(NSArray *)data
                             success:(LJLiveResponseBlock)success
                             failure:(LJLiveVoidBlock)failure{
    [kLJLiveManager.delegate lj_requestWay:LJLiveRequestMethodPost requestApi:kLJLiveApi_Account_SetEventLabelSequence query:@{
        @"session": kLJLiveManager.inside.session,
    } body:[data mj_JSONObject] success:^(id  _Nonnull responseObj) {
        if (LJValidResponseObj(responseObj, NO)) {
            if (success) success(responseObj[@"data"]);
        } else {
            if (failure) failure();
        }
    } failure:^(NSString * _Nullable error) {
        if (failure) failure();
    }];
}

/// 设置默认活动标签
/// @param title 标签名
/// @param success 成功
/// @param failure 失败
+ (void)lj_setEventLabelWithTitle:(NSString *)title
                           success:(LJLiveResponseBlock)success
                           failure:(LJLiveVoidBlock)failure
{
    [kLJLiveManager.delegate lj_requestWay:LJLiveRequestMethodPost requestApi:kLJLiveApi_Account_SetDefaultEventLabel query:@{
        @"session": kLJLiveManager.inside.session,
        @"title":title
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (LJValidResponseObj(responseObj, NO)) {
            if (success) success(responseObj[@"data"]);
        } else {
            if (failure) failure();
        }
    } failure:^(NSString * _Nullable error) {
        if (failure) failure();
    }];
}

/// 拉黑某人
/// @param targetAccountId ID
/// @param success 成功
/// @param failure 失败
+ (void)lj_blockByTargetAccountId:(NSInteger)targetAccountId
                           success:(LJLiveVoidBlock)success
                           failure:(LJLiveVoidBlock)failure
{
    [kLJLiveManager.delegate lj_requestWay:LJLiveRequestMethodPost requestApi:kLJLiveApi_Account_Block query:@{
        @"session": kLJLiveManager.inside.session,
        @"targetAccountId":@(targetAccountId).stringValue
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (LJValidResponseObj(responseObj, YES)) {
            if (success) success();
        } else {
            if (failure) failure();
        }
    } failure:^(NSString * _Nullable error) {
        if (failure) failure();
    }];
}

/// 取消拉黑某人
/// @param targetAccountId ID
/// @param success 成功
/// @param failure 失败
+ (void)lj_cancelBlockByTargetAccountId:(NSInteger)targetAccountId
                           success:(LJLiveVoidBlock)success
                           failure:(LJLiveVoidBlock)failure
{
    [kLJLiveManager.delegate lj_requestWay:LJLiveRequestMethodPost requestApi:kLJLiveApi_Account_CancelBlock query:@{
        @"session": kLJLiveManager.inside.session,
        @"targetAccountId":@(targetAccountId).stringValue
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (LJValidResponseObj(responseObj, YES)) {
            if (success) success();
        } else {
            if (failure) failure();
        }
    } failure:^(NSString * _Nullable error) {
        if (failure) failure();
    }];
}

/// 关注某人
/// @param targetAccountId ID
/// @param success 成功
/// @param failure 失败
+ (void)lj_followByTargetAccountId:(NSInteger)targetAccountId
                            success:(LJLiveVoidBlock)success
                            failure:(LJLiveVoidBlock)failure
{
    [kLJLiveManager.delegate lj_requestWay:LJLiveRequestMethodPost requestApi:kLJLiveApi_Account_Follow query:@{
        @"session": kLJLiveManager.inside.session,
        @"targetAccountId":@(targetAccountId).stringValue
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (LJValidResponseObj(responseObj, YES)) {
            if (success) success();
            
            // 外部关注刷新直播间
            if (kLJLiveHelper.isMinimize) {
                NSArray *array = @[@(targetAccountId), @(1)];
                kLJNTFPost(kLJLiveFollowStatusUpdate, array);
            }
            // 陌生人功能
            
            // 数数统计
            LJLiveThinking(LJLiveThinkingEventTypeEvent, LJLiveThinkingEventFollowSuccess, (@{
                LJLiveThinkingKeyFrom: kLJLiveManager.inside.from,
                LJLiveThinkingKeyFromDetail: kLJLiveManager.inside.fromDetail
            }));
        } else {
            if (failure) failure();
        }
    } failure:^(NSString * _Nullable error) {
        if (failure) failure();
    }];
}

/// 取消关注
/// @param targetAccountId ID
/// @param success 成功
/// @param failure 失败
+ (void)lj_cancelFollowByTargetAccountId:(NSInteger)targetAccountId
                                  success:(LJLiveVoidBlock)success
                                  failure:(LJLiveVoidBlock)failure
{
    [kLJLiveManager.delegate lj_requestWay:LJLiveRequestMethodPost requestApi:kLJLiveApi_Account_CancelFollow query:@{
        @"session": kLJLiveManager.inside.session,
        @"targetAccountId":@(targetAccountId).stringValue
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (LJValidResponseObj(responseObj, YES)) {
            if (success) success();
            
            // 外部关注刷新直播间
            if (kLJLiveHelper.isMinimize) {
                NSArray *array = @[@(targetAccountId), @(1)];
                kLJNTFPost(kLJLiveFollowStatusUpdate, array);
            }
            // 陌生人功能
            
        } else {
            if (failure) failure();
        }
    } failure:^(NSString * _Nullable error) {
        if (failure) failure();
    }];
}

/// 获取主播详情
/// @param accountId ID
/// @param success 成功
/// @param failure 失败
+ (void)lj_getAnchorInfoWithAccountId:(NSInteger)accountId
                               success:(void(^) (LJLiveAccount *anchor))success
                               failure:(LJLiveVoidBlock)failure
{
    [kLJLiveManager.delegate lj_requestWay:LJLiveRequestMethodPost requestApi:kLJLiveApi_Account_getAnchorInfo query:@{
        @"session": kLJLiveManager.inside.session,
        @"anchorId":@(accountId).stringValue
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (LJValidResponseObj(responseObj, YES)) {
            LJLiveAccount *anchor = [[LJLiveAccount alloc] initWithDictionary:responseObj[@"data"]];
            if (success) success(anchor);
        } else {
            if (failure) failure();
        }
    } failure:^(NSString * _Nullable error) {
        if (failure) failure();
    }];
}

/// 获取用户详情
/// @param accountId ID
/// @param success 成功
/// @param failure 失败
+ (void)lj_getUserInfoWithAccountId:(NSInteger)accountId
                             success:(void(^) (LJLiveAccount *a))success
                             failure:(LJLiveVoidBlock)failure
{
    [kLJLiveManager.delegate lj_requestWay:LJLiveRequestMethodGet requestApi:kLJLiveApi_Account_GetUserInfo query:@{
        @"session": kLJLiveManager.inside.session,
        @"userId":@(accountId).stringValue
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (LJValidResponseObj(responseObj, NO)) {
            LJLiveAccount *a = [[LJLiveAccount alloc] initWithDictionary:responseObj[@"data"]];
            if (success) success(a);
        } else {
            if (failure) failure();
        }
    } failure:^(NSString * _Nullable error) {
        if (failure) failure();
    }];
}

/// 记录发送文本弹幕
/// @param text 文本
/// @param roomId ID
/// @param success 成功
/// @param failure 失败
+ (void)lj_sendTextMessage:(NSString *)text
                     roomId:(NSInteger)roomId
                    success:(LJLiveVoidBlock)success
                    failure:(LJLiveVoidBlock)failure
{
    [kLJLiveManager.delegate lj_requestWay:LJLiveRequestMethodPost requestApi:kLJLiveApi_Room_SendTextMsg query:@{
        @"session": kLJLiveManager.inside.session,
        @"roomId":@(roomId).stringValue,
        @"content": [text stringByURLEncode]
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (success) success();
    } failure:^(NSString * _Nullable error) {
        if (failure) failure();
    }];
}

@end
