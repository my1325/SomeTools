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
        @"bannerInfoList": [LJBannerInfo class],
        @"voiceChatRoomBannerInfoList":[LJBannerInfo class],
        @"payConfigs": [LJPayConfig class],
    };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"rechargeTList": @"rechargeTList.rechargeT",
        @"bannerInfoList": @"bannerInfoList.bannerInfo",
        @"voiceChatRoomBannerInfoList":@"voiceChatRoomBannerInfoList.bannerInfo",
        @"liveConfig": @"videoChatRoomConfig"
    };
}

//        @"ppConfigs": @"ppConfigs.ppConfig",
//        @"ccConfigs":   [LJIapConfig class],
//        @"ccConfigs": @"ccConfigs.ccConfig",
//        @"giftConfigs": [LJLiveGift class],
//        @"iapConfigs": @"iapConfigs.iapConfig",
//        @"ppConfigs":   [LJIapConfig class],
//        @"voiceChatRoomGiftConfigs": [LJLiveGift class],
//        @"giftConfigs": @"giftConfigs.giftConfig",
//        @"voiceChatRoomGiftConfigs": @"voiceChatRoomGiftConfigs.giftConfig",
//        @"drawTypeList" : @"drawTypeList.drawT",
//        @"iapConfigs":  [LJIapConfig class],
//        @"videoChatRoomConfig": [LJLiveConfig class]
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
- (NSString *)lj_activityUrl
{
    if (self.imageUrl.length > 0 && self.timeInterval > 0) return self.imageUrl;
    return @"";
}
- (NSInteger)timeInterval
{
    return self.expirationTime - ([[NSDate date] timeIntervalSince1970] - [self lj_timeStampFrom2017ToNow]);
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
