//
//  GYLiveWaitMoreAlertView.m
//  Woohoo
//
//  Created by M2-mini on 2021/9/1.
//

#import "GYLiveWaitMoreAlertView.h"

@interface GYLiveWaitMoreAlertView ()

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelLeft;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelRight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *waitButtonLeft;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreButtonRight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *waitButtonRight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftRightRatio;

@property (nonatomic, copy) GYLiveVoidBlock waitBlock, moreBlock;

@end

@implementation GYLiveWaitMoreAlertView

#pragma mark - Life Cycle

+ (GYLiveWaitMoreAlertView *)waitMoreViewWithWait:(GYLiveVoidBlock)wait more:(GYLiveVoidBlock)more
{
    GYLiveWaitMoreAlertView *view = kGYLoadingXib(@"GYLiveWaitMoreAlertView");
    view.frame = kGYScreenBounds;
    view.waitBlock = wait;
    view.moreBlock = more;
    
    [view.waitButton setTitle:kGYLocalString(@"Wait") forState:UIControlStateNormal];
    [view.moreButton setTitle:kGYLocalString(@"More anchors") forState:UIControlStateNormal];
    view.leftRightRatio.constant = 5/8;
    CGFloat width = (kGYWidthScale(287) - kGYWidthScale(18)*3) * 8/(5+8);
    UIImage *image = [UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
        graColor.fromColor = kGYHexColor(0xFF32A1);
        graColor.toColor = kGYHexColor(0xFC5F7C);
        graColor.type = QQGradualChangeTypeLeftToRight;
    } size:CGSizeMake(width, 44) cornerRadius:QQRadiusMakeSame(22)];
    [view.moreButton setBackgroundImage:image forState:UIControlStateNormal];
    
    return view;
}

+ (GYLiveWaitMoreAlertView *)closeViewWithClose:(GYLiveVoidBlock)close notNow:(GYLiveVoidBlock)notNow
{
    GYLiveWaitMoreAlertView *view = kGYLoadingXib(@"GYLiveWaitMoreAlertView");
    view.frame = kGYScreenBounds;
    view.waitBlock = close;
    view.moreBlock = notNow;
    
    [view.waitButton setTitle:kGYLocalString(@"Close") forState:UIControlStateNormal];
    [view.moreButton setTitle:kGYLocalString(@"Not now") forState:UIControlStateNormal];
    view.leftRightRatio.constant = 1;
    CGFloat width = (kGYWidthScale(287) - kGYWidthScale(18)*3) * 1/(1+1);
    UIImage *image = [UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
        graColor.fromColor = kGYHexColor(0xFF32A1);
        graColor.toColor = kGYHexColor(0xFC5F7C);
        graColor.type = QQGradualChangeTypeLeftToRight;
    } size:CGSizeMake(width, 44) cornerRadius:QQRadiusMakeSame(22)];
    [view.moreButton setBackgroundImage:image forState:UIControlStateNormal];
    
    return view;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self fb_setupViews];
}

#pragma mark - Init

- (void)fb_setupViews
{
    self.contentLabelLeft.constant = kGYWidthScale(25);
    self.contentLabelRight.constant = kGYWidthScale(25);
    self.waitButtonLeft.constant = kGYWidthScale(18);
    self.waitButtonRight.constant = kGYWidthScale(18);
    self.moreButtonRight.constant = kGYWidthScale(18);
    //
    self.contentView.layer.cornerRadius = 12;
    self.waitButton.layer.masksToBounds = YES;
    self.waitButton.layer.cornerRadius = 22;
    self.moreButton.layer.cornerRadius = 22;
    [self.moreButton setLayerShadow:kGYColorFromRGBA(0xFF9EC1, 0.56) offset:CGSizeMake(0, 5) radius:8];
    
//    // 5/8 = x/y  y = x / 5/8   100 /2 = 50 * 5/8       100 * 5/5+8
//    CGFloat width = (kGYWidthScale(287) - kGYWidthScale(18)*3) * 8/(5+8);
//    UIImage *image = [UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
//        graColor.fromColor = kGYHexColor(0xFF32A1);
//        graColor.toColor = kGYHexColor(0xFC5F7C);
//        graColor.type = QQGradualChangeTypeLeftToRight;
//    } size:CGSizeMake(width, 44) cornerRadius:QQRadiusMakeSame(22)];
//    [self.moreButton setBackgroundImage:image forState:UIControlStateNormal];
    self.contentLabel.text = kGYLocalString(@"The host is in a private call. Please come back later");
}

#pragma mark - Events

- (IBAction)waitButtonClick:(UIButton *)sender
{
    if (self.waitBlock) self.waitBlock();
    [self fb_dismiss];
}

- (IBAction)moreButtonClick:(UIButton *)sender
{
    if (self.moreBlock) self.moreBlock();
    [self fb_dismiss];
}

#pragma mark - Methods

- (void)fb_open
{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    self.contentView.alpha = 0;
    self.contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.85 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
        self.contentView.alpha = 1;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    } completion:^(BOOL finished) {
    }];
}

- (void)fb_dismiss
{
    [UIView animateWithDuration:0.1 animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(0, 0);
        self.alpha = 0;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

@end
