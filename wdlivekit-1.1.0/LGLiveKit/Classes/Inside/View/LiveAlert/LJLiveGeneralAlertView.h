//
//  LJLiveGeneralAlertView.h
//  Woohoo
//
//  Created by M2-mini on 2021/9/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveGeneralAlertView : UIView

@property (nonatomic, copy) LJLiveVoidBlock eventBlock, spaceDismissBlock;

@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) UIImage *iconImage;

+ (LJLiveGeneralAlertView *)remindAlertView;

+ (LJLiveGeneralAlertView *)moreAlertView;

- (void)lj_open;

- (void)lj_dismiss;

@end

NS_ASSUME_NONNULL_END
