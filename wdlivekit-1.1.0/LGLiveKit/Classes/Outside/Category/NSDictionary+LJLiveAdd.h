//
//  NSDictionary+LJLiveAdd.h
//  Woohoo
//
//  Created by M2-mini on 2021/2/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (LJLiveAdd)

+ (NSDictionary *)lj_dictionaryWithJsonString:(NSString *)jsonString;

- (NSString *)lj_toJson;

@end

NS_ASSUME_NONNULL_END
