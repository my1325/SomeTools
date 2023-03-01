//
//  GYLiveControlMenuView.h
//  WDLiveKit
//
//  Created by M1-mini on 2022/6/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYLiveControlMenuView : UIView

@property (nonatomic, copy) GYLiveEventBlock eventBlock;

- (void)fb_showInView:(UIView *)inView;

- (void)fb_dismiss;

@end

NS_ASSUME_NONNULL_END
