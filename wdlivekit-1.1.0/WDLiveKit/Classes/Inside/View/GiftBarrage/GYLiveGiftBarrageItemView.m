//
//  GYLiveGiftBarrageItemView.m
//  Woohoo
//
//  Created by M2-mini on 2021/9/14.
//

#import "GYLiveGiftBarrageItemView.h"

@interface GYLiveGiftBarrageItemView ()

@property (weak, nonatomic) IBOutlet UIImageView *bgdImageView;

@property (weak, nonatomic) IBOutlet UIButton *avatarButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;

@property (weak, nonatomic) IBOutlet UIView *comboView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *comboViewLeft;

@property (weak, nonatomic) IBOutlet UILabel *sendGiftLabel;

@property (nonatomic, strong) NSMutableArray *comboViews;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger countdown;

@end

@implementation GYLiveGiftBarrageItemView

#pragma mark - Life Cycle

+ (GYLiveGiftBarrageItemView *)giftBarrageWithFrame:(CGRect)frame
{
    GYLiveGiftBarrageItemView *item = kGYLoadingXib(@"GYLiveGiftBarrageItemView");
    item.frame = frame;
    return item;
}

#pragma mark - Init

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self fb_setupViews];
}

- (void)fb_setupViews
{
    self.comboViews = [@[] mutableCopy];
    self.avatarButton.layer.masksToBounds = YES;
    self.avatarButton.layer.cornerRadius = 18;
    self.avatarButton.layer.borderWidth = 2;
    self.avatarButton.layer.borderColor = UIColor.whiteColor.CGColor;
    self.avatarButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    //
    kGYWeakSelf;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (weakSelf.countdown == 0) {
            // 执行消失操作
            [weakSelf fb_dismissToLeftWithCompletion:^{
                if (weakSelf.dismissBlock) weakSelf.dismissBlock();
            }];
        }
        weakSelf.countdown--;
    }];
    [self.timer setFireDate:[NSDate distantFuture]];
    //
    self.bgdImageView.image = [kGYImageNamed(@"fb_live_giftbarrage_bgd_icon") fb_flipedByRTL];
    if (kGYLiveManager.inside.appRTL && kGYLiveManager.config.flipRTLEnable) self.comboViewLeft.constant = 200;
    self.sendGiftLabel.text = kGYLocalString(@"Send gift");
}



- (void)fb_configComboView
{
    for (UIView *subview in self.comboViews) {
        [subview removeFromSuperview];
    }
    [self.comboViews removeAllObjects];
    //
    UIImageView *iv_x = [[UIImageView alloc] initWithImage:kGYImageNamed(@"fb_live_giftNum_x")];
    iv_x.contentMode = UIViewContentModeBottom;
    [self.comboView addSubview:iv_x];
    [self.comboViews addObject:iv_x];
    //
    NSString *comboString = @(self.gift.combo).stringValue;
    int comboLength = (int)comboString.length;
    for (int i = 0; i < comboLength; i++) {
        NSString *diget = [comboString substringToIndex:1];
        if (diget.length == 0) {
        } else {
            //
            NSString *imagename = [NSString stringWithFormat:@"fb_live_giftNum_%ld", diget.integerValue];
            UIImage *image = kGYImageNamed(imagename);
            UIImageView *iv_n = [[UIImageView alloc] initWithImage:image];
            [self.comboView addSubview:iv_n];
            [self.comboViews addObject:iv_n];
        }
        comboString = [comboString substringFromIndex:1];
    }
}

- (void)fb_updateConstraints
{
    UIImageView *last;
    for (int i = 0; i < self.comboViews.count; i++) {
        UIImageView *comboView = (kGYLiveManager.inside.appRTL && kGYLiveManager.config.flipRTLEnable) ? self.comboViews[self.comboViews.count-1 - i] : self.comboViews[i];
        [comboView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.leading.mas_equalTo(@(0));
                make.size.mas_equalTo((kGYLiveManager.inside.appRTL && kGYLiveManager.config.flipRTLEnable) ? CGSizeMake(15, 20) : CGSizeMake(25/2, 22/2));
            } else {
                make.size.mas_equalTo((kGYLiveManager.inside.appRTL && self.comboViews.count-1 == i) ? CGSizeMake(25/2, 22/2) : CGSizeMake(15, 20));
                make.leading.equalTo(last.mas_trailing).offset(0);
            }
            make.bottom.mas_equalTo(@(0));
        }];
        last = comboView;
    }
}

- (IBAction)avatarButtonClick:(UIButton *)sender
{
    
}

#pragma mark - Methods

- (void)fb_loadingFromLeftWithDismissDelay:(NSTimeInterval)delay
                                completion:(GYLiveVoidBlock)completion
{
    // 开始定时器
    self.countdown = delay;
    [self.timer setFireDate:[NSDate distantPast]];
    // 显示UI
    if (self.isLoading) {
    } else {
        self.hidden = NO;
        self.isLoading = YES;
        [UIView animateWithDuration:0.3 animations:^{
            if (kGYLiveManager.inside.appRTL && kGYLiveManager.config.flipRTLEnable) {
                self.transform = CGAffineTransformMakeTranslation(-(250 + kGYWidthScale(15)), 0);
            } else {
                self.transform = CGAffineTransformMakeTranslation(250 + kGYWidthScale(15), 0);
            }
        } completion:^(BOOL finished) {
            if (completion) completion();
        }];
    }
}

- (void)fb_dismissToLeftWithCompletion:(GYLiveVoidBlock)completion
{
    // 暂停定时器
    [self.timer setFireDate:[NSDate distantFuture]];
    // 消失UI
    if (!self.isLoading) {
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.hidden = YES;
            self.isLoading = NO;
            if (completion) completion();
        }];
    }
}

- (void)fb_comboScaleAnimation
{
    [UIView animateWithDuration:0.1
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:12
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        self.comboView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2
                              delay:0
             usingSpringWithDamping:1
              initialSpringVelocity:15
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
            self.comboView.transform = CGAffineTransformMake(1.35, 0, 0, 1.35, 100/4, 0);
        } completion:^(BOOL finished) {
        }];
    }];
}

#pragma mark - Getter

#pragma mark - Setter

- (void)setGift:(GYLiveBarrage *)giftBarrage
{
    _gift = giftBarrage;
    //
    [self.avatarButton sd_setImageWithURL:[NSURL URLWithString:giftBarrage.avatar] forState:UIControlStateNormal placeholderImage:kGYLiveManager.config.avatar];
    self.nameLabel.text = giftBarrage.userName;
    GYLiveGift *giftConfig;
    for (GYLiveGift *config in kGYLiveManager.inside.accountConfig.liveConfig.giftConfigs) {//模型转换2
        if (giftBarrage.giftId == config.giftId) {
            giftConfig = config;
            break;
        }
    }
    // 兼容老版本礼物
    if (!giftConfig) {
        for (GYLiveGift *config in kGYLiveManager.inside.accountConfig.liveConfig.videoChatRoomReplacedGiftConfigs) {//模型转换
            if (giftBarrage.giftId == config.giftId) {
                giftConfig = config;
                break;
            }
        }
    }
    if (giftConfig) {
        [self.giftImageView sd_setImageWithURL:[NSURL URLWithString:giftConfig.iconUrl]];
    }
    //
    [self fb_configComboView];
    [self fb_updateConstraints];
    [self fb_comboScaleAnimation];
}

@end
