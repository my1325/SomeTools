//
//  GYLiveBarrage.h
//  Woohoo
//
//  Created by M2-mini on 2021/8/24.
//

#import "GYLiveBaseObject.h"
#import "GYLiveEnum.h"
#import "GYLiveGift.h"
#import "GYLiveRoom.h"
#import "GYLivePrivate.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYLiveBarrage : GYLiveBaseObject

/// 0：hint；1：pkEnd
@property (nonatomic, assign) NSInteger systemMsgType;
/// 弹幕类型
@property (nonatomic, assign) GYLiveBarrageType type;
/// 用户类型
@property (nonatomic, assign) GYLiveUserType userType;
/// 是否VIP
@property (nonatomic, assign) BOOL isVip;
/// 是否SVIP
@property (nonatomic, assign) BOOL isSvip;
/// 特权
@property (nonatomic, assign) BOOL isPrivilege;
/// 用户ID（AccountId）
@property (nonatomic, assign) NSInteger userId;
/// 昵称
@property (nonatomic, strong) NSString *userName;
/// 头像
@property (nonatomic, strong) NSString *avatar;
/// 内容（jsonString）
@property (nonatomic, strong) NSString *content;
/// 礼物ID和combo数
@property (nonatomic, assign) NSInteger giftId, combo, isblindBox;
/// 弹幕标签地址
@property (nonatomic, strong) NSString *uniqueTagUrl;
/// 标签宽高
@property (nonatomic, assign) NSInteger uniqueTagHeight, uniqueTagWidth;

/// 加入
+ (GYLiveBarrage *)joinedMessage;

/// 提示
+ (GYLiveBarrage *)hintMessage;

/// 提示
+ (GYLiveBarrage *)pkEndMessage;

/// SayHi
+ (GYLiveBarrage *)sayHiMessage;

/// 礼物
/// @param giftConfig 礼物配置
/// @param combo combo
+ (GYLiveBarrage *)messageWithGift:(GYLiveGift *)giftConfig combo:(NSInteger)combo;

/// 房间信息
/// @param live 房间信息
+ (GYLiveBarrage *)messageWithLive:(GYLiveRoom *)live;

/// 观众信息
/// @param members 观众
+ (GYLiveBarrage *)messageWithMembers:(NSArray<GYLiveRoomMember *> *)members;

/// 私聊带走
/// @param giftConfig gift
/// @param room room
+ (GYLiveBarrage *)messageWithPrivateGift:(GYLiveGift *)giftConfig privateRoom:(GYLivePrivate *)room;

#pragma mark - Methods

/// 3s自动消失的消息
- (BOOL)fb_isSystemBarrage;

/// 需要显示的消息
- (BOOL)fb_isDisplayedBarrage;

- (BOOL)fb_isSameGiftBarrageWith:(GYLiveBarrage *)barrage;

@end

NS_ASSUME_NONNULL_END
