//
//  LJLiveAgoraHelper.h
//  Woohoo
//
//  Created by M2-mini on 2021/8/24.
//

#import <Foundation/Foundation.h>
#import "LJLiveScreenshotHideView.h"
#import "LJLiveBarrage.h"
#import "LJLiveAttributeUpdate.h"
#import "LJLiveHeader.h"

NS_ASSUME_NONNULL_BEGIN

#define kLJLiveAgoraHelper [LJLiveAgoraHelper helper]

typedef void(^LJLiveAgoraRemoteViewBlock)(UIView * __nullable videoView);
// 收到弹幕消息/系统消息
typedef void(^LJLiveMessageReceiveBlock)(LJLiveBarrage * _Nullable barrage);

typedef void(^LJLiveAttributeUpdateBlock)(NSArray<LJLiveAttributeUpdate *> * _Nullable updates);

@interface LJLiveAgoraHelper : NSObject




#pragma mark - Public Methods




#pragma mark - RTC





#pragma mark - RTM








/// @param completion 完成
/// 收到弹幕
/// 最小化的视频幕布
/// @param completion 完成
/*------------------------------------------------------------------------------
 声网
 */
/// @param completion 完成
/// @param completion 完成
///// @param completion 完成
/// 重置最小化幕布
/// 利用RTM发送弹幕及通知消息
///// 退出RTM
/// 切换频道（内置退出加入）
//- (void)lj_loginAgoraRtmWithCompletion:(LJLiveVoidBlock __nullable)completion;
/// 幕布
/// 退出频道
/// @param agoraRoomId 房间ID
/// 重置全屏幕布
/// 最小化的pk视频幕布
/// @param completion 完成
/// @param agoraRoomId 房号
///// @param channelId 频道
//- (void)lj_destroyRtmChannelWithId:(NSString *)channelId;
/// 单例
/// RTC
/// @param uid uid
/// 加入RTM指定频道
//
/// RTM
///// 初始化登录RTM
/// @param channelId 频道ID
/// 获取房间内封禁等信息
/// @param barrage 消息
/// 初始化声网rtc功能
///// @param completion completion
/// 收到RTM内房间信息更新
/// 收到远端视频
//- (void)lj_logoutAgoraRtmWithCompletion:(LJLiveVoidBlock __nullable )completion;
/// 己方主播视频mute状态
/// @param completion 完成
/// @param uid uid
/*------------------------------------------------------------------------------
 数据传递
 */
/// 离开RTM频道
/// 加入频道
/// 退出agora，销毁
///// 当离开了频道且不再加入该频道时，及时释放频道实例所占用的资源
/// @param agoraRoomId ID
/// @param agoraRoomId 房号
/// RTM频道
- (void)lj_getChannelAttributesWithRoomId:(NSString *)channelId;
- (void)lj_joinAgoraRtmWithAgoraRoomId:(NSString *)agoraRoomId completion:(LJLiveVoidBlock __nullable )completion;
- (void)lj_switchAgoraRtcWithAgoraRoomId:(NSString *)agoraRoomId completion:(LJLiveVoidBlock __nullable )completion;
- (void)lj_leaveRtmRtcWithAgoraRoomId:(NSString * __nullable )agoraRoomId;
- (void)lj_setupFullRemoteVideoWithUid:(NSInteger)uid;
- (void)lj_sendLiveMessageBarrage:(LJLiveBarrage *)barrage completion:(LJLiveVoidBlock __nullable )completion;
- (void)lj_initAgoraRtm;
- (void)lj_initAgoraRtc;
- (void)lj_setupMininzeRemoteVideoWithUid:(NSInteger)uid;
- (void)lj_joinAgoraRtcWithAgoraRoomId:(NSString *)agoraRoomId completion:(LJLiveVoidBlock __nullable )completion;
+ (LJLiveAgoraHelper *)helper;
- (void)lj_leaveRtmChannelWithCompletion:(LJLiveVoidBlock __nullable )completion;
- (void)lj_logoutAgoraRtcWithCompletion:(LJLiveVoidBlock __nullable )completion;
@property (nonatomic, copy) LJLiveAgoraRemoteViewBlock receivedVideoBlock, receivedMininizeVideoBlock, receivePkVideoBlock;
@property (nonatomic, strong) AgoraRtmKit * __nullable rtmKit;
@property (nonatomic, strong) LJLiveScreenshotHideView * __nullable minimizePKVideoView;
@property (nonatomic, copy) LJLiveMessageReceiveBlock receiveBarrageBlock;
@property (nonatomic, strong) AgoraRtmChannel * __nullable rtmChannel;
@property (nonatomic, strong) LJLiveScreenshotHideView * __nullable videoView, * __nullable pkVideoView;
@property (strong, nonatomic) AgoraRtcEngineKit * __nullable rtcKit;
@property (nonatomic, copy) LJLiveAttributeUpdateBlock receiveUpdateBlock;
@property (nonatomic, assign) BOOL videoMute;
@property (nonatomic, strong) LJLiveScreenshotHideView * __nullable minimizeVideoView;
@end

NS_ASSUME_NONNULL_END
