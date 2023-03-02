//
//  LJLiveMethods.h
//  Woohoo
//
//  Created by M1-mini on 2022/4/25.
//  Copyright © 2022 tt. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define LJFlipedScreenBy(_rect) [LJLiveMethods lj_flipedRect:_rect bySuperRect:kLJScreenBounds]
#define LJFlipedBy(_rect, _superRect) [LJLiveMethods lj_flipedRect:_rect bySuperRect:_superRect]

@interface LJLiveMethods : NSObject

/// 当前vc
+ (UIViewController *)lj_currentViewController;
/// 当前nav
+ (UINavigationController *)lj_currentNavigationController;

+ (CGRect)lj_flipedRect:(CGRect)targetRect bySuperRect:(CGRect)superRect;

@end

NS_ASSUME_NONNULL_END
