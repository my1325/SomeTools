//
//  LJLiveBarrage.h
//  Woohoo
//
//  Created by M2-mini on 2021/8/24.
//

#import "LJLiveBaseObject.h"
#import "LJLiveEnum.h"
#import "LJLiveGift.h"
#import "LJLiveRoom.h"
#import "LJLivePrivate.h"

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveBarrage : LJLiveBaseObject

/// 0：hint；1：pkEnd
@property (nonatomic, assign) NSInteger systemMsgType;
/// 弹幕类型
@property (nonatomic, assign) LJLiveBarrageType type;
/// 用户类型
@property (nonatomic, assign) LJLiveUserType userType;
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
+ (LJLiveBarrage *)joinedMessage;

/// 提示
+ (LJLiveBarrage *)hintMessage;

/// 提示
+ (LJLiveBarrage *)pkEndMessage;

/// SayHi
+ (LJLiveBarrage *)sayHiMessage;

/// 礼物
/// @param giftConfig 礼物配置
/// @param combo combo
+ (LJLiveBarrage *)messageWithGift:(LJLiveGift *)giftConfig combo:(NSInteger)combo;

/// 房间信息
/// @param live 房间信息
+ (LJLiveBarrage *)messageWithLive:(LJLiveRoom *)live;

/// 观众信息
/// @param members 观众
+ (LJLiveBarrage *)messageWithMembers:(NSArray<LJLiveRoomMember *> *)members;

/// 私聊带走
/// @param giftConfig gift
/// @param room room
+ (LJLiveBarrage *)messageWithPrivateGift:(LJLiveGift *)giftConfig privateRoom:(LJLivePrivate *)room;

#pragma mark - Methods

/// 3s自动消失的消息
- (BOOL)lj_isSystemBarrage;

/// 需要显示的消息
- (BOOL)lj_isDisplayedBarrage;

- (BOOL)lj_isSameGiftBarrageWith:(LJLiveBarrage *)barrage;

@end

NS_ASSUME_NONNULL_END
