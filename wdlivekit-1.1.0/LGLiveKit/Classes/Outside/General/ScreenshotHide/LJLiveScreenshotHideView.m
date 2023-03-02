//
//  LJLiveScreenshotHideView.m
//  Woohoo
//
//  Created by M1-mini on 2022/4/6.
//

#import "LJLiveScreenshotHideView.h"

@implementation LJLiveScreenshotHideView

- (instancetype)init
{
    self = [super init];
    // 截屏功能是否开启
    if (!kLJLiveManager.config.screenshotHideEnable) return self;
    if (self) {
        if (kLJSystemVersion >= 13.2) {
            UITextField *textField = [[UITextField alloc] init];
            textField.secureTextEntry = YES;
            textField.enabled = NO;
            if (textField.subviews.firstObject != nil) {
                self = textField.subviews.firstObject;
                self.userInteractionEnabled = YES;
            }
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    // 截屏功能是否开启
    if (!kLJLiveManager.config.screenshotHideEnable) return self;
    if (self) {
        if (kLJSystemVersion >= 13.2) {
            UITextField *textField = [[UITextField alloc] init];
            textField.secureTextEntry = YES;
            textField.enabled = NO;
            if (textField.subviews.firstObject != nil) {
                self = textField.subviews.firstObject;
                self.frame = frame;
                self.userInteractionEnabled = YES;
            }
        }
    }
    return self;
}

@end
