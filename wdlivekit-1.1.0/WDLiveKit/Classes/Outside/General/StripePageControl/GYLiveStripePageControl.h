//
//  GYLiveStripePageControl.h
//  Woohoo
//
//  Created by M2-mini on 2021/7/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYLiveStripePageControl : UIView

@property (nonatomic, strong) UIColor *normalColor, *currentTagColor;

@property (nonatomic, assign) CGSize currentTagSize;

@property (nonatomic, assign) CGFloat currentTagRadius;



@property (nonatomic, assign) NSInteger numbersOfPage;

@property (nonatomic, assign) NSInteger currentPage;

@end

NS_ASSUME_NONNULL_END
