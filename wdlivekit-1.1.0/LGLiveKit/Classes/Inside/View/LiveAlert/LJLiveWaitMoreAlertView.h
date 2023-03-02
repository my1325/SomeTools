//
//  LJLiveWaitMoreAlertView.h
//  Woohoo
//
//  Created by M2-mini on 2021/9/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveWaitMoreAlertView : UIView

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIButton *waitButton;

@property (weak, nonatomic) IBOutlet UIButton *moreButton;

+ (LJLiveWaitMoreAlertView *)waitMoreViewWithWait:(LJLiveVoidBlock)wait more:(LJLiveVoidBlock)more;

+ (LJLiveWaitMoreAlertView *)closeViewWithClose:(LJLiveVoidBlock)close notNow:(LJLiveVoidBlock)notNow;

- (void)lj_open;

- (void)lj_dismiss;

@end

NS_ASSUME_NONNULL_END
