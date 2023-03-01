//
//  UIFont+GYLiveAdd.h
//  Woohoo
//
//  Created by M2-mini on 2021/2/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kGYHurmeRegularFont(floatValue)     [UIFont fb_hurmeRegularFontOfSize:floatValue]

#define kGYHurmeBoldFont(floatValue)        [UIFont fb_hurmeBoldFontOfSize:floatValue]

@interface UIFont (GYLiveAdd)

/// HurmeGeometricSans1-Regular
/// @param size 大小
+ (UIFont *)fb_hurmeRegularFontOfSize:(CGFloat)size;

/// HurmeGeometricSans1-Bold
/// @param size 大小
+ (UIFont *)fb_hurmeBoldFontOfSize:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
