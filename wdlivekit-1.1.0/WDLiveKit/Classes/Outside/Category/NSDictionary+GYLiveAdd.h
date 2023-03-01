//
//  NSDictionary+GYLiveAdd.h
//  Woohoo
//
//  Created by M2-mini on 2021/2/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (GYLiveAdd)

+ (NSDictionary *)fb_dictionaryWithJsonString:(NSString *)jsonString;

- (NSString *)fb_toJson;

@end

NS_ASSUME_NONNULL_END
