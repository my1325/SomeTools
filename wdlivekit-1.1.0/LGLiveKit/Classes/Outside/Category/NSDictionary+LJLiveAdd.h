//
//  NSDictionary+LJLiveAdd.h
//  Woohoo
//
//  Created by M2-mini on 2021/2/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (LJLiveAdd)



- (NSString *)lj_toJson;
+ (NSDictionary *)lj_dictionaryWithJsonString:(NSString *)jsonString;
@end

NS_ASSUME_NONNULL_END
