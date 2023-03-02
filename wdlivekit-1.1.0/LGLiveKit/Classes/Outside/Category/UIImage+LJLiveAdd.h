//
//  UIImage+LJLiveAdd.h
//  Woohoo
//
//  Created by M2-mini on 2021/4/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (LJLiveAdd)

/// 图片镜像
- (UIImage *)lj_flipedByRTL;

- (CGImageRef)lj_newCGImageRenderedInBitmapContext;

@end

NS_ASSUME_NONNULL_END
