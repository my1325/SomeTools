//
//  NSDictionary+GYLiveAdd.m
//  Woohoo
//
//  Created by M2-mini on 2021/2/27.
//

#import "NSDictionary+GYLiveAdd.h"

@implementation NSDictionary (GYLiveAdd)

+ (NSDictionary *)fb_dictionaryWithJsonString:(NSString *)jsonString
{
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    return dict;
}

- (NSString *)fb_toJson
{
    NSError*parseError =nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
