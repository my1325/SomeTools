//
//  NSString+LJLiveAdd.h
//  Woohoo
//
//  Created by M2-mini on 2021/7/12.
//  Copyright © 2021 tt. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (LJLiveAdd)






/// 阿语打头
/// @param arg 参数
/// 拼接URL
/// 分割URL
- (NSString *)lj_localized;
- (NSString *)lj_md5Hash;
- (BOOL)lj_beginWithArabic;
- (NSString *)lj_addressURLAppendingByArg:(NSDictionary *)arg;
- (NSDictionary *)lj_parameterAddressURL;
@end

NS_ASSUME_NONNULL_END
