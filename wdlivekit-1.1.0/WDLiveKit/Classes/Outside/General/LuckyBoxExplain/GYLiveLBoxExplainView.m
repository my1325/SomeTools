//
//  GYLiveLBoxExplainView.m
//  Woohoo
//
//  Created by M2-mini on 2021/1/11.
//  Copyright © 2021 王振明. All rights reserved.
//

#import "GYLiveLBoxExplainView.h"
#import <WDLiveKit/WDLiveKit-Swift.h>
static NSString *const kGYLiveLuckyboxUrl = @"https://sng-apps-configs.s3-us-west-2.amazonaws.com/public/images/lucky_box_rules.png";

@interface GYLiveLBoxExplainView ()<WKNavigationDelegate>

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIScrollView *wrapScrollView;

@property (nonatomic, strong) UIImageView *img;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end

@implementation GYLiveLBoxExplainView

+ (GYLiveLBoxExplainView *)luckyboxExplainView
{
    GYLiveLBoxExplainView *view = kGYLoadingXib(@"GYLiveLBoxExplainView");
    view.frame = kGYScreenBounds;
    return view;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self bz_initViews];
}

- (void)bz_initViews
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, kScreenWidth, kScreenWidth) byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(kGYWidthScale(25), kGYWidthScale(25))];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.mainView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.mainView.layer.mask = maskLayer;
    self.mainView.transform = CGAffineTransformMakeTranslation(0, kScreenWidth);
    
    [self.wrapScrollView addSubview:self.img];
    kGYWeakSelf;
    [self.img sd_setImageWithURL:[NSURL URLWithString:kGYLiveLuckyboxUrl] placeholderImage:kGYLiveManager.config.avatar options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            float progress = ((expectedSize == 0 || receivedSize <= 0) ? 0 : (CGFloat)receivedSize / expectedSize);
            [weakSelf.progressView setProgress:progress];
        }];
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (image) {
                weakSelf.progressView.hidden = YES;
                weakSelf.img.frame = CGRectMake(15, 15, kGYScreenWidth - 30, image.size.height * (kGYScreenWidth - 30) / image.size.width);
                weakSelf.wrapScrollView.contentSize = CGSizeMake(kGYScreenWidth, weakSelf.img.size.height + 30);
            }
        }];
    }];
}

- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:12 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.mainView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
    // 清理combo动画
    kGYLiveHelper.comboing = -1;
    [GYLiveComboViewManager.shared fb_removeCurrentViewFromSuperView];
    UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
}

- (void)dismiss
{
    [UIView animateWithDuration:0.2 animations:^{
        self.mainView.transform = CGAffineTransformMakeTranslation(0, kScreenWidth);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)bz_backAction:(id)sender {
    [self dismiss];
}

- (UIImageView *)img
{
    if (!_img) {
        _img = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _img;;
}
@end
