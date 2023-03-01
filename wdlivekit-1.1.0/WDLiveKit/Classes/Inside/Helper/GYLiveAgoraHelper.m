//
//  GYLiveAgoraHelper.m
//  Woohoo
//
//  Created by M2-mini on 2021/8/24.
//

#import "GYLiveAgoraHelper.h"

@interface GYLiveAgoraHelper () <AgoraRtcEngineDelegate, AgoraRtmChannelDelegate, AgoraRtmDelegate>

@property (nonatomic, strong) AgoraRtcVideoCanvas *canvas, *mininizeCanvas;

@end

@implementation GYLiveAgoraHelper

#pragma mark - Life Cycel

+ (GYLiveAgoraHelper *)helper
{
    static GYLiveAgoraHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[GYLiveAgoraHelper alloc] init];
    });
    return helper;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self fb_config];
    }
    return self;
}

#pragma mark - Getter


#pragma mark - Config

- (void)fb_config
{
    
}

#pragma mark - AgoraRtcEngineDelegate

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed
{
    GYLog(@"live debug agora - rtcEngine didJoinedOfUid: %ld", uid);
}

// first remote video frame 刚进房间设置的远端视图
- (void)rtcEngine:(AgoraRtcEngineKit *)engine remoteVideoStateChangedOfUid:(NSUInteger)uid state:(AgoraVideoRemoteState)state reason:(AgoraVideoRemoteReason)reason elapsed:(NSInteger)elapsed{
    GYLog(@"live debug agora - rtcEngine firstRemoteVideoDecodedOfUid: %ld", uid);
    if (uid == kGYLiveHelper.data.current.hostAccountId) {
        // 主播
        UIView *videoView = kGYLiveHelper.isMinimize ? self.minimizeVideoView : self.videoView;
        AgoraRtcVideoCanvas *canvas = [[AgoraRtcVideoCanvas alloc] init];
        canvas.uid = uid;
        canvas.renderMode = AgoraVideoRenderModeHidden;
        canvas.view = videoView;
        [self.rtcKit setupRemoteVideo:canvas];
        // 最小化
        if (kGYLiveHelper.isMinimize) {
            if (self.receivedMininizeVideoBlock) self.receivedMininizeVideoBlock(videoView);
        } else {
            if (self.receivedVideoBlock) self.receivedVideoBlock(videoView);
        }
    } else {
        //
        AgoraRtcVideoCanvas *canvas = [[AgoraRtcVideoCanvas alloc] init];
        canvas.uid = uid;
        canvas.renderMode = AgoraVideoRenderModeHidden;
        canvas.view = self.pkVideoView;
        [self.rtcKit setupRemoteVideo:canvas];
        //
        if (kGYLiveHelper.data.current.pking){
            self.videoView.frame = CGRectMake(0, 0, kGYLiveHelper.ui.pkHomeVideoRect.size.width, kGYLiveHelper.ui.pkHomeVideoRect.size.height);
        }else{
            self.videoView.frame = kGYLiveHelper.ui.homeVideoRect;
        }

        // 对方主播
//        if (self.receivePkVideoBlock) self.receivePkVideoBlock(self.minimizePKVideoView);
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine firstRemoteVideoFrameOfUid:(NSUInteger)uid size:(CGSize)size elapsed:(NSInteger)elapsed
{
    GYLog(@"live debug agora - rtcEngine firstRemoteVideoFrameOfUid: %ld, size: %@", uid, NSStringFromCGSize(size));
}


//- (void)rtcEngine:(AgoraRtcEngineKit *)engine remoteVideoStateChangedOfUid:(NSUInteger)uid state:(AgoraVideoRemoteState)state reason:(AgoraVideoRemoteReason)reason elapsed:(NSInteger)elapsed{
//    GYLog(@"live debug agora - rtcEngine remoteVideoStateChangedOfUid: %ld  %ld  %ld", uid, state, reason);
//}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine receiveStreamMessageFromUid:(NSUInteger)uid streamId:(NSInteger)streamId data:(NSData *)data
{
    // 收到数据流
    GYLog(@"live debug agora - rtcEngine receiveStreamMessageFromUid: %ld  %ld", uid, streamId);
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didVideoMuted:(BOOL)muted byUid:(NSUInteger)uid
{
    // 禁视频
    GYLog(@"live debug agora - rtcEngine didVideoMuted: %ld %@", uid, muted ? @"beMute" : @"unMute");
    // 己方主播幕布
    if (uid == kGYLiveHelper.data.current.hostAccountId) {
        if (kGYLiveHelper.isMinimize) {
            if (self.receivedMininizeVideoBlock) self.receivedMininizeVideoBlock(muted ? nil : self.minimizeVideoView);
        } else {
            if (self.receivedVideoBlock) self.receivedVideoBlock(muted ? nil : self.videoView);
        }
        self.videoMute = muted;
    }
    // PK对方主播幕布
    if (kGYLiveHelper.data.current.pking && uid == kGYLiveHelper.data.current.pkData.awayPlayer.hostAccountId) {
        if (self.receivePkVideoBlock) self.receivePkVideoBlock(muted ? nil : self.pkVideoView);
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didAudioMuted:(BOOL)muted byUid:(NSUInteger)uid
{
    // 禁音
    GYLog(@"live debug agora - rtcEngine didAudioMuted: %ld %@", uid, muted ? @"beMute" : @"unMute");
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason
{
    GYLog(@"live debug agora - rtcEngine didOfflineOfUid: %ld", uid);

    AgoraRtcVideoCanvas *canvas = [[AgoraRtcVideoCanvas alloc] init];
    canvas.uid = uid;
    canvas.renderMode = AgoraVideoRenderModeHidden;
    canvas.view = nil;
    [self.rtcKit setupRemoteVideo:canvas];
    
    // PK中，对方主播退出
    if (kGYLiveHelper.data.current.pkData && uid == kGYLiveHelper.data.current.pkData.awayPlayer.hostAccountId) {
        // 过5s检测（正常PK结束的通知会在5s内反馈，则不处理以下代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (kGYLiveHelper.inARoom && kGYLiveHelper.data.current.pkData && uid == kGYLiveHelper.data.current.pkData.awayPlayer.hostAccountId) {
                // 请求最新直播数据，同步
                [GYLiveNetworkHelper fb_getLiveInfoWithRoomId:kGYLiveHelper.data.current.roomId success:^(GYLiveRoom * _Nullable room) {
                    if (room) kGYLiveAgoraHelper.receiveBarrageBlock([GYLiveBarrage messageWithLive:room]);
                } failure:^{
                }];
            }
        });
    }
}

#pragma mark - AgoraRtmDelegate

- (void)rtmKit:(AgoraRtmKit *)kit connectionStateChanged:(AgoraRtmConnectionState)state reason:(AgoraRtmConnectionChangeReason)reason
{
    GYLog(@"live debug agora - connection state changed to %@", @(reason));
}

- (void)rtmKit:(AgoraRtmKit *)kit messageReceived:(AgoraRtmMessage *)message fromPeer:(NSString *)peerId
{
    GYLog(@"live debug agora - message received from %@: %@", message.text, peerId);
}

#pragma mark - AgoraRtmChannelDelegate

- (void)channel:(AgoraRtmChannel *)channel memberLeft:(AgoraRtmMember *)member
{
    GYLog(@"live debug agora - %@ left channel %@", member.userId, member.channelId);
}

- (void)channel:(AgoraRtmChannel *)channel memberJoined:(AgoraRtmMember *)member
{
    GYLog(@"live debug agora - %@ joined channel %@", member.userId, member.channelId);
}

- (void)channel:(AgoraRtmChannel *)channel messageReceived:(AgoraRtmMessage *)message fromMember:(AgoraRtmMember *)member
{
    AgoraRtmRawMessage *rawMsg = (AgoraRtmRawMessage *)message;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:rawMsg.rawData options:NSJSONReadingMutableLeaves error:nil];
    GYLog(@"live debug agora - message received from %@ in channel %@: %@ \n%@", message.text, member.channelId, member.userId, dict);
    GYLiveBarrage *barrage = [[GYLiveBarrage alloc] initWithDictionary:dict];
    // 回传
    if (self.receiveBarrageBlock) self.receiveBarrageBlock(barrage);
}

- (void)channel:(AgoraRtmChannel *)channel attributeUpdate:(NSArray<AgoraRtmChannelAttribute *> *)attributes
{
    [self fb_receiveRtmChannelAttributes:attributes];
}

#pragma mark - Public Methods

/// 重置最小化幕布
/// @param uid uid
- (void)fb_setupMininzeRemoteVideoWithUid:(NSInteger)uid
{
    AgoraRtcVideoCanvas *canvas = [[AgoraRtcVideoCanvas alloc] init];
    canvas.uid = uid;
    canvas.renderMode = AgoraVideoRenderModeHidden;
    canvas.view = self.minimizeVideoView;
    [self.rtcKit setupRemoteVideo:canvas];
    //
    if (self.receivedMininizeVideoBlock) self.receivedMininizeVideoBlock(self.videoMute ? nil : self.minimizeVideoView);
//    if (self.receivePkVideoBlock) self.receivePkVideoBlock(self.minimizePKVideoView);
}

/// 重置全屏幕布
/// @param uid uid
- (void)fb_setupFullRemoteVideoWithUid:(NSInteger)uid
{
    AgoraRtcVideoCanvas *canvas = [[AgoraRtcVideoCanvas alloc] init];
    canvas.uid = uid;
    canvas.renderMode = AgoraVideoRenderModeHidden;
    canvas.view = self.videoView;
    [self.rtcKit setupRemoteVideo:canvas];
    //
    if (self.receivedVideoBlock) self.receivedVideoBlock(self.videoMute ? nil : self.videoView);
}

/// 重置PK对手幕布
/// @param uid uid
- (void)fb_setupPkRemoteVideoWithUid:(NSInteger)uid
{
    AgoraRtcVideoCanvas *canvas = [[AgoraRtcVideoCanvas alloc] init];
    canvas.uid = uid;
    canvas.renderMode = AgoraVideoRenderModeHidden;
    canvas.view = self.pkVideoView;
    [self.rtcKit setupRemoteVideo:canvas];
    //
    if (self.receivePkVideoBlock) self.receivePkVideoBlock(self.pkVideoView);
}

/// 退出agora，销毁
/// @param agoraRoomId ID
- (void)fb_leaveRtmRtcWithAgoraRoomId:(NSString * __nullable )agoraRoomId
{
    // rtc
    if (self.rtcKit) [self.rtcKit leaveChannel:nil];
    if ([kGYLiveManager.dataSource fb_rtcKit] == nil){
        [AgoraRtcEngineKit destroy];
    }
    // rtm
    if (self.rtmChannel) {
        [self fb_leaveRtmChannelWithCompletion:nil];
//        if (agoraRoomId.length) [self fb_destroyRtmChannelWithId:agoraRoomId];
        self.rtmChannel.channelDelegate = nil;
        self.rtmChannel = nil;
        //
        [kGYLiveManager.dataSource fb_bindingRTMDelegate:nil];
    }
    // rtmKit在关闭房间时不能置为空，会导致加入频道时，rtmchannel创建失败，加不了房间
    // 在退出登录时置为空是可行的
//    self.rtmKit = nil;

    // 幕布
    if (self.videoView) {
        [self.videoView removeAllSubviews];
        [self.videoView removeFromSuperview];
        self.videoView = nil;
    }
    if (self.minimizeVideoView) {
        [self.minimizeVideoView removeAllSubviews];
        [self.minimizeVideoView removeFromSuperview];
        self.minimizeVideoView = nil;
    }
    // 自动锁屏
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void)fb_receiveRtmChannelAttributes:(NSArray<AgoraRtmChannelAttribute *> * _Nullable)attributes
{
    // 收到更新自定义的信息（收到主播禁言某人）
    NSMutableArray *marr = [@[] mutableCopy];
    for (AgoraRtmChannelAttribute *attribute in attributes) {
        GYLiveAttributeUpdate *update = [[GYLiveAttributeUpdate alloc] init];
        update.key = attribute.key;
        if ([attribute.key isEqualToString:kGYLiveAttributeKeyMuteOpAudio]) {
            // PK对方主播开关麦状态
            GYLiveAttribute *att = [[GYLiveAttribute alloc] init];
            att.agoraRoomId = kGYLiveHelper.data.current.agoraRoomId;
            att.isMuted = ![attribute.value isEqualToString:@"false"];
            update.attribute = att;
            if (kGYLiveHelper.data.current.pking) {
                [self.rtcKit muteRemoteAudioStream:kGYLiveHelper.data.current.pkData.awayPlayer.hostAccountId mute:att.isMuted];
            }
        } else if ([attribute.key isEqualToString:kGYLiveAttributeKeyMuteOpVideo]) {
            // PK对方主播开关视频状态
            GYLiveAttribute *att = [[GYLiveAttribute alloc] init];
            att.agoraRoomId = kGYLiveHelper.data.current.agoraRoomId;
            att.isMuted = ![attribute.value isEqualToString:@"false"];
            update.attribute = att;
            if (kGYLiveHelper.data.current.pking) {
                [self.rtcKit muteRemoteVideoStream:kGYLiveHelper.data.current.pkData.awayPlayer.hostAccountId mute:att.isMuted];
                if (self.receivePkVideoBlock) self.receivePkVideoBlock(att.isMuted ? nil : self.pkVideoView);
            }
        } else {
            // 当前直播间观众禁言状态（已弃用，禁言状态由服务器管理）
            NSData *jsonData = [attribute.value dataUsingEncoding:NSUTF8StringEncoding];
            id obj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            update.attribute = [[GYLiveAttribute alloc] initWithDictionary:(NSDictionary *)obj];
        }
        [marr addObject:update];
    }
    if (self.receiveUpdateBlock) self.receiveUpdateBlock(marr);
}

#pragma mark - RTC

/// 初始化声网
- (void)fb_initAgoraRtc
{
    self.rtcKit = [kGYLiveManager.dataSource fb_rtcKit]?:[AgoraRtcEngineKit sharedEngineWithAppId:kGYLiveManager.agoraAppId delegate:self];
    self.rtcKit.delegate = self;
    [self.rtcKit setChannelProfile:AgoraChannelProfileLiveBroadcasting];
    [self.rtcKit enableAudio];
    [self.rtcKit enableVideo];
    [self.rtcKit setClientRole:AgoraClientRoleAudience];
    [self.rtcKit adjustRecordingSignalVolume:300];
    [self.rtcKit adjustPlaybackSignalVolume:200];
    [self.rtcKit setParameters:@"{\"che.video.keepLastFrame\":false}"];
    // 不自动锁屏
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

/// 加入频道
/// @param agoraRoomId 房号
/// @param completion 完成
- (void)fb_joinAgoraRtcWithAgoraRoomId:(NSString *)agoraRoomId completion:(GYLiveVoidBlock __nullable )completion
{
    self.videoView.frame = kGYLiveHelper.ui.homeVideoRect;
    self.videoMute = NO;
    NSInteger uid = kGYLiveManager.inside.account.accountId;
    [self.rtcKit joinChannelByToken:nil channelId:agoraRoomId info:nil uid:uid joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
        GYLog(@"live debug agora - rtc join success");
        if (completion) completion();
    }];
}

/// 切换频道
/// @param agoraRoomId 房号
/// @param completion 完成
- (void)fb_switchAgoraRtcWithAgoraRoomId:(NSString *)agoraRoomId completion:(GYLiveVoidBlock __nullable )completion
{
    self.videoView.frame = kGYLiveHelper.ui.homeVideoRect;
    self.videoMute = NO;
    [self.rtcKit leaveChannel:^(AgoraChannelStats * _Nonnull stat) {
        [self.rtcKit joinChannelByToken:nil channelId:agoraRoomId info:nil uid:kGYLiveManager.inside.account.accountId joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
            if (completion) completion();
        }];
    }];
//    GYLog(@"live debug agora - switchAgoraRtcWithAgoraRoomId: %d", result);
}

/// 退出频道
/// @param completion 完成
- (void)fb_logoutAgoraRtcWithCompletion:(GYLiveVoidBlock __nullable )completion
{
    // rtc
    [self.rtcKit setupRemoteVideo:nil];
    [self.rtcKit setupLocalVideo:nil];
    [self.rtcKit leaveChannel:nil];
}

#pragma mark - RTM

///// 初始化登录RTM
///// @param completion completion
//- (void)fb_loginAgoraRtmWithCompletion:(GYLiveVoidBlock __nullable)completion
//{
//    // 创建一个AgoraRtmKit实例
//    if (kGYLiveManager.inside.account.accountId == 0 || kGYLiveManager.inside.session.length == 0) return;
//    if (self.rtmKit) [self fb_logoutAgoraRtmWithCompletion:nil];
//    kGYWeakSelf;
//    self.rtmKit = [[AgoraRtmKit alloc] initWithAppId:kGYLiveManager.agoraAppId delegate:self];
//    [self.rtmKit loginByToken:nil user:@(kGYLiveManager.inside.account.accountId).stringValue completion:^(AgoraRtmLoginErrorCode errorCode) {
//        if (errorCode != AgoraRtmLoginErrorOk) {
//            GYLog(@"live debug agora - rtm login failed %@", @(errorCode));
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [weakSelf fb_loginAgoraRtmWithCompletion:completion];
//            });
//        } else {
//            GYLog(@"live debug agora - rtm login success");
//            if (completion) completion();
//        }
//    }];
//}
//
///// 退出RTM
///// @param completion 完成
//- (void)fb_logoutAgoraRtmWithCompletion:(GYLiveVoidBlock __nullable )completion
//{
//    [self.rtmKit logoutWithCompletion:^(AgoraRtmLogoutErrorCode errorCode) {
//        if (errorCode != AgoraRtmLogoutErrorOk) {
//            GYLog(@"live debug agora - rtm logout failed %@", @(errorCode));
//        } else {
//            GYLog(@"live debug agora - rtm logout success");
//            if (completion) completion();
//        }
//    }];
//}

- (void)fb_initAgoraRtm
{
    self.rtmKit = kGYLiveManager.inside.rtmKit;
}

/// 加入RTM指定频道
/// @param agoraRoomId 房间ID
/// @param completion 完成
- (void)fb_joinAgoraRtmWithAgoraRoomId:(NSString *)agoraRoomId completion:(GYLiveVoidBlock __nullable )completion
{
    kGYWeakSelf;
    self.rtmChannel = [self.rtmKit createChannelWithId:agoraRoomId delegate:self];
    [self.rtmChannel joinWithCompletion:^(AgoraRtmJoinChannelErrorCode errorCode) {
        if (errorCode == AgoraRtmJoinChannelErrorOk) {
            GYLog(@"live debug agora - rtm channel join success: %@", agoraRoomId);
            // hint
            if (weakSelf.receiveBarrageBlock) weakSelf.receiveBarrageBlock([GYLiveBarrage hintMessage]);
            // join
            if (weakSelf.receiveBarrageBlock) weakSelf.receiveBarrageBlock([GYLiveBarrage joinedMessage]);
            // 发给别人
            [weakSelf fb_sendLiveMessageBarrage:[GYLiveBarrage joinedMessage] completion:nil];
            //
            if (completion) completion();
        } else {
            GYLog(@"live debug agora - rtm channel %@ join failed: %@", agoraRoomId, @(errorCode));
            // 加入超时
            if (errorCode == AgoraRtmJoinChannelErrorTimeout) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (kGYLiveHelper.data.current && [agoraRoomId isEqualToString:kGYLiveHelper.data.current.agoraRoomId]) {
                        [weakSelf fb_joinAgoraRtmWithAgoraRoomId:agoraRoomId completion:completion];
                    }
                });
            }
        }
    }];
}

/// 离开RTM频道
/// @param completion 完成
- (void)fb_leaveRtmChannelWithCompletion:(GYLiveVoidBlock __nullable )completion
{
    [self.rtmChannel leaveWithCompletion:^(AgoraRtmLeaveChannelErrorCode errorCode) {
        if (errorCode == AgoraRtmLeaveChannelErrorOk) {
            GYLog(@"live debug agora - rtm channel leave success");
            if (completion) completion();
        } else {
            GYLog(@"live debug agora - rtm channel leave failed: %@", @(errorCode));
        }
    }];
}

///// 当离开了频道且不再加入该频道时，及时释放频道实例所占用的资源
///// @param channelId 频道
//- (void)fb_destroyRtmChannelWithId:(NSString *)channelId
//{
//    [self.rtmKit destroyChannelWithId:channelId];
//}

/// 利用RTM发送弹幕及通知消息
/// @param barrage 消息
/// @param completion 完成
- (void)fb_sendLiveMessageBarrage:(GYLiveBarrage *)barrage completion:(GYLiveVoidBlock __nullable )completion
{
    AgoraRtmRawMessage *message = [[AgoraRtmRawMessage alloc] initWithRawData:[barrage mj_JSONData] description:@"iOS"];
    [self.rtmChannel sendMessage:message completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
        if (errorCode == AgoraRtmSendChannelMessageErrorOk) {
            GYLog(@"sent success");
            if (completion) completion();
        }
    }];
}

/// 获取房间内封禁等信息
/// @param channelId 频道ID
- (void)fb_getChannelAttributesWithRoomId:(NSString *)channelId
{
    kGYWeakSelf;
    [self.rtmKit getChannelAllAttributes:channelId completion:^(NSArray<AgoraRtmChannelAttribute *> * _Nullable attributes, AgoraRtmProcessAttributeErrorCode errorCode) {
        [weakSelf fb_receiveRtmChannelAttributes:attributes];
    }];
}

#pragma mark - Getter

- (GYLiveScreenshotHideView *)videoView
{
    if (!_videoView) {
        _videoView = [[GYLiveScreenshotHideView alloc] initWithFrame:kGYLiveHelper.ui.homeVideoRect];
        _videoView.backgroundColor = UIColor.clearColor;
    }
    return _videoView;
}

- (GYLiveScreenshotHideView *)pkVideoView
{
    if (!_pkVideoView) {
        _pkVideoView = [[GYLiveScreenshotHideView alloc] initWithFrame:CGRectMake(0, 0, kGYLiveHelper.ui.pkAwayVideoRect.size.width, kGYLiveHelper.ui.pkAwayVideoRect.size.height)];
        _pkVideoView.backgroundColor = UIColor.clearColor;
    }
    return _pkVideoView;
}

- (GYLiveScreenshotHideView *)minimizeVideoView
{
    if (!_minimizeVideoView) {
        CGFloat width = kGYWidthScale(100);
        CGFloat height = kGYWidthScale(160);
        _minimizeVideoView = [[GYLiveScreenshotHideView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _minimizeVideoView.backgroundColor = UIColor.clearColor;
    }
    return _minimizeVideoView;
}

- (GYLiveScreenshotHideView *)minimizePKVideoView
{
    if (!_minimizePKVideoView) {
        CGFloat width = kGYWidthScale(100);
        CGFloat height = kGYWidthScale(160);
        _minimizePKVideoView = [[GYLiveScreenshotHideView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _minimizePKVideoView.backgroundColor = UIColor.clearColor;
    }
    return _minimizePKVideoView;
}

@end
