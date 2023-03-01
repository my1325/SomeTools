//
//  GYLiveBonusView.m
//  ActionSheetPicker-3.0
//
//  Created by Mimio on 2022/9/20.
//

#import "GYLiveBonusView.h"

@interface GYLiveBonusView()
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIButton *rechargeBtn;
@property (nonatomic, strong) UILabel *coinLab;
@end

@implementation GYLiveBonusView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = kGYColorFromRGBA(0x000000, 0.3);
        self.frame = CGRectMake(0, kGYScreenHeight, kGYScreenWidth, kGYScreenHeight);
        [self fb_creatUI];
    }
    return self;
}

-(void)fb_creatUI{
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:self.bounds];
    [self addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(fb_dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *coinsBg = [[UIImageView alloc] initWithFrame:CGRectMake(29.5, 242.5, 129.5, 106)];
    coinsBg.image = kGYImageNamed(@"fb_live_discount_item");
    [self.bgView addSubview:coinsBg];
    
    UILabel *coinsTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 129.5, 12)];
    coinsTitle.textColor = UIColor.whiteColor;
    coinsTitle.font = kGYHurmeBoldFont(10);
    coinsTitle.textAlignment = NSTextAlignmentCenter;
    coinsTitle.text = kGYLocalString(@"100% Extra coins");
    [coinsBg addSubview:coinsTitle];
    
    UIImageView *coinIcon = [[UIImageView alloc] initWithFrame:CGRectMake(52, 40, 26, 26)];
    coinIcon.image = kGYImageNamed(@"fb_live_discount_coin");
    [coinsBg addSubview:coinIcon];
    
    _coinLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, 129.5, 19)];
    _coinLab.textColor = kGYColorFromRGBA(0xFF7103, 1);
    _coinLab.font = kGYHurmeBoldFont(16);
    _coinLab.textAlignment = NSTextAlignmentCenter;
    _coinLab.text = @"10+10";
    [coinsBg addSubview:_coinLab];
    
    UIImageView *vipBg = [[UIImageView alloc] initWithFrame:CGRectMake(174, 242.5, 129.5, 106)];
    vipBg.image = kGYImageNamed(@"fb_live_discount_item");
    [self.bgView addSubview:vipBg];
    
    UILabel *vipTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 129.5, 12)];
    vipTitle.textColor = UIColor.whiteColor;
    vipTitle.font = kGYHurmeBoldFont(10);
    vipTitle.textAlignment = NSTextAlignmentCenter;
    vipTitle.text = kGYLocalString(@"VIP Comment Effect");
    [vipBg addSubview:vipTitle];
    
    UIImageView *vipIcon = [[UIImageView alloc] initWithFrame:CGRectMake(38, 42.5, 50, 20.5)];
    vipIcon.image = kGYImageNamed(@"fb_live_discount_vip");
    [vipBg addSubview:vipIcon];
    
    UILabel *vipLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, 129.5, 19)];
    vipLab.textColor = kGYColorFromRGBA(0xFF7103, 1);
    vipLab.font = kGYHurmeBoldFont(16);
    vipLab.textAlignment = NSTextAlignmentCenter;
    vipLab.text = kGYLocalString(@"Permanent");
    [vipBg addSubview:vipLab];
    
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.rechargeBtn];
}

- (void)fb_showInView:(UIView *)inView withPrice:(GYLiveBonusViewPrice)price{
    GYLiveThinking(GYLiveThinkingEventTypeEvent, GYLiveThinkingEventFirstRechargeWindowAppear, nil);
    for (UIView *subview in inView.subviews) {
        if ([subview isKindOfClass:[self class]]) {
            return;
        }
    }
    [self fb_creatUI];
    [inView addSubview:self];
    if (price == GYLiveBonusViewPrice099){
        [self.rechargeBtn setTitle:@"$ 0.99" forState:UIControlStateNormal];
        self.coinLab.text = @"10+10";
    }else if (price == GYLiveBonusViewPrice499){
        [self.rechargeBtn setTitle:@"$ 4.99" forState:UIControlStateNormal];
        self.coinLab.text = @"30+30";
    }

    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.bgView.transform = CGAffineTransformMakeScale(1,1);
    self.bgView.center = CGPointMake(kGYScreenWidth/2, kGYScreenHeight/2);
    [UIView commitAnimations];


}

- (void)fb_dismiss{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.bgView.transform = CGAffineTransformMakeScale(0.01,0.01);
    self.bgView.center = CGPointMake(kGYScreenWidth - 45, 76 + kGYStatusBarHeight + 15 + 105);
    [UIView commitAnimations];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeAllSubviews];
        [self removeFromSuperview];
        if (self.bonusViewDismissBlock) self.bonusViewDismissBlock();
    });
    
}


-(void)rechargeClick{
    GYLiveThinking(GYLiveThinkingEventTypeEvent, GYLiveThinkingEventClickRechargeWindow, nil);
    if ([self.rechargeBtn.titleLabel.text isEqualToString:@"$ 0.99"]) {
        if (kGYLiveManager.delegate && [kGYLiveManager.delegate respondsToSelector:@selector(fb_click099DisCountItem)]) {
            [kGYLiveManager.delegate fb_click099DisCountItem];
        }
    }
    if ([self.rechargeBtn.titleLabel.text isEqualToString:@"$ 4.99"]) {
        if (kGYLiveManager.delegate && [kGYLiveManager.delegate respondsToSelector:@selector(fb_click499DisCountItem)]) {
            [kGYLiveManager.delegate fb_click499DisCountItem];
        }
    }
}

- (UIImageView *)bgView{
    if (!_bgView) {
        _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(kGYScreenWidth - 70, 76 + kGYStatusBarHeight + 15 + 105, 331, 460)];
        _bgView.transform = CGAffineTransformMakeScale(0.01,0.01);
        _bgView.image = kGYImageNamed(@"fb_live_discount_bg");
        _bgView.userInteractionEnabled = YES;
    }
    return _bgView;
}

- (UIButton *)rechargeBtn{
    if (!_rechargeBtn) {
        _rechargeBtn = [[UIButton alloc] initWithFrame:CGRectMake(30.5, 367, 270, 53)];
        [_rechargeBtn setBackgroundImage:kGYImageNamed(@"fb_live_discount_btn") forState:UIControlStateNormal];
        _rechargeBtn.titleLabel.font = kGYHurmeBoldFont(16);
        [_rechargeBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_rechargeBtn addTarget:self action:@selector(rechargeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rechargeBtn;
}

@end
