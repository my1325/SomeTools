//
//  LJLiveRadioMarqueeView.h
//  LJLiveRadioMarqueeView
//
//  Created by youyou on 16/12/5.
//  Copyright © 2016年 iceyouyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LJLiveRadioMarqueeView;

typedef NS_ENUM(NSUInteger, LJMarqueeViewDirection) {
    LJMarqueeViewDirectionUpward,   // scroll from bottom to top
    LJMarqueeViewDirectionLeftward  // scroll from right to left
};

#pragma mark - LJMarqueeViewDelegate
@protocol LJMarqueeViewDelegate <NSObject>
@optional- (NSUInteger)numberOfVisibleItemsForMarqueeView:(LJLiveRadioMarqueeView*)marqueeView;   // only for [LJMarqueeViewDirectionUpward]
- (CGFloat)itemViewWidthAtIndex:(NSUInteger)index forMarqueeView:(LJLiveRadioMarqueeView*)marqueeView;   // only for [LJMarqueeViewDirectionLeftward]
- (CGFloat)itemViewHeightAtIndex:(NSUInteger)index forMarqueeView:(LJLiveRadioMarqueeView*)marqueeView;   // only for [LJMarqueeViewDirectionUpward] and [useDynamicHeight = YES]
- (void)didTouchItemViewAtIndex:(NSUInteger)index forMarqueeView:(LJLiveRadioMarqueeView*)marqueeView;
@required- (NSUInteger)numberOfDataForMarqueeView:(LJLiveRadioMarqueeView*)marqueeView;
- (void)createItemView:(UIView*)itemView forMarqueeView:(LJLiveRadioMarqueeView*)marqueeView;
- (void)updateItemView:(UIView*)itemView atIndex:(NSUInteger)index forMarqueeView:(LJLiveRadioMarqueeView*)marqueeView;
@end

#pragma mark - LJLiveRadioMarqueeView
@interface LJLiveRadioMarqueeView : UIView
- (instancetype)initWithFrame:(CGRect)frame direction:(LJMarqueeViewDirection)direction;
- (void)pause;
- (void)reloadData;
- (instancetype)initWithDirection:(LJMarqueeViewDirection)direction;
- (void)resetAll;
- (void)start;
@property (nonatomic, assign, getter=isTouchEnabled) BOOL touchEnabled;
@property (nonatomic, assign) float scrollSpeed;    // only for [LJMarqueeViewDirectionLeftward] or [LJMarqueeViewDirectionUpward] with [useDynamicHeight = YES]
@property (nonatomic, assign) BOOL useDynamicHeight;    // only for [LJMarqueeViewDirectionUpward]
@property (nonatomic, assign) NSTimeInterval timeDurationPerScroll; // only for [LJMarqueeViewDirectionUpward] and [useDynamicHeight = NO]
@property (nonatomic, weak) id<LJMarqueeViewDelegate> delegate;
@property (nonatomic, assign) float itemSpacing;    // only for [LJMarqueeViewDirectionLeftward]
@property (nonatomic, assign) LJMarqueeViewDirection direction;
@property (nonatomic, assign) NSTimeInterval timeIntervalPerScroll;
@property (nonatomic, assign) BOOL clipsToBounds;
@property (nonatomic, assign) BOOL stopWhenLessData;    // do not scroll when all data has been shown
@end

#pragma mark - LJMarqueeViewTouchResponder(Private)
@protocol LJMarqueeViewTouchResponder <NSObject>
@optional- (void)touchesBegan;
@required- (void)touchesCancelled;
- (void)touchesEndedAtPoint:(CGPoint)point;
@end

#pragma mark - LJMarqueeViewTouchReceiver(Private)
@interface LJMarqueeViewTouchReceiver : UIView
@property (nonatomic, weak) id<LJMarqueeViewTouchResponder> touchDelegate;
@end

#pragma mark - LJMarqueeItemView(Private)
@interface LJMarqueeItemView : UIView   // LJMarqueeItemView's [tag] is the index of data source. if none data source then [tag] is -1
- (void)clear;
@property (nonatomic, assign) CGFloat width;    // cache the item width, only for [LJMarqueeViewDirectionLeftward]
@property (nonatomic, assign) BOOL didFinishCreate;
@property (nonatomic, assign) CGFloat height;   // cache the item height, only for [LJMarqueeViewDirectionUpward]
@end
