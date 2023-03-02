//
//  LJLiveGeneralAlertView.m
//  Woohoo
//
//  Created by M2-mini on 2021/9/2.
//

#import "LJLiveGeneralAlertView.h"

@interface LJLiveGeneralAlertView ()







@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelLeft;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *eventButton;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *eventButtonLeft;
@end

@implementation LJLiveGeneralAlertView

+ (LJLiveGeneralAlertView *)remindAlertView
{
    LJLiveGeneralAlertView *view = kLJLoadingXib(@"LJLiveGeneralAlertView");
    view.frame = kLJScreenBounds;
    
    [view.eventButton setTitle:kLJLocalString(@"Don’t show again.") forState:UIControlStateNormal];
    view.eventButton.backgroundColor = kLJHexColor(0xF7F5F6);
    [view.eventButton setTitleColor:kLJHexColor(0x9B999A) forState:UIControlStateNormal];
    
    return view;
}

+ (LJLiveGeneralAlertView *)moreAlertView
{
    LJLiveGeneralAlertView *view = kLJLoadingXib(@"LJLiveGeneralAlertView");
    view.frame = kLJScreenBounds;
    
    [view.eventButton setTitle:kLJLocalString(@"More anchors") forState:UIControlStateNormal];
    [view.eventButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [view.eventButton setLayerShadow:kLJColorFromRGBA(0xFF9EB1, 0.56) offset:CGSizeMake(0, 5) radius:8];
    CGFloat width = kLJWidthScale(287) - kLJWidthScale(20)*2;
    UIImage *image = [UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
        graColor.fromColor = kLJHexColor(0xFF32A1);
        graColor.toColor = kLJHexColor(0xFC5F7C);
        graColor.type = QQGradualChangeTypeLeftToRight;
    } size:CGSizeMake(width, 44) cornerRadius:QQRadiusMakeSame(22)];
    [view.eventButton setBackgroundImage:image forState:UIControlStateNormal];
    
    return view;
}


#pragma mark - Init


#pragma mark - Events



#pragma mark - Methods



#pragma mark - Setter



- (IBAction)masButtonClick:(UIButton *)sender
{
    if (self.spaceDismissBlock) {
        self.spaceDismissBlock();
        [self lj_dismiss];
    }
}
- (void)setIconImage:(UIImage *)iconImage
{
    _iconImage = iconImage;
    [self.imageView setImage:iconImage];
}
- (void)lj_setupViews
{
    self.contentLabelLeft.constant = kLJWidthScale(25);
    self.eventButtonLeft.constant = kLJWidthScale(20);
    //
    self.contentView.layer.cornerRadius = 12;
    self.eventButton.layer.cornerRadius = 22;
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
- (void)setContent:(NSString *)content
{
    _content = content;
    self.contentLabel.text = content;
}
- (IBAction)eventButtonClick:(UIButton *)sender
{
    if (self.eventBlock) {
        self.eventBlock();
        [self lj_dismiss];
    }
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
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self lj_setupViews];
}
@end
