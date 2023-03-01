//
//  GYLiveAutoFollowView.m
//  Woohoo
//
//  Created by M2-mini on 2021/8/28.
//

#import "GYLiveAutoFollowView.h"

@interface GYLiveAutoFollowView ()

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIButton *avatarButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UIButton *followButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;

@property (nonatomic, assign) BOOL isFollowed;

@end

@implementation GYLiveAutoFollowView

#pragma mark - Life Cycle

+ (GYLiveAutoFollowView *)followView
{
    GYLiveAutoFollowView *follow = kGYLoadingXib(@"GYLiveAutoFollowView");
    follow.frame = kGYScreenBounds;
    return follow;
}

#pragma mark - Init

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self fb_setupViews];
}

- (void)fb_setupViews
{
    self.contentView.layer.cornerRadius = 12;
    self.avatarButton.layer.masksToBounds = YES;
    self.avatarButton.layer.cornerRadius = 86/2;
    self.avatarButton.layer.borderWidth = 2;
    self.avatarButton.layer.borderColor = UIColor.whiteColor.CGColor;
    self.contentViewHeight.constant = 12 + kGYBottomSafeHeight + 202;
    //
    self.avatarButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
}

#pragma mark - Events

- (IBAction)maskButtonClick:(UIButton *)sender
{
    if (self.dimissBlock) self.dimissBlock();
    [self fb_dismiss];
}

- (IBAction)avatarButtonClick:(UIButton *)sender
{
    if (self.avatarBlock) self.avatarBlock();
}

- (IBAction)followButtonClick:(UIButton *)sender
{
    self.isFollowed = !self.isFollowed;
    
    [UIView animateWithDuration:0.4 animations:^{
        [self.followButton setTitle:kGYLocalString(@"Followed") forState:UIControlStateNormal];
        UIImage *image = [UIImage imageWithQQCorner:^(QQCorner *corner) {
            corner.fillColor = kGYHexColor(0xDDE0E4);
            corner.radius = QQRadiusMakeSame(25);
        } size:CGSizeMake(265, 50)];
        [self.followButton setBackgroundImage:image forState:UIControlStateNormal];
    }];
    
    if (self.followBlock) self.followBlock(self.isFollowed);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self fb_dismiss];
    });
    
    if (self.isFollowed) {
        GYEvent(@"fb_LiveTouchFollowBy1Min", nil);
    }
}

#pragma mark - Methods

- (void)fb_showAvatar:(NSString *)avatar
             nickname:(NSString *)nickname
               follow:(BOOL)follow
               inView:(UIView *)inView
{
    NSString *desc = kGYLiveHelper.data.current.hostMood.length == 0 ? kGYLiveManager.config.mood : kGYLiveHelper.data.current.hostMood;
    self.descLabel.text = desc;
    CGSize size = kGYTextSize_MutiLine(desc, kGYHurmeRegularFont(12), CGSizeMake(kGYScreenWidth-45*2, MAXFLOAT));
    self.contentViewHeight.constant = 12 + kGYBottomSafeHeight + 202-29 + size.height;
    self.isFollowed = follow;
    if (follow) {
        // 已关注
        [self.followButton setTitle:kGYLocalString(@"Followed") forState:UIControlStateNormal];
        UIImage *image = [UIImage imageWithQQCorner:^(QQCorner *corner) {
            corner.fillColor = kGYHexColor(0xDDE0E4);
            corner.radius = QQRadiusMakeSame(25);
        } size:CGSizeMake(265, 50)];
        [self.followButton setBackgroundImage:image forState:UIControlStateNormal];
    } else {
        // 未关注
        [self.followButton setTitle:kGYLocalString(@"+ Follow") forState:UIControlStateNormal];
        UIImage *image = [UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
            graColor.fromColor = kGYHexColor(0xFF32A1);
            graColor.toColor = kGYHexColor(0xFC5F7C);
            graColor.type = QQGradualChangeTypeLeftToRight;
        } size:CGSizeMake(265, 50) cornerRadius:QQRadiusMakeSame(25)];
        [self.followButton setBackgroundImage:image forState:UIControlStateNormal];
    }
    [self.avatarButton sd_setImageWithURL:[NSURL URLWithString:avatar] forState:UIControlStateNormal placeholderImage:kGYLiveManager.config.avatar];
    self.nameLabel.text = nickname;
    
    [inView addSubview:self];
    self.contentView.y = kGYScreenHeight;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.y = kGYScreenHeight - (kGYBottomSafeHeight + 202);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    } completion:^(BOOL finished) {
    }];
}

- (void)fb_dismiss
{
    [UIView animateWithDuration:0.1 animations:^{
        self.contentView.y = kGYScreenHeight;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}


@end
