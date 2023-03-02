//
//  LJLiveAgoraHelper.m
//  Woohoo
//
//  Created by M2-mini on 2021/8/24.
//

#import "LJLiveAgoraHelper.h"

@interface LJLiveAgoraHelper () <AgoraRtcEngineDelegate, AgoraRtmChannelDelegate, AgoraRtmDelegate>

@property (nonatomic, strong) AgoraRtcVideoCanvas *canvas, *mininizeCanvas;

@end

@implementation LJLiveAgoraHelper

#pragma mark - Life Cycel

+ (LJLiveAgoraHelper *)helper
{
    static LJLiveAgoraHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[LJLiveAgoraHelper alloc] init];
    });
    return helper;
}


#pragma mark - Getter


#pragma mark - Config


#pragma mark - AgoraRtcEngineDelegate










#pragma mark - AgoraRtmDelegate



#pragma mark - AgoraRtmChannelDelegate





#pragma mark - Public Methods






#pragma mark - RTC





#pragma mark - RTM








#pragma mark - Getter





//- (void)lj_destroyRtmChannelWithId:(NSString *)channelId
///// @param completion 完成
/// 退出频道
//- (void)rtcEngine:(AgoraRtcEngineKit *)engine remoteVideoStateChangedOfUid:(NSUInteger)uid state:(AgoraVideoRemoteState)state reason:(AgoraVideoRemoteReason)reason elapsed:(NSInteger)elapsed{
/// 初始化声网
//    if (self.rtmKit) [self lj_logoutAgoraRtmWithCompletion:nil];
//        }
//            LJLog(@"live debug agora - rtm logout failed %@", @(errorCode));
/// @param agoraRoomId 房间ID
//    [self.rtmKit loginByToken:nil user:@(kLJLiveManager.inside.account.accountId).stringValue completion:^(AgoraRtmLoginErrorCode errorCode) {
//
//        if (errorCode != AgoraRtmLoginErrorOk) {
//            LJLog(@"live debug agora - rtm login failed %@", @(errorCode));
//        }
/// 重置最小化幕布
///// @param completion completion
//    self.rtmKit = [[AgoraRtmKit alloc] initWithAppId:kLJLiveManager.agoraAppId delegate:self];
//    // 创建一个AgoraRtmKit实例
//}
///// 初始化登录RTM
/// @param barrage 消息
/// @param completion 完成
/// @param completion 完成
//    if (kLJLiveManager.inside.account.accountId == 0 || kLJLiveManager.inside.session.length == 0) return;
//            LJLog(@"live debug agora - rtm login success");
/// @param uid uid
/// 切换频道
/// @param completion 完成
//    kLJWeakSelf;
///// 退出RTM
//}
/// 退出agora，销毁
///// 当离开了频道且不再加入该频道时，及时释放频道实例所占用的资源
//}
//        if (errorCode != AgoraRtmLogoutErrorOk) {
/// @param uid uid
/// @param agoraRoomId 房号
//            if (completion) completion();
//            });
//{
/// @param completion 完成
/// @param completion 完成
//        } else {
/// @param uid uid
/// 获取房间内封禁等信息
/// @param agoraRoomId ID
/// @param agoraRoomId 房号
/// 重置PK对手幕布
//{
//    [self.rtmKit logoutWithCompletion:^(AgoraRtmLogoutErrorCode errorCode) {
/// 加入频道
//    [self.rtmKit destroyChannelWithId:channelId];
//            if (completion) completion();
/// 加入RTM指定频道
/// @param channelId 频道ID
//    }];
//            LJLog(@"live debug agora - rtm logout success");
//        } else {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//    }];
//}
//- (void)lj_loginAgoraRtmWithCompletion:(LJLiveVoidBlock __nullable)completion
//{
/// 利用RTM发送弹幕及通知消息
/// 重置全屏幕布
//- (void)lj_logoutAgoraRtmWithCompletion:(LJLiveVoidBlock __nullable )completion
/// 离开RTM频道
// first remote video frame 刚进房间设置的远端视图
//    LJLog(@"live debug agora - rtcEngine remoteVideoStateChangedOfUid: %ld  %ld  %ld", uid, state, reason);
/// @param completion 完成
//                [weakSelf lj_loginAgoraRtmWithCompletion:completion];
///// @param channelId 频道
- (LJLiveScreenshotHideView *)minimizeVideoView
{
    if (!_minimizeVideoView) {
        CGFloat width = kLJWidthScale(100);
        CGFloat height = kLJWidthScale(160);
        _minimizeVideoView = [[LJLiveScreenshotHideView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _minimizeVideoView.backgroundColor = UIColor.clearColor;
    }
    return _minimizeVideoView;
}
- (void)lj_logoutAgoraRtcWithCompletion:(LJLiveVoidBlock __nullable )completion
{
    // rtc
    [self.rtcKit setupRemoteVideo:nil];
    [self.rtcKit setupLocalVideo:nil];
    [self.rtcKit leaveChannel:nil];
}
- (void)lj_initAgoraRtm
{
    self.rtmKit = kLJLiveManager.inside.rtmKit;
}
- (LJLiveScreenshotHideView *)pkVideoView
{
    if (!_pkVideoView) {
        _pkVideoView = [[LJLiveScreenshotHideView alloc] initWithFrame:CGRectMake(0, 0, kLJLiveHelper.ui.pkAwayVideoRect.size.width, kLJLiveHelper.ui.pkAwayVideoRect.size.height)];
        _pkVideoView.backgroundColor = UIColor.clearColor;
    }
    return _pkVideoView;
}
- (void)rtmKit:(AgoraRtmKit *)kit messageReceived:(AgoraRtmMessage *)message fromPeer:(NSString *)peerId
{
    LJLog(@"live debug agora - message received from %@: %@", message.text, peerId);
}
- (void)lj_leaveRtmRtcWithAgoraRoomId:(NSString * __nullable )agoraRoomId
{
    // rtc
    if (self.rtcKit) [self.rtcKit leaveChannel:nil];
    if ([kLJLiveManager.dataSource lj_rtcKit] == nil){
        [AgoraRtcEngineKit destroy];
    }
    // rtm
    if (self.rtmChannel) {
        [self lj_leaveRtmChannelWithCompletion:nil];
//        if (agoraRoomId.length) [self lj_destroyRtmChannelWithId:agoraRoomId];
        self.rtmChannel.channelDelegate = nil;
        self.rtmChannel = nil;
        //
        [kLJLiveManager.dataSource lj_bindingRTMDelegate:nil];
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
- (void)lj_joinAgoraRtmWithAgoraRoomId:(NSString *)agoraRoomId completion:(LJLiveVoidBlock __nullable )completion
{
    kLJWeakSelf;
    self.rtmChannel = [self.rtmKit createChannelWithId:agoraRoomId delegate:self];
    [self.rtmChannel joinWithCompletion:^(AgoraRtmJoinChannelErrorCode errorCode) {
        if (errorCode == AgoraRtmJoinChannelErrorOk) {
            LJLog(@"live debug agora - rtm channel join success: %@", agoraRoomId);
            // hint
            if (weakSelf.receiveBarrageBlock) weakSelf.receiveBarrageBlock([LJLiveBarrage hintMessage]);
            // join
            if (weakSelf.receiveBarrageBlock) weakSelf.receiveBarrageBlock([LJLiveBarrage joinedMessage]);
            // 发给别人
            [weakSelf lj_sendLiveMessageBarrage:[LJLiveBarrage joinedMessage] completion:nil];
            //
            if (completion) completion();
        } else {
            LJLog(@"live debug agora - rtm channel %@ join failed: %@", agoraRoomId, @(errorCode));
            // 加入超时
            if (errorCode == AgoraRtmJoinChannelErrorTimeout) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (kLJLiveHelper.data.current && [agoraRoomId isEqualToString:kLJLiveHelper.data.current.agoraRoomId]) {
                        [weakSelf lj_joinAgoraRtmWithAgoraRoomId:agoraRoomId completion:completion];
                    }
                });
            }
        }
    }];
}
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didVideoMuted:(BOOL)muted byUid:(NSUInteger)uid
{
    // 禁视频
    LJLog(@"live debug agora - rtcEngine didVideoMuted: %ld %@", uid, muted ? @"beMute" : @"unMute");
    // 己方主播幕布
    if (uid == kLJLiveHelper.data.current.hostAccountId) {
        if (kLJLiveHelper.isMinimize) {
            if (self.receivedMininizeVideoBlock) self.receivedMininizeVideoBlock(muted ? nil : self.minimizeVideoView);
        } else {
            if (self.receivedVideoBlock) self.receivedVideoBlock(muted ? nil : self.videoView);
        }
        self.videoMute = muted;
    }
    // PK对方主播幕布
    if (kLJLiveHelper.data.current.pking && uid == kLJLiveHelper.data.current.pkData.awayPlayer.hostAccountId) {
        if (self.receivePkVideoBlock) self.receivePkVideoBlock(muted ? nil : self.pkVideoView);
    }
}
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine firstRemoteVideoFrameOfUid:(NSUInteger)uid size:(CGSize)size elapsed:(NSInteger)elapsed
{
    LJLog(@"live debug agora - rtcEngine firstRemoteVideoFrameOfUid: %ld, size: %@", uid, NSStringFromCGSize(size));
}
- (void)lj_setupPkRemoteVideoWithUid:(NSInteger)uid
{
    AgoraRtcVideoCanvas *canvas = [[AgoraRtcVideoCanvas alloc] init];
    canvas.uid = uid;
    canvas.renderMode = AgoraVideoRenderModeHidden;
    canvas.view = self.pkVideoView;
    [self.rtcKit setupRemoteVideo:canvas];
    //
    if (self.receivePkVideoBlock) self.receivePkVideoBlock(self.pkVideoView);
}
- (void)lj_getChannelAttributesWithRoomId:(NSString *)channelId
{
    kLJWeakSelf;
    [self.rtmKit getChannelAllAttributes:channelId completion:^(NSArray<AgoraRtmChannelAttribute *> * _Nullable attributes, AgoraRtmProcessAttributeErrorCode errorCode) {
        [weakSelf lj_receiveRtmChannelAttributes:attributes];
    }];
}
- (void)lj_setupFullRemoteVideoWithUid:(NSInteger)uid
{
    AgoraRtcVideoCanvas *canvas = [[AgoraRtcVideoCanvas alloc] init];
    canvas.uid = uid;
    canvas.renderMode = AgoraVideoRenderModeHidden;
    canvas.view = self.videoView;
    [self.rtcKit setupRemoteVideo:canvas];
    //
    if (self.receivedVideoBlock) self.receivedVideoBlock(self.videoMute ? nil : self.videoView);
}
- (void)rtcEngine:(AgoraRtcEngineKit *)engine remoteVideoStateChangedOfUid:(NSUInteger)uid state:(AgoraVideoRemoteState)state reason:(AgoraVideoRemoteReason)reason elapsed:(NSInteger)elapsed{
    LJLog(@"live debug agora - rtcEngine firstRemoteVideoDecodedOfUid: %ld", uid);
    if (uid == kLJLiveHelper.data.current.hostAccountId) {
        // 主播
        UIView *videoView = kLJLiveHelper.isMinimize ? self.minimizeVideoView : self.videoView;
        AgoraRtcVideoCanvas *canvas = [[AgoraRtcVideoCanvas alloc] init];
        canvas.uid = uid;
        canvas.renderMode = AgoraVideoRenderModeHidden;
        canvas.view = videoView;
        [self.rtcKit setupRemoteVideo:canvas];
        // 最小化
        if (kLJLiveHelper.isMinimize) {
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
        if (kLJLiveHelper.data.current.pking){
            self.videoView.frame = CGRectMake(0, 0, kLJLiveHelper.ui.pkHomeVideoRect.size.width, kLJLiveHelper.ui.pkHomeVideoRect.size.height);
        }else{
            self.videoView.frame = kLJLiveHelper.ui.homeVideoRect;
        }

        // 对方主播
//        if (self.receivePkVideoBlock) self.receivePkVideoBlock(self.minimizePKVideoView);
    }
}
- (void)channel:(AgoraRtmChannel *)channel memberLeft:(AgoraRtmMember *)member
{
    LJLog(@"live debug agora - %@ left channel %@", member.userId, member.channelId);
}
- (void)lj_switchAgoraRtcWithAgoraRoomId:(NSString *)agoraRoomId completion:(LJLiveVoidBlock __nullable )completion
{
    self.videoView.frame = kLJLiveHelper.ui.homeVideoRect;
    self.videoMute = NO;
    [self.rtcKit leaveChannel:^(AgoraChannelStats * _Nonnull stat) {
        [self.rtcKit joinChannelByToken:nil channelId:agoraRoomId info:nil uid:kLJLiveManager.inside.account.accountId joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
            if (completion) completion();
        }];
    }];
//    LJLog(@"live debug agora - switchAgoraRtcWithAgoraRoomId: %d", result);
}
- (void)lj_leaveRtmChannelWithCompletion:(LJLiveVoidBlock __nullable )completion
{
    [self.rtmChannel leaveWithCompletion:^(AgoraRtmLeaveChannelErrorCode errorCode) {
        if (errorCode == AgoraRtmLeaveChannelErrorOk) {
            LJLog(@"live debug agora - rtm channel leave success");
            if (completion) completion();
        } else {
            LJLog(@"live debug agora - rtm channel leave failed: %@", @(errorCode));
        }
    }];
}
- (void)channel:(AgoraRtmChannel *)channel messageReceived:(AgoraRtmMessage *)message fromMember:(AgoraRtmMember *)member
{
    AgoraRtmRawMessage *rawMsg = (AgoraRtmRawMessage *)message;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:rawMsg.rawData options:NSJSONReadingMutableLeaves error:nil];
    LJLog(@"live debug agora - message received from %@ in channel %@: %@ \n%@", message.text, member.channelId, member.userId, dict);
    LJLiveBarrage *barrage = [[LJLiveBarrage alloc] initWithDictionary:dict];
    // 回传
    if (self.receiveBarrageBlock) self.receiveBarrageBlock(barrage);
}
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didAudioMuted:(BOOL)muted byUid:(NSUInteger)uid
{
    // 禁音
    LJLog(@"live debug agora - rtcEngine didAudioMuted: %ld %@", uid, muted ? @"beMute" : @"unMute");
}
- (void)lj_receiveRtmChannelAttributes:(NSArray<AgoraRtmChannelAttribute *> * _Nullable)attributes
{
    // 收到更新自定义的信息（收到主播禁言某人）
    NSMutableArray *marr = [@[] mutableCopy];
    for (AgoraRtmChannelAttribute *attribute in attributes) {
        LJLiveAttributeUpdate *update = [[LJLiveAttributeUpdate alloc] init];
        update.key = attribute.key;
        if ([attribute.key isEqualToString:kLJLiveAttributeKeyMuteOpAudio]) {
            // PK对方主播开关麦状态
            LJLiveAttribute *att = [[LJLiveAttribute alloc] init];
            att.agoraRoomId = kLJLiveHelper.data.current.agoraRoomId;
            att.isMuted = ![attribute.value isEqualToString:@"false"];
            update.attribute = att;
            if (kLJLiveHelper.data.current.pking) {
                [self.rtcKit muteRemoteAudioStream:kLJLiveHelper.data.current.pkData.awayPlayer.hostAccountId mute:att.isMuted];
            }
        } else if ([attribute.key isEqualToString:kLJLiveAttributeKeyMuteOpVideo]) {
            // PK对方主播开关视频状态
            LJLiveAttribute *att = [[LJLiveAttribute alloc] init];
            att.agoraRoomId = kLJLiveHelper.data.current.agoraRoomId;
            att.isMuted = ![attribute.value isEqualToString:@"false"];
            update.attribute = att;
            if (kLJLiveHelper.data.current.pking) {
                [self.rtcKit muteRemoteVideoStream:kLJLiveHelper.data.current.pkData.awayPlayer.hostAccountId mute:att.isMuted];
                if (self.receivePkVideoBlock) self.receivePkVideoBlock(att.isMuted ? nil : self.pkVideoView);
            }
        } else {
            // 当前直播间观众禁言状态（已弃用，禁言状态由服务器管理）
            NSData *jsonData = [attribute.value dataUsingEncoding:NSUTF8StringEncoding];
            id obj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            update.attribute = [[LJLiveAttribute alloc] initWithDictionary:(NSDictionary *)obj];
        }
        [marr addObject:update];
    }
    if (self.receiveUpdateBlock) self.receiveUpdateBlock(marr);
}
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason
{
    LJLog(@"live debug agora - rtcEngine didOfflineOfUid: %ld", uid);

    AgoraRtcVideoCanvas *canvas = [[AgoraRtcVideoCanvas alloc] init];
    canvas.uid = uid;
    canvas.renderMode = AgoraVideoRenderModeHidden;
    canvas.view = nil;
    [self.rtcKit setupRemoteVideo:canvas];
    
    // PK中，对方主播退出
    if (kLJLiveHelper.data.current.pkData && uid == kLJLiveHelper.data.current.pkData.awayPlayer.hostAccountId) {
        // 过5s检测（正常PK结束的通知会在5s内反馈，则不处理以下代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (kLJLiveHelper.inARoom && kLJLiveHelper.data.current.pkData && uid == kLJLiveHelper.data.current.pkData.awayPlayer.hostAccountId) {
                // 请求最新直播数据，同步
                [LJLiveNetworkHelper lj_getLiveInfoWithRoomId:kLJLiveHelper.data.current.roomId success:^(LJLiveRoom * _Nullable room) {
                    if (room) kLJLiveAgoraHelper.receiveBarrageBlock([LJLiveBarrage messageWithLive:room]);
                } failure:^{
                }];
            }
        });
    }
}
- (void)lj_setupMininzeRemoteVideoWithUid:(NSInteger)uid
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
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self lj_config];
    }
    return self;
}
- (void)rtmKit:(AgoraRtmKit *)kit connectionStateChanged:(AgoraRtmConnectionState)state reason:(AgoraRtmConnectionChangeReason)reason
{
    LJLog(@"live debug agora - connection state changed to %@", @(reason));
}
- (LJLiveScreenshotHideView *)minimizePKVideoView
{
    if (!_minimizePKVideoView) {
        CGFloat width = kLJWidthScale(100);
        CGFloat height = kLJWidthScale(160);
        _minimizePKVideoView = [[LJLiveScreenshotHideView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _minimizePKVideoView.backgroundColor = UIColor.clearColor;
    }
    return _minimizePKVideoView;
}
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed
{
    LJLog(@"live debug agora - rtcEngine didJoinedOfUid: %ld", uid);
}
- (void)channel:(AgoraRtmChannel *)channel attributeUpdate:(NSArray<AgoraRtmChannelAttribute *> *)attributes
{
    [self lj_receiveRtmChannelAttributes:attributes];
}
- (void)channel:(AgoraRtmChannel *)channel memberJoined:(AgoraRtmMember *)member
{
    LJLog(@"live debug agora - %@ joined channel %@", member.userId, member.channelId);
}
- (void)lj_sendLiveMessageBarrage:(LJLiveBarrage *)barrage completion:(LJLiveVoidBlock __nullable )completion
{
    AgoraRtmRawMessage *message = [[AgoraRtmRawMessage alloc] initWithRawData:[barrage mj_JSONData] description:@"iOS"];
    [self.rtmChannel sendMessage:message completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
        if (errorCode == AgoraRtmSendChannelMessageErrorOk) {
            LJLog(@"sent success");
            if (completion) completion();
        }
    }];
}
- (void)lj_config
{
    
}
- (void)lj_initAgoraRtc
{
    self.rtcKit = [kLJLiveManager.dataSource lj_rtcKit]?:[AgoraRtcEngineKit sharedEngineWithAppId:kLJLiveManager.agoraAppId delegate:self];
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
- (void)rtcEngine:(AgoraRtcEngineKit *)engine receiveStreamMessageFromUid:(NSUInteger)uid streamId:(NSInteger)streamId data:(NSData *)data
{
    // 收到数据流
    LJLog(@"live debug agora - rtcEngine receiveStreamMessageFromUid: %ld  %ld", uid, streamId);
}
- (LJLiveScreenshotHideView *)videoView
{
    if (!_videoView) {
        _videoView = [[LJLiveScreenshotHideView alloc] initWithFrame:kLJLiveHelper.ui.homeVideoRect];
        _videoView.backgroundColor = UIColor.clearColor;
    }
    return _videoView;
}
- (void)lj_joinAgoraRtcWithAgoraRoomId:(NSString *)agoraRoomId completion:(LJLiveVoidBlock __nullable )completion
{
    self.videoView.frame = kLJLiveHelper.ui.homeVideoRect;
    self.videoMute = NO;
    NSInteger uid = kLJLiveManager.inside.account.accountId;
    [self.rtcKit joinChannelByToken:nil channelId:agoraRoomId info:nil uid:uid joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
        LJLog(@"live debug agora - rtc join success");
        if (completion) completion();
    }];
}
@end
