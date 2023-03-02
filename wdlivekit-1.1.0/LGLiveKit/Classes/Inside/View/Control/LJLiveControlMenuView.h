//
//  LJLiveControlMenuView.h
//  LGLiveKit
//
//  Created by M1-mini on 2022/6/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveControlMenuView : UIView

@property (nonatomic, copy) LJLiveEventBlock eventBlock;

- (void)lj_showInView:(UIView *)inView;

- (void)lj_dismiss;

@end

NS_ASSUME_NONNULL_END
