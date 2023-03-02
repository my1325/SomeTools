//
//  LJLiveContainerView.m
//  Woohoo
//
//  Created by M2-mini on 2021/8/24.
//

#import "LJLiveContainerView.h"
#import "LJLiveHeadView.h"
#import "LJLiveBarrageView.h"
#import "LJLiveControlView.h"
#import "LJLiveBannerView.h"
#import "LJLiveGoalView.h"
#import "LJLiveGoalPopView.h"
#import "LJLiveTurnPlateView.h"
#import "LJLiveTurnPlateTipView.h"
#import "LJLiveBonusView.h"
@interface LJLiveContainerView ()

/// 顶部信息视图
@property (nonatomic, strong) LJLiveHeadView *headView;
/// 弹幕
@property (nonatomic, strong) LJLiveBarrageView *barrageView;
/// 底部控制视图
@property (nonatomic, strong) LJLiveControlView *controlView;

/// 活动banner
@property (nonatomic, strong) LJLiveBannerView *bannerView;

@property (nonatomic, assign) BOOL pkLoading;

/// 目标视图
@property (nonatomic, strong) LJLiveGoalView *goalView;

@property (nonatomic, strong) LJLiveGoalPopView *goalPopView;

/// 抽奖转盘
@property(nonatomic,strong) LJLiveTurnPlateView *turnPlateView;

@property(nonatomic,strong) LJLiveTurnPlateTipView *turnPlateResultTipView;

@property(nonatomic,strong) UIButton *openTurnPlateBtn;

@property (nonatomic, strong) LJLiveBonusView *bonusView;

@property(nonatomic,strong) UIButton *openBonusBtn;
@end

@implementation LJLiveContainerView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self lj_setupDataSource];
        [self lj_setupViews];
    }
    return self;
}

#pragma mark - Init

- (void)lj_setupDataSource
{
    
}

- (void)lj_setupViews
{
    [self addSubview:self.headView];
    [self addSubview:self.barrageView];
    [self addSubview:self.goalView];

    [self addSubview:self.openTurnPlateBtn];
    if (kLJLiveManager.inside.account.rechargeAmount < 0.1 && kLJLiveManager.inside.account.coins < 0.1){
        [self addSubview:self.openBonusBtn];
    }
    [self addSubview:self.turnPlateView];
    [self addSubview:self.turnPlateResultTipView];
    
    [self lj_addActivityBannerView];
    
    [self addSubview:self.controlView];
    
    kLJWeakSelf;
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
        if (kLJLiveManager.inside.account.rechargeAmount < 0.1) {
            NSLog(@"111");
        }
        if (kLJLiveManager.inside.account.coins < 0.1) {
            NSLog(@"222");
        }
        if (kLJLiveManager.inside.account.rechargeAmount < 0.1 && kLJLiveManager.inside.account.coins < 0.1) {
            [self showBonus];
        }
    });
    
    //
    self.headView.eventBlock = ^(LJLiveEvent event, id object) {
        weakSelf.eventBlock(event, object);
    };
    self.barrageView.eventBlock = ^(LJLiveEvent event, id object) {
        weakSelf.eventBlock(event, object);
    };
    self.controlView.eventBlock = ^(LJLiveEvent event, id object) {
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
        weakSelf.eventBlock(LJLiveEventGifts, nil);
    };
}

- (void)lj_addActivityBannerView
{
    NSArray *bannerInfo = kLJLiveManager.inside.accountConfig.voiceChatRoomBannerInfoList;
    if (bannerInfo.count > 0) {
        [self addSubview:self.bannerView];
        self.bannerView.dataArray = bannerInfo;
    }
}

#pragma mark - Public Methods

- (void)lj_event:(LJLiveEvent)event withObj:(NSObject * __nullable )obj
{
    [self.headView lj_event:event withObj:obj];
    [self.barrageView lj_event:event withObj:obj];
    
    // 接收到pk方视频
    if (event == LJLiveEventPKReceiveVideo) [self lj_beginPKWithCompletion:nil];
    
    // 开始PK
    if (event == LJLiveEventPKReceiveMatchSuccessed) [self lj_beginPKWithCompletion:nil];
    
    // PK结束
    if (event == LJLiveEventPKEnded) [self lj_endPKWithCompletion:nil];
    
    // 目标更新
    if (event == LJLiveGoalUpdate) {
        LJLiveRoomGoal *model = [[LJLiveRoomGoal alloc] initWithDictionary:(NSDictionary *)obj];
        self.liveRoom.roomGoal = model;
        [self.goalView updateUIWithModel:self.liveRoom.roomGoal];
        if (self.goalView.isOpen) {
            [self.goalPopView updateUIWithModel:self.liveRoom.roomGoal];
        }
    }
    
    // 更新banner布局
    if (event == LJLiveEventUpdatePrivateChat && [obj isKindOfClass:[LJLivePrivateChatFlagMsg class]]) {
        LJLivePrivateChatFlagMsg *private = (LJLivePrivateChatFlagMsg *)obj;
        self.bannerView.frame = LJFlipedScreenBy(private.privateChatFlag == 2 ? kLJLiveHelper.ui.pkBannerRect : kLJLiveHelper.ui.bannerRect);
    }
    
    // 转盘信息更新
    if (event == LJLiveEventTurnPlateUpdate) {
        [self.turnPlateView reciveTurnPlateInfoData:(NSDictionary*)obj];
    }
    
    // 金币更新
    if (event == LJLiveEventRechargeSuccess) {
        self.openBonusBtn.hidden = YES;
        self.bonusView.hidden = YES;
    }

}

- (void)lj_beginPKWithCompletion:(LJLiveVoidBlock __nullable)completion
{
    CGRect barrageRect = kLJLiveHelper.ui.pkBarrageRect;
    barrageRect.origin.y = barrageRect.origin.y - self.keyboardChangedHeight;
    //
    self.bannerView.frame = LJFlipedScreenBy(kLJLiveHelper.ui.pkBannerRect);
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

- (void)lj_endPKWithCompletion:(LJLiveVoidBlock __nullable)completion
{
    CGRect barrageRect = kLJLiveHelper.ui.barrageRect;
    barrageRect.origin.y = barrageRect.origin.y - self.keyboardChangedHeight;
    //
    self.bannerView.frame = LJFlipedScreenBy(kLJLiveHelper.ui.bannerRect);
    [UIView animateWithDuration:0.15 animations:^{
        self.barrageView.frame = barrageRect;
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
    // 恢复转盘状态
    if (kLJLiveManager.inside.accountConfig.liveConfig.isTurntableFeatureOn) {
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
    for (int i = 0;i < kLJLiveManager.inside.accountConfig.payConfigs.count; i++) {
        if (kLJLiveManager.inside.accountConfig.payConfigs[i].type == LJRechargeTypeIAP) index = i;
    }
    if (index < 0) {
        return;
    }
    NSArray *productsArr = [kLJLiveManager.inside.accountConfig.payConfigs[index].products mutableCopy];
    for (LJIapConfig *iap in productsArr.reverseObjectEnumerator) {
        if (iap.productType == 2 && [iap.isBought isEqualToNumber:@1]) {
            hasBought = YES;
        }
    }
    if (!kLJLiveManager.inside.account.isGreen && ((kLJLiveManager.inside.account.abTestFlag&16) > 0) && !hasBought){
        UIView *subScroll = ((UIView *)(self.superview)).superview;
        UIView *cell = (UIView *)subScroll.superview;
        UIScrollView *scroll = (UIScrollView *)cell.superview;
        scroll.scrollEnabled = NO;
        [self.bonusView lj_showInView:[UIApplication sharedApplication].keyWindow withPrice:LJLiveBonusViewPrice099];
    }
}

#pragma mark - Getter

- (LJLiveHeadView *)headView
{
    if (!_headView) {
        _headView = [[LJLiveHeadView alloc] initWithFrame:kLJLiveHelper.ui.headRect];
    }
    return _headView;
}

- (LJLiveBarrageView *)barrageView
{
    if (!_barrageView) {
        _barrageView = [[LJLiveBarrageView alloc] initWithFrame:kLJLiveHelper.ui.barrageRect];
        _barrageView.backgroundColor = UIColor.clearColor;
    }
    return _barrageView;
}

- (LJLiveControlView *)controlView
{
    if (!_controlView) {
        _controlView = [[LJLiveControlView alloc] initWithFrame:kLJLiveHelper.ui.inputRect];
        _controlView.backgroundColor = UIColor.clearColor;
    }
    return _controlView;
}

- (LJLiveBannerView *)bannerView
{
    if (!_bannerView) {
        _bannerView = [[LJLiveBannerView alloc] initWithFrame:LJFlipedScreenBy(kLJLiveHelper.data.current.privateChatFlag == 2 ? kLJLiveHelper.ui.pkBannerRect : kLJLiveHelper.ui.bannerRect)];
        _bannerView.isLive = YES;
    }
    return _bannerView;
}

- (LJLiveGoalView *)goalView
{
    if (!_goalView) {
        _goalView = [[LJLiveGoalView alloc] initWithFrame:LJFlipedScreenBy(kLJLiveHelper.ui.roomGoalRect)];
    }
    return _goalView;
    
}

- (LJLiveGoalPopView *)goalPopView
{
    if (!_goalPopView) {
        _goalPopView = [[LJLiveGoalPopView alloc] initWithFrame:LJFlipedScreenBy(kLJLiveHelper.ui.roomGoalPopRect)];
    }
    return _goalPopView;
}

- (LJLiveBonusView *)bonusView
{
    if (!_bonusView) {
        _bonusView = [[LJLiveBonusView alloc] init];
        _bonusView.frame = LJFlipedScreenBy(kLJLiveHelper.ui.bonusViewRect);
        kLJWeakSelf;
        _bonusView.bonusViewDismissBlock = ^{
            UIView *subScroll = ((UIView *)(weakSelf.superview)).superview;
            UIView *cell = (UIView *)subScroll.superview;
            UIScrollView *scroll = (UIScrollView *)cell.superview;
            scroll.scrollEnabled = YES;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.bonusView lj_showInView:kLJLiveHelper.isMinimize?weakSelf:[UIApplication sharedApplication].keyWindow withPrice:LJLiveBonusViewPrice499];
                });
            });
        };
    }
    return _bonusView;
}

- (LJLiveTurnPlateView *)turnPlateView
{
    if (!_turnPlateView) {
        _turnPlateView = kLJLoadingXib(@"LJLiveTurnPlateView");
        kLJWeakSelf;
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
            if (kLJLiveManager.inside.accountConfig.liveConfig.isTurntableFeatureOn && kLJLiveHelper.data.current.turntableFlag == 1) {
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

-(LJLiveTurnPlateTipView*)turnPlateResultTipView
{
    if (!_turnPlateResultTipView) {
        _turnPlateResultTipView = kLJLoadingXib(@"LJLiveTurnPlateTipView");
        _turnPlateResultTipView.hidden = YES;
        _turnPlateResultTipView.layer.cornerRadius = 10;
        _turnPlateResultTipView.layer.masksToBounds = YES;
    }
    return _turnPlateResultTipView;
}

-(UIButton *)openTurnPlateBtn
{
    if (!_openTurnPlateBtn) {
        _openTurnPlateBtn = [[UIButton alloc] initWithFrame:kLJLiveHelper.ui.turnPlateBtnRect];
        [_openTurnPlateBtn setImage:kLJImageNamed(@"lj_live_plate_small") forState:UIControlStateNormal];
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
        for (int i = 0;i < kLJLiveManager.inside.accountConfig.payConfigs.count; i++) {
            if (kLJLiveManager.inside.accountConfig.payConfigs[i].type == LJRechargeTypeIAP) index = i;
        }
        
        NSArray *productsArr = [kLJLiveManager.inside.accountConfig.payConfigs[index].products mutableCopy];
        for (LJIapConfig *iap in productsArr.reverseObjectEnumerator) {
            if (iap.productType == 2 && [iap.isBought isEqualToNumber:@1]) {
                hasBought = YES;
            }
        }
        
        if (!kLJLiveManager.inside.account.isGreen && ((kLJLiveManager.inside.account.abTestFlag&16) > 0) && !hasBought) {
            _openBonusBtn = [[UIButton alloc] initWithFrame:kLJLiveHelper.ui.openBonusBtnRect];
            [_openBonusBtn setImage:kLJImageNamed(@"lj_live_discount_bonus") forState:UIControlStateNormal];
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
        [self.controlView lj_closeChatView];
    } else {
        // 弹起键盘
        self.controlView.transform = CGAffineTransformMakeTranslation(0, - keyboardChangedHeight);
        self.barrageView.transform = CGAffineTransformMakeTranslation(0, - keyboardChangedHeight);
        [self.controlView lj_openChatView];
    }
}

- (void)setLiveRoom:(LJLiveRoom *)liveRoom
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
    if (kLJLiveManager.inside.accountConfig.liveConfig.isTurntableFeatureOn && !self.turnPlateView.isShowing) {//模型转换
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
