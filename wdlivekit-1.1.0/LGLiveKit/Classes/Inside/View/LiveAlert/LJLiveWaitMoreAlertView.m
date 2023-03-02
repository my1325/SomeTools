//
//  LJLiveWaitMoreAlertView.m
//  Woohoo
//
//  Created by M2-mini on 2021/9/1.
//

#import "LJLiveWaitMoreAlertView.h"

@interface LJLiveWaitMoreAlertView ()










@property (nonatomic, copy) LJLiveVoidBlock waitBlock, moreBlock;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreButtonRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftRightRatio;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *waitButtonRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelRight;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *waitButtonLeft;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation LJLiveWaitMoreAlertView

#pragma mark - Life Cycle

+ (LJLiveWaitMoreAlertView *)waitMoreViewWithWait:(LJLiveVoidBlock)wait more:(LJLiveVoidBlock)more
{
    LJLiveWaitMoreAlertView *view = kLJLoadingXib(@"LJLiveWaitMoreAlertView");
    view.frame = kLJScreenBounds;
    view.waitBlock = wait;
    view.moreBlock = more;
    
    [view.waitButton setTitle:kLJLocalString(@"Wait") forState:UIControlStateNormal];
    [view.moreButton setTitle:kLJLocalString(@"More anchors") forState:UIControlStateNormal];
    view.leftRightRatio.constant = 5/8;
    CGFloat width = (kLJWidthScale(287) - kLJWidthScale(18)*3) * 8/(5+8);
    UIImage *image = [UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
        graColor.fromColor = kLJHexColor(0xFF32A1);
        graColor.toColor = kLJHexColor(0xFC5F7C);
        graColor.type = QQGradualChangeTypeLeftToRight;
    } size:CGSizeMake(width, 44) cornerRadius:QQRadiusMakeSame(22)];
    [view.moreButton setBackgroundImage:image forState:UIControlStateNormal];
    
    return view;
}

+ (LJLiveWaitMoreAlertView *)closeViewWithClose:(LJLiveVoidBlock)close notNow:(LJLiveVoidBlock)notNow
{
    LJLiveWaitMoreAlertView *view = kLJLoadingXib(@"LJLiveWaitMoreAlertView");
    view.frame = kLJScreenBounds;
    view.waitBlock = close;
    view.moreBlock = notNow;
    
    [view.waitButton setTitle:kLJLocalString(@"Close") forState:UIControlStateNormal];
    [view.moreButton setTitle:kLJLocalString(@"Not now") forState:UIControlStateNormal];
    view.leftRightRatio.constant = 1;
    CGFloat width = (kLJWidthScale(287) - kLJWidthScale(18)*3) * 1/(1+1);
    UIImage *image = [UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
        graColor.fromColor = kLJHexColor(0xFF32A1);
        graColor.toColor = kLJHexColor(0xFC5F7C);
        graColor.type = QQGradualChangeTypeLeftToRight;
    } size:CGSizeMake(width, 44) cornerRadius:QQRadiusMakeSame(22)];
    [view.moreButton setBackgroundImage:image forState:UIControlStateNormal];
    
    return view;
}


#pragma mark - Init


#pragma mark - Events



#pragma mark - Methods



- (IBAction)waitButtonClick:(UIButton *)sender
{
    if (self.waitBlock) self.waitBlock();
    [self lj_dismiss];
}
- (void)lj_setupViews
{
    self.contentLabelLeft.constant = kLJWidthScale(25);
    self.contentLabelRight.constant = kLJWidthScale(25);
    self.waitButtonLeft.constant = kLJWidthScale(18);
    self.waitButtonRight.constant = kLJWidthScale(18);
    self.moreButtonRight.constant = kLJWidthScale(18);
    //
    self.contentView.layer.cornerRadius = 12;
    self.waitButton.layer.masksToBounds = YES;
    self.waitButton.layer.cornerRadius = 22;
    self.moreButton.layer.cornerRadius = 22;
    [self.moreButton setLayerShadow:kLJColorFromRGBA(0xFF9EC1, 0.56) offset:CGSizeMake(0, 5) radius:8];
    
//    // 5/8 = x/y  y = x / 5/8   100 /2 = 50 * 5/8       100 * 5/5+8
//    CGFloat width = (kLJWidthScale(287) - kLJWidthScale(18)*3) * 8/(5+8);
//    UIImage *image = [UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
//        graColor.fromColor = kLJHexColor(0xFF32A1);
//        graColor.toColor = kLJHexColor(0xFC5F7C);
//        graColor.type = QQGradualChangeTypeLeftToRight;
//    } size:CGSizeMake(width, 44) cornerRadius:QQRadiusMakeSame(22)];
//    [self.moreButton setBackgroundImage:image forState:UIControlStateNormal];
    self.contentLabel.text = kLJLocalString(@"The host is in a private call. Please come back later");
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self lj_setupViews];
}
- (void)lj_open
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
- (IBAction)moreButtonClick:(UIButton *)sender
{
    if (self.moreBlock) self.moreBlock();
    [self lj_dismiss];
}
- (void)lj_dismiss
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
