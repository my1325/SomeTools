//
//  GYLiveNetworkHelper.m
//  Woohoo
//
//  Created by M2-mini on 2021/10/28.
//

#import "GYLiveNetworkHelper.h"

@implementation GYLiveNetworkHelper

+ (BOOL)fb_valid:(NSDictionary *)response showTip:(BOOL)showTip
{
    NSString *tipText = @"";

    NSInteger code = [response[@"retCode"] integerValue];
    switch (code) {
        case 0:
            return YES;
        
        case -4:
        case -18:
        case -37:
            tipText = kGYLocalString(@"She's not available.");
            break;
        case -11:
            tipText = kGYLocalString(@"You can only upload maximum 7 photos.");
            break;
        case -35:
            tipText = kGYLocalString(@"Oops, no internet…try again.");
            break;
        case -3:
            tipText = kGYLocalString(@"The livestreamer is busy now. Try to leave her messages.");
            break;
        case -25:
            tipText = kGYLocalString(@"Insufficient Coins.");
            break;
        case -45:
            tipText = kGYLocalString(@"The user blocked you.");
            break;
        case -46:
            tipText = kGYLocalString(@"You blocked the user.");
            break;
        case -9:
            tipText = kGYLocalString(@"The account has been blocked.");
            break;
        case -17:
            tipText = kGYLocalString(@"Anchor doesn't exist.");
            break;
        case -5:
            tipText = kGYLocalString(@"The caller has hung up.");
            break;
        case -28:
            tipText = kGYLocalString(@"User name already exists, please login with password.");
            break;
        case -20:
            tipText = kGYLocalString(@"You can only withdraw once a day.");
            break;
        case -23:
            tipText = kGYLocalString(@"Mimimum withdraw amount: 100 dollars.");
            break;
        case -91:
            tipText = kGYLocalString(@"The nickname is already taken.");
            break;
        case -82:
            tipText = kGYLocalString(@"Please don't do anything inappropriate again.Try again in 5 minutes.");
            break;
        case -78:
            tipText = kGYLocalString(@"We have a Boss now, please try again later!");
            break;
        case -100:
            tipText = kGYLocalString(@"The video chat room is closed.");
            break;
        case -102:
            tipText = kGYLocalString(@"The host is not available now.");
            break;
        case -107:
            tipText = kGYLocalString(@"Private call is closed.");
            break;
        case -108:
            tipText = kGYLocalString(@"The host is not in the room.");
            break;
            
        default:
            break;
    }
    // 弹窗
    if (showTip && tipText.length > 0) GYTipError(tipText);
    return NO;
}

/// 加入房间
/// @param roomId 房间ID
/// @param success 成功
/// @param failure 失败
+ (void)fb_joinRoomWithRoomId:(NSInteger)roomId
                       success:(GYLiveVoidBlock)success
                       failure:(GYLiveVoidBlock)failure
{
    [kGYLiveManager.delegate fb_requestWay:GYLiveRequestMethodPost requestApi:kGYLiveApi_Room_JoinRoom query:@{
        @"session": kGYLiveManager.inside.session,
        @"roomId": @(roomId).stringValue
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (GYValidResponseObj(responseObj, NO)) {
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
+ (void)fb_joinRoomByHostId:(NSInteger)hostId
                     success:(GYLiveObjectBlock)success
                     failure:(GYLiveVoidBlock)failure
{
    NSString *api = kGYLiveApi_Room_JoinRoomByHostId;
    if (kGYLiveManager.room && kGYLiveManager.room.isUgc) api = kGYLiveApi_UgcRoom_JoinRoomByHostId;
    //
    [kGYLiveManager.delegate fb_requestWay:GYLiveRequestMethodPost requestApi:api query:@{
        @"session": kGYLiveManager.inside.session,
        @"hostId": @(hostId).stringValue
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (GYValidResponseObj(responseObj, NO)) {
            GYLiveRoom *room = [[GYLiveRoom alloc] initWithDictionary:responseObj[@"data"]];
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
+ (void)fb_leaveRoomWithRoomId:(NSInteger)roomId
                        success:(void(^) (GYLiveRoom * __nullable room))success
                        failure:(GYLiveVoidBlock)failure
{
    NSString *api = kGYLiveApi_Room_LeaveRoom;
    if (kGYLiveManager.room && kGYLiveManager.room.isUgc) api = kGYLiveApi_UgcRoom_LeaveRoom;
    //
    [kGYLiveManager.delegate fb_requestWay:GYLiveRequestMethodPost requestApi:api query:@{
        @"session": kGYLiveManager.inside.session,
        @"roomId": @(roomId).stringValue
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (GYValidResponseObj(responseObj, NO)) {
            GYLiveRoom *room = [[GYLiveRoom alloc] initWithDictionary:responseObj[@"data"]];
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
+ (void)fb_userSendGiftWithGiftId:(NSInteger)giftId
                            roomId:(NSInteger)roomId
                           success:(void(^) (GYLiveRoomDiamond * __nullable diamond))success
                           failure:(GYLiveVoidBlock)failure
{
    NSString *api = kGYLiveApi_Room_UserSendGift;
    if (kGYLiveManager.room && kGYLiveManager.room.isUgc) api = kGYLiveApi_UgcRoom_UserSendGift;
    //
    [kGYLiveManager.delegate fb_requestWay:GYLiveRequestMethodPost requestApi:api query:@{
        @"session": kGYLiveManager.inside.session,
        @"roomId": @(roomId).stringValue,
        @"giftId": @(giftId).stringValue
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (GYValidResponseObj(responseObj, NO)) {
            GYLiveRoomDiamond *diamond = [[GYLiveRoomDiamond alloc] initWithDictionary:responseObj[@"data"]];
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
+ (void)fb_getFollowAnchorListWithSuccess:(void(^) (NSArray<GYLiveRoomAnchor *> *anchors))success
                                   failure:(GYLiveVoidBlock)failure
{
    [kGYLiveManager.delegate fb_requestWay:GYLiveRequestMethodGet requestApi:kGYLiveApi_Room_GetFollowingAnchorList query:@{
        @"session": kGYLiveManager.inside.session
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (GYValidResponseObj(responseObj, NO)) {
            NSMutableArray *marr = [@[] mutableCopy];
            for (NSDictionary *dict in responseObj[@"data"]) {
                GYLiveRoomAnchor *anchor = [[GYLiveRoomAnchor alloc] initWithDictionary:dict];
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
+ (void)fb_getLivesWithSuccess:(void(^) (NSArray<GYLiveRoom *> *rooms))success
                        failure:(GYLiveVoidBlock)failure
{
    NSString *api = kGYLiveApi_Room_GetRoomList;
    if (kGYLiveManager.room && kGYLiveManager.room.isUgc) api = kGYLiveApi_UgcRoom_GetRoomList;
    //
    [kGYLiveManager.delegate fb_requestWay:GYLiveRequestMethodGet requestApi:api query:@{
        @"session": kGYLiveManager.inside.session
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (GYValidResponseObj(responseObj, NO)) {
            NSMutableArray *marr = [@[] mutableCopy];
            NSArray *arr = responseObj[@"data"][@"videoChatRooms"];
            for (NSDictionary *dict in arr) {
                GYLiveRoom *room = [[GYLiveRoom alloc] initWithDictionary:dict];
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
+ (void)fb_getLiveInfoWithRoomId:(NSInteger)roomId
                          success:(void(^) (GYLiveRoom * __nullable room))success
                          failure:(GYLiveVoidBlock)failure
{
    NSString *api = kGYLiveApi_Room_GetRoomInfo;
    if (kGYLiveManager.room && kGYLiveManager.room.isUgc) api = kGYLiveApi_UgcRoom_GetRoomInfo;
    //
    [kGYLiveManager.delegate fb_requestWay:GYLiveRequestMethodGet requestApi:api query:@{
        @"session": kGYLiveManager.inside.session,
        @"roomId": @(roomId).stringValue
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (GYValidResponseObj(responseObj, NO)) {
            GYLiveRoom *room = [[GYLiveRoom alloc] initWithDictionary:responseObj[@"data"]];
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
+ (void)fb_getLiveAnchorInfoWithAnchorId:(NSInteger)anchorId
                                   roomId:(NSInteger)roomId
                                  success:(void(^) (GYLiveRoomAnchor * __nullable anchor))success
                                  failure:(GYLiveVoidBlock)failure
{
    [kGYLiveManager.delegate fb_requestWay:GYLiveRequestMethodGet requestApi:kGYLiveApi_Room_GetVideoChatRoomAnchorInfo query:@{
        @"session": kGYLiveManager.inside.session,
        @"roomId": @(roomId).stringValue,
        @"anchorId": @(anchorId).stringValue
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (GYValidResponseObj(responseObj, NO)) {
            GYLiveRoomAnchor *anchor = [[GYLiveRoomAnchor alloc] initWithDictionary:responseObj[@"data"]];
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
+ (void)fb_getLiveUserInfoWithUserId:(NSInteger)userId
                               roomId:(NSInteger)roomId
                              success:(void(^) (GYLiveRoomUser * __nullable user))success
                              failure:(GYLiveVoidBlock)failure
{
    NSString *api = kGYLiveApi_Room_GetVideoChatRoomUserInfo;
    if (kGYLiveManager.room && kGYLiveManager.room.isUgc) api = kGYLiveApi_UgcRoom_GetVideoChatRoomUserInfo;
    //
    [kGYLiveManager.delegate fb_requestWay:GYLiveRequestMethodGet requestApi:api query:@{
        @"session": kGYLiveManager.inside.session,
        @"roomId": @(roomId).stringValue,
        @"userId": @(userId).stringValue
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (GYValidResponseObj(responseObj, NO)) {
            GYLiveRoomUser *user = [[GYLiveRoomUser alloc] initWithDictionary:responseObj[@"data"]];
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
+ (void)fb_userTakeHostWithRoomId:(NSInteger)roomId
                            giftId:(NSInteger)giftId
                           success:(void(^) (GYLivePrivate * __nullable privateChat))success
                           failure:(GYLiveVoidBlock)failure
{
    [kGYLiveManager.delegate fb_requestWay:GYLiveRequestMethodPost requestApi:kGYLiveApi_Room_UserTakeHost query:@{
        @"session": kGYLiveManager.inside.session,
        @"roomId": @(roomId).stringValue,
        @"giftId": @(giftId).stringValue
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (GYValidResponseObj(responseObj, YES)) {
            GYLivePrivate *private = [[GYLivePrivate alloc] initWithDictionary:responseObj[@"data"]];
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
+ (void)fb_reportWithAccountId:(NSInteger)accountId
                        content:(NSString *)content
                         images:(NSArray<NSString *> *)images
                        success:(GYLiveVoidBlock)success
                        failure:(GYLiveVoidBlock)failure
{
    if (kGYLiveManager.room && kGYLiveManager.room.isUgc && accountId == kGYLiveManager.room.hostAccountId) {
        // UGC
        [kGYLiveManager.delegate fb_requestWay:GYLiveRequestMethodPost requestApi:kGYLiveApi_UgcRoom_ReportRoom query:@{
            @"session": kGYLiveManager.inside.session,
            @"roomId": @(kGYLiveManager.room.roomId).stringValue
        } body:@{
            @"images": images,
            @"content": content
        } success:^(id  _Nonnull responseObj) {
            if (GYValidResponseObj(responseObj, NO)) {
                if (success) success();
            } else {
                if (failure) failure();
            }
        } failure:^(NSString * _Nullable error) {
            if (failure) failure();
        }];
    } else {
        //
        [kGYLiveManager.delegate fb_requestWay:GYLiveRequestMethodPost requestApi:kGYLiveApi_Account_Report query:@{
            @"session": kGYLiveManager.inside.session,
            @"targetAccountId":@(accountId).stringValue
        } body:@{
            @"images": images,
            @"content": content
        } success:^(id  _Nonnull responseObj) {
            if (GYValidResponseObj(responseObj, NO)) {
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
+ (void)fb_getLiveTopFansWithRoomId:(NSInteger)roomId
                              hostId:(NSInteger)hostId
                             success:(void(^) (NSArray<GYLivePkTopFan *> * fans))success
                             failure:(GYLiveVoidBlock)failure
{
    [kGYLiveManager.delegate fb_requestWay:GYLiveRequestMethodGet requestApi:kGYLiveApi_Room_GetVideoChatRoomPKTopFanList query:@{
        @"session": kGYLiveManager.inside.session,
        @"roomId":@(roomId).stringValue,
        @"hostId":@(hostId).stringValue
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (GYValidResponseObj(responseObj, NO)) {
            NSMutableArray *marr = [@[] mutableCopy];
            for (NSDictionary *dict in responseObj[@"data"]) {
                GYLivePkTopFan *fan = [[GYLivePkTopFan alloc] initWithDictionary:dict];
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
+ (void)fb_getMultiplayerChatRoomListWithSuccess:(void(^) (NSArray<GYLiveMultiplayerRoom *> * rooms))success
                                          failure:(GYLiveVoidBlock)failure
{
    [kGYLiveManager.delegate fb_requestWay:GYLiveRequestMethodGet requestApi:kGYLiveApi_Room_GetMultiplayerChatRoomList query:@{
        @"session": kGYLiveManager.inside.session
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (GYValidResponseObj(responseObj, NO)) {
            NSMutableArray *marr = [@[] mutableCopy];
            for (NSDictionary *dict in responseObj[@"data"]) {
                GYLiveMultiplayerRoom *room = [[GYLiveMultiplayerRoom alloc] initWithDictionary:dict];
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
+ (void)fb_getMultiplayerChatRoomFollowingAnchorList:(void(^) (NSArray<GYLiveMultiplayerRoomAnchor *> *anchors))success
                                              failure:(GYLiveVoidBlock)failure
{
    [kGYLiveManager.delegate fb_requestWay:GYLiveRequestMethodGet requestApi:kGYLiveApi_Room_GetMultiplayerChatRoomFollowingAnchorList query:@{
        @"session": kGYLiveManager.inside.session
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (GYValidResponseObj(responseObj, NO)) {
            NSMutableArray *marr = [@[] mutableCopy];
            for (NSDictionary *dict in responseObj[@"data"]) {
                GYLiveMultiplayerRoomAnchor *anchor = [[GYLiveMultiplayerRoomAnchor alloc] initWithDictionary:dict];
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
+ (void)fb_setGiftViewdByTitle:(NSString *)title
                        success:(GYLiveVoidBlock __nullable)success
                        failure:(GYLiveVoidBlock __nullable)failure
{
    [kGYLiveManager.delegate fb_requestWay:GYLiveRequestMethodPost requestApi:kGYLiveApi_Room_SetGiftViewed query:@{
        @"session": kGYLiveManager.inside.session,
        @"title": title
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (GYValidResponseObj(responseObj, NO)) {
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
+ (void)fb_getMutedMembersWithAgoraRoomId:(NSString *)agoraRoomId
                                   success:(GYLiveArrayBlock __nullable)success
                                   failure:(GYLiveVoidBlock __nullable)failure
{
    NSString *api = kGYLiveApi_Room_GetMutedMembers;
    if (kGYLiveManager.room && kGYLiveManager.room.isUgc) api = kGYLiveApi_UgcRoom_GetMutedMembers;
    //
    [kGYLiveManager.delegate fb_requestWay:GYLiveRequestMethodGet requestApi:api query:@{
        @"session": kGYLiveManager.inside.session,
        @"agoraRoomId": agoraRoomId
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (GYValidResponseObj(responseObj, NO)) {
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
+ (void)fb_getEventLabelListSuccess:(GYLiveResponseBlock)success
                             failure:(GYLiveVoidBlock)failure
{
    [kGYLiveManager.delegate fb_requestWay:GYLiveRequestMethodGet requestApi:kGYLiveApi_Account_GetEventLabelList query:@{
        @"session": kGYLiveManager.inside.session
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (GYValidResponseObj(responseObj, NO)) {
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
+ (void)fb_getEventLabelListWithAccountId:(NSInteger)accountId
                               success:(GYLiveResponseBlock)success
                               failure:(GYLiveVoidBlock)failure
{
    [kGYLiveManager.delegate fb_requestWay:GYLiveRequestMethodGet requestApi:kGYLiveApi_Account_GetEventLabelList query:@{
        @"session": kGYLiveManager.inside.session,
        @"accountId": @(accountId).stringValue
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (GYValidResponseObj(responseObj, NO)) {
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
+ (void)fb_setEventLabelListSequence:(NSArray *)data
                             success:(GYLiveResponseBlock)success
                             failure:(GYLiveVoidBlock)failure{
    [kGYLiveManager.delegate fb_requestWay:GYLiveRequestMethodPost requestApi:kGYLiveApi_Account_SetEventLabelSequence query:@{
        @"session": kGYLiveManager.inside.session,
    } body:[data mj_JSONObject] success:^(id  _Nonnull responseObj) {
        if (GYValidResponseObj(responseObj, NO)) {
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
+ (void)fb_setEventLabelWithTitle:(NSString *)title
                           success:(GYLiveResponseBlock)success
                           failure:(GYLiveVoidBlock)failure
{
    [kGYLiveManager.delegate fb_requestWay:GYLiveRequestMethodPost requestApi:kGYLiveApi_Account_SetDefaultEventLabel query:@{
        @"session": kGYLiveManager.inside.session,
        @"title":title
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (GYValidResponseObj(responseObj, NO)) {
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
+ (void)fb_blockByTargetAccountId:(NSInteger)targetAccountId
                           success:(GYLiveVoidBlock)success
                           failure:(GYLiveVoidBlock)failure
{
    [kGYLiveManager.delegate fb_requestWay:GYLiveRequestMethodPost requestApi:kGYLiveApi_Account_Block query:@{
        @"session": kGYLiveManager.inside.session,
        @"targetAccountId":@(targetAccountId).stringValue
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (GYValidResponseObj(responseObj, YES)) {
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
+ (void)fb_cancelBlockByTargetAccountId:(NSInteger)targetAccountId
                           success:(GYLiveVoidBlock)success
                           failure:(GYLiveVoidBlock)failure
{
    [kGYLiveManager.delegate fb_requestWay:GYLiveRequestMethodPost requestApi:kGYLiveApi_Account_CancelBlock query:@{
        @"session": kGYLiveManager.inside.session,
        @"targetAccountId":@(targetAccountId).stringValue
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (GYValidResponseObj(responseObj, YES)) {
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
+ (void)fb_followByTargetAccountId:(NSInteger)targetAccountId
                            success:(GYLiveVoidBlock)success
                            failure:(GYLiveVoidBlock)failure
{
    [kGYLiveManager.delegate fb_requestWay:GYLiveRequestMethodPost requestApi:kGYLiveApi_Account_Follow query:@{
        @"session": kGYLiveManager.inside.session,
        @"targetAccountId":@(targetAccountId).stringValue
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (GYValidResponseObj(responseObj, YES)) {
            if (success) success();
            
            // 外部关注刷新直播间
            if (kGYLiveHelper.isMinimize) {
                NSArray *array = @[@(targetAccountId), @(1)];
                kGYNTFPost(kGYLiveFollowStatusUpdate, array);
            }
            // 陌生人功能
            
            // 数数统计
            GYLiveThinking(GYLiveThinkingEventTypeEvent, GYLiveThinkingEventFollowSuccess, (@{
                GYLiveThinkingKeyFrom: kGYLiveManager.inside.from,
                GYLiveThinkingKeyFromDetail: kGYLiveManager.inside.fromDetail
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
+ (void)fb_cancelFollowByTargetAccountId:(NSInteger)targetAccountId
                                  success:(GYLiveVoidBlock)success
                                  failure:(GYLiveVoidBlock)failure
{
    [kGYLiveManager.delegate fb_requestWay:GYLiveRequestMethodPost requestApi:kGYLiveApi_Account_CancelFollow query:@{
        @"session": kGYLiveManager.inside.session,
        @"targetAccountId":@(targetAccountId).stringValue
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (GYValidResponseObj(responseObj, YES)) {
            if (success) success();
            
            // 外部关注刷新直播间
            if (kGYLiveHelper.isMinimize) {
                NSArray *array = @[@(targetAccountId), @(1)];
                kGYNTFPost(kGYLiveFollowStatusUpdate, array);
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
+ (void)fb_getAnchorInfoWithAccountId:(NSInteger)accountId
                               success:(void(^) (GYLiveAccount *anchor))success
                               failure:(GYLiveVoidBlock)failure
{
    [kGYLiveManager.delegate fb_requestWay:GYLiveRequestMethodPost requestApi:kGYLiveApi_Account_getAnchorInfo query:@{
        @"session": kGYLiveManager.inside.session,
        @"anchorId":@(accountId).stringValue
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (GYValidResponseObj(responseObj, YES)) {
            GYLiveAccount *anchor = [[GYLiveAccount alloc] initWithDictionary:responseObj[@"data"]];
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
+ (void)fb_getUserInfoWithAccountId:(NSInteger)accountId
                             success:(void(^) (GYLiveAccount *a))success
                             failure:(GYLiveVoidBlock)failure
{
    [kGYLiveManager.delegate fb_requestWay:GYLiveRequestMethodGet requestApi:kGYLiveApi_Account_GetUserInfo query:@{
        @"session": kGYLiveManager.inside.session,
        @"userId":@(accountId).stringValue
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (GYValidResponseObj(responseObj, NO)) {
            GYLiveAccount *a = [[GYLiveAccount alloc] initWithDictionary:responseObj[@"data"]];
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
+ (void)fb_sendTextMessage:(NSString *)text
                     roomId:(NSInteger)roomId
                    success:(GYLiveVoidBlock)success
                    failure:(GYLiveVoidBlock)failure
{
    [kGYLiveManager.delegate fb_requestWay:GYLiveRequestMethodPost requestApi:kGYLiveApi_Room_SendTextMsg query:@{
        @"session": kGYLiveManager.inside.session,
        @"roomId":@(roomId).stringValue,
        @"content": [text stringByURLEncode]
    } body:@{} success:^(id  _Nonnull responseObj) {
        if (success) success();
    } failure:^(NSString * _Nullable error) {
        if (failure) failure();
    }];
}

@end
