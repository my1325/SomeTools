//
//  LJLiveControlGiftsView.h
//  Woohoo
//
//  Created by M2-mini on 2021/8/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveControlGiftsView : UIView

@property (nonatomic, copy) LJLiveEventBlock eventBlock;

@property (nonatomic, strong) NSArray<LJLiveGiftConfig *> *configs;

- (void)lj_showInView:(UIView *)inView;

- (void)lj_dismiss;

- (void)lj_reloadMyCoins;

@end

NS_ASSUME_NONNULL_END
