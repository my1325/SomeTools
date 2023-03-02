//
//  NSDictionary+LJLiveAdd.m
//  Woohoo
//
//  Created by M2-mini on 2021/2/27.
//

#import "NSDictionary+LJLiveAdd.h"

@implementation NSDictionary (LJLiveAdd)

+ (NSDictionary *)lj_dictionaryWithJsonString:(NSString *)jsonString
{
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    return dict;
}

- (NSString *)lj_toJson
{
    NSError*parseError =nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
