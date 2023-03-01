//
//  GYLiveBonusView.h
//  ActionSheetPicker-3.0
//
//  Created by Mimio on 2022/9/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    GYLiveBonusViewPrice099,
    GYLiveBonusViewPrice499
} GYLiveBonusViewPrice;

@interface GYLiveBonusView : UIView

@property (nonatomic, copy) GYLiveVoidBlock bonusViewDismissBlock;

- (void)fb_showInView:(UIView *)inView withPrice:(GYLiveBonusViewPrice)price;

- (void)fb_dismiss;

@end

NS_ASSUME_NONNULL_END
