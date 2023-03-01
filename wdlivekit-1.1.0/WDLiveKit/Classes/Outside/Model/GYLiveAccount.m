//
//  GYLiveAccount.m
//  Woohoo
//
//  Created by M1-mini on 2022/4/24.
//  Copyright © 2022 tt. All rights reserved.
//

#import "GYLiveAccount.h"

@implementation GYLiveAccount

- (BOOL)isGreen
{
    return (self.abTestFlag & 1073741824) != 0;
}

@end


@implementation GYSvipInfo

@end


@implementation GYLiveAccountConfig

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
//        @"giftConfigs": [GYLiveGift class],
//        @"iapConfigs":  [GYIapConfig class],
//        @"ppConfigs":   [GYIapConfig class],
//        @"ccConfigs":   [GYIapConfig class],
//        @"voiceChatRoomGiftConfigs": [GYLiveGift class],
        @"bannerInfoList": [GYBannerInfo class],
        @"voiceChatRoomBannerInfoList":[GYBannerInfo class],
        @"payConfigs": [GYPayConfig class],
//        @"videoChatRoomConfig": [GYLiveConfig class]
    };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
//        @"iapConfigs": @"iapConfigs.iapConfig",
//        @"ppConfigs": @"ppConfigs.ppConfig",
//        @"ccConfigs": @"ccConfigs.ccConfig",
//        @"giftConfigs": @"giftConfigs.giftConfig",
//        @"drawTypeList" : @"drawTypeList.drawT",
        @"rechargeTList": @"rechargeTList.rechargeT",
        @"bannerInfoList": @"bannerInfoList.bannerInfo",
        @"voiceChatRoomBannerInfoList":@"voiceChatRoomBannerInfoList.bannerInfo",
//        @"voiceChatRoomGiftConfigs": @"voiceChatRoomGiftConfigs.giftConfig",
        @"liveConfig": @"videoChatRoomConfig"
    };
}

@end


@implementation GYBannerInfo

@end


@implementation GYLiveConfig

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"giftConfigs": [GYLiveGift class],
        @"videoChatRoomReplacedGiftConfigs":[GYLiveGift class]
    };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"giftConfigs": @"videoChatRoomGiftConfigs.giftConfig",
        @"videoChatRoomReplacedGiftConfigs":@"videoChatRoomReplacedGiftConfigs.giftConfig"
    };
}

@end



@implementation GYUniqueTag

- (NSString *)fb_activityUrl
{
    if (self.imageUrl.length > 0 && self.timeInterval > 0) return self.imageUrl;
    return @"";
}

- (NSInteger)timeInterval
{
    return self.expirationTime - ([[NSDate date] timeIntervalSince1970] - [self fb_timeStampFrom2017ToNow]);
}

- (NSInteger)fb_timeStampFrom2017ToNow
{
    return 1483228800;
    
    NSString *str = @"2017-01-01 00:00:00 +0000";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
    NSDate *date20170101 = [formatter dateFromString:str];
    NSTimeInterval newDate = [date20170101 timeIntervalSince1970];
    NSInteger second = [[NSNumber numberWithDouble:newDate] integerValue];
    return second;
}

@end

@implementation GYPayConfig

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"products": [GYIapConfig class]
    };
}

@end

@implementation GYIapConfig

@end
