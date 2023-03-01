//
//  UIImage+GYLiveAdd.h
//  Woohoo
//
//  Created by M2-mini on 2021/4/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (GYLiveAdd)

/// 图片镜像
- (UIImage *)fb_flipedByRTL;

- (CGImageRef)fb_newCGImageRenderedInBitmapContext;

@end

NS_ASSUME_NONNULL_END
