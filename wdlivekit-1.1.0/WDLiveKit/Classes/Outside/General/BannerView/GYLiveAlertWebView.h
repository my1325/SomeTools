//
//  GYLiveAlertWebView.h
//  Woohoo
//
//  Created by M2-mini on 2021/12/25.
//  Copyright © 2020 王振明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYLiveAlertWebView : UIView

@property (strong, nonatomic) NSString *reloadURL;

+ (GYLiveAlertWebView *)activityPopView;

- (void)showInView:(UIView *)view;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
