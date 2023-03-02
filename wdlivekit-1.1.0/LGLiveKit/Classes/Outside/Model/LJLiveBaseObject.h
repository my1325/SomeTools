//
//  LJLiveBaseObject.h
//  Woohoo
//
//  Created by M1-mini on 2022/4/24.
//  Copyright © 2022 tt. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveBaseObject : NSObject
///
@property (nonatomic, strong) NSDictionary *dictionary;

- (instancetype)initWithDictionary:(NSDictionary * __nullable )dictionary;

@end

NS_ASSUME_NONNULL_END
