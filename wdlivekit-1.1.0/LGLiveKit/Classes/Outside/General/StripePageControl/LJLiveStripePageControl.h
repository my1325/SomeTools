//
//  LJLiveStripePageControl.h
//  Woohoo
//
//  Created by M2-mini on 2021/7/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveStripePageControl : UIView








@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UIColor *normalColor, *currentTagColor;
@property (nonatomic, assign) CGSize currentTagSize;
@property (nonatomic, assign) NSInteger numbersOfPage;
@property (nonatomic, assign) CGFloat currentTagRadius;
@end

NS_ASSUME_NONNULL_END
