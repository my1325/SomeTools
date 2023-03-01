//
//  GYLiveConfiguration.m
//  Woohoo
//
//  Created by M1-mini on 2022/4/27.
//  Copyright © 2022 tt. All rights reserved.
//

#import "GYLiveConfiguration.h"

@implementation GYLiveConfiguration

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.privateEnable = YES;
        self.flipRTLEnable = YES;
        self.mood = kGYLocalString(@"");
        self.avatar = kGYImageNamed(@"fb_live_default_head");
        self.isTestServer = NO;
        self.screenshotHideEnable = YES;
    }
    return self;
}

@end
