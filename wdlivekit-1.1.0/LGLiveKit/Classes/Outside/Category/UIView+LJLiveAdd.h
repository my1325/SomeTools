//
//  UIView+LJLiveAdd.h
//  Woohoo
//
//  Created by M2-mini on 2021/2/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (LJLiveAdd)











/// scrollview针对RTL做翻转适配，在视图布局固定时使用
/// 已添加在视图上之后，才能有效重置X
- (void)lj_adjustView:(UIScrollView * __nullable)scrollView;
- (void)lj_flipedByRTL;
- (void)lj_flippedSubviewsByRTL;
@property (nonatomic, assign) CGFloat   x;
@property (nonatomic, assign) CGFloat   height;
@property (nonatomic, assign) CGFloat   centerX;
@property (nonatomic, assign) CGSize    size;
@property (nonatomic, assign) CGFloat   centerY;
@property (nonatomic, assign) CGFloat   width;
@property (nonatomic, assign) CGFloat   y;
@end

NS_ASSUME_NONNULL_END
