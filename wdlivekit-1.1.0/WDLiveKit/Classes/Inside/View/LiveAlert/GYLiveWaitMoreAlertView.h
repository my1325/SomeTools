//
//  GYLiveWaitMoreAlertView.h
//  Woohoo
//
//  Created by M2-mini on 2021/9/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYLiveWaitMoreAlertView : UIView

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIButton *waitButton;

@property (weak, nonatomic) IBOutlet UIButton *moreButton;

+ (GYLiveWaitMoreAlertView *)waitMoreViewWithWait:(GYLiveVoidBlock)wait more:(GYLiveVoidBlock)more;

+ (GYLiveWaitMoreAlertView *)closeViewWithClose:(GYLiveVoidBlock)close notNow:(GYLiveVoidBlock)notNow;

- (void)fb_open;

- (void)fb_dismiss;

@end

NS_ASSUME_NONNULL_END
