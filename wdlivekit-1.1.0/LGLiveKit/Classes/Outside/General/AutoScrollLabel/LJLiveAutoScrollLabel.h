//
//  LJLiveAutoScrollLabel.h
//  LJLiveAutoScrollLabel
//
//  Created by Brian Stormont on 10/21/09.
//  Updated/Modernized by Christopher Bess on 2/5/12
//
//  Copyright 2009 Stormy Productions. All rights reserved.
//
//  Originally from: http://blog.stormyprods.com/2009/10/simple-scrolling-uilabel-for-iphone.html
//
//  Permission is granted to use this code free of charge for any project.
//

#import <UIKit/UIKit.h>

/// Specifies the direction of the scroll
typedef NS_ENUM(NSInteger, LJLiveAutoScrollDirection) {
    LJLiveAutoScrollDirectionRight,
    LJLiveAutoScrollDirectionLeft
};

@interface LJLiveAutoScrollLabel : UIView <UIScrollViewDelegate>










/**
 * Initiates auto-scroll, if the label width exceeds the bounds of the scrollview.
 */
/**
 * The animation options used when scrolling the UILabels.
 * @discussion UIViewAnimationOptionAllowUserInteraction is always applied to the animations.
 */
/**
 * Lays out the scrollview contents, enabling text scrolling if the text will be clipped.
 * @discussion Uses [scrollLabelIfNeeded] internally.
 */
/// Scroll speed in pixels per second, defaults to 30
/**
 Set the attributed text and refresh labels, if needed.
 */
/**
 * Observes UIApplication state notifications to auto-restart scrolling and watch for 
 * orientation changes to refresh the labels.
 * @discussion Must be called to observe the notifications. Calling multiple times will still only
 * register the notifications once.
 */
/**
 * Returns YES, if it is actively scrolling, NO if it has paused or if text is within bounds (disables scrolling).
 */
// UILabel properties
/**
 * Set the text to the label and refresh labels, if needed.
 * @discussion Useful when you have a situation where you need to layout the scroll label after it's text is set.
 */
- (void)observeApplicationNotifications;
- (void)refreshLabels;
- (void)setText:(nullable NSString *)text refreshLabels:(BOOL)refresh;
- (void)setAttributedText:(nullable NSAttributedString *)theText refreshLabels:(BOOL)refresh;
- (void)scrollLabelIfNeeded;
@property (nonatomic) CGFloat fadeLength; // defaults to 7
@property (nonatomic, strong, nonnull) UIFont *font;
@property (nonatomic, strong, nullable) UIColor *shadowColor;
@property (nonatomic, readonly) BOOL scrolling;
@property (nonatomic, copy, nullable) NSString *text;
@property (nonatomic) CGSize shadowOffset;
@property (nonatomic) NSTextAlignment textAlignment; // only applies when not auto-scrolling
@property (nonatomic) LJLiveAutoScrollDirection scrollDirection;
@property (nonatomic) UIViewAnimationOptions animationOptions;
@property (nonatomic) NSTimeInterval pauseInterval; // defaults to 1.5
@property (nonatomic) float scrollSpeed;
@property (nonatomic, strong, nonnull) UIColor *textColor;
@property (nonatomic) NSInteger labelSpacing; // pixels, defaults to 20
@property (nonatomic, copy, nullable) NSAttributedString *attributedText;
@end
