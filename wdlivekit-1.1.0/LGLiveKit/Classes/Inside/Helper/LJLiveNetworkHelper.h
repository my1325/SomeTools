//
//  LJLiveNetworkHelper.h
//  Woohoo
//
//  Created by M2-mini on 2021/10/28.
//

#import "LJLiveBaseObject.h"

NS_ASSUME_NONNULL_BEGIN

#define LJValidResponseObj(_resObj, _showTip) [LJLiveNetworkHelper lj_valid:_resObj showTip:_showTip]

@interface LJLiveNetworkHelper : LJLiveBaseObject

+ (BOOL)lj_valid:(NSDictionary *)response showTip:(BOOL)showTip;

/// 加入房间
/// @param roomId 房间ID
/// @param success 成功
/// @param failure 失败
+ (void)lj_joinRoomWithRoomId:(NSInteger)roomId
                       success:(LJLiveVoidBlock)success
                       failure:(LJLiveVoidBlock)failure;

/// 加入房间
/// @param hostId 主播ID
/// @param success 成功
/// @param failure 失败
+ (void)lj_joinRoomByHostId:(NSInteger)hostId
                     success:(LJLiveObjectBlock)success
                     failure:(LJLiveVoidBlock)failure;

/// 离开房间
/// @param roomId 房间ID
/// @param success 成功
/// @param failure 失败
+ (void)lj_leaveRoomWithRoomId:(NSInteger)roomId
                        success:(void(^) (LJLiveRoom * __nullable room))success
                        failure:(LJLiveVoidBlock)failure;

/// 送礼
/// @param giftId 礼物ID
/// @param roomId 房间ID
/// @param success 成功
/// @param failure 失败
+ (void)lj_userSendGiftWithGiftId:(NSInteger)giftId
                            roomId:(NSInteger)roomId
                           success:(void(^) (LJLiveRoomDiamond * __nullable diamond))success
                           failure:(LJLiveVoidBlock)failure;

/// 获取关注的主播列表
/// @param success 成功
/// @param failure 失败
+ (void)lj_getFollowAnchorListWithSuccess:(void(^) (NSArray<LJLiveRoomAnchor *> *anchors))success
                                   failure:(LJLiveVoidBlock)failure;

/// 获取直播间列表
/// @param success 成功
/// @param failure 失败
+ (void)lj_getLivesWithSuccess:(void(^) (NSArray<LJLiveRoom *> *rooms))success
                        failure:(LJLiveVoidBlock)failure;

/// 获取直播间信息
/// @param roomId 房间ID
/// @param success 成功
/// @param failure 失败
+ (void)lj_getLiveInfoWithRoomId:(NSInteger)roomId
                          success:(void(^) (LJLiveRoom * __nullable room))success
                          failure:(LJLiveVoidBlock)failure;

/// 获取直播间主播的信息
/// @param anchorId 主播ID
/// @param roomId 房间ID
/// @param success 成功
/// @param failure 失败
+ (void)lj_getLiveAnchorInfoWithAnchorId:(NSInteger)anchorId
                                   roomId:(NSInteger)roomId
                                  success:(void(^) (LJLiveRoomAnchor * __nullable anchor))success
                                  failure:(LJLiveVoidBlock)failure;

/// 获取直播间用户信息
/// @param userId 用户ID
/// @param roomId 房间ID
/// @param success 成功
/// @param failure 失败
+ (void)lj_getLiveUserInfoWithUserId:(NSInteger)userId
                               roomId:(NSInteger)roomId
                              success:(void(^) (LJLiveRoomUser * __nullable user))success
                              failure:(LJLiveVoidBlock)failure;

/// 私聊带走
/// @param roomId 房间ID
/// @param giftId 礼物ID
/// @param success 成功
/// @param failure 失败
+ (void)lj_userTakeHostWithRoomId:(NSInteger)roomId
                            giftId:(NSInteger)giftId
                           success:(void(^) (LJLivePrivate * __nullable privateChat))success
                           failure:(LJLiveVoidBlock)failure;

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
                        failure:(LJLiveVoidBlock)failure;

/// 获取PK排行
/// @param roomId 房间ID
/// @param hostId 主播ID
/// @param success 成功
/// @param failure 失败
+ (void)lj_getLiveTopFansWithRoomId:(NSInteger)roomId
                              hostId:(NSInteger)hostId
                             success:(void(^) (NSArray<LJLivePkTopFan *> * fans))success
                             failure:(LJLiveVoidBlock)failure;

/// 获取multi-beam及live合并之后的列表数据
/// @param success 成功
/// @param failure 失败
+ (void)lj_getMultiplayerChatRoomListWithSuccess:(void(^) (NSArray<LJLiveMultiplayerRoom *> * rooms))success
                                          failure:(LJLiveVoidBlock)failure;

/// 获取multi-beam及live合并之后的关注的主播列表
/// @param success 成功
/// @param failure 失败
+ (void)lj_getMultiplayerChatRoomFollowingAnchorList:(void(^) (NSArray<LJLiveMultiplayerRoomAnchor *> *anchors))success
                                              failure:(LJLiveVoidBlock)failure;

/// 阅读礼物标签
/// @param success 成功
/// @param failure 失败
+ (void)lj_setGiftViewdByTitle:(NSString *)title
                        success:(LJLiveVoidBlock __nullable)success
                        failure:(LJLiveVoidBlock __nullable)failure;

/// 获取禁言列表
/// @param success 成功
/// @param failure 失败
/// @param agoraRoomId 房间ID
+ (void)lj_getMutedMembersWithAgoraRoomId:(NSString *)agoraRoomId
                                   success:(LJLiveArrayBlock __nullable)success
                                   failure:(LJLiveVoidBlock __nullable)failure;

/// 获取活动标签列表
/// @param success 成功
/// @param failure 失败
+ (void)lj_getEventLabelListSuccess:(LJLiveResponseBlock)success
                             failure:(LJLiveVoidBlock)failure;

/// 获取活动标签列表
/// @param accountId accountId
/// @param success 成功
/// @param failure 失败
+ (void)lj_getEventLabelListWithAccountId:(NSInteger)accountId
                               success:(LJLiveResponseBlock)success
                                  failure:(LJLiveVoidBlock)failure;

/// 设置活动标签顺序
/// @param data 数据
/// @param success 成功
/// @param failure 失败
+ (void)lj_setEventLabelListSequence:(NSArray *)data
                             success:(LJLiveResponseBlock)success
                                failure:(LJLiveVoidBlock)failure;

/// 设置默认活动标签
/// @param title 标签名
/// @param success 成功
/// @param failure 失败
+ (void)lj_setEventLabelWithTitle:(NSString *)title
                           success:(LJLiveResponseBlock)success
                           failure:(LJLiveVoidBlock)failure;

/// 拉黑某人
/// @param targetAccountId ID
/// @param success 成功
/// @param failure 失败
+ (void)lj_blockByTargetAccountId:(NSInteger)targetAccountId
                           success:(LJLiveVoidBlock)success
                           failure:(LJLiveVoidBlock)failure;

/// 取消拉黑某人
/// @param targetAccountId ID
/// @param success 成功
/// @param failure 失败
+ (void)lj_cancelBlockByTargetAccountId:(NSInteger)targetAccountId
                           success:(LJLiveVoidBlock)success
                                failure:(LJLiveVoidBlock)failure;

/// 关注某人
/// @param targetAccountId ID
/// @param success 成功
/// @param failure 失败
+ (void)lj_followByTargetAccountId:(NSInteger)targetAccountId
                            success:(LJLiveVoidBlock)success
                            failure:(LJLiveVoidBlock)failure;

/// 取消关注
/// @param targetAccountId ID
/// @param success 成功
/// @param failure 失败
+ (void)lj_cancelFollowByTargetAccountId:(NSInteger)targetAccountId
                                  success:(LJLiveVoidBlock)success
                                  failure:(LJLiveVoidBlock)failure;

/// 获取主播详情
/// @param accountId ID
/// @param success 成功
/// @param failure 失败
+ (void)lj_getAnchorInfoWithAccountId:(NSInteger)accountId
                               success:(void(^) (LJLiveAccount *anchor))success
                               failure:(LJLiveVoidBlock)failure;

/// 获取用户详情
/// @param accountId ID
/// @param success 成功
/// @param failure 失败
+ (void)lj_getUserInfoWithAccountId:(NSInteger)accountId
                             success:(void(^) (LJLiveAccount *a))success
                             failure:(LJLiveVoidBlock)failure;

/// 记录发送文本弹幕
/// @param text 文本
/// @param roomId ID
/// @param success 成功
/// @param failure 失败
+ (void)lj_sendTextMessage:(NSString *)text
                     roomId:(NSInteger)roomId
                    success:(LJLiveVoidBlock)success
                    failure:(LJLiveVoidBlock)failure;

@end

NS_ASSUME_NONNULL_END
