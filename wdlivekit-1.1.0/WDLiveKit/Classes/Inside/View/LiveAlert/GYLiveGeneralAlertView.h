//
//  GYLiveGeneralAlertView.h
//  Woohoo
//
//  Created by M2-mini on 2021/9/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYLiveGeneralAlertView : UIView

@property (nonatomic, copy) GYLiveVoidBlock eventBlock, spaceDismissBlock;

@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) UIImage *iconImage;

+ (GYLiveGeneralAlertView *)remindAlertView;

+ (GYLiveGeneralAlertView *)moreAlertView;

- (void)fb_open;

- (void)fb_dismiss;

@end

NS_ASSUME_NONNULL_END
