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

- (NSString *)lj_md5Hash;

/// 拼接URL
/// @param arg 参数
- (NSString *)lj_addressURLAppendingByArg:(NSDictionary *)arg;

/// 分割URL
- (NSDictionary *)lj_parameterAddressURL;

/// 阿语打头
- (BOOL)lj_beginWithArabic;

- (NSString *)lj_localized;

@end

NS_ASSUME_NONNULL_END