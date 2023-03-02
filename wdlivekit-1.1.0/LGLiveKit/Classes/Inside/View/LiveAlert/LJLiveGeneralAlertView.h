//
//  LJLiveGeneralAlertView.h
//  Woohoo
//
//  Created by M2-mini on 2021/9/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveGeneralAlertView : UIView








+ (LJLiveGeneralAlertView *)remindAlertView;
- (void)lj_dismiss;
+ (LJLiveGeneralAlertView *)moreAlertView;
- (void)lj_open;
@property (nonatomic, copy) LJLiveVoidBlock eventBlock, spaceDismissBlock;
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, strong) NSString *content;
@end

NS_ASSUME_NONNULL_END
