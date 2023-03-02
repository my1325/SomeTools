//
//  LJLiveBarrage.m
//  Woohoo
//
//  Created by M2-mini on 2021/8/24.
//

#import "LJLiveBarrage.h"

#pragma mark - LJLiveBarrage

@implementation LJLiveBarrage

+ (LJLiveBarrage *)joinedMessage
{
    LJLiveAccount *account = kLJLiveManager.inside.account;
    LJLiveAccountConfig *accountConfig = kLJLiveManager.inside.accountConfig;
    LJLiveBarrage *barrage = [[LJLiveBarrage alloc] init];
    barrage.type = LJLiveBarrageTypeJoinLive;
    barrage.userId = account.accountId;
    barrage.userName = account.nickName;
    barrage.avatar = account.avatar;
    barrage.isVip = account.rechargeAmount > 0.1;
    barrage.isSvip = account.isSVip;
    barrage.isPrivilege = [account.privileges containsObject:@(LJLivePrivilegeInRoom)];
    barrage.content = @"Join the room";
    barrage.userType = LJLiveUserTypeUser;
    barrage.uniqueTagUrl = [accountConfig.defaultEventLabel lj_activityUrl];
    barrage.uniqueTagHeight = accountConfig.defaultEventLabel.imageHeight;
    barrage.uniqueTagWidth = accountConfig.defaultEventLabel.imageWidth;
    return barrage;
}

+ (LJLiveBarrage *)hintMessage
{
    LJLiveAccount *account = kLJLiveManager.inside.account;
    LJLiveBarrage *barrage = [[LJLiveBarrage alloc] init];
    barrage.type = LJLiveBarrageTypeHint;
    barrage.userId = account.accountId;
    barrage.userName = account.nickName;
    barrage.avatar = account.avatar;
    barrage.isVip = account.rechargeAmount > 0.1;
    barrage.isSvip = account.isSVip;
    barrage.content = kLJLocalString(@"Please don't spread vulgar, pornographic, abuse content, or any content violating customs, rights or laws. Exposure of personal information is also prohibited. Violators will be muted or banned.");
    barrage.userType = LJLiveUserTypeUser;
    return barrage;
}

+ (LJLiveBarrage *)pkEndMessage
{
    LJLiveAccount *account = kLJLiveManager.inside.account;
    LJLiveBarrage *barrage = [[LJLiveBarrage alloc] init];
    barrage.type = LJLiveBarrageTypeHint;
    barrage.systemMsgType = 1;
    barrage.userId = account.accountId;
    barrage.userName = account.nickName;
    barrage.avatar = account.avatar;
    barrage.isVip = account.rechargeAmount > 0.1;
    barrage.isSvip = account.isSVip;
    barrage.content = kLJLocalString(@"This round of PK is over. Please wait for the next round.");
    barrage.userType = LJLiveUserTypeUser;
    return barrage;
}

+ (LJLiveBarrage *)sayHiMessage
{
    LJLiveAccount *account = kLJLiveManager.inside.account;
    LJLiveAccountConfig *accountConfig = kLJLiveManager.inside.accountConfig;
    LJLiveBarrage *barrage = [[LJLiveBarrage alloc] init];
    barrage.type = LJLiveBarrageTypeTextMessage;
    barrage.userId = account.accountId;
    barrage.userName = account.nickName;
    barrage.avatar = account.avatar;
    barrage.isVip = account.rechargeAmount > 0.1;
    barrage.isSvip = account.isSVip;
    barrage.content = @"hi";
    barrage.userType = LJLiveUserTypeUser;
    barrage.uniqueTagUrl = [accountConfig.defaultEventLabel lj_activityUrl];
    barrage.uniqueTagHeight = accountConfig.defaultEventLabel.imageHeight;
    barrage.uniqueTagWidth = accountConfig.defaultEventLabel.imageWidth;
    return barrage;
}

+ (LJLiveBarrage *)messageWithGift:(LJLiveGift *)giftConfig combo:(NSInteger)combo
{
    LJLiveAccount *account = kLJLiveManager.inside.account;
    LJLiveAccountConfig *accountConfig = kLJLiveManager.inside.accountConfig;//模型转换
    LJLiveBarrage *barrage = [[LJLiveBarrage alloc] init];
    barrage.type = LJLiveBarrageTypeGift;
    barrage.userId = account.accountId;
    barrage.userName = account.nickName;
    barrage.avatar = account.avatar;
    barrage.isVip = account.rechargeAmount > 0.1;
    barrage.isSvip = account.isSVip;
    barrage.uniqueTagUrl = [accountConfig.defaultEventLabel lj_activityUrl];
    barrage.uniqueTagHeight = accountConfig.defaultEventLabel.imageHeight;
    barrage.uniqueTagWidth = accountConfig.defaultEventLabel.imageWidth;
    barrage.content = [giftConfig mj_JSONString];
    barrage.giftId = giftConfig.giftId;
    barrage.combo = combo;
    barrage.userType = LJLiveUserTypeUser;
    return barrage;
}

+ (LJLiveBarrage *)messageWithPrivateGift:(LJLiveGift *)giftConfig
                               privateRoom:(LJLivePrivate *)room
{
    LJLiveAccount *account = kLJLiveManager.inside.account;
    LJLiveBarrage *barrage = [[LJLiveBarrage alloc] init];
    barrage.type = LJLiveBarrageTypeTakeAnchor;
    barrage.userId = account.accountId;
    barrage.userName = account.nickName;
    barrage.avatar = account.avatar;
    barrage.isVip = account.rechargeAmount > 0.1;
    barrage.isSvip = account.isSVip;
    NSMutableDictionary *mdit = [room.dictionary mutableCopy];
    BOOL enable = NO;//kLJLiveManager.inside.accountConfig.truthOrDareConfig.isTruthOrDareOn;
    [mdit setValue:[NSNumber numberWithBool:enable] forKey:@"isTruthOrDareOn"];
    [mdit setValue:account.dictionary forKey:@"callUser"];
    barrage.content = [mdit mj_JSONString];
    barrage.giftId = giftConfig.giftId;
    barrage.combo = 1;
    barrage.userType = LJLiveUserTypeUser;
    return barrage;
}

+ (LJLiveBarrage *)messageWithLive:(LJLiveRoom *)live
{
    LJLiveAccount *account = kLJLiveManager.inside.account;
    LJLiveBarrage *barrage = [[LJLiveBarrage alloc] init];
    barrage.type = LJLiveBarrageTypeLiveRoomInfo;
    barrage.userId = account.accountId;
    barrage.userName = account.nickName;
    barrage.avatar = account.avatar;
    barrage.isVip = account.rechargeAmount > 0.1;
    barrage.isSvip = account.isSVip;
    LJLiveRoom *room = [[LJLiveRoom alloc] initWithDictionary:live.mj_keyValues];
    room.dictionary = @{};
    room.gifts = @[];
    barrage.content = [room mj_JSONString];
    barrage.userType = LJLiveUserTypeUser;
    return barrage;
}

+ (LJLiveBarrage *)messageWithMembers:(NSArray<LJLiveRoomMember *> *)members
{
    LJLiveAccount *account = kLJLiveManager.inside.account;
    LJLiveBarrage *barrage = [[LJLiveBarrage alloc] init];
    barrage.type = LJLiveBarrageTypeMembersInfo;
    barrage.userId = account.accountId;
    barrage.userName = account.nickName;
    barrage.avatar = account.avatar;
    barrage.isVip = account.rechargeAmount > 0.1;
    barrage.isSvip = account.isSVip;
    barrage.content = [[LJLiveRoomMember mj_keyValuesArrayWithObjectArray:members] mj_JSONString];
    barrage.userType = LJLiveUserTypeUser;
    return barrage;
}

#pragma mark - Methods






    //
    // 协定改为自己的支持状态（真心话大冒险遗弃）
    // 协定
//    LJLiveAccountConfig *accountConfig = kLJLiveManager.inside.accountConfig;
    //
    // RTM限制32K长度，为了避免超长，剔除部分无用数据
    //
    //
/// 需要显示的消息
    //
//    LJLiveAccountConfig *accountConfig = kLJLiveManager.inside.accountConfig;
    //
    // 协定
//    LJLiveAccountConfig *accountConfig = kLJLiveManager.inside.accountConfig;
//    barrage.content = @"";
//    LJLiveAccountConfig *accountConfig = kLJLiveManager.inside.accountConfig;
    //
/// 3s自动消失的消息
    //
    //
- (NSString *)content{
    NSString *result = [(NSString *)_content stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    return [result stringByRemovingPercentEncoding];
}
- (BOOL)lj_isSystemBarrage
{
    return self.type == LJLiveBarrageTypeJoinLive || self.type == LJLiveBarrageTypeBeMute;
}
- (BOOL)lj_isSameGiftBarrageWith:(LJLiveBarrage *)barrage
{
    if (self.giftId == barrage.giftId && self.userId == barrage.userId) {
        return YES;
    }
    return NO;
}
- (BOOL)lj_isDisplayedBarrage
{
    switch (self.type) {
        case LJLiveBarrageTypeHint:
        case LJLiveBarrageTypeJoinLive:
        case LJLiveBarrageTypeTextMessage:
        case LJLiveBarrageTypeGift:
        case LJLiveBarrageTypeBeMute:
//        case LJLiveBarrageTypeCancelMute:
            return YES;
            
        default:
            return NO;
    }
}
@end


