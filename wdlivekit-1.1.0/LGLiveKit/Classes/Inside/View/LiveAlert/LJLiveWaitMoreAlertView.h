//
//  LJLiveWaitMoreAlertView.h
//  Woohoo
//
//  Created by M2-mini on 2021/9/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveWaitMoreAlertView : UIView








- (void)lj_dismiss;
+ (LJLiveWaitMoreAlertView *)waitMoreViewWithWait:(LJLiveVoidBlock)wait more:(LJLiveVoidBlock)more;
- (void)lj_open;
+ (LJLiveWaitMoreAlertView *)closeViewWithClose:(LJLiveVoidBlock)close notNow:(LJLiveVoidBlock)notNow;
@property (weak, nonatomic) IBOutlet UIButton *waitButton;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@end

NS_ASSUME_NONNULL_END
