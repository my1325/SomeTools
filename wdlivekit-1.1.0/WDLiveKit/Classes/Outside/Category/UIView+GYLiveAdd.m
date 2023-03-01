//
//  UIView+GYLiveAdd.m
//  Woohoo
//
//  Created by M2-mini on 2021/2/27.
//

#import "UIView+GYLiveAdd.h"

@implementation UIView (GYLiveAdd)

- (void)fb_adjustView:(UIScrollView * __nullable)scrollView
{
    if (@available(iOS 11.0, *)) {
        if (scrollView) scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

/// 已添加在视图上之后，才能有效重置X
- (void)fb_flipedByRTL
{
    if (!kGYLiveManager.inside.appRTL || !kGYLiveManager.config.flipRTLEnable) return;
    UIView *superView = self.superview;
    if (superView) {
        self.x = superView.width - self.x - self.width;
    }
}

/// scrollview针对RTL做翻转适配，在视图布局固定时使用
- (void)fb_flippedSubviewsByRTL
{
    if (!kGYLiveManager.inside.appRTL || !kGYLiveManager.config.flipRTLEnable) return;
    if ([self isKindOfClass:[UIScrollView class]]) {
        for (UIView *subView in self.subviews) {
            subView.transform = CGAffineTransformMakeRotation(M_PI);
        }
        self.transform = CGAffineTransformMakeRotation(M_PI);
    }
}

#pragma mark - Getter

- (CGSize)size
{
    return self.frame.size;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (CGFloat)centerY
{
    return self.center.y;
}

#pragma mark - Setter

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)setX:(CGFloat)x
{
    if (isnan(x)) {
        return;
    }
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (void)setWidth:(CGFloat)width
{
    if (isnan(width)) {
        return;
    }
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    if (isnan(height)) {
        return;
    }
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

@end
