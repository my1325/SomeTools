//
//  UIFont+LJLiveAdd.h
//  Woohoo
//
//  Created by M2-mini on 2021/2/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kLJHurmeRegularFont(floatValue)     [UIFont lj_hurmeRegularFontOfSize:floatValue]

#define kLJHurmeBoldFont(floatValue)        [UIFont lj_hurmeBoldFontOfSize:floatValue]

@interface UIFont (LJLiveAdd)

/// HurmeGeometricSans1-Regular
/// @param size 大小
+ (UIFont *)lj_hurmeRegularFontOfSize:(CGFloat)size;

/// HurmeGeometricSans1-Bold
/// @param size 大小
+ (UIFont *)lj_hurmeBoldFontOfSize:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
