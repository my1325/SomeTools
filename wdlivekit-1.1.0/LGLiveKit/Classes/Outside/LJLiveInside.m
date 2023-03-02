//
//  LJLiveInside.m
//  Woohoo
//
//  Created by M1-mini on 2022/4/25.
//  Copyright © 2022 tt. All rights reserved.
//

#import "LJLiveInside.h"

@implementation LJLiveInside

- (instancetype)init
{
    self = [super init];
    if (self) {
        //
        self.from = @"";
        self.fromDetail = @"";
        // 金币更新告知外部
        self.coinsUpdate = ^(NSInteger intValue) {
            [kLJLiveManager.delegate lj_insideCoinsUpdateWith:intValue];
        };
        // 关注更新告知外部
        self.followStatusUpdate = ^(NSInteger status, NSInteger targetAccountId) {
            if ([kLJLiveManager.delegate respondsToSelector:@selector(lj_insideFollowStatusUpdateWithStatus:targetAccountId:)]) [kLJLiveManager.delegate lj_insideFollowStatusUpdateWithStatus:status targetAccountId:targetAccountId];
        };
        self.uniqueTagDidSelected = ^(LJUniqueTag * _Nullable uniqueTag) {
            [kLJLiveManager.delegate lj_insideDidSelectedUniqueTag:uniqueTag];
        };
    }
    return self;
}

+ (void)lj_firbase:(LJLiveFirbaseEventType)type params:(NSDictionary * __nullable )params
{
    if ([kLJLiveManager.delegate respondsToSelector:@selector(lj_firbase:params:)]) {
        [kLJLiveManager.delegate lj_firbase:type params:params];
    }
}

+ (void)lj_thinking:(LJLiveThinkingEventType)type eventName:(NSString *)eventName params:(NSDictionary * __nullable )params
{
    if ([kLJLiveManager.delegate respondsToSelector:@selector(lj_thinking:eventName:params:)]) {
        [kLJLiveManager.delegate lj_thinking:type eventName:eventName params:params];
    }
}

+ (void)lj_other:(NSString *)eventName params:(NSDictionary * __nullable )params
{
    if ([kLJLiveManager.delegate respondsToSelector:@selector(lj_event:params:)]) {
        [kLJLiveManager.delegate lj_event:eventName params:params];
    }
}

+ (void)lj_loading
{
    if ([kLJLiveManager.delegate respondsToSelector:@selector(lj_showLoading)]) {
        [kLJLiveManager.delegate lj_showLoading];
    }
}

+ (void)lj_hideLoading
{
    if ([kLJLiveManager.delegate respondsToSelector:@selector(lj_hideLoading)]) {
        [kLJLiveManager.delegate lj_hideLoading];
    }
}

+ (void)lj_reloadHomeList
{
    if ([kLJLiveManager.delegate respondsToSelector:@selector(lj_reloadHomeList)]) {
        [kLJLiveManager.delegate lj_reloadHomeList];
    }
}

+ (void)lj_tipWithText:(NSString *)text status:(LJLiveTipStatus)status delay:(float)delay
{
    if ([kLJLiveManager.delegate respondsToSelector:@selector(lj_tipWithText:status:delay:)]) {
        [kLJLiveManager.delegate lj_tipWithText:text status:status delay:delay];
    }
}

#pragma mark - Getter

- (NSInteger)networkStatus
{
    return [kLJLiveManager.dataSource lj_networkStatus];
}

- (NSInteger)sseStatus
{
    return [kLJLiveManager.dataSource lj_sseStatus];
}

- (NSString *)session
{
    return [kLJLiveManager.dataSource lj_session];
}

- (LJLiveAccount *)account
{
    id obj = [kLJLiveManager.dataSource lj_account];
    LJLiveAccount *a;
    if ([obj isKindOfClass:[NSDictionary class]]) {
        CFAbsoluteTime startTime =CFAbsoluteTimeGetCurrent();
        a = [[LJLiveAccount alloc] initWithDictionary:(NSDictionary *)obj];
        NSLog(@"Linked in %f ms",  ((CFAbsoluteTimeGetCurrent() - startTime) *1000.0));
    } else {
        CFAbsoluteTime startTime =CFAbsoluteTimeGetCurrent();
        a = [[LJLiveAccount alloc] initWithDictionary:[(NSObject *)obj mj_keyValues]];
        NSLog(@"Linked in %f ms",  ((CFAbsoluteTimeGetCurrent() - startTime) *1000.0));
    }
    NSLog(@"模型转换account");
    return a;
}

- (LJLiveAccountConfig *)accountConfig
{
    id obj = [kLJLiveManager.dataSource lj_accountConfig];
    LJLiveAccountConfig *config;
    if ([obj isKindOfClass:[NSDictionary class]]) {
        CFAbsoluteTime startTime =CFAbsoluteTimeGetCurrent();
        config = [[LJLiveAccountConfig alloc] initWithDictionary:(NSDictionary *)obj];
        NSLog(@"Linked in %f ms",  ((CFAbsoluteTimeGetCurrent() - startTime) *1000.0));
    } else {
        CFAbsoluteTime startTime =CFAbsoluteTimeGetCurrent();
        config = [[LJLiveAccountConfig alloc] initWithDictionary:[(NSObject *)obj mj_keyValues]];
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
    return [kLJLiveManager.dataSource lj_bindingRTMDelegate:kLJLiveAgoraHelper];
}

- (NSString *)localizableAbbr
{
    if ([kLJLiveManager.dataSource respondsToSelector:@selector(lj_localizableAbbr)]) {
        return [kLJLiveManager.dataSource lj_localizableAbbr].lowercaseString;
    }
    return @"en";
}

@end
