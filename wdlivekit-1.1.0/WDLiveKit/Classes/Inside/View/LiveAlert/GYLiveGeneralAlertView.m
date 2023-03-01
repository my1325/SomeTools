//
//  GYLiveGeneralAlertView.m
//  Woohoo
//
//  Created by M2-mini on 2021/9/2.
//

#import "GYLiveGeneralAlertView.h"

@interface GYLiveGeneralAlertView ()

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIButton *eventButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *eventButtonLeft;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelLeft;

@end

@implementation GYLiveGeneralAlertView

+ (GYLiveGeneralAlertView *)remindAlertView
{
    GYLiveGeneralAlertView *view = kGYLoadingXib(@"GYLiveGeneralAlertView");
    view.frame = kGYScreenBounds;
    
    [view.eventButton setTitle:kGYLocalString(@"Don’t show again.") forState:UIControlStateNormal];
    view.eventButton.backgroundColor = kGYHexColor(0xF7F5F6);
    [view.eventButton setTitleColor:kGYHexColor(0x9B999A) forState:UIControlStateNormal];
    
    return view;
}

+ (GYLiveGeneralAlertView *)moreAlertView
{
    GYLiveGeneralAlertView *view = kGYLoadingXib(@"GYLiveGeneralAlertView");
    view.frame = kGYScreenBounds;
    
    [view.eventButton setTitle:kGYLocalString(@"More anchors") forState:UIControlStateNormal];
    [view.eventButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [view.eventButton setLayerShadow:kGYColorFromRGBA(0xFF9EB1, 0.56) offset:CGSizeMake(0, 5) radius:8];
    CGFloat width = kGYWidthScale(287) - kGYWidthScale(20)*2;
    UIImage *image = [UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
        graColor.fromColor = kGYHexColor(0xFF32A1);
        graColor.toColor = kGYHexColor(0xFC5F7C);
        graColor.type = QQGradualChangeTypeLeftToRight;
    } size:CGSizeMake(width, 44) cornerRadius:QQRadiusMakeSame(22)];
    [view.eventButton setBackgroundImage:image forState:UIControlStateNormal];
    
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
    self.eventButtonLeft.constant = kGYWidthScale(20);
    //
    self.contentView.layer.cornerRadius = 12;
    self.eventButton.layer.cornerRadius = 22;
}

#pragma mark - Events

- (IBAction)masButtonClick:(UIButton *)sender
{
    if (self.spaceDismissBlock) {
        self.spaceDismissBlock();
        [self fb_dismiss];
    }
}

- (IBAction)eventButtonClick:(UIButton *)sender
{
    if (self.eventBlock) {
        self.eventBlock();
        [self fb_dismiss];
    }
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

#pragma mark - Setter

- (void)setContent:(NSString *)content
{
    _content = content;
    self.contentLabel.text = content;
}

- (void)setIconImage:(UIImage *)iconImage
{
    _iconImage = iconImage;
    [self.imageView setImage:iconImage];
}

@end
