//
//  LJLiveAlertWebView.h
//  Woohoo
//
//  Created by M2-mini on 2021/12/25.
//  Copyright © 2020 王振明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveAlertWebView : UIView





+ (LJLiveAlertWebView *)activityPopView;
- (void)dismiss;
- (void)showInView:(UIView *)view;
@property (strong, nonatomic) NSString *reloadURL;
@end

NS_ASSUME_NONNULL_END
