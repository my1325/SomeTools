//
//  LJLiveControlGiftsView.h
//  Woohoo
//
//  Created by M2-mini on 2021/8/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveControlGiftsView : UIView






- (void)lj_reloadMyCoins;
- (void)lj_showInView:(UIView *)inView;
- (void)lj_dismiss;
@property (nonatomic, strong) NSArray<LJLiveGiftConfig *> *configs;
@property (nonatomic, copy) LJLiveEventBlock eventBlock;
@end

NS_ASSUME_NONNULL_END
