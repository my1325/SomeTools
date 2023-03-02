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










#pragma mark - Methods




/// 用户ID（AccountId）
/// 用户类型
/// 3s自动消失的消息
/// @param members 观众
/// 提示
/// 标签宽高
/// 头像
/// 礼物
/// 房间信息
/// 礼物ID和combo数
/// 需要显示的消息
/// 昵称
/// 内容（jsonString）
/// 特权
/// 提示
/// @param room room
/// @param giftConfig 礼物配置
/// 弹幕类型
/// 私聊带走
/// SayHi
/// 是否SVIP
/// @param combo combo
/// 0：hint；1：pkEnd
/// 加入
/// 弹幕标签地址
/// @param live 房间信息
/// 是否VIP
/// 观众信息
/// @param giftConfig gift
+ (LJLiveBarrage *)sayHiMessage;
+ (LJLiveBarrage *)joinedMessage;
- (BOOL)lj_isSameGiftBarrageWith:(LJLiveBarrage *)barrage;
+ (LJLiveBarrage *)pkEndMessage;
+ (LJLiveBarrage *)messageWithGift:(LJLiveGift *)giftConfig combo:(NSInteger)combo;
+ (LJLiveBarrage *)hintMessage;
+ (LJLiveBarrage *)messageWithPrivateGift:(LJLiveGift *)giftConfig privateRoom:(LJLivePrivate *)room;
+ (LJLiveBarrage *)messageWithMembers:(NSArray<LJLiveRoomMember *> *)members;
+ (LJLiveBarrage *)messageWithLive:(LJLiveRoom *)live;
- (BOOL)lj_isDisplayedBarrage;
- (BOOL)lj_isSystemBarrage;
@property (nonatomic, assign) BOOL isPrivilege;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) BOOL isVip;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, assign) LJLiveUserType userType;
@property (nonatomic, assign) NSInteger uniqueTagHeight, uniqueTagWidth;
@property (nonatomic, assign) NSInteger systemMsgType;
@property (nonatomic, assign) NSInteger giftId, combo, isblindBox;
@property (nonatomic, strong) NSString *uniqueTagUrl;
@property (nonatomic, assign) BOOL isSvip;
@property (nonatomic, assign) LJLiveBarrageType type;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString *avatar;
@end

NS_ASSUME_NONNULL_END
