//
//  GYLiveAgoraHelper.h
//  Woohoo
//
//  Created by M2-mini on 2021/8/24.
//

#import <Foundation/Foundation.h>
#import "GYLiveScreenshotHideView.h"
#import "GYLiveBarrage.h"
#import "GYLiveAttributeUpdate.h"
#import "GYLiveHeader.h"

NS_ASSUME_NONNULL_BEGIN

#define kGYLiveAgoraHelper [GYLiveAgoraHelper helper]

typedef void(^GYLiveAgoraRemoteViewBlock)(UIView * __nullable videoView);
// 收到弹幕消息/系统消息
typedef void(^GYLiveMessageReceiveBlock)(GYLiveBarrage * _Nullable barrage);

typedef void(^GYLiveAttributeUpdateBlock)(NSArray<GYLiveAttributeUpdate *> * _Nullable updates);

@interface GYLiveAgoraHelper : NSObject

/*------------------------------------------------------------------------------
 声网
 */
/// RTC
@property (strong, nonatomic) AgoraRtcEngineKit * __nullable rtcKit;
/// RTM
@property (nonatomic, strong) AgoraRtmKit * __nullable rtmKit;
/// RTM频道
@property (nonatomic, strong) AgoraRtmChannel * __nullable rtmChannel;
/// 幕布
@property (nonatomic, strong) GYLiveScreenshotHideView * __nullable videoView, * __nullable pkVideoView;
/// 最小化的视频幕布
@property (nonatomic, strong) GYLiveScreenshotHideView * __nullable minimizeVideoView;
/// 最小化的pk视频幕布
@property (nonatomic, strong) GYLiveScreenshotHideView * __nullable minimizePKVideoView;
/// 己方主播视频mute状态
@property (nonatomic, assign) BOOL videoMute;

/*------------------------------------------------------------------------------
 数据传递
 */
/// 收到弹幕
@property (nonatomic, copy) GYLiveMessageReceiveBlock receiveBarrageBlock;
/// 收到RTM内房间信息更新
@property (nonatomic, copy) GYLiveAttributeUpdateBlock receiveUpdateBlock;
/// 收到远端视频
@property (nonatomic, copy) GYLiveAgoraRemoteViewBlock receivedVideoBlock, receivedMininizeVideoBlock, receivePkVideoBlock;

/// 单例
+ (GYLiveAgoraHelper *)helper;

#pragma mark - Public Methods

/// 重置最小化幕布
/// @param uid uid
- (void)fb_setupMininzeRemoteVideoWithUid:(NSInteger)uid;

/// 重置全屏幕布
/// @param uid uid
- (void)fb_setupFullRemoteVideoWithUid:(NSInteger)uid;

/// 退出agora，销毁
/// @param agoraRoomId ID
- (void)fb_leaveRtmRtcWithAgoraRoomId:(NSString * __nullable )agoraRoomId;

#pragma mark - RTC

/// 初始化声网rtc功能
- (void)fb_initAgoraRtc;

/// 加入频道
/// @param agoraRoomId 房号
/// @param completion 完成
- (void)fb_joinAgoraRtcWithAgoraRoomId:(NSString *)agoraRoomId completion:(GYLiveVoidBlock __nullable )completion;

/// 切换频道（内置退出加入）
/// @param agoraRoomId 房号
/// @param completion 完成
- (void)fb_switchAgoraRtcWithAgoraRoomId:(NSString *)agoraRoomId completion:(GYLiveVoidBlock __nullable )completion;

/// 退出频道
/// @param completion 完成
- (void)fb_logoutAgoraRtcWithCompletion:(GYLiveVoidBlock __nullable )completion;

#pragma mark - RTM

///// 初始化登录RTM
///// @param completion completion
//- (void)fb_loginAgoraRtmWithCompletion:(GYLiveVoidBlock __nullable)completion;
//
///// 退出RTM
///// @param completion 完成
//- (void)fb_logoutAgoraRtmWithCompletion:(GYLiveVoidBlock __nullable )completion;

- (void)fb_initAgoraRtm;

/// 加入RTM指定频道
/// @param agoraRoomId 房间ID
/// @param completion 完成
- (void)fb_joinAgoraRtmWithAgoraRoomId:(NSString *)agoraRoomId completion:(GYLiveVoidBlock __nullable )completion;

/// 离开RTM频道
/// @param completion 完成
- (void)fb_leaveRtmChannelWithCompletion:(GYLiveVoidBlock __nullable )completion;

///// 当离开了频道且不再加入该频道时，及时释放频道实例所占用的资源
///// @param channelId 频道
//- (void)fb_destroyRtmChannelWithId:(NSString *)channelId;

/// 利用RTM发送弹幕及通知消息
/// @param barrage 消息
/// @param completion 完成
- (void)fb_sendLiveMessageBarrage:(GYLiveBarrage *)barrage completion:(GYLiveVoidBlock __nullable )completion;

/// 获取房间内封禁等信息
/// @param channelId 频道ID
- (void)fb_getChannelAttributesWithRoomId:(NSString *)channelId;

@end

NS_ASSUME_NONNULL_END
