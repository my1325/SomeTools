//
//  GYLiveGiftPrivateView.m
//  Woohoo
//
//  Created by M2-mini on 2021/8/28.
//

#import "GYLiveGiftPrivateView.h"
#import <WDLiveKit/WDLiveKit-Swift.h>
@interface GYLiveGiftPrivateView ()

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UIButton *leftAvatarButton;

@property (weak, nonatomic) IBOutlet UIButton *rightAvatarButton;

@property (weak, nonatomic) IBOutlet UIView *privateChatView;

@property (weak, nonatomic) IBOutlet UIView *giftView;

@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UILabel *coinsLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftAvatarCenterX;

@property (weak, nonatomic) IBOutlet UILabel *privateChatLabel;

@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@property (weak, nonatomic) IBOutlet UILabel *privateLabel;

@property (nonatomic, strong) GYLiveGift *gift;

@end

@implementation GYLiveGiftPrivateView

#pragma mark - Life Cycle

+ (GYLiveGiftPrivateView *)privateView
{
    GYLiveGiftPrivateView *private = kGYLoadingXib(@"GYLiveGiftPrivateView");
    private.frame = kGYScreenBounds;
    return private;
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
    self.contentViewHeight.constant = 12 + kGYBottomSafeHeight + 321;
    //
    [self.privateChatView setLayerShadow:kGYColorFromRGBA(0xFF9EB1, 0.56) offset:CGSizeMake(0, 5) radius:8];
    CGFloat width = kGYWidthScale(326);
    UIImage *image = [UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
        graColor.fromColor = kGYHexColor(0xFF32A1);
        graColor.toColor = kGYHexColor(0xFC5F7C);
        graColor.type = QQGradualChangeTypeLeftToRight;
    } size:CGSizeMake(width, 68) cornerRadius:QQRadiusMakeSame(34)];
    [self.privateChatView setBackgroundColor:[UIColor colorWithPatternImage:image]];
    //
    UIImage *giftBgdImage = [UIImage imageWithQQCorner:^(QQCorner *corner) {
        corner.fillColor = UIColor.whiteColor;
        corner.radius = (kGYLiveManager.inside.appRTL && kGYLiveManager.config.flipRTLEnable) ? QQRadiusMake(0, 31, 0, 31) : QQRadiusMake(31, 0, 31, 0);
    } size:CGSizeMake(kGYWidthScale(120), 62)];
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
    self.leftAvatarCenterX.constant = (kGYLiveManager.inside.appRTL && kGYLiveManager.config.flipRTLEnable) ? 42 : -42;
    self.privateChatLabel.text = kGYLocalString(@"Private video chat");
    self.desLabel.text = [NSString stringWithFormat:kGYLocalString(@"First 5 minutes for free, %ld coins/min after that"), kGYLiveHelper.data.current.hostCallPrice];
    self.privateLabel.text = kGYLocalString(@"Start the private chat");
}

#pragma mark - Event

- (IBAction)maskButtonClick:(UIButton *)sender
{
    if (self.dismissBlock) self.dismissBlock();
    [self fb_dismiss];
}

- (IBAction)leftAvatarButtonClick:(UIButton *)sender
{
    if (self.leftAvatarBlock) self.leftAvatarBlock();
}

- (IBAction)rightAvatarButtonClick:(UIButton *)sender
{
    if (self.rightAvatarBlock) self.rightAvatarBlock();
}

- (IBAction)privateButtonClick:(UIButton *)sender
{
    if (kGYLiveManager.inside.sseStatus != 1) {
        GYTipError(kGYLocalString(@"Reconnecting, please try again later."));
        GYLiveThinking(GYLiveThinkingEventTypeEvent, GYLiveThinkingEventSseLost, nil);
        return;
    }
    if (self.privateBlock && self.gift) self.privateBlock(self.gift);
    [self fb_dismiss];
    //
    GYEvent(@"fb_LiveTouchPrivate", nil);
}

#pragma mark - Methods

- (void)fb_showInView:(UIView *)inView
{
    [inView addSubview:self];
    self.contentView.y = kGYScreenHeight;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.y = kGYScreenHeight - (kGYBottomSafeHeight + 321);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    } completion:^(BOOL finished) {
    }];
    // 清理combo动画
    kGYLiveHelper.comboing = -1;
    [GYLiveComboViewManager.shared fb_removeCurrentViewFromSuperView];
    UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
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

#pragma mark - Setter

- (void)setLiveRoom:(GYLiveRoom *)liveRoom
{
    _liveRoom = liveRoom;
    [self.leftAvatarButton sd_setImageWithURL:[NSURL URLWithString:kGYLiveManager.inside.account.avatar] forState:UIControlStateNormal placeholderImage:kGYLiveManager.config.avatar];
    [self.rightAvatarButton sd_setImageWithURL:[NSURL URLWithString:liveRoom.hostAvatar] forState:UIControlStateNormal placeholderImage:kGYLiveManager.config.avatar];
    self.desLabel.text = [NSString stringWithFormat:kGYLocalString(@"First 5 minutes for free, %ld coins/min after that"), liveRoom.hostCallPrice];
    //
    self.countLabel.text = @"X1";
    for (GYLiveGift *config in kGYLiveManager.inside.accountConfig.liveConfig.giftConfigs) {
        if (config.giftId == liveRoom.privateChatGiftId) {
            [self.giftImageView sd_setImageWithURL:[NSURL URLWithString:config.iconUrl] placeholderImage:kGYLiveManager.config.avatar];
            self.coinsLabel.text = @(config.giftPrice).stringValue;
            self.gift = config;
            break;
        }
    }
}

@end
