//
//  GYLiveInside.m
//  Woohoo
//
//  Created by M1-mini on 2022/4/25.
//  Copyright © 2022 tt. All rights reserved.
//

#import "GYLiveInside.h"

@implementation GYLiveInside

- (instancetype)init
{
    self = [super init];
    if (self) {
        //
        self.from = @"";
        self.fromDetail = @"";
        // 金币更新告知外部
        self.coinsUpdate = ^(NSInteger intValue) {
            [kGYLiveManager.delegate fb_insideCoinsUpdateWith:intValue];
        };
        // 关注更新告知外部
        self.followStatusUpdate = ^(NSInteger status, NSInteger targetAccountId) {
            if ([kGYLiveManager.delegate respondsToSelector:@selector(fb_insideFollowStatusUpdateWithStatus:targetAccountId:)]) [kGYLiveManager.delegate fb_insideFollowStatusUpdateWithStatus:status targetAccountId:targetAccountId];
        };
        self.uniqueTagDidSelected = ^(GYUniqueTag * _Nullable uniqueTag) {
            [kGYLiveManager.delegate fb_insideDidSelectedUniqueTag:uniqueTag];
        };
    }
    return self;
}

+ (void)fb_firbase:(GYLiveFirbaseEventType)type params:(NSDictionary * __nullable )params
{
    if ([kGYLiveManager.delegate respondsToSelector:@selector(fb_firbase:params:)]) {
        [kGYLiveManager.delegate fb_firbase:type params:params];
    }
}

+ (void)fb_thinking:(GYLiveThinkingEventType)type eventName:(NSString *)eventName params:(NSDictionary * __nullable )params
{
    if ([kGYLiveManager.delegate respondsToSelector:@selector(fb_thinking:eventName:params:)]) {
        [kGYLiveManager.delegate fb_thinking:type eventName:eventName params:params];
    }
}

+ (void)fb_other:(NSString *)eventName params:(NSDictionary * __nullable )params
{
    if ([kGYLiveManager.delegate respondsToSelector:@selector(fb_event:params:)]) {
        [kGYLiveManager.delegate fb_event:eventName params:params];
    }
}

+ (void)fb_loading
{
    if ([kGYLiveManager.delegate respondsToSelector:@selector(fb_showLoading)]) {
        [kGYLiveManager.delegate fb_showLoading];
    }
}

+ (void)fb_hideLoading
{
    if ([kGYLiveManager.delegate respondsToSelector:@selector(fb_hideLoading)]) {
        [kGYLiveManager.delegate fb_hideLoading];
    }
}

+ (void)fb_reloadHomeList
{
    if ([kGYLiveManager.delegate respondsToSelector:@selector(fb_reloadHomeList)]) {
        [kGYLiveManager.delegate fb_reloadHomeList];
    }
}

+ (void)fb_tipWithText:(NSString *)text status:(GYLiveTipStatus)status delay:(float)delay
{
    if ([kGYLiveManager.delegate respondsToSelector:@selector(fb_tipWithText:status:delay:)]) {
        [kGYLiveManager.delegate fb_tipWithText:text status:status delay:delay];
    }
}

#pragma mark - Getter

- (NSInteger)networkStatus
{
    return [kGYLiveManager.dataSource fb_networkStatus];
}

- (NSInteger)sseStatus
{
    return [kGYLiveManager.dataSource fb_sseStatus];
}

- (NSString *)session
{
    return [kGYLiveManager.dataSource fb_session];
}

- (GYLiveAccount *)account
{
    id obj = [kGYLiveManager.dataSource fb_account];
    GYLiveAccount *a;
    if ([obj isKindOfClass:[NSDictionary class]]) {
        CFAbsoluteTime startTime =CFAbsoluteTimeGetCurrent();
        a = [[GYLiveAccount alloc] initWithDictionary:(NSDictionary *)obj];
        NSLog(@"Linked in %f ms",  ((CFAbsoluteTimeGetCurrent() - startTime) *1000.0));
    } else {
        CFAbsoluteTime startTime =CFAbsoluteTimeGetCurrent();
        a = [[GYLiveAccount alloc] initWithDictionary:[(NSObject *)obj mj_keyValues]];
        NSLog(@"Linked in %f ms",  ((CFAbsoluteTimeGetCurrent() - startTime) *1000.0));
    }
    NSLog(@"模型转换account");
    return a;
}

- (GYLiveAccountConfig *)accountConfig
{
    id obj = [kGYLiveManager.dataSource fb_accountConfig];
    GYLiveAccountConfig *config;
    if ([obj isKindOfClass:[NSDictionary class]]) {
        CFAbsoluteTime startTime =CFAbsoluteTimeGetCurrent();
        config = [[GYLiveAccountConfig alloc] initWithDictionary:(NSDictionary *)obj];
        NSLog(@"Linked in %f ms",  ((CFAbsoluteTimeGetCurrent() - startTime) *1000.0));
    } else {
        CFAbsoluteTime startTime =CFAbsoluteTimeGetCurrent();
        config = [[GYLiveAccountConfig alloc] initWithDictionary:[(NSObject *)obj mj_keyValues]];
        NSLog(@"Linked in %f ms",  ((CFAbsoluteTimeGetCurrent() - startTime) *1000.0));
    }
    NSLog(@"模型转换glabol");
    return config;
}

- (BOOL)appRTL
{
    return [self.localizableAbbr isEqualToString:@"ar"];
}

- (AgoraRtmKit *)rtmKit
{
    return [kGYLiveManager.dataSource fb_bindingRTMDelegate:kGYLiveAgoraHelper];
}

- (NSString *)localizableAbbr
{
    if ([kGYLiveManager.dataSource respondsToSelector:@selector(fb_localizableAbbr)]) {
        return [kGYLiveManager.dataSource fb_localizableAbbr].lowercaseString;
    }
    return @"en";
}

@end
