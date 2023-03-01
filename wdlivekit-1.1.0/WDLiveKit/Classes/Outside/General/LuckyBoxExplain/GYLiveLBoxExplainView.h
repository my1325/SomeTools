//
//  GYLiveLBoxExplainView.h
//  Woohoo
//
//  Created by M2-mini on 2021/1/11.
//  Copyright © 2021 王振明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYLiveLBoxExplainView : UIView

+ (GYLiveLBoxExplainView *)luckyboxExplainView;

- (void)showInView:(UIView *)view;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
