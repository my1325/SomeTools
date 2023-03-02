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
@property (nonatomic, strong) LJLiveScreenshotHideView * __nullable videoView, * __nullable pkVideoView;
/// 最小化的视频幕布
@property (nonatomic, strong) LJLiveScreenshotHideView * __nullable minimizeVideoView;
/// 最小化的pk视频幕布
@property (nonatomic, strong) LJLiveScreenshotHideView * __nullable minimizePKVideoView;
/// 己方主播视频mute状态
@property (nonatomic, assign) BOOL videoMute;

/*------------------------------------------------------------------------------
 数据传递
 */
/// 收到弹幕
@property (nonatomic, copy) LJLiveMessageReceiveBlock receiveBarrageBlock;
/// 收到RTM内房间信息更新
@property (nonatomic, copy) LJLiveAttributeUpdateBlock receiveUpdateBlock;
/// 收到远端视频
@property (nonatomic, copy) LJLiveAgoraRemoteViewBlock receivedVideoBlock, receivedMininizeVideoBlock, receivePkVideoBlock;

/// 单例
+ (LJLiveAgoraHelper *)helper;

#pragma mark - Public Methods

/// 重置最小化幕布
/// @param uid uid
- (void)lj_setupMininzeRemoteVideoWithUid:(NSInteger)uid;

/// 重置全屏幕布
/// @param uid uid
- (void)lj_setupFullRemoteVideoWithUid:(NSInteger)uid;

/// 退出agora，销毁
/// @param agoraRoomId ID
- (void)lj_leaveRtmRtcWithAgoraRoomId:(NSString * __nullable )agoraRoomId;

#pragma mark - RTC

/// 初始化声网rtc功能
- (void)lj_initAgoraRtc;

/// 加入频道
/// @param agoraRoomId 房号
/// @param completion 完成
- (void)lj_joinAgoraRtcWithAgoraRoomId:(NSString *)agoraRoomId completion:(LJLiveVoidBlock __nullable )completion;

/// 切换频道（内置退出加入）
/// @param agoraRoomId 房号
/// @param completion 完成
- (void)lj_switchAgoraRtcWithAgoraRoomId:(NSString *)agoraRoomId completion:(LJLiveVoidBlock __nullable )completion;

/// 退出频道
/// @param completion 完成
- (void)lj_logoutAgoraRtcWithCompletion:(LJLiveVoidBlock __nullable )completion;

#pragma mark - RTM

///// 初始化登录RTM
///// @param completion completion
//- (void)lj_loginAgoraRtmWithCompletion:(LJLiveVoidBlock __nullable)completion;
//
///// 退出RTM
///// @param completion 完成
//- (void)lj_logoutAgoraRtmWithCompletion:(LJLiveVoidBlock __nullable )completion;

- (void)lj_initAgoraRtm;

/// 加入RTM指定频道
/// @param agoraRoomId 房间ID
/// @param completion 完成
- (void)lj_joinAgoraRtmWithAgoraRoomId:(NSString *)agoraRoomId completion:(LJLiveVoidBlock __nullable )completion;

/// 离开RTM频道
/// @param completion 完成
- (void)lj_leaveRtmChannelWithCompletion:(LJLiveVoidBlock __nullable )completion;

///// 当离开了频道且不再加入该频道时，及时释放频道实例所占用的资源
///// @param channelId 频道
//- (void)lj_destroyRtmChannelWithId:(NSString *)channelId;

/// 利用RTM发送弹幕及通知消息
/// @param barrage 消息
/// @param completion 完成
- (void)lj_sendLiveMessageBarrage:(LJLiveBarrage *)barrage completion:(LJLiveVoidBlock __nullable )completion;

/// 获取房间内封禁等信息
/// @param channelId 频道ID
- (void)lj_getChannelAttributesWithRoomId:(NSString *)channelId;

@end

NS_ASSUME_NONNULL_END
