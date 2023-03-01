//
//  GYLiveBarrage.m
//  Woohoo
//
//  Created by M2-mini on 2021/8/24.
//

#import "GYLiveBarrage.h"

#pragma mark - GYLiveBarrage

@implementation GYLiveBarrage

+ (GYLiveBarrage *)joinedMessage
{
    GYLiveAccount *account = kGYLiveManager.inside.account;
    GYLiveAccountConfig *accountConfig = kGYLiveManager.inside.accountConfig;
    //
    GYLiveBarrage *barrage = [[GYLiveBarrage alloc] init];
    barrage.type = GYLiveBarrageTypeJoinLive;
    barrage.userId = account.accountId;
    barrage.userName = account.nickName;
    barrage.avatar = account.avatar;
    barrage.isVip = account.rechargeAmount > 0.1;
    barrage.isSvip = account.isSVip;
    barrage.isPrivilege = [account.privileges containsObject:@(GYLivePrivilegeInRoom)];
    barrage.content = @"Join the room";
    barrage.userType = GYLiveUserTypeUser;
    barrage.uniqueTagUrl = [accountConfig.defaultEventLabel fb_activityUrl];
    barrage.uniqueTagHeight = accountConfig.defaultEventLabel.imageHeight;
    barrage.uniqueTagWidth = accountConfig.defaultEventLabel.imageWidth;
    return barrage;
}

+ (GYLiveBarrage *)hintMessage
{
    GYLiveAccount *account = kGYLiveManager.inside.account;
    //
    GYLiveBarrage *barrage = [[GYLiveBarrage alloc] init];
    barrage.type = GYLiveBarrageTypeHint;
    barrage.userId = account.accountId;
    barrage.userName = account.nickName;
    barrage.avatar = account.avatar;
    barrage.isVip = account.rechargeAmount > 0.1;
    barrage.isSvip = account.isSVip;
    barrage.content = kGYLocalString(@"Please don't spread vulgar, pornographic, abuse content, or any content violating customs, rights or laws. Exposure of personal information is also prohibited. Violators will be muted or banned.");
    barrage.userType = GYLiveUserTypeUser;
    return barrage;
}

+ (GYLiveBarrage *)pkEndMessage
{
    GYLiveAccount *account = kGYLiveManager.inside.account;
//    GYLiveAccountConfig *accountConfig = kGYLiveManager.inside.accountConfig;
    //
    GYLiveBarrage *barrage = [[GYLiveBarrage alloc] init];
    barrage.type = GYLiveBarrageTypeHint;
    barrage.systemMsgType = 1;
    barrage.userId = account.accountId;
    barrage.userName = account.nickName;
    barrage.avatar = account.avatar;
    barrage.isVip = account.rechargeAmount > 0.1;
    barrage.isSvip = account.isSVip;
    barrage.content = kGYLocalString(@"This round of PK is over. Please wait for the next round.");
    barrage.userType = GYLiveUserTypeUser;
    return barrage;
}

+ (GYLiveBarrage *)sayHiMessage
{
    GYLiveAccount *account = kGYLiveManager.inside.account;
    GYLiveAccountConfig *accountConfig = kGYLiveManager.inside.accountConfig;
    //
    GYLiveBarrage *barrage = [[GYLiveBarrage alloc] init];
    barrage.type = GYLiveBarrageTypeTextMessage;
    barrage.userId = account.accountId;
    barrage.userName = account.nickName;
    barrage.avatar = account.avatar;
    barrage.isVip = account.rechargeAmount > 0.1;
    barrage.isSvip = account.isSVip;
    barrage.content = @"hi";
    barrage.userType = GYLiveUserTypeUser;
    barrage.uniqueTagUrl = [accountConfig.defaultEventLabel fb_activityUrl];
    barrage.uniqueTagHeight = accountConfig.defaultEventLabel.imageHeight;
    barrage.uniqueTagWidth = accountConfig.defaultEventLabel.imageWidth;
    return barrage;
}

+ (GYLiveBarrage *)messageWithGift:(GYLiveGift *)giftConfig combo:(NSInteger)combo
{
    GYLiveAccount *account = kGYLiveManager.inside.account;
    GYLiveAccountConfig *accountConfig = kGYLiveManager.inside.accountConfig;//模型转换
    //
    GYLiveBarrage *barrage = [[GYLiveBarrage alloc] init];
    barrage.type = GYLiveBarrageTypeGift;
    barrage.userId = account.accountId;
    barrage.userName = account.nickName;
    barrage.avatar = account.avatar;
    barrage.isVip = account.rechargeAmount > 0.1;
    barrage.isSvip = account.isSVip;
    barrage.uniqueTagUrl = [accountConfig.defaultEventLabel fb_activityUrl];
    barrage.uniqueTagHeight = accountConfig.defaultEventLabel.imageHeight;
    barrage.uniqueTagWidth = accountConfig.defaultEventLabel.imageWidth;
    // 协定
//    barrage.content = @"";
    barrage.content = [giftConfig mj_JSONString];
    barrage.giftId = giftConfig.giftId;
    barrage.combo = combo;
    barrage.userType = GYLiveUserTypeUser;
    return barrage;
}

+ (GYLiveBarrage *)messageWithPrivateGift:(GYLiveGift *)giftConfig
                               privateRoom:(GYLivePrivate *)room
{
    GYLiveAccount *account = kGYLiveManager.inside.account;
//    GYLiveAccountConfig *accountConfig = kGYLiveManager.inside.accountConfig;
    //
    GYLiveBarrage *barrage = [[GYLiveBarrage alloc] init];
    barrage.type = GYLiveBarrageTypeTakeAnchor;
    barrage.userId = account.accountId;
    barrage.userName = account.nickName;
    barrage.avatar = account.avatar;
    barrage.isVip = account.rechargeAmount > 0.1;
    barrage.isSvip = account.isSVip;
    //
    NSMutableDictionary *mdit = [room.dictionary mutableCopy];
    // 协定改为自己的支持状态（真心话大冒险遗弃）
    BOOL enable = NO;//kGYLiveManager.inside.accountConfig.truthOrDareConfig.isTruthOrDareOn;
    [mdit setValue:[NSNumber numberWithBool:enable] forKey:@"isTruthOrDareOn"];
    [mdit setValue:account.dictionary forKey:@"callUser"];
    barrage.content = [mdit mj_JSONString];
    barrage.giftId = giftConfig.giftId;
    barrage.combo = 1;
    barrage.userType = GYLiveUserTypeUser;
    return barrage;
}

+ (GYLiveBarrage *)messageWithLive:(GYLiveRoom *)live
{
    GYLiveAccount *account = kGYLiveManager.inside.account;
//    GYLiveAccountConfig *accountConfig = kGYLiveManager.inside.accountConfig;
    //
    GYLiveBarrage *barrage = [[GYLiveBarrage alloc] init];
    barrage.type = GYLiveBarrageTypeLiveRoomInfo;
    barrage.userId = account.accountId;
    barrage.userName = account.nickName;
    barrage.avatar = account.avatar;
    barrage.isVip = account.rechargeAmount > 0.1;
    barrage.isSvip = account.isSVip;
    // RTM限制32K长度，为了避免超长，剔除部分无用数据
    GYLiveRoom *room = [[GYLiveRoom alloc] initWithDictionary:live.mj_keyValues];
    room.dictionary = @{};
    room.gifts = @[];
    barrage.content = [room mj_JSONString];
    barrage.userType = GYLiveUserTypeUser;
    return barrage;
}

+ (GYLiveBarrage *)messageWithMembers:(NSArray<GYLiveRoomMember *> *)members
{
    GYLiveAccount *account = kGYLiveManager.inside.account;
//    GYLiveAccountConfig *accountConfig = kGYLiveManager.inside.accountConfig;
    //
    GYLiveBarrage *barrage = [[GYLiveBarrage alloc] init];
    barrage.type = GYLiveBarrageTypeMembersInfo;
    barrage.userId = account.accountId;
    barrage.userName = account.nickName;
    barrage.avatar = account.avatar;
    barrage.isVip = account.rechargeAmount > 0.1;
    barrage.isSvip = account.isSVip;
    // 协定
    barrage.content = [[GYLiveRoomMember mj_keyValuesArrayWithObjectArray:members] mj_JSONString];
    barrage.userType = GYLiveUserTypeUser;
    return barrage;
}

#pragma mark - Methods

/// 3s自动消失的消息
- (BOOL)fb_isSystemBarrage
{
    return self.type == GYLiveBarrageTypeJoinLive || self.type == GYLiveBarrageTypeBeMute;
}

/// 需要显示的消息
- (BOOL)fb_isDisplayedBarrage
{
    switch (self.type) {
        case GYLiveBarrageTypeHint:
        case GYLiveBarrageTypeJoinLive:
        case GYLiveBarrageTypeTextMessage:
        case GYLiveBarrageTypeGift:
        case GYLiveBarrageTypeBeMute:
//        case GYLiveBarrageTypeCancelMute:
            return YES;
            
        default:
            return NO;
    }
}

- (BOOL)fb_isSameGiftBarrageWith:(GYLiveBarrage *)barrage
{
    if (self.giftId == barrage.giftId && self.userId == barrage.userId) {
        return YES;
    }
    return NO;
}

- (NSString *)content{
    NSString *result = [(NSString *)_content stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    return [result stringByRemovingPercentEncoding];
}


@end


