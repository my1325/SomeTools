//
//  GYLiveBaseObject.m
//  Woohoo
//
//  Created by M1-mini on 2022/4/24.
//  Copyright © 2022 tt. All rights reserved.
//

#import "GYLiveBaseObject.h"

@implementation GYLiveBaseObject

- (instancetype)initWithDictionary:(NSDictionary * __nullable )dictionary
{
    if (dictionary != nil) {
        
        @try {
            self = [[self class] mj_objectWithKeyValues:dictionary];
        } @catch (NSException *exception) {
            GYLog(@"%@ Error: %@", NSStringFromClass([self class]), exception.reason);
        } @finally {
            self.dictionary = dictionary;
        }
        return self;
        
    }
    return nil;
}

+ (NSArray *)mj_ignoredPropertyNames
{
    return @[@"dictionary"];
}

@end
