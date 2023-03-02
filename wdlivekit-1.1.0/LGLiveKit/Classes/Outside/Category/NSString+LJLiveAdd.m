//
//  NSString+LJLiveAdd.m
//  Woohoo
//
//  Created by M2-mini on 2021/7/12.
//  Copyright © 2021 tt. All rights reserved.
//

#import "NSString+LJLiveAdd.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (LJLiveAdd)

- (NSString *)lj_md5Hash
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    NSNumber *num = [NSNumber numberWithUnsignedLong:strlen(cStr)];
    CC_MD5( cStr,[num intValue], result );
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]] lowercaseString];
}

/// 拼接URLl
/// @param arg 参数
- (NSString *)lj_addressURLAppendingByArg:(NSDictionary *)arg
{
    __block NSString *str = self;
    str = [str stringByAppendingString:@"?"];
    [arg enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        str = [str stringByAppendingString:key];
        str = [str stringByAppendingString:@"="];
        str = [str stringByAppendingString:obj];
        str = [str stringByAppendingString:@"&"];
    }];
    str = [str substringToIndex:str.length - 1];
    return str;
}

/// 分割URL
- (NSDictionary *)lj_parameterAddressURL
{
    /** 分开 请求URL地址 获取参数段 */
    NSArray *requestAddresArray = [self componentsSeparatedByString:@"//"];
    /** 拆分参数段 */
    NSArray *paramTotalArray = [requestAddresArray[1] componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc]init];
    /** 拆分key value */
    for (int i = 0; i<paramTotalArray.count; i++) {
        NSArray *dictArray = [paramTotalArray[i] componentsSeparatedByString:@"="];
        
        [paramDict setObject:dictArray[1] forKey:dictArray[0]];
    }
    return paramDict;
}

/// 是否阿语打头
- (BOOL)lj_beginWithArabic
{
    if (!self || self.length == 0) return NO;
    NSString *text = [self substringToIndex:1];
    // 正则表达式：阿拉伯语
    NSString *regex = @"^[ء-ي]+$";
    // 创建谓词对象并设定条件表达式
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    // 字符串判断，然后BOOL值
    BOOL result = [predicate evaluateWithObject:text];
    return result;
}

- (NSString *)lj_localized
{
    NSArray *supports = @[@"en", @"ar", @"tr"];
    NSString *abbr = kLJLiveManager.inside.localizableAbbr;
    if ([supports containsObject:abbr]) {
        NSString *path = [kLJLiveBundle pathForResource:abbr ofType:@"lproj"];
        if (path) {
            NSString *text = [[NSBundle bundleWithPath:path] localizedStringForKey:self value:self table:@"LJLiveLocalizable"];
            return text;
        }
    }
    return self;
}

@end
