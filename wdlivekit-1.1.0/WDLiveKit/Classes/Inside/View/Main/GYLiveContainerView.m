//
//  GYLiveContainerView.m
//  Woohoo
//
//  Created by M2-mini on 2021/8/24.
//

#import "GYLiveContainerView.h"
#import "GYLiveHeadView.h"
#import "GYLiveBarrageView.h"
#import "GYLiveControlView.h"
#import "GYLiveBannerView.h"
#import "GYLiveGoalView.h"
#import "GYLiveGoalPopView.h"
#import "GYLiveTurnPlateView.h"
#import "GYLiveTurnPlateTipView.h"
#import "GYLiveBonusView.h"
@interface GYLiveContainerView ()

/// 顶部信息视图
@property (nonatomic, strong) GYLiveHeadView *headView;
/// 弹幕
@property (nonatomic, strong) GYLiveBarrageView *barrageView;
/// 底部控制视图
@property (nonatomic, strong) GYLiveControlView *controlView;

/// 活动banner
@property (nonatomic, strong) GYLiveBannerView *bannerView;

@property (nonatomic, assign) BOOL pkLoading;

/// 目标视图
@property (nonatomic, strong) GYLiveGoalView *goalView;

@property (nonatomic, strong) GYLiveGoalPopView *goalPopView;

/// 抽奖转盘
@property(nonatomic,strong) GYLiveTurnPlateView *turnPlateView;

@property(nonatomic,strong) GYLiveTurnPlateTipView *turnPlateResultTipView;

@property(nonatomic,strong) UIButton *openTurnPlateBtn;

@property (nonatomic, strong) GYLiveBonusView *bonusView;

@property(nonatomic,strong) UIButton *openBonusBtn;
@end

@implementation GYLiveContainerView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self fb_setupDataSource];
        [self fb_setupViews];
    }
    return self;
}

#pragma mark - Init

- (void)fb_setupDataSource
{
    
}

- (void)fb_setupViews
{
    [self addSubview:self.headView];
    [self addSubview:self.barrageView];
    [self addSubview:self.goalView];

    [self addSubview:self.openTurnPlateBtn];
    if (kGYLiveManager.inside.account.rechargeAmount < 0.1 && kGYLiveManager.inside.account.coins < 0.1){
        [self addSubview:self.openBonusBtn];
    }
    [self addSubview:self.turnPlateView];
    [self addSubview:self.turnPlateResultTipView];
    
    [self fb_addActivityBannerView];
    
    [self addSubview:self.controlView];
    
    kGYWeakSelf;
    [self.turnPlateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    [self.turnPlateResultTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf).offset(-50);
        make.centerX.equalTo(weakSelf);
        make.height.mas_equalTo(68);
        make.width.mas_equalTo(169);
    }];
    
    // 第一次进入显示折扣项
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (kGYLiveManager.inside.account.rechargeAmount < 0.1) {
            NSLog(@"111");
        }
        if (kGYLiveManager.inside.account.coins < 0.1) {
            NSLog(@"222");
        }
        if (kGYLiveManager.inside.account.rechargeAmount < 0.1 && kGYLiveManager.inside.account.coins < 0.1) {
            [self showBonus];
        }
    });
    
    //
    self.headView.eventBlock = ^(GYLiveEvent event, id object) {
        weakSelf.eventBlock(event, object);
    };
    self.barrageView.eventBlock = ^(GYLiveEvent event, id object) {
        weakSelf.eventBlock(event, object);
    };
    self.controlView.eventBlock = ^(GYLiveEvent event, id object) {
        weakSelf.eventBlock(event, object);
    };
    self.goalView.openAction = ^(BOOL boolValue) {
        if (boolValue) {
            [weakSelf addSubview:weakSelf.goalPopView];
            [weakSelf.goalPopView updateUIWithModel:weakSelf.liveRoom.roomGoal];
        }else {
            [weakSelf.goalPopView removeFromSuperview];
        }
    };
    self.goalPopView.sendGiftBlock = ^{
        weakSelf.eventBlock(GYLiveEventGifts, nil);
    };
}

- (void)fb_addActivityBannerView
{
    NSArray *bannerInfo = kGYLiveManager.inside.accountConfig.voiceChatRoomBannerInfoList;
    if (bannerInfo.count > 0) {
        [self addSubview:self.bannerView];
        self.bannerView.dataArray = bannerInfo;
    }
}

#pragma mark - Public Methods

- (void)fb_event:(GYLiveEvent)event withObj:(NSObject * __nullable )obj
{
    [self.headView fb_event:event withObj:obj];
    [self.barrageView fb_event:event withObj:obj];
    
    // 接收到pk方视频
    if (event == GYLiveEventPKReceiveVideo) [self fb_beginPKWithCompletion:nil];
    
    // 开始PK
    if (event == GYLiveEventPKReceiveMatchSuccessed) [self fb_beginPKWithCompletion:nil];
    
    // PK结束
    if (event == GYLiveEventPKEnded) [self fb_endPKWithCompletion:nil];
    
    // 目标更新
    if (event == GYLiveGoalUpdate) {
        GYLiveRoomGoal *model = [[GYLiveRoomGoal alloc] initWithDictionary:(NSDictionary *)obj];
        self.liveRoom.roomGoal = model;
        [self.goalView updateUIWithModel:self.liveRoom.roomGoal];
        if (self.goalView.isOpen) {
            [self.goalPopView updateUIWithModel:self.liveRoom.roomGoal];
        }
    }
    
    // 更新banner布局
    if (event == GYLiveEventUpdatePrivateChat && [obj isKindOfClass:[GYLivePrivateChatFlagMsg class]]) {
        GYLivePrivateChatFlagMsg *private = (GYLivePrivateChatFlagMsg *)obj;
        self.bannerView.frame = GYFlipedScreenBy(private.privateChatFlag == 2 ? kGYLiveHelper.ui.pkBannerRect : kGYLiveHelper.ui.bannerRect);
    }
    
    // 转盘信息更新
    if (event == GYLiveEventTurnPlateUpdate) {
        [self.turnPlateView reciveTurnPlateInfoData:(NSDictionary*)obj];
    }
    
    // 金币更新
    if (event == GYLiveEventRechargeSuccess) {
        self.openBonusBtn.hidden = YES;
        self.bonusView.hidden = YES;
    }

}

- (void)fb_beginPKWithCompletion:(GYLiveVoidBlock __nullable)completion
{
    CGRect barrageRect = kGYLiveHelper.ui.pkBarrageRect;
    barrageRect.origin.y = barrageRect.origin.y - self.keyboardChangedHeight;
    //
    self.bannerView.frame = GYFlipedScreenBy(kGYLiveHelper.ui.pkBannerRect);
    [UIView animateWithDuration:0.15 animations:^{
        self.barrageView.frame = barrageRect;
    } completion:^(BOOL finished) {
        self.pkLoading = NO;
        if (completion) completion();
    }];
    // 开始pk关闭转盘
    [self.turnPlateView hiddenView];
    self.openTurnPlateBtn.hidden = YES;
}

- (void)fb_endPKWithCompletion:(GYLiveVoidBlock __nullable)completion
{
    CGRect barrageRect = kGYLiveHelper.ui.barrageRect;
    barrageRect.origin.y = barrageRect.origin.y - self.keyboardChangedHeight;
    //
    self.bannerView.frame = GYFlipedScreenBy(kGYLiveHelper.ui.bannerRect);
    [UIView animateWithDuration:0.15 animations:^{
        self.barrageView.frame = barrageRect;
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
    // 恢复转盘状态
    if (kGYLiveManager.inside.accountConfig.liveConfig.isTurntableFeatureOn) {
        if (self.liveRoom.turntableFlag == 1) {
            self.openTurnPlateBtn.hidden = NO;
        } else {
            self.openTurnPlateBtn.hidden = YES;
        }
    } else {
        self.openTurnPlateBtn.hidden = YES;
    }
    
}

#pragma mark - Events

/// 显示转盘
- (void)showTurnPlate:(UIButton*)btn
{
    self.openTurnPlateBtn.hidden = YES;
    UIView *subScroll = ((UIView *)(self.superview)).superview;
    UIView *cell = (UIView *)subScroll.superview;
    UIScrollView *scroll = (UIScrollView *)cell.superview;
    scroll.scrollEnabled = NO;
    [self.turnPlateView showView];
}

/// 显示折扣
- (void)showBonus
{
    BOOL hasBought = NO;
    NSInteger index = -1;
    for (int i = 0;i < kGYLiveManager.inside.accountConfig.payConfigs.count; i++) {
        if (kGYLiveManager.inside.accountConfig.payConfigs[i].type == GYRechargeTypeIAP) index = i;
    }
    if (index < 0) {
        return;
    }
    NSArray *productsArr = [kGYLiveManager.inside.accountConfig.payConfigs[index].products mutableCopy];
    for (GYIapConfig *iap in productsArr.reverseObjectEnumerator) {
        if (iap.productType == 2 && [iap.isBought isEqualToNumber:@1]) {
            hasBought = YES;
        }
    }
    if (!kGYLiveManager.inside.account.isGreen && ((kGYLiveManager.inside.account.abTestFlag&16) > 0) && !hasBought){
        UIView *subScroll = ((UIView *)(self.superview)).superview;
        UIView *cell = (UIView *)subScroll.superview;
        UIScrollView *scroll = (UIScrollView *)cell.superview;
        scroll.scrollEnabled = NO;
        [self.bonusView fb_showInView:[UIApplication sharedApplication].keyWindow withPrice:GYLiveBonusViewPrice099];
    }
}

#pragma mark - Getter

- (GYLiveHeadView *)headView
{
    if (!_headView) {
        _headView = [[GYLiveHeadView alloc] initWithFrame:kGYLiveHelper.ui.headRect];
    }
    return _headView;
}

- (GYLiveBarrageView *)barrageView
{
    if (!_barrageView) {
        _barrageView = [[GYLiveBarrageView alloc] initWithFrame:kGYLiveHelper.ui.barrageRect];
        _barrageView.backgroundColor = UIColor.clearColor;
    }
    return _barrageView;
}

- (GYLiveControlView *)controlView
{
    if (!_controlView) {
        _controlView = [[GYLiveControlView alloc] initWithFrame:kGYLiveHelper.ui.inputRect];
        _controlView.backgroundColor = UIColor.clearColor;
    }
    return _controlView;
}

- (GYLiveBannerView *)bannerView
{
    if (!_bannerView) {
        _bannerView = [[GYLiveBannerView alloc] initWithFrame:GYFlipedScreenBy(kGYLiveHelper.data.current.privateChatFlag == 2 ? kGYLiveHelper.ui.pkBannerRect : kGYLiveHelper.ui.bannerRect)];
        _bannerView.isLive = YES;
    }
    return _bannerView;
}

- (GYLiveGoalView *)goalView
{
    if (!_goalView) {
        _goalView = [[GYLiveGoalView alloc] initWithFrame:GYFlipedScreenBy(kGYLiveHelper.ui.roomGoalRect)];
    }
    return _goalView;
    
}

- (GYLiveGoalPopView *)goalPopView
{
    if (!_goalPopView) {
        _goalPopView = [[GYLiveGoalPopView alloc] initWithFrame:GYFlipedScreenBy(kGYLiveHelper.ui.roomGoalPopRect)];
    }
    return _goalPopView;
}

- (GYLiveBonusView *)bonusView
{
    if (!_bonusView) {
        _bonusView = [[GYLiveBonusView alloc] init];
        _bonusView.frame = GYFlipedScreenBy(kGYLiveHelper.ui.bonusViewRect);
        kGYWeakSelf;
        _bonusView.bonusViewDismissBlock = ^{
            UIView *subScroll = ((UIView *)(weakSelf.superview)).superview;
            UIView *cell = (UIView *)subScroll.superview;
            UIScrollView *scroll = (UIScrollView *)cell.superview;
            scroll.scrollEnabled = YES;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.bonusView fb_showInView:kGYLiveHelper.isMinimize?weakSelf:[UIApplication sharedApplication].keyWindow withPrice:GYLiveBonusViewPrice499];
                });
            });
        };
    }
    return _bonusView;
}

- (GYLiveTurnPlateView *)turnPlateView
{
    if (!_turnPlateView) {
        _turnPlateView = kGYLoadingXib(@"GYLiveTurnPlateView");
        kGYWeakSelf;
        // 主播用户自身显示隐藏大转盘回调事件
        _turnPlateView.hiddenBlock = ^{
            weakSelf.openTurnPlateBtn.hidden = NO;
            weakSelf.turnPlateView.hidden = YES;
            UIView *subScroll = ((UIView *)(weakSelf.superview)).superview;
            UIView *cell = (UIView *)subScroll.superview;
            UIScrollView *scroll = (UIScrollView *)cell.superview;
            scroll.scrollEnabled = YES;
        };
        // 主播关闭打开转盘block回调事件
        _turnPlateView.hostCloseOpenTurnPlateBlock = ^{
            if (kGYLiveManager.inside.accountConfig.liveConfig.isTurntableFeatureOn && kGYLiveHelper.data.current.turntableFlag == 1) {
                if (weakSelf.turnPlateView.isHidden) {
                    weakSelf.openTurnPlateBtn.hidden = NO;
                } else {
                    weakSelf.openTurnPlateBtn.hidden = YES;
                }
            } else {
                weakSelf.openTurnPlateBtn.hidden = YES;
                weakSelf.turnPlateView.hidden = YES;
                UIView *subScroll = ((UIView *)(weakSelf.superview)).superview;
                UIView *cell = (UIView *)subScroll.superview;
                UIScrollView *scroll = (UIScrollView *)cell.superview;
                scroll.scrollEnabled = YES;
            }
        };
        _turnPlateView.showResultBlock = ^(NSString *result) {
            [weakSelf.turnPlateResultTipView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(weakSelf).offset(-50);
                make.centerX.equalTo(weakSelf);
                make.height.mas_greaterThanOrEqualTo(68);
                make.width.mas_greaterThanOrEqualTo(169);
                make.width.mas_lessThanOrEqualTo(kScreenWidth-30);
            }];
            [UIView animateWithDuration:0.5 animations:^{
                weakSelf.turnPlateResultTipView.resultLabel.text =  [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                weakSelf.turnPlateResultTipView.hidden = NO;
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.5 animations:^{
                    weakSelf.turnPlateResultTipView.hidden = YES;
                }];
            });
        };
    }
    return _turnPlateView;
}

-(GYLiveTurnPlateTipView*)turnPlateResultTipView
{
    if (!_turnPlateResultTipView) {
        _turnPlateResultTipView = kGYLoadingXib(@"GYLiveTurnPlateTipView");
        _turnPlateResultTipView.hidden = YES;
        _turnPlateResultTipView.layer.cornerRadius = 10;
        _turnPlateResultTipView.layer.masksToBounds = YES;
    }
    return _turnPlateResultTipView;
}

-(UIButton *)openTurnPlateBtn
{
    if (!_openTurnPlateBtn) {
        _openTurnPlateBtn = [[UIButton alloc] initWithFrame:kGYLiveHelper.ui.turnPlateBtnRect];
        [_openTurnPlateBtn setImage:kGYImageNamed(@"fb_live_plate_small") forState:UIControlStateNormal];
        [_openTurnPlateBtn addTarget:self action:@selector(showTurnPlate:) forControlEvents:UIControlEventTouchUpInside];
        _openTurnPlateBtn.hidden = YES;
    }
   return _openTurnPlateBtn;
}

-(UIButton *)openBonusBtn
{
    if (!_openBonusBtn) {
        BOOL hasBought = NO;
        NSInteger index = -1;
        for (int i = 0;i < kGYLiveManager.inside.accountConfig.payConfigs.count; i++) {
            if (kGYLiveManager.inside.accountConfig.payConfigs[i].type == GYRechargeTypeIAP) index = i;
        }
        
        NSArray *productsArr = [kGYLiveManager.inside.accountConfig.payConfigs[index].products mutableCopy];
        for (GYIapConfig *iap in productsArr.reverseObjectEnumerator) {
            if (iap.productType == 2 && [iap.isBought isEqualToNumber:@1]) {
                hasBought = YES;
            }
        }
        
        if (!kGYLiveManager.inside.account.isGreen && ((kGYLiveManager.inside.account.abTestFlag&16) > 0) && !hasBought) {
            _openBonusBtn = [[UIButton alloc] initWithFrame:kGYLiveHelper.ui.openBonusBtnRect];
            [_openBonusBtn setImage:kGYImageNamed(@"fb_live_discount_bonus") forState:UIControlStateNormal];
            [_openBonusBtn addTarget:self action:@selector(showBonus) forControlEvents:UIControlEventTouchUpInside];
        }
    }
   return _openBonusBtn;
}

#pragma mark - Setter

- (void)setKeyboardChangedHeight:(CGFloat)keyboardChangedHeight
{
    _keyboardChangedHeight = keyboardChangedHeight;
    if (keyboardChangedHeight == 0) {
        // 收起键盘
        self.controlView.transform = CGAffineTransformIdentity;
        self.barrageView.transform = CGAffineTransformIdentity;
        [self.controlView fb_closeChatView];
    } else {
        // 弹起键盘
        self.controlView.transform = CGAffineTransformMakeTranslation(0, - keyboardChangedHeight);
        self.barrageView.transform = CGAffineTransformMakeTranslation(0, - keyboardChangedHeight);
        [self.controlView fb_openChatView];
    }
}

- (void)setLiveRoom:(GYLiveRoom *)liveRoom
{
    _liveRoom = liveRoom;
    
    self.headView.liveRoom = liveRoom;
    self.controlView.liveRoom = liveRoom;
    self.barrageView.liveRoom = liveRoom;
    
    // 目标
    if (liveRoom.roomGoal.goalDesc.length == 0) {
        self.goalView.hidden = YES;
    } else {
        self.goalView.hidden = NO;
        [self.goalView updateUIWithModel:liveRoom.roomGoal];
        if (self.goalView.isOpen) {
            [self.goalPopView updateUIWithModel:liveRoom.roomGoal];
        }
    }
    
    // 转盘
    [self.turnPlateView updateRoomInfo:liveRoom];
    // 控制转盘按显示
    if (kGYLiveManager.inside.accountConfig.liveConfig.isTurntableFeatureOn && !self.turnPlateView.isShowing) {//模型转换
        if (liveRoom.turntableFlag == 1) {
            self.openTurnPlateBtn.hidden = NO;
        } else {
            self.openTurnPlateBtn.hidden = YES;
        }
    } else {
        self.openTurnPlateBtn.hidden = YES;
    }
    // pk中切换房间
    if (liveRoom.pking) {
        self.turnPlateView.hiddenBlock();
        self.openTurnPlateBtn.hidden = YES;
    }
}

@end
