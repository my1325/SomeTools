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





























/// @param success 成功
/// 加入房间
/// 获取活动标签列表
/// @param accountId ID
/// @param roomId 房间ID
/// @param success 成功
/// @param success 成功
/// 获取关注的主播列表
/// 设置活动标签顺序
/// 取消拉黑某人
/// @param success 成功
/// 记录发送文本弹幕
/// @param failure 失败
/// @param failure 失败
/// @param success 成功
/// 加入房间
/// @param success 成功
/// @param success 成功
/// @param success 成功
/// 获取直播间主播的信息
/// @param targetAccountId ID
/// @param success 成功
/// @param failure 失败
/// @param success 成功
/// @param agoraRoomId 房间ID
/// @param failure 失败
/// @param roomId 房间ID
/// @param failure 失败
/// @param success 成功
/// @param failure 失败
/// @param success 成功
/// 取消关注
/// @param failure 失败
/// @param success 成功
/// 获取multi-beam及live合并之后的列表数据
/// @param failure 失败
/// @param failure 失败
/// @param success 成功
/// @param roomId 房间ID
/// @param failure 失败
/// @param userId 用户ID
/// @param title 标签名
/// @param roomId 房间ID
/// @param success 成功
/// @param failure 失败
/// @param accountId accountId
/// 设置默认活动标签
/// @param success 成功
/// @param failure 失败
/// @param failure 失败
/// @param failure 失败
/// @param roomId 房间ID
/// @param failure 失败
/// 离开房间
/// @param failure 失败
/// @param targetAccountId ID
/// 私聊带走
/// @param roomId ID
/// @param failure 失败
/// 获取用户详情
/// @param accountId ID
/// @param failure 失败
/// @param success 成功
/// @param success 成功
/// 获取multi-beam及live合并之后的关注的主播列表
/// @param anchorId 主播ID
/// @param failure 失败
/// 获取直播间用户信息
/// 获取直播间列表
/// @param giftId 礼物ID
/// @param failure 失败
/// @param success 成功
/// @param failure 失败
/// 获取禁言列表
/// @param failure 失败
/// @param failure 失败
/// @param success 成功
/// @param failure 失败
/// @param hostId 主播ID
/// @param data 数据
/// 举报
/// 获取PK排行
/// @param success 成功
/// @param success 成功
/// @param failure 失败
/// @param accountId ID
/// 获取直播间信息
/// @param success 成功
/// @param success 成功
/// @param success 成功
/// 获取主播详情
/// @param success 成功
/// 获取活动标签列表
/// 送礼
/// @param failure 失败
/// @param text 文本
/// 阅读礼物标签
/// 拉黑某人
/// @param failure 失败
/// @param content 文本
/// @param hostId 主播ID
/// @param giftId 礼物ID
/// @param roomId 房间ID
/// @param roomId 房间ID
/// @param success 成功
/// @param targetAccountId ID
/// @param images 图片
/// @param targetAccountId ID
/// @param roomId 房间ID
/// 关注某人
+ (void)lj_getEventLabelListSuccess:(LJLiveResponseBlock)success
                             failure:(LJLiveVoidBlock)failure;
+ (void)lj_userSendGiftWithGiftId:(NSInteger)giftId
                            roomId:(NSInteger)roomId
                           success:(void(^) (LJLiveRoomDiamond * __nullable diamond))success
                           failure:(LJLiveVoidBlock)failure;
+ (void)lj_blockByTargetAccountId:(NSInteger)targetAccountId
                           success:(LJLiveVoidBlock)success
                           failure:(LJLiveVoidBlock)failure;
+ (void)lj_getLiveTopFansWithRoomId:(NSInteger)roomId
                              hostId:(NSInteger)hostId
                             success:(void(^) (NSArray<LJLivePkTopFan *> * fans))success
                             failure:(LJLiveVoidBlock)failure;
+ (void)lj_getLiveInfoWithRoomId:(NSInteger)roomId
                          success:(void(^) (LJLiveRoom * __nullable room))success
                          failure:(LJLiveVoidBlock)failure;
+ (void)lj_getAnchorInfoWithAccountId:(NSInteger)accountId
                               success:(void(^) (LJLiveAccount *anchor))success
                               failure:(LJLiveVoidBlock)failure;
+ (void)lj_getLiveUserInfoWithUserId:(NSInteger)userId
                               roomId:(NSInteger)roomId
                              success:(void(^) (LJLiveRoomUser * __nullable user))success
                              failure:(LJLiveVoidBlock)failure;
+ (void)lj_getMultiplayerChatRoomListWithSuccess:(void(^) (NSArray<LJLiveMultiplayerRoom *> * rooms))success
                                          failure:(LJLiveVoidBlock)failure;
+ (void)lj_getFollowAnchorListWithSuccess:(void(^) (NSArray<LJLiveRoomAnchor *> *anchors))success
                                   failure:(LJLiveVoidBlock)failure;
+ (void)lj_setEventLabelListSequence:(NSArray *)data
                             success:(LJLiveResponseBlock)success
                                failure:(LJLiveVoidBlock)failure;
+ (void)lj_followByTargetAccountId:(NSInteger)targetAccountId
                            success:(LJLiveVoidBlock)success
                            failure:(LJLiveVoidBlock)failure;
+ (void)lj_cancelBlockByTargetAccountId:(NSInteger)targetAccountId
                           success:(LJLiveVoidBlock)success
                                failure:(LJLiveVoidBlock)failure;
+ (void)lj_getLiveAnchorInfoWithAnchorId:(NSInteger)anchorId
                                   roomId:(NSInteger)roomId
                                  success:(void(^) (LJLiveRoomAnchor * __nullable anchor))success
                                  failure:(LJLiveVoidBlock)failure;
+ (void)lj_setEventLabelWithTitle:(NSString *)title
                           success:(LJLiveResponseBlock)success
                           failure:(LJLiveVoidBlock)failure;
+ (void)lj_getUserInfoWithAccountId:(NSInteger)accountId
                             success:(void(^) (LJLiveAccount *a))success
                             failure:(LJLiveVoidBlock)failure;
+ (void)lj_cancelFollowByTargetAccountId:(NSInteger)targetAccountId
                                  success:(LJLiveVoidBlock)success
                                  failure:(LJLiveVoidBlock)failure;
+ (void)lj_setGiftViewdByTitle:(NSString *)title
                        success:(LJLiveVoidBlock __nullable)success
                        failure:(LJLiveVoidBlock __nullable)failure;
+ (void)lj_getLivesWithSuccess:(void(^) (NSArray<LJLiveRoom *> *rooms))success
                        failure:(LJLiveVoidBlock)failure;
+ (void)lj_leaveRoomWithRoomId:(NSInteger)roomId
                        success:(void(^) (LJLiveRoom * __nullable room))success
                        failure:(LJLiveVoidBlock)failure;
+ (void)lj_sendTextMessage:(NSString *)text
                     roomId:(NSInteger)roomId
                    success:(LJLiveVoidBlock)success
                    failure:(LJLiveVoidBlock)failure;
+ (void)lj_getMutedMembersWithAgoraRoomId:(NSString *)agoraRoomId
                                   success:(LJLiveArrayBlock __nullable)success
                                   failure:(LJLiveVoidBlock __nullable)failure;
+ (void)lj_reportWithAccountId:(NSInteger)accountId
                        content:(NSString *)content
                         images:(NSArray<NSString *> *)images
                        success:(LJLiveVoidBlock)success
                        failure:(LJLiveVoidBlock)failure;
+ (void)lj_getMultiplayerChatRoomFollowingAnchorList:(void(^) (NSArray<LJLiveMultiplayerRoomAnchor *> *anchors))success
                                              failure:(LJLiveVoidBlock)failure;
+ (void)lj_joinRoomWithRoomId:(NSInteger)roomId
                       success:(LJLiveVoidBlock)success
                       failure:(LJLiveVoidBlock)failure;
+ (BOOL)lj_valid:(NSDictionary *)response showTip:(BOOL)showTip;
+ (void)lj_getEventLabelListWithAccountId:(NSInteger)accountId
                               success:(LJLiveResponseBlock)success
                                  failure:(LJLiveVoidBlock)failure;
+ (void)lj_joinRoomByHostId:(NSInteger)hostId
                     success:(LJLiveObjectBlock)success
                     failure:(LJLiveVoidBlock)failure;
+ (void)lj_userTakeHostWithRoomId:(NSInteger)roomId
                            giftId:(NSInteger)giftId
                           success:(void(^) (LJLivePrivate * __nullable privateChat))success
                           failure:(LJLiveVoidBlock)failure;
@end

NS_ASSUME_NONNULL_END
