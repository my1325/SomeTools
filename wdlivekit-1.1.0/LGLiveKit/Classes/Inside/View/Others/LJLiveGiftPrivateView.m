//
//  LJLiveGiftPrivateView.m
//  Woohoo
//
//  Created by M2-mini on 2021/8/28.
//

#import "LJLiveGiftPrivateView.h"
#import <LGLiveKit/LGLiveKit-Swift.h>
@interface LJLiveGiftPrivateView ()
















@property (weak, nonatomic) IBOutlet UIButton *leftAvatarButton;
@property (weak, nonatomic) IBOutlet UIView *privateChatView;
@property (weak, nonatomic) IBOutlet UILabel *privateChatLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinsLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftAvatarCenterX;
@property (weak, nonatomic) IBOutlet UIButton *rightAvatarButton;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *privateLabel;
@property (nonatomic, strong) LJLiveGift *gift;
@property (weak, nonatomic) IBOutlet UIView *giftView;
@end

@implementation LJLiveGiftPrivateView

#pragma mark - Life Cycle

+ (LJLiveGiftPrivateView *)privateView
{
    LJLiveGiftPrivateView *private = kLJLoadingXib(@"LJLiveGiftPrivateView");
    private.frame = kLJScreenBounds;
    return private;
}

#pragma mark - Init



#pragma mark - Event





#pragma mark - Methods



#pragma mark - Setter


- (IBAction)maskButtonClick:(UIButton *)sender
{
    if (self.dismissBlock) self.dismissBlock();
    [self lj_dismiss];
}
- (IBAction)privateButtonClick:(UIButton *)sender
{
    if (kLJLiveManager.inside.sseStatus != 1) {
        LJTipError(kLJLocalString(@"Reconnecting, please try again later."));
        LJLiveThinking(LJLiveThinkingEventTypeEvent, LJLiveThinkingEventSseLost, nil);
        return;
    }
    if (self.privateBlock && self.gift) self.privateBlock(self.gift);
    [self lj_dismiss];
    //
    LJEvent(@"lj_LiveTouchPrivate", nil);
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self lj_setupViews];
}
- (IBAction)rightAvatarButtonClick:(UIButton *)sender
{
    if (self.rightAvatarBlock) self.rightAvatarBlock();
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
- (void)lj_showInView:(UIView *)inView
{
    [inView addSubview:self];
    self.contentView.y = kLJScreenHeight;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.y = kLJScreenHeight - (kLJBottomSafeHeight + 321);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    } completion:^(BOOL finished) {
    }];
    // 清理combo动画
    kLJLiveHelper.comboing = -1;
    [LJLiveComboViewManager.shared lj_removeCurrentViewFromSuperView];
    UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
}
- (void)setLiveRoom:(LJLiveRoom *)liveRoom
{
    _liveRoom = liveRoom;
    [self.leftAvatarButton sd_setImageWithURL:[NSURL URLWithString:kLJLiveManager.inside.account.avatar] forState:UIControlStateNormal placeholderImage:kLJLiveManager.config.avatar];
    [self.rightAvatarButton sd_setImageWithURL:[NSURL URLWithString:liveRoom.hostAvatar] forState:UIControlStateNormal placeholderImage:kLJLiveManager.config.avatar];
    self.desLabel.text = [NSString stringWithFormat:kLJLocalString(@"First 5 minutes for free, %ld coins/min after that"), liveRoom.hostCallPrice];
    //
    self.countLabel.text = @"X1";
    for (LJLiveGift *config in kLJLiveManager.inside.accountConfig.liveConfig.giftConfigs) {
        if (config.giftId == liveRoom.privateChatGiftId) {
            [self.giftImageView sd_setImageWithURL:[NSURL URLWithString:config.iconUrl] placeholderImage:kLJLiveManager.config.avatar];
            self.coinsLabel.text = @(config.giftPrice).stringValue;
            self.gift = config;
            break;
        }
    }
}
- (void)lj_setupViews
{
    self.contentView.layer.cornerRadius = 12;
    self.contentViewHeight.constant = 12 + kLJBottomSafeHeight + 321;
    //
    [self.privateChatView setLayerShadow:kLJColorFromRGBA(0xFF9EB1, 0.56) offset:CGSizeMake(0, 5) radius:8];
    CGFloat width = kLJWidthScale(326);
    UIImage *image = [UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
        graColor.fromColor = kLJHexColor(0xFF32A1);
        graColor.toColor = kLJHexColor(0xFC5F7C);
        graColor.type = QQGradualChangeTypeLeftToRight;
    } size:CGSizeMake(width, 68) cornerRadius:QQRadiusMakeSame(34)];
    [self.privateChatView setBackgroundColor:[UIColor colorWithPatternImage:image]];
    //
    UIImage *giftBgdImage = [UIImage imageWithQQCorner:^(QQCorner *corner) {
        corner.fillColor = UIColor.whiteColor;
        corner.radius = (kLJLiveManager.inside.appRTL && kLJLiveManager.config.flipRTLEnable) ? QQRadiusMake(0, 31, 0, 31) : QQRadiusMake(31, 0, 31, 0);
    } size:CGSizeMake(kLJWidthScale(120), 62)];
    [self.giftView setBackgroundColor:[UIColor colorWithPatternImage:giftBgdImage]];
    //
    self.leftAvatarButton.layer.masksToBounds = YES;
    self.leftAvatarButton.layer.cornerRadius = 55/2;
    self.leftAvatarButton.layer.borderWidth = 2;
    self.leftAvatarButton.layer.borderColor = UIColor.whiteColor.CGColor;
    self.rightAvatarButton.layer.masksToBounds = YES;
    self.rightAvatarButton.layer.cornerRadius = 55/2;
    self.rightAvatarButton.layer.borderWidth = 2;
    self.rightAvatarButton.layer.borderColor = UIColor.whiteColor.CGColor;
    self.leftAvatarButton.transform = CGAffineTransformMakeRotation(-M_PI_4);
    self.rightAvatarButton.transform = CGAffineTransformMakeRotation(M_PI_4);
    self.leftAvatarButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.rightAvatarButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    //
    self.leftAvatarCenterX.constant = (kLJLiveManager.inside.appRTL && kLJLiveManager.config.flipRTLEnable) ? 42 : -42;
    self.privateChatLabel.text = kLJLocalString(@"Private video chat");
    self.desLabel.text = [NSString stringWithFormat:kLJLocalString(@"First 5 minutes for free, %ld coins/min after that"), kLJLiveHelper.data.current.hostCallPrice];
    self.privateLabel.text = kLJLocalString(@"Start the private chat");
}
- (IBAction)leftAvatarButtonClick:(UIButton *)sender
{
    if (self.leftAvatarBlock) self.leftAvatarBlock();
}
@end
