//
//  LJLiveAttributeUpdate.h
//  Woohoo
//
//  Created by M2-mini on 2021/9/9.
//

#import "LJLiveBaseObject.h"

@class LJLiveAttribute;

NS_ASSUME_NONNULL_BEGIN

static NSString *const kLJLiveAttributeKeyMuteOpAudio = @"muteOpAudio";
static NSString *const kLJLiveAttributeKeyMuteOpVideo = @"muteOpVideo";

@interface LJLiveAttributeUpdate : LJLiveBaseObject

/// AccountID
@property (nonatomic, strong) NSString *key;

@property (nonatomic, strong) LJLiveAttribute *attribute;

@end

/*
 AgoraRtmChannelAttribute *attr = [[AgoraRtmChannelAttribute alloc] init];
  
 // 更新房间信息（封禁某人）
 attr.key = @"accountid";
 attr.value = @"{
     muteExpire: 128738278,
 }"
 
 // 主播开关麦
 attr.key = @"muteOpAudio";
 attr.value = @"false";
 
 */

@interface LJLiveAttribute : LJLiveBaseObject

/// 声网房间（频道）
@property (nonatomic, strong) NSString *agoraRoomId;
/// 禁言到期时间轴
@property (nonatomic, assign) NSInteger muteExpire;

/// 音频开关（仅PK使用）
@property (nonatomic, assign) BOOL isMuted;

@end

NS_ASSUME_NONNULL_END
