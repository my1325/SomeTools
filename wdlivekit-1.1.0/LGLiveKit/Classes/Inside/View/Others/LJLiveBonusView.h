//
//  LJLiveBonusView.h
//  ActionSheetPicker-3.0
//
//  Created by Mimio on 2022/9/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    LJLiveBonusViewPrice099,
    LJLiveBonusViewPrice499
} LJLiveBonusViewPrice;

@interface LJLiveBonusView : UIView

@property (nonatomic, copy) LJLiveVoidBlock bonusViewDismissBlock;

- (void)lj_showInView:(UIView *)inView withPrice:(LJLiveBonusViewPrice)price;

- (void)lj_dismiss;

@end

NS_ASSUME_NONNULL_END
