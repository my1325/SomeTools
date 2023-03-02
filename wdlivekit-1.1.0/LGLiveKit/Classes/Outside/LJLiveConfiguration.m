//
//  LJLiveConfiguration.m
//  Woohoo
//
//  Created by M1-mini on 2022/4/27.
//  Copyright © 2022 tt. All rights reserved.
//

#import "LJLiveConfiguration.h"

@implementation LJLiveConfiguration

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.privateEnable = YES;
        self.flipRTLEnable = YES;
        self.mood = kLJLocalString(@"");
        self.avatar = kLJImageNamed(@"lj_live_default_head");
        self.isTestServer = NO;
        self.screenshotHideEnable = YES;
    }
    return self;
}

@end
