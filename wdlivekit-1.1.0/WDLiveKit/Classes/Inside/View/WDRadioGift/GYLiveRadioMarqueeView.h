//
//  GYLiveRadioMarqueeView.h
//  GYLiveRadioMarqueeView
//
//  Created by youyou on 16/12/5.
//  Copyright © 2016年 iceyouyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYLiveRadioMarqueeView;

typedef NS_ENUM(NSUInteger, GYMarqueeViewDirection) {
    GYMarqueeViewDirectionUpward,   // scroll from bottom to top
    GYMarqueeViewDirectionLeftward  // scroll from right to left
};

#pragma mark - GYMarqueeViewDelegate
@protocol GYMarqueeViewDelegate <NSObject>
- (NSUInteger)numberOfDataForMarqueeView:(GYLiveRadioMarqueeView*)marqueeView;
- (void)createItemView:(UIView*)itemView forMarqueeView:(GYLiveRadioMarqueeView*)marqueeView;
- (void)updateItemView:(UIView*)itemView atIndex:(NSUInteger)index forMarqueeView:(GYLiveRadioMarqueeView*)marqueeView;
@optional
- (NSUInteger)numberOfVisibleItemsForMarqueeView:(GYLiveRadioMarqueeView*)marqueeView;   // only for [GYMarqueeViewDirectionUpward]
- (CGFloat)itemViewWidthAtIndex:(NSUInteger)index forMarqueeView:(GYLiveRadioMarqueeView*)marqueeView;   // only for [GYMarqueeViewDirectionLeftward]
- (CGFloat)itemViewHeightAtIndex:(NSUInteger)index forMarqueeView:(GYLiveRadioMarqueeView*)marqueeView;   // only for [GYMarqueeViewDirectionUpward] and [useDynamicHeight = YES]
- (void)didTouchItemViewAtIndex:(NSUInteger)index forMarqueeView:(GYLiveRadioMarqueeView*)marqueeView;
@end

#pragma mark - GYLiveRadioMarqueeView
@interface GYLiveRadioMarqueeView : UIView
@property (nonatomic, weak) id<GYMarqueeViewDelegate> delegate;
@property (nonatomic, assign) NSTimeInterval timeIntervalPerScroll;
@property (nonatomic, assign) NSTimeInterval timeDurationPerScroll; // only for [GYMarqueeViewDirectionUpward] and [useDynamicHeight = NO]
@property (nonatomic, assign) BOOL useDynamicHeight;    // only for [GYMarqueeViewDirectionUpward]
@property (nonatomic, assign) float scrollSpeed;    // only for [GYMarqueeViewDirectionLeftward] or [GYMarqueeViewDirectionUpward] with [useDynamicHeight = YES]
@property (nonatomic, assign) float itemSpacing;    // only for [GYMarqueeViewDirectionLeftward]
@property (nonatomic, assign) BOOL stopWhenLessData;    // do not scroll when all data has been shown
@property (nonatomic, assign) BOOL clipsToBounds;
@property (nonatomic, assign, getter=isTouchEnabled) BOOL touchEnabled;
@property (nonatomic, assign) GYMarqueeViewDirection direction;
- (instancetype)initWithDirection:(GYMarqueeViewDirection)direction;
- (instancetype)initWithFrame:(CGRect)frame direction:(GYMarqueeViewDirection)direction;
- (void)reloadData;
- (void)start;
- (void)pause;
- (void)resetAll;
@end

#pragma mark - GYMarqueeViewTouchResponder(Private)
@protocol GYMarqueeViewTouchResponder <NSObject>
- (void)touchesBegan;
- (void)touchesEndedAtPoint:(CGPoint)point;
- (void)touchesCancelled;
@end

#pragma mark - GYMarqueeViewTouchReceiver(Private)
@interface GYMarqueeViewTouchReceiver : UIView
@property (nonatomic, weak) id<GYMarqueeViewTouchResponder> touchDelegate;
@end

#pragma mark - GYMarqueeItemView(Private)
@interface GYMarqueeItemView : UIView   // GYMarqueeItemView's [tag] is the index of data source. if none data source then [tag] is -1
@property (nonatomic, assign) BOOL didFinishCreate;
@property (nonatomic, assign) CGFloat width;    // cache the item width, only for [GYMarqueeViewDirectionLeftward]
@property (nonatomic, assign) CGFloat height;   // cache the item height, only for [GYMarqueeViewDirectionUpward]
- (void)clear;
@end
