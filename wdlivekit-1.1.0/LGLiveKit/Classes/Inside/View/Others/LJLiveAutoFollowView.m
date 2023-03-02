//
//  LJLiveAutoFollowView.m
//  Woohoo
//
//  Created by M2-mini on 2021/8/28.
//

#import "LJLiveAutoFollowView.h"

@interface LJLiveAutoFollowView ()








@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (nonatomic, assign) BOOL isFollowed;
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@end

@implementation LJLiveAutoFollowView

#pragma mark - Life Cycle

+ (LJLiveAutoFollowView *)followView
{
    LJLiveAutoFollowView *follow = kLJLoadingXib(@"LJLiveAutoFollowView");
    follow.frame = kLJScreenBounds;
    return follow;
}

#pragma mark - Init



#pragma mark - Events




#pragma mark - Methods




- (IBAction)avatarButtonClick:(UIButton *)sender
{
    if (self.avatarBlock) self.avatarBlock();
}
- (void)lj_showAvatar:(NSString *)avatar
             nickname:(NSString *)nickname
               follow:(BOOL)follow
               inView:(UIView *)inView
{
    NSString *desc = kLJLiveHelper.data.current.hostMood.length == 0 ? kLJLiveManager.config.mood : kLJLiveHelper.data.current.hostMood;
    self.descLabel.text = desc;
    CGSize size = kLJTextSize_MutiLine(desc, kLJHurmeRegularFont(12), CGSizeMake(kLJScreenWidth-45*2, MAXFLOAT));
    self.contentViewHeight.constant = 12 + kLJBottomSafeHeight + 202-29 + size.height;
    self.isFollowed = follow;
    if (follow) {
        // 已关注
        [self.followButton setTitle:kLJLocalString(@"Followed") forState:UIControlStateNormal];
        UIImage *image = [UIImage imageWithQQCorner:^(QQCorner *corner) {
            corner.fillColor = kLJHexColor(0xDDE0E4);
            corner.radius = QQRadiusMakeSame(25);
        } size:CGSizeMake(265, 50)];
        [self.followButton setBackgroundImage:image forState:UIControlStateNormal];
    } else {
        // 未关注
        [self.followButton setTitle:kLJLocalString(@"+ Follow") forState:UIControlStateNormal];
        UIImage *image = [UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
            graColor.fromColor = kLJHexColor(0xFF32A1);
            graColor.toColor = kLJHexColor(0xFC5F7C);
            graColor.type = QQGradualChangeTypeLeftToRight;
        } size:CGSizeMake(265, 50) cornerRadius:QQRadiusMakeSame(25)];
        [self.followButton setBackgroundImage:image forState:UIControlStateNormal];
    }
    [self.avatarButton sd_setImageWithURL:[NSURL URLWithString:avatar] forState:UIControlStateNormal placeholderImage:kLJLiveManager.config.avatar];
    self.nameLabel.text = nickname;
    
    [inView addSubview:self];
    self.contentView.y = kLJScreenHeight;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.y = kLJScreenHeight - (kLJBottomSafeHeight + 202);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    } completion:^(BOOL finished) {
    }];
}
- (IBAction)followButtonClick:(UIButton *)sender
{
    self.isFollowed = !self.isFollowed;
    
    [UIView animateWithDuration:0.4 animations:^{
        [self.followButton setTitle:kLJLocalString(@"Followed") forState:UIControlStateNormal];
        UIImage *image = [UIImage imageWithQQCorner:^(QQCorner *corner) {
            corner.fillColor = kLJHexColor(0xDDE0E4);
            corner.radius = QQRadiusMakeSame(25);
        } size:CGSizeMake(265, 50)];
        [self.followButton setBackgroundImage:image forState:UIControlStateNormal];
    }];
    
    if (self.followBlock) self.followBlock(self.isFollowed);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self lj_dismiss];
    });
    
    if (self.isFollowed) {
        LJEvent(@"lj_LiveTouchFollowBy1Min", nil);
    }
}
- (IBAction)maskButtonClick:(UIButton *)sender
{
    if (self.dimissBlock) self.dimissBlock();
    [self lj_dismiss];
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self lj_setupViews];
}
- (void)lj_dismiss
{
    [UIView animateWithDuration:0.1 animations:^{
        self.contentView.y = kLJScreenHeight;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}
- (void)lj_setupViews
{
    self.contentView.layer.cornerRadius = 12;
    self.avatarButton.layer.masksToBounds = YES;
    self.avatarButton.layer.cornerRadius = 86/2;
    self.avatarButton.layer.borderWidth = 2;
    self.avatarButton.layer.borderColor = UIColor.whiteColor.CGColor;
    self.contentViewHeight.constant = 12 + kLJBottomSafeHeight + 202;
    //
    self.avatarButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
}
@end
