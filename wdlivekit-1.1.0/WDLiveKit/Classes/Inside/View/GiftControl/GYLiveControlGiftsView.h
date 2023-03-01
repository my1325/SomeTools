//
//  GYLiveControlGiftsView.h
//  Woohoo
//
//  Created by M2-mini on 2021/8/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYLiveControlGiftsView : UIView

@property (nonatomic, copy) GYLiveEventBlock eventBlock;

@property (nonatomic, strong) NSArray<GYLiveGiftConfig *> *configs;

- (void)fb_showInView:(UIView *)inView;

- (void)fb_dismiss;

- (void)fb_reloadMyCoins;

@end

NS_ASSUME_NONNULL_END
