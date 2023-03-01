//
//  GYLiveNetworkHelper.h
//  Woohoo
//
//  Created by M2-mini on 2021/10/28.
//

#import "GYLiveBaseObject.h"

NS_ASSUME_NONNULL_BEGIN

#define GYValidResponseObj(_resObj, _showTip) [GYLiveNetworkHelper fb_valid:_resObj showTip:_showTip]

@interface GYLiveNetworkHelper : GYLiveBaseObject

+ (BOOL)fb_valid:(NSDictionary *)response showTip:(BOOL)showTip;

/// 加入房间
/// @param roomId 房间ID
/// @param success 成功
/// @param failure 失败
+ (void)fb_joinRoomWithRoomId:(NSInteger)roomId
                       success:(GYLiveVoidBlock)success
                       failure:(GYLiveVoidBlock)failure;

/// 加入房间
/// @param hostId 主播ID
/// @param success 成功
/// @param failure 失败
+ (void)fb_joinRoomByHostId:(NSInteger)hostId
                     success:(GYLiveObjectBlock)success
                     failure:(GYLiveVoidBlock)failure;

/// 离开房间
/// @param roomId 房间ID
/// @param success 成功
/// @param failure 失败
+ (void)fb_leaveRoomWithRoomId:(NSInteger)roomId
                        success:(void(^) (GYLiveRoom * __nullable room))success
                        failure:(GYLiveVoidBlock)failure;

/// 送礼
/// @param giftId 礼物ID
/// @param roomId 房间ID
/// @param success 成功
/// @param failure 失败
+ (void)fb_userSendGiftWithGiftId:(NSInteger)giftId
                            roomId:(NSInteger)roomId
                           success:(void(^) (GYLiveRoomDiamond * __nullable diamond))success
                           failure:(GYLiveVoidBlock)failure;

/// 获取关注的主播列表
/// @param success 成功
/// @param failure 失败
+ (void)fb_getFollowAnchorListWithSuccess:(void(^) (NSArray<GYLiveRoomAnchor *> *anchors))success
                                   failure:(GYLiveVoidBlock)failure;

/// 获取直播间列表
/// @param success 成功
/// @param failure 失败
+ (void)fb_getLivesWithSuccess:(void(^) (NSArray<GYLiveRoom *> *rooms))success
                        failure:(GYLiveVoidBlock)failure;

/// 获取直播间信息
/// @param roomId 房间ID
/// @param success 成功
/// @param failure 失败
+ (void)fb_getLiveInfoWithRoomId:(NSInteger)roomId
                          success:(void(^) (GYLiveRoom * __nullable room))success
                          failure:(GYLiveVoidBlock)failure;

/// 获取直播间主播的信息
/// @param anchorId 主播ID
/// @param roomId 房间ID
/// @param success 成功
/// @param failure 失败
+ (void)fb_getLiveAnchorInfoWithAnchorId:(NSInteger)anchorId
                                   roomId:(NSInteger)roomId
                                  success:(void(^) (GYLiveRoomAnchor * __nullable anchor))success
                                  failure:(GYLiveVoidBlock)failure;

/// 获取直播间用户信息
/// @param userId 用户ID
/// @param roomId 房间ID
/// @param success 成功
/// @param failure 失败
+ (void)fb_getLiveUserInfoWithUserId:(NSInteger)userId
                               roomId:(NSInteger)roomId
                              success:(void(^) (GYLiveRoomUser * __nullable user))success
                              failure:(GYLiveVoidBlock)failure;

/// 私聊带走
/// @param roomId 房间ID
/// @param giftId 礼物ID
/// @param success 成功
/// @param failure 失败
+ (void)fb_userTakeHostWithRoomId:(NSInteger)roomId
                            giftId:(NSInteger)giftId
                           success:(void(^) (GYLivePrivate * __nullable privateChat))success
                           failure:(GYLiveVoidBlock)failure;

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
                        failure:(GYLiveVoidBlock)failure;

/// 获取PK排行
/// @param roomId 房间ID
/// @param hostId 主播ID
/// @param success 成功
/// @param failure 失败
+ (void)fb_getLiveTopFansWithRoomId:(NSInteger)roomId
                              hostId:(NSInteger)hostId
                             success:(void(^) (NSArray<GYLivePkTopFan *> * fans))success
                             failure:(GYLiveVoidBlock)failure;

/// 获取multi-beam及live合并之后的列表数据
/// @param success 成功
/// @param failure 失败
+ (void)fb_getMultiplayerChatRoomListWithSuccess:(void(^) (NSArray<GYLiveMultiplayerRoom *> * rooms))success
                                          failure:(GYLiveVoidBlock)failure;

/// 获取multi-beam及live合并之后的关注的主播列表
/// @param success 成功
/// @param failure 失败
+ (void)fb_getMultiplayerChatRoomFollowingAnchorList:(void(^) (NSArray<GYLiveMultiplayerRoomAnchor *> *anchors))success
                                              failure:(GYLiveVoidBlock)failure;

/// 阅读礼物标签
/// @param success 成功
/// @param failure 失败
+ (void)fb_setGiftViewdByTitle:(NSString *)title
                        success:(GYLiveVoidBlock __nullable)success
                        failure:(GYLiveVoidBlock __nullable)failure;

/// 获取禁言列表
/// @param success 成功
/// @param failure 失败
/// @param agoraRoomId 房间ID
+ (void)fb_getMutedMembersWithAgoraRoomId:(NSString *)agoraRoomId
                                   success:(GYLiveArrayBlock __nullable)success
                                   failure:(GYLiveVoidBlock __nullable)failure;

/// 获取活动标签列表
/// @param success 成功
/// @param failure 失败
+ (void)fb_getEventLabelListSuccess:(GYLiveResponseBlock)success
                             failure:(GYLiveVoidBlock)failure;

/// 获取活动标签列表
/// @param accountId accountId
/// @param success 成功
/// @param failure 失败
+ (void)fb_getEventLabelListWithAccountId:(NSInteger)accountId
                               success:(GYLiveResponseBlock)success
                                  failure:(GYLiveVoidBlock)failure;

/// 设置活动标签顺序
/// @param data 数据
/// @param success 成功
/// @param failure 失败
+ (void)fb_setEventLabelListSequence:(NSArray *)data
                             success:(GYLiveResponseBlock)success
                                failure:(GYLiveVoidBlock)failure;

/// 设置默认活动标签
/// @param title 标签名
/// @param success 成功
/// @param failure 失败
+ (void)fb_setEventLabelWithTitle:(NSString *)title
                           success:(GYLiveResponseBlock)success
                           failure:(GYLiveVoidBlock)failure;

/// 拉黑某人
/// @param targetAccountId ID
/// @param success 成功
/// @param failure 失败
+ (void)fb_blockByTargetAccountId:(NSInteger)targetAccountId
                           success:(GYLiveVoidBlock)success
                           failure:(GYLiveVoidBlock)failure;

/// 取消拉黑某人
/// @param targetAccountId ID
/// @param success 成功
/// @param failure 失败
+ (void)fb_cancelBlockByTargetAccountId:(NSInteger)targetAccountId
                           success:(GYLiveVoidBlock)success
                                failure:(GYLiveVoidBlock)failure;

/// 关注某人
/// @param targetAccountId ID
/// @param success 成功
/// @param failure 失败
+ (void)fb_followByTargetAccountId:(NSInteger)targetAccountId
                            success:(GYLiveVoidBlock)success
                            failure:(GYLiveVoidBlock)failure;

/// 取消关注
/// @param targetAccountId ID
/// @param success 成功
/// @param failure 失败
+ (void)fb_cancelFollowByTargetAccountId:(NSInteger)targetAccountId
                                  success:(GYLiveVoidBlock)success
                                  failure:(GYLiveVoidBlock)failure;

/// 获取主播详情
/// @param accountId ID
/// @param success 成功
/// @param failure 失败
+ (void)fb_getAnchorInfoWithAccountId:(NSInteger)accountId
                               success:(void(^) (GYLiveAccount *anchor))success
                               failure:(GYLiveVoidBlock)failure;

/// 获取用户详情
/// @param accountId ID
/// @param success 成功
/// @param failure 失败
+ (void)fb_getUserInfoWithAccountId:(NSInteger)accountId
                             success:(void(^) (GYLiveAccount *a))success
                             failure:(GYLiveVoidBlock)failure;

/// 记录发送文本弹幕
/// @param text 文本
/// @param roomId ID
/// @param success 成功
/// @param failure 失败
+ (void)fb_sendTextMessage:(NSString *)text
                     roomId:(NSInteger)roomId
                    success:(GYLiveVoidBlock)success
                    failure:(GYLiveVoidBlock)failure;

@end

NS_ASSUME_NONNULL_END
