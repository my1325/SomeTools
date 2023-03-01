//
//  GYLiveMethods.h
//  Woohoo
//
//  Created by M1-mini on 2022/4/25.
//  Copyright © 2022 tt. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define GYFlipedScreenBy(_rect) [GYLiveMethods fb_flipedRect:_rect bySuperRect:kGYScreenBounds]
#define GYFlipedBy(_rect, _superRect) [GYLiveMethods fb_flipedRect:_rect bySuperRect:_superRect]

@interface GYLiveMethods : NSObject

/// 当前vc
+ (UIViewController *)fb_currentViewController;
/// 当前nav
+ (UINavigationController *)fb_currentNavigationController;

+ (CGRect)fb_flipedRect:(CGRect)targetRect bySuperRect:(CGRect)superRect;

@end

NS_ASSUME_NONNULL_END
