//
//  LJLiveAccount.m
//  Woohoo
//
//  Created by M1-mini on 2022/4/24.
//  Copyright © 2022 tt. All rights reserved.
//

#import "LJLiveAccount.h"

@implementation LJLiveAccount

- (BOOL)isGreen
{
    return (self.abTestFlag & 1073741824) != 0;
}

@end


@implementation LJSvipInfo

@end


@implementation LJLiveAccountConfig

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
//        @"giftConfigs": [LJLiveGift class],
//        @"iapConfigs":  [LJIapConfig class],
//        @"ppConfigs":   [LJIapConfig class],
//        @"ccConfigs":   [LJIapConfig class],
//        @"voiceChatRoomGiftConfigs": [LJLiveGift class],
        @"bannerInfoList": [LJBannerInfo class],
        @"voiceChatRoomBannerInfoList":[LJBannerInfo class],
        @"payConfigs": [LJPayConfig class],
//        @"videoChatRoomConfig": [LJLiveConfig class]
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


@implementation LJBannerInfo

@end


@implementation LJLiveConfig

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"giftConfigs": [LJLiveGift class],
        @"videoChatRoomReplacedGiftConfigs":[LJLiveGift class]
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



@implementation LJUniqueTag

- (NSString *)lj_activityUrl
{
    if (self.imageUrl.length > 0 && self.timeInterval > 0) return self.imageUrl;
    return @"";
}

- (NSInteger)timeInterval
{
    return self.expirationTime - ([[NSDate date] timeIntervalSince1970] - [self lj_timeStampFrom2017ToNow]);
}

- (NSInteger)lj_timeStampFrom2017ToNow
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

@implementation LJPayConfig

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"products": [LJIapConfig class]
    };
}

@end

@implementation LJIapConfig

@end
