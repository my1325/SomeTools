//
//  LJLiveMethods.m
//  Woohoo
//
//  Created by M1-mini on 2022/4/25.
//  Copyright © 2022 tt. All rights reserved.
//

#import "LJLiveMethods.h"

@implementation LJLiveMethods

+ (UIViewController *)lj_currentViewController
{
    UIViewController *result = nil;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *temp in windows) {
            if (temp.windowLevel == UIWindowLevelNormal) {
                window = temp;
                break;
            }
        }
    }
    // 取当前展示的控制器
    result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    // 如果为UITabBarController：取选中控制器
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
    }
    // 如果为UINavigationController：取可视控制器
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result visibleViewController];
    }
    return result;
}

+ (UINavigationController *)lj_currentNavigationController
{
    if (![[UIApplication sharedApplication].windows.lastObject isKindOfClass:[UIWindow class]]) {
        NSAssert(0, @"未获取到导航控制器");
        return nil;
    }
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self getCurrentNavigationController:rootViewController];
}

+ (UINavigationController *)getCurrentNavigationController:(UIViewController *)vc
{
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UINavigationController *nc = ((UITabBarController *)vc).selectedViewController;
        return [self getCurrentNavigationController:nc];
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        if (((UINavigationController *)vc).presentedViewController) {
            return [self getCurrentNavigationController:((UINavigationController *)vc).presentedViewController];
        }
        return [self getCurrentNavigationController:((UINavigationController *)vc).topViewController];
    } else if ([vc isKindOfClass:[UIViewController class]]) {
        if (vc.presentedViewController) {
            return [self getCurrentNavigationController:vc.presentedViewController];
        }
        else {
            return vc.navigationController;
        }
    } else {
        NSAssert(0, @"未获取到导航控制器");
        return nil;
    }
}

+ (CGRect)lj_flipedRect:(CGRect)targetRect bySuperRect:(CGRect)superRect
{
    if (kLJLiveManager.inside.appRTL && kLJLiveManager.config.flipRTLEnable) {
        CGRect rect = targetRect;
        if (superRect.size.width == kLJScreenWidth) {
            CGFloat x = kLJScreenWidth - rect.origin.x - rect.size.width;
            CGFloat y = rect.origin.y;
            CGFloat width = rect.size.width;
            CGFloat height = rect.size.height;
            rect = CGRectMake(x, y, width, height);
        } else {
            CGFloat x = superRect.size.width - rect.origin.x - rect.size.width;
            CGFloat y = rect.origin.y;
            CGFloat width = rect.size.width;
            CGFloat height = rect.size.height;
            rect = CGRectMake(x, y, width, height);
        }
        return rect;
    }
    return targetRect;
}

@end
