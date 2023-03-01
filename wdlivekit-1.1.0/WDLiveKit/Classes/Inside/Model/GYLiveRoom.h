//
//  GYLiveRoom.h
//  Woohoo
//
//  Created by M2-mini on 2021/9/4.
//

#import "GYLiveBaseObject.h"
#import "GYLiveRoomGoal.h"

@class GYLiveRoomMember, GYLiveRoomAnchor, GYLiveRoomUser, GYLivePkData, GYLivePkPlayer, GYLivePkPlayerPoint, GYLivePkWinner, GYLivePkPointUpdatedMsg, GYLivePkTopFan, GYLiveGiftConfig, GYLiveGift, GYLiveBarrage;

NS_ASSUME_NONNULL_BEGIN

@interface GYLiveRoom : GYLiveBaseObject

@property (nonatomic, assign) NSInteger roomId;
@property (nonatomic, strong) NSString *roomTitle;
@property (nonatomic, strong) NSString *roomCover;
/// 房间类型（1：HOT 2：NEW 3:普通)
@property (nonatomic, assign) NSInteger roomType;
@property (nonatomic, strong) NSString *agoraRoomId;
@property (nonatomic, assign) NSInteger hostAccountId;
@property (nonatomic, strong) NSString *hostDisplayAccountId;
@property (nonatomic, strong) NSString *hostName;
@property (nonatomic, strong) NSString *hostAvatar;
/// 主持人麦克风状态（1：正常 2：关麦）
@property (nonatomic, assign) NSInteger hostStatus;
@property (nonatomic, strong) NSString *hostMood;
/// 主持人开始的粉丝数
@property (nonatomic, assign) NSInteger hostFollowersBeg;
/// 主持人结束的粉丝数
@property (nonatomic, assign) NSInteger hostFollowersEnd;
/// 主持人收到的礼物数
@property (nonatomic, assign) NSInteger hostReceivedGifts;
/// 主播金币收入
@property (nonatomic, assign) NSInteger hostIncome;
/// 当前人数
@property (nonatomic, assign) NSInteger memberCount;
/// 最大人数
@property (nonatomic, assign) NSInteger maxMemberCount;
/// 私聊次数
@property (nonatomic, assign) NSInteger privateChatCount;
/// 是否开启（1：开启 2：关闭）
@property (nonatomic, assign) NSInteger privateChatFlag;
/// 私聊礼物Id
@property (nonatomic, assign) NSInteger privateChatGiftId;
/// 是否已关注主持人
@property (nonatomic, assign) BOOL isHostFollowed;
/// 直播已开始秒数
@property (nonatomic, assign) NSInteger liveDuration;
/// 房间状态（1：未开播 2：直播中 3：主持人私聊挂起 4：结束 5：PK匹配中 6：PK中 7：PK下一场等待中 8：惩罚中）
@property (nonatomic, assign) NSInteger roomStatus;
/// 成员列表（members仅UGC用）
@property (nonatomic, strong) NSArray<GYLiveRoomMember *> *videoChatRoomMembers, *members;
/// pk邀请开关（1：开启 2：关闭）
@property (nonatomic, assign) NSInteger pkInvitationFlag;
/// pk数据
@property (nonatomic, strong) GYLivePkData * __nullable pkData;

@property (nonatomic, strong) GYLiveRoomGoal *roomGoal;

@property (nonatomic, strong) NSArray<GYLiveGiftConfig *> *gifts;
/// 私聊每分钟收费金币数
@property (nonatomic, assign) NSInteger hostCallPrice;
/// 转盘内容数组
@property (nonatomic, strong) NSArray *turntableItems;
/// 转盘title
@property (nonatomic, strong) NSString *turntableTitle;
/// 转盘开关 (1.开启  2.关闭)
@property (nonatomic, assign) NSInteger turntableFlag;
/// UGC直播
@property (nonatomic, assign) BOOL isUgc;
/// 快捷礼物
@property (nonatomic, strong) GYLiveGift *lovelyGift;
///
@property (nonatomic, strong) NSArray<GYLiveBarrage *> *latestBarrages;

#pragma mark - 自定义参数
/// 直播中
@property (nonatomic, assign) BOOL beActive;
/// PK中
@property (nonatomic, assign) BOOL pking;

@end

@interface GYLiveRoomMember : GYLiveBaseObject

@property (nonatomic, assign) NSInteger accountId;
@property (nonatomic, strong) NSString *displayAccountId;
@property (nonatomic, assign) GYLiveRoleType roleType;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, assign) NSInteger giftCost;
@property (nonatomic, assign) NSInteger commentUp;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) BOOL isFollowed;

/// 自定义参数（PK专用），所在房间
@property (nonatomic, assign) NSInteger pkRoomId;

@end

@interface GYLiveRoomAnchor : GYLiveBaseObject

@property (nonatomic, assign) NSInteger accountId;
@property (nonatomic, strong) NSString *displayAccountId;
@property (nonatomic, strong) NSString *anchorName;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *mood;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSInteger commentUp;
@property (nonatomic, assign) NSInteger commentDown;
@property (nonatomic, assign) NSInteger anchorFlag;
@property (nonatomic, assign) NSInteger followerings;
@property (nonatomic, assign) NSInteger followers;
@property (nonatomic, strong) NSArray *eventLables;
@property (nonatomic, assign) BOOL isFollowed;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, assign) int blacklistStatus;
/// 自定义参数（PK专用），所在房间
@property (nonatomic, assign) NSInteger pkRoomId;

@end

@interface GYLiveRoomUser : GYLiveBaseObject

@property (nonatomic, assign) NSInteger accountId;
@property (nonatomic, strong) NSString *displayAccountId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *mood;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSInteger followers;
@property (nonatomic, assign) NSInteger followings;
@property (nonatomic, assign) NSInteger giftCost;
@property (nonatomic, assign) BOOL isFollowed;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSArray *eventLables;
@end

@interface GYLiveRoomDiamond : GYLiveBaseObject

@property (nonatomic, assign) NSInteger giftId;

@property (nonatomic, assign) NSInteger leftDiamond;

@end

@interface GYLivePerfectMatchMsg : GYLiveBaseObject

/// 用户AccountId
@property (nonatomic, assign) NSInteger userId;
/// 用户名
@property (nonatomic, strong) NSString *userName;
/// 用户头像
@property (nonatomic, strong) NSString *userAvatar;
/// 主播AccountId
@property (nonatomic, assign) NSInteger anchorId;
/// 主播名
@property (nonatomic, strong) NSString *anchorName;
/// 主播头像
@property (nonatomic, strong) NSString *anchorAvatar;
/// 房间号
@property (nonatomic, assign) NSInteger roomId;

@end

@interface GYLivePrivateChatFlagMsg : GYLiveBaseObject

/// 房间号
@property (nonatomic, assign) NSInteger roomId;
/// 是否开启（1：开启 2：关闭）
@property (nonatomic, assign) NSInteger privateChatFlag;

@end

@interface GYLiveDestroyMsg : GYLiveBaseObject

/// 被销毁的房间
@property (nonatomic, strong) GYLiveRoom *destroyedRoom;
/// 新的野房间
@property (nonatomic, strong) GYLiveRoom *roomNew;

@end

@interface GYLivePkData : GYLiveBaseObject

/// PK开始时间（从UTC时区 2017-01-01 00:00:00 开始到现在的秒数）
@property (nonatomic, assign) NSInteger pkTime;
/// PK最大持续时长（秒）
@property (nonatomic, assign) NSInteger pkMaxDuration;
/// PK剩余时间（秒）
@property (nonatomic, assign) NSInteger pkLeftTime;
/// 赢家数据
@property (nonatomic, strong) GYLivePkWinner *winner;
/// 主队玩家数据
@property (nonatomic, strong) GYLivePkPlayer *homePlayer;
/// 客队玩家数据
@property (nonatomic, strong) GYLivePkPlayer *awayPlayer;
/// 主队得分数据
@property (nonatomic, strong) GYLivePkPlayerPoint *homePoint;
/// 客队得分数据
@property (nonatomic, strong) GYLivePkPlayerPoint *awayPoint;

@end

@interface GYLivePkPlayer : GYLiveBaseObject

/// 直播房间Id
@property (nonatomic, assign) NSInteger roomId;
/// 声网房间号
@property (nonatomic, strong) NSString *agoraRoomId;
@property (nonatomic, assign) NSInteger hostAccountId;
@property (nonatomic, strong) NSString *hostName;
@property (nonatomic, strong) NSString *hostAvatar;
@property (nonatomic, strong) NSString *roomCover;
/// 房间状态（1：未开播 2：直播中 3：主持人私聊挂起 4：结束 5：PK匹配中 6：PK中 7：PK下一场等待中 8：惩罚中）
@property (nonatomic, assign) NSInteger roomStatus;
/// 上一次的私聊开关（1：开启 2：关闭）
@property (nonatomic, assign) NSInteger lastPrivateChatFlag;
/// 连胜次数
@property (nonatomic, assign) NSInteger wins;
/// 关注状态
@property (nonatomic, assign) BOOL isHostFollowed;

@end

@interface GYLivePkPlayerPoint : GYLiveBaseObject

/// 主持人Id
@property (nonatomic, assign) NSInteger hostAccountId;
/// 积分
@property (nonatomic, assign) NSInteger points;
/// 前三守护用户头像
@property (nonatomic, strong) NSArray *topFanAvatars;

@end

@interface GYLivePkWinner : GYLiveBaseObject

/// 主持人Id
@property (nonatomic, assign) NSInteger hostAccountId;
/// 连胜次数
@property (nonatomic, assign) NSInteger wins;

@end

@interface GYLivePkPointUpdatedMsg : GYLiveBaseObject

/// 主队得分数据
@property (nonatomic, strong) GYLivePkPlayerPoint *homePoint;
/// 客队得分数据
@property (nonatomic, strong) GYLivePkPlayerPoint *awayPoint;

@end

@interface GYLivePkTopFan : GYLiveBaseObject

/// 账号
@property (nonatomic, assign) NSInteger accountId;
/// 头像
@property (nonatomic, strong) NSString *avatar;
/// 昵称
@property (nonatomic, strong) NSString *userName;
/// vip
@property (nonatomic, assign) BOOL isVip;
/// svip
@property (nonatomic, assign) BOOL isSVip;
/// 分数
@property (nonatomic, assign) NSInteger points;

@end


@interface GYLiveGiftConfig : GYLiveBaseObject

/// 标题
@property (nonatomic, strong) NSString *title;
/// 标签
@property (nonatomic, strong) NSString *tagIconUrl;
/// 礼物
@property (nonatomic, strong) NSArray<GYLiveGift *> *gifts;
/// 1：一次性展示，2：永久展示
@property (nonatomic, assign) NSInteger tagIconType;
/// 此类礼物可设置私聊带走
@property (nonatomic, assign) BOOL canSetPrivate;

@end


NS_ASSUME_NONNULL_END
