//
//  LJLiveRoom.h
//  Woohoo
//
//  Created by M2-mini on 2021/9/4.
//

#import "LJLiveBaseObject.h"
#import "LJLiveRoomGoal.h"

@class LJLiveRoomMember, LJLiveRoomAnchor, LJLiveRoomUser, LJLivePkData, LJLivePkPlayer, LJLivePkPlayerPoint, LJLivePkWinner, LJLivePkPointUpdatedMsg, LJLivePkTopFan, LJLiveGiftConfig, LJLiveGift, LJLiveBarrage;

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveRoom : LJLiveBaseObject




#pragma mark - 自定义参数

/// 当前人数
/// 是否已关注主持人
/// PK中
/// 私聊次数
/// 主持人开始的粉丝数
/// 快捷礼物
/// pk邀请开关（1：开启 2：关闭）
/// 主持人收到的礼物数
/// 直播中
/// 最大人数
/// 是否开启（1：开启 2：关闭）
/// UGC直播
/// 私聊每分钟收费金币数
/// 转盘内容数组
/// 房间类型（1：HOT 2：NEW 3:普通)
/// 主播金币收入
/// 私聊礼物Id
/// 直播已开始秒数
/// 房间状态（1：未开播 2：直播中 3：主持人私聊挂起 4：结束 5：PK匹配中 6：PK中 7：PK下一场等待中 8：惩罚中）
///
/// 主持人麦克风状态（1：正常 2：关麦）
/// 主持人结束的粉丝数
/// 成员列表（members仅UGC用）
/// pk数据
/// 转盘开关 (1.开启  2.关闭)
/// 转盘title
@property (nonatomic, assign) BOOL pking;
@property (nonatomic, strong) LJLiveRoomGoal *roomGoal;
@property (nonatomic, strong) NSString *turntableTitle;
@property (nonatomic, assign) NSInteger maxMemberCount;
@property (nonatomic, strong) NSArray<LJLiveGiftConfig *> *gifts;
@property (nonatomic, assign) NSInteger memberCount;
@property (nonatomic, strong) LJLiveGift *lovelyGift;
@property (nonatomic, assign) NSInteger hostFollowersEnd;
@property (nonatomic, assign) NSInteger hostCallPrice;
@property (nonatomic, assign) NSInteger hostReceivedGifts;
@property (nonatomic, assign) NSInteger hostIncome;
@property (nonatomic, assign) BOOL isUgc;
@property (nonatomic, strong) NSArray<LJLiveRoomMember *> *videoChatRoomMembers, *members;
@property (nonatomic, strong) LJLivePkData * __nullable pkData;
@property (nonatomic, assign) NSInteger privateChatCount;
@property (nonatomic, strong) NSString *hostDisplayAccountId;
@property (nonatomic, assign) NSInteger privateChatFlag;
@property (nonatomic, assign) BOOL isHostFollowed;
@property (nonatomic, strong) NSString *hostAvatar;
@property (nonatomic, assign) NSInteger roomStatus;
@property (nonatomic, assign) NSInteger hostFollowersBeg;
@property (nonatomic, strong) NSArray<LJLiveBarrage *> *latestBarrages;
@property (nonatomic, strong) NSString *hostMood;
@property (nonatomic, assign) NSInteger roomId;
@property (nonatomic, assign) NSInteger hostStatus;
@property (nonatomic, strong) NSString *roomTitle;
@property (nonatomic, assign) NSInteger privateChatGiftId;
@property (nonatomic, strong) NSString *agoraRoomId;
@property (nonatomic, assign) NSInteger roomType;
@property (nonatomic, assign) BOOL beActive;
@property (nonatomic, strong) NSString *roomCover;
@property (nonatomic, assign) NSInteger liveDuration;
@property (nonatomic, assign) NSInteger hostAccountId;
@property (nonatomic, strong) NSString *hostName;
@property (nonatomic, assign) NSInteger pkInvitationFlag;
@property (nonatomic, assign) NSInteger turntableFlag;
@property (nonatomic, strong) NSArray *turntableItems;
@end

@interface LJLiveRoomMember : LJLiveBaseObject



/// 自定义参数（PK专用），所在房间
@property (nonatomic, assign) NSInteger pkRoomId;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, assign) NSInteger commentUp;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, assign) LJLiveRoleType roleType;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, assign) NSInteger giftCost;
@property (nonatomic, assign) BOOL isFollowed;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSInteger accountId;
@property (nonatomic, strong) NSString *displayAccountId;
@end

@interface LJLiveRoomAnchor : LJLiveBaseObject


/// 自定义参数（PK专用），所在房间
@property (nonatomic, strong) NSString *anchorName;
@property (nonatomic, assign) NSInteger commentUp;
@property (nonatomic, strong) NSString *mood;
@property (nonatomic, strong) NSString *displayAccountId;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, assign) NSInteger accountId;
@property (nonatomic, assign) NSInteger followers;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, assign) NSInteger pkRoomId;
@property (nonatomic, assign) int blacklistStatus;
@property (nonatomic, assign) NSInteger anchorFlag;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) BOOL isFollowed;
@property (nonatomic, assign) NSInteger followerings;
@property (nonatomic, strong) NSArray *eventLables;
@property (nonatomic, assign) NSInteger commentDown;
@end

@interface LJLiveRoomUser : LJLiveBaseObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSArray *eventLables;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, assign) NSInteger followers;
@property (nonatomic, assign) NSInteger accountId;
@property (nonatomic, assign) BOOL isFollowed;
@property (nonatomic, assign) NSInteger giftCost;
@property (nonatomic, assign) NSInteger followings;
@property (nonatomic, strong) NSString *mood;
@property (nonatomic, strong) NSString *displayAccountId;
@end

@interface LJLiveRoomDiamond : LJLiveBaseObject



@property (nonatomic, assign) NSInteger giftId;
@property (nonatomic, assign) NSInteger leftDiamond;
@end

@interface LJLivePerfectMatchMsg : LJLiveBaseObject


/// 主播名
/// 用户名
/// 用户头像
/// 用户AccountId
/// 主播头像
/// 主播AccountId
/// 房间号
@property (nonatomic, strong) NSString *anchorAvatar;
@property (nonatomic, strong) NSString *userAvatar;
@property (nonatomic, assign) NSInteger anchorId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, assign) NSInteger roomId;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString *anchorName;
@end

@interface LJLivePrivateChatFlagMsg : LJLiveBaseObject


/// 房间号
/// 是否开启（1：开启 2：关闭）
@property (nonatomic, assign) NSInteger privateChatFlag;
@property (nonatomic, assign) NSInteger roomId;
@end

@interface LJLiveDestroyMsg : LJLiveBaseObject


/// 被销毁的房间
/// 新的野房间
@property (nonatomic, strong) LJLiveRoom *destroyedRoom;
@property (nonatomic, strong) LJLiveRoom *roomNew;
@end

@interface LJLivePkData : LJLiveBaseObject


/// PK剩余时间（秒）
/// 客队玩家数据
/// 赢家数据
/// 客队得分数据
/// 主队得分数据
/// 主队玩家数据
/// PK最大持续时长（秒）
/// PK开始时间（从UTC时区 2017-01-01 00:00:00 开始到现在的秒数）
@property (nonatomic, strong) LJLivePkWinner *winner;
@property (nonatomic, strong) LJLivePkPlayer *homePlayer;
@property (nonatomic, assign) NSInteger pkLeftTime;
@property (nonatomic, assign) NSInteger pkMaxDuration;
@property (nonatomic, strong) LJLivePkPlayer *awayPlayer;
@property (nonatomic, strong) LJLivePkPlayerPoint *homePoint;
@property (nonatomic, strong) LJLivePkPlayerPoint *awayPoint;
@property (nonatomic, assign) NSInteger pkTime;
@end

@interface LJLivePkPlayer : LJLiveBaseObject


/// 上一次的私聊开关（1：开启 2：关闭）
/// 直播房间Id
/// 关注状态
/// 声网房间号
/// 连胜次数
/// 房间状态（1：未开播 2：直播中 3：主持人私聊挂起 4：结束 5：PK匹配中 6：PK中 7：PK下一场等待中 8：惩罚中）
@property (nonatomic, strong) NSString *hostAvatar;
@property (nonatomic, strong) NSString *roomCover;
@property (nonatomic, strong) NSString *agoraRoomId;
@property (nonatomic, assign) NSInteger roomId;
@property (nonatomic, assign) NSInteger lastPrivateChatFlag;
@property (nonatomic, assign) NSInteger wins;
@property (nonatomic, assign) BOOL isHostFollowed;
@property (nonatomic, assign) NSInteger roomStatus;
@property (nonatomic, assign) NSInteger hostAccountId;
@property (nonatomic, strong) NSString *hostName;
@end

@interface LJLivePkPlayerPoint : LJLiveBaseObject


/// 主持人Id
/// 前三守护用户头像
/// 积分
@property (nonatomic, strong) NSArray *topFanAvatars;
@property (nonatomic, assign) NSInteger points;
@property (nonatomic, assign) NSInteger hostAccountId;
@end

@interface LJLivePkWinner : LJLiveBaseObject


/// 连胜次数
/// 主持人Id
@property (nonatomic, assign) NSInteger hostAccountId;
@property (nonatomic, assign) NSInteger wins;
@end

@interface LJLivePkPointUpdatedMsg : LJLiveBaseObject


/// 客队得分数据
/// 主队得分数据
@property (nonatomic, strong) LJLivePkPlayerPoint *awayPoint;
@property (nonatomic, strong) LJLivePkPlayerPoint *homePoint;
@end

@interface LJLivePkTopFan : LJLiveBaseObject


/// svip
/// 昵称
/// 头像
/// 分数
/// vip
/// 账号
@property (nonatomic, assign) BOOL isSVip;
@property (nonatomic, assign) NSInteger accountId;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, assign) BOOL isVip;
@property (nonatomic, assign) NSInteger points;
@end


@interface LJLiveGiftConfig : LJLiveBaseObject


/// 1：一次性展示，2：永久展示
/// 标题
/// 礼物
/// 标签
/// 此类礼物可设置私聊带走
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL canSetPrivate;
@property (nonatomic, assign) NSInteger tagIconType;
@property (nonatomic, strong) NSString *tagIconUrl;
@property (nonatomic, strong) NSArray<LJLiveGift *> *gifts;
@end


NS_ASSUME_NONNULL_END
