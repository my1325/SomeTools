//
//  GYLiveControlGiftsView.m
//  Woohoo
//
//  Created by M2-mini on 2021/8/28.
//

#import "GYLiveControlGiftsView.h"
#import "GYLiveControlGiftsItemCell.h"
#import "GYLiveLBoxExplainView.h"
#import "GYLiveStripePageControl.h"
#import <WDLiveKit/WDLiveKit-Swift.h>
static NSInteger const kGYCollectionViewsTag = 289;
static NSString *const kGYCellID = @"GYLiveControlGiftsViewCellID";

@interface GYLiveControlGiftsView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GYLivePageMenuDelegate>

@property (nonatomic, strong) UIButton *maskButton;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIImageView *coinsImageView, *rightImageView;

@property (nonatomic, strong) UILabel *coinsLabel;

@property (nonatomic, strong) UIButton *rechargeButton;

@property (nonatomic, strong) GYLiveStripePageControl *pageControl;

@property (nonatomic, assign) BOOL isEnough;

@property (nonatomic, strong) UIButton *luckyBoxBtn;

@property (nonatomic, strong) UIButton *closeBoxBtn;

@property (nonatomic, strong) GYLivePageMenu *pageMenu;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *collectionViews;

@property (nonatomic, strong) NSMutableArray *tagViews;

@end

@implementation GYLiveControlGiftsView

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
    self.collectionViews = [@[] mutableCopy];
    self.tagViews = [@[] mutableCopy];
}

- (void)fb_setupViews
{
    self.backgroundColor = UIColor.clearColor;
//    // 高斯模糊
//    UIBlurEffect *blur;
//    if (@available(iOS 13.0, *)) {
//        blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterialDark];
//    } else {
//        blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    }
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
//    effectView.frame = self.contentView.bounds;
//    effectView.contentView.backgroundColor = kGYColorFromRGBA(0x270F42, 0.7);
    self.contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    //
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 12;
    //
    [self addSubview:self.maskButton];
    [self addSubview:self.contentView];
//    [self.contentView addSubview:effectView];
    
    [self.contentView addSubview:self.scrollView];
    [self.contentView addSubview:self.rightImageView];
    [self.contentView addSubview:self.coinsLabel];
    [self.contentView addSubview:self.coinsImageView];
    [self.contentView addSubview:self.rechargeButton];
    [self.contentView addSubview:self.pageControl];
    [self.contentView addSubview:self.pageMenu];
    
    [self fb_adjustView:self.scrollView];
}

- (void)fb_updateConstraints
{
    kGYWeakSelf;
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(@(105*2 + 15*2 + 7));
    }];
    [self.rightImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(7));
        make.height.mas_equalTo(@(13));
        make.trailing.equalTo(weakSelf.contentView).offset(-15);
        make.top.equalTo(weakSelf.scrollView.mas_bottom).offset(35);
    }];
    [self.coinsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(weakSelf.rightImageView.mas_leading).offset(-5);
        make.centerY.equalTo(weakSelf.rightImageView);
    }];
    [self.coinsImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17, 17));
        make.trailing.equalTo(weakSelf.coinsLabel.mas_leading).offset(-5);
        make.centerY.equalTo(weakSelf.coinsLabel);
    }];
    [self.rechargeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.coinsLabel);
        make.trailing.equalTo(weakSelf.rightImageView);
        make.height.mas_equalTo(@(40));
        make.centerY.equalTo(weakSelf.rightImageView);
    }];
    [self.pageControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 40));
        make.top.equalTo(weakSelf.scrollView.mas_bottom).offset(-15);
        make.centerX.equalTo(weakSelf.contentView);
    }];
    [self.pageMenu mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(@(0));
        make.trailing.equalTo(weakSelf.coinsImageView.mas_leading).offset(-5);
        make.centerY.equalTo(weakSelf.rightImageView);
        make.height.mas_equalTo(@(40));
    }];
    //
    for (int i = 0; i < self.collectionViews.count; i++) {
        UICollectionView *cv = self.collectionViews[i];
        [cv mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(@(i * kGYScreenWidth));
            make.size.equalTo(weakSelf.scrollView);
            make.top.equalTo(weakSelf.scrollView);
        }];
        // RTL
        if (kGYLiveManager.inside.appRTL && kGYLiveManager.config.flipRTLEnable) {
            cv.transform = CGAffineTransformMakeRotation(M_PI);
        }
    }
    //
    for (int i = 0; i < self.tagViews.count; i++) {
        UIImageView *tag = self.tagViews[i];
        UIView *itemView = self.pageMenu.itemScrollView.subviews[i];
        [tag mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(21, 10));
            make.leading.equalTo(itemView.mas_trailing).offset(-7);
            make.top.equalTo(itemView).offset(3);
        }];
    }
    // RTL
    if (kGYLiveManager.inside.appRTL && kGYLiveManager.config.flipRTLEnable) {
        self.pageControl.transform = CGAffineTransformMakeRotation(M_PI);
        self.scrollView.transform = CGAffineTransformMakeRotation(M_PI);
    }
}

#pragma mark - Events

- (void)maskButtonClick:(UIButton *)sender
{
    [self fb_dismiss];
}

- (void)rechargeButtonClick:(UIButton *)sender
{
    if (self.eventBlock) self.eventBlock(GYLiveEventWallet, nil);
    [self fb_dismiss];
    //
    if (!self.isEnough) {
        GYEvent(@"fb_LiveNotEnoughCoinsTouchRechargeInGifts", nil);
    }
    GYEvent(@"fb_LiveTouchRechargeByGifts", nil);
}

- (void)luckyBoxAction:(UIButton *)sender
{
    GYEvent(@"fb_clickBlindboxRules", nil);
    GYLiveLBoxExplainView *view = [GYLiveLBoxExplainView luckyboxExplainView];
    [view showInView:[GYLiveMethods fb_currentViewController].view];
    [kGYUserDefaults setBool:YES forKey:kGYLiveLuckyBoxClicked];
    self.closeBoxBtn.hidden = NO;
}

- (void)closeBoxAction:(UIButton *)sender
{
    [kGYUserDefaults setBool:YES forKey:kGYLiveLuckyBoxCloseClicked];
    [self.luckyBoxBtn removeFromSuperview];
}

#pragma mark - GYLivePageMenuDelegate

- (void)pageMenu:(GYLivePageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    GYLiveGiftConfig *config = self.configs[toIndex];
    self.pageControl.numbersOfPage = ceil(config.gifts.count/8.0);
    
    // 隐藏标签
    UIImageView *tag = self.tagViews[toIndex];
    if (!tag.isHidden) {
        [GYLiveNetworkHelper fb_setGiftViewdByTitle:config.title success:nil failure:nil];
        tag.hidden = YES;
        //
        for (GYLiveGiftConfig *gift in kGYLiveHelper.data.current.gifts) {
            if ([gift.title isEqualToString:config.title]) {
                gift.tagIconUrl = @"";
                break;
            }
        }
    }
    
    NSInteger currentTag = 0;
    for (int i = 0; i < self.configs.count; i++) {
        GYLiveGiftConfig *config = self.configs[i];
        NSInteger count = ceil(config.gifts.count/8.0);
        for (int j = 0; j < count; j++) {
            if (i == toIndex) {
                
                NSInteger index = self.scrollView.contentOffset.x / kGYScreenWidth;
                if (index < currentTag + count &&
                    index >= currentTag) {
                } else {
                    self.pageControl.currentPage = 0;
                    [self.scrollView setContentOffset:CGPointMake(kGYScreenWidth * currentTag, 0) animated:YES];
                }
                // 4 <= a < 4+1
                return;
            }
            currentTag ++;
        }
    }
    
    
    if (fromIndex == toIndex) {
    } else {
        // 清理combo动画
        kGYLiveHelper.comboing = -1;
        [GYLiveComboViewManager.shared fb_removeCurrentViewFromSuperView];
        UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
    }
}

#pragma mark - UICollectionViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 清理combo动画
    kGYLiveHelper.comboing = -1;
    [GYLiveComboViewManager.shared fb_removeCurrentViewFromSuperView];
    UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / kGYScreenWidth;
    
    NSInteger currentTag = 0;
    for (int i = 0; i < self.configs.count; i++) {
        GYLiveGiftConfig *config = self.configs[i];
        NSInteger count = ceil(config.gifts.count/8.0);
        for (int j = 0; j < count; j++) {
            if (currentTag == index) {
                
                if (self.pageMenu.selectedItemIndex != i) {
                    self.pageMenu.selectedItemIndex = i;
                }
                self.pageControl.currentPage = j;
                
                return;
            }
            currentTag ++;
        }
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger idx = collectionView.tag - kGYCollectionViewsTag;
    GYLiveGiftConfig *config;
    
    NSMutableArray *marr = [@[] mutableCopy];
    NSInteger a = 0;
    for (GYLiveGiftConfig *model in self.configs) {
        NSInteger count = ceil(model.gifts.count / 8.0);
        for (int i = 0; i < count; i++) {
            if (a == idx) {
                config = model;
                NSInteger length = i*8 + 8 > model.gifts.count ? model.gifts.count - i*8 : 8;
                [marr addObjectsFromArray:[model.gifts subarrayWithRange:NSMakeRange(i*8, length)]];
                break;
            }
            a ++;
        }
        if (marr.count > 0) break;
    }
    
    BOOL isDual = indexPath.row % 2 == 0;
    NSInteger index = indexPath.row;
    if (isDual) {
        index = indexPath.row / 2 + indexPath.section * 8;
    } else {
        index = indexPath.row + 4 - (indexPath.row + 1) / 2 + indexPath.section * 8;
    }
    NSString *cellId = [NSString stringWithFormat:@"%@_%ld", kGYCellID, idx];
    GYLiveControlGiftsItemCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (index > marr.count-1) {
        // 占位
        item.hidden = YES;
    } else {
        item.hidden = NO;
        GYLiveGift *gift = marr[index];
        item.giftConfig = gift;
        // svip & 盲盒
        BOOL isClosed = [kGYUserDefaults boolForKey:kGYLiveLuckyBoxCloseClicked];
        item.topRightButton.hidden = YES;
        if (config && [[config.title lowercaseString] isEqualToString:@"svip"]) {
            if (kGYLiveManager.inside.account.svipInfo.isSVip) {
                if (gift.isBlindBox && isClosed) {
                    item.topRightButton.hidden = NO;
                    [item.topRightButton setImage:kGYImageNamed(@"fb_live_luckybox_?") forState:UIControlStateNormal];
                    //
                    item.clickBlindboxDetail = ^{
                        GYEvent(@"fb_clickBlindboxQuestion", nil);
                        GYLiveLBoxExplainView *view = [GYLiveLBoxExplainView luckyboxExplainView];
                        [view showInView:[GYLiveMethods fb_currentViewController].view];
                    };
                }
                item.giftImageView.alpha = 1;
            } else {
                item.topRightButton.hidden = NO;
                [item.topRightButton setImage:kGYImageNamed(@"fb_live_gift_lock_icon") forState:UIControlStateNormal];
                item.giftImageView.alpha = 0.65;
            }
        }
    }
    
    item.sendGiftBlock = ^{
        [collectionView.delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    };
    return item;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger idx = collectionView.tag - kGYCollectionViewsTag;
    GYLiveGiftConfig *config;
    
    NSMutableArray *marr = [@[] mutableCopy];
    NSInteger a = 0;
    for (GYLiveGiftConfig *model in self.configs) {
        NSInteger count = ceil(model.gifts.count / 8.0);
        for (int i = 0; i < count; i++) {
            if (a == idx) {
                config = model;
                NSInteger length = i*8 + 8 > model.gifts.count ? model.gifts.count - i*8 : 8;
                [marr addObjectsFromArray:[model.gifts subarrayWithRange:NSMakeRange(i*8, length)]];
                break;
            }
            a ++;
        }
        if (marr.count > 0) break;
    }
    
    // svip
    if (config && [[config.title lowercaseString] isEqualToString:@"svip"] && !kGYLiveManager.inside.account.svipInfo.isSVip) {
        if (kGYLiveManager.delegate && [kGYLiveManager.delegate respondsToSelector:@selector(fb_toDisplaySvipRechargePage)]) {
            [kGYLiveManager.delegate fb_toDisplaySvipRechargePage];
        }
        [self fb_dismiss];
        return;
    }
    
    BOOL isDual = indexPath.row % 2 == 0;
    NSInteger index = 0;
    if (isDual) {
        index = indexPath.row / 2 + indexPath.section * 8;
    } else {
        index = indexPath.row + 4 - (indexPath.row + 1) / 2 + indexPath.section * 8;
    }
    if (kGYLiveManager.inside.networkStatus == 0) {
        GYTipError(kGYLocalString(@"Please check your network."));
        return;
    }
    
    if (index > marr.count-1) {
    } else {
        GYLiveGift *gift = marr[index];
        
        if (self.eventBlock) self.eventBlock(GYLiveEventSendGift, gift);
        // 刷新UI
        NSInteger coins = kGYLiveManager.inside.account.coins - gift.giftPrice;
        self.isEnough = coins >= 0;
        if (self.isEnough) {
            //
            coins = MAX(coins, 0);
            kGYLiveManager.inside.account.coins = coins;
            
            self.coinsLabel.text = @(coins).stringValue;
            [self fb_updateConstraints];
            // combo动画
            if (gift.comboIconUrl.length > 0) {
                UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
                [GYLiveComboViewManager.shared fb_clickedGiftWithGiftId:gift.giftId roomId:kGYLiveHelper.data.current.hostAccountId frame:[cell convertRect:cell.bounds toView:self.superview] containerView:self.superview isQuick:NO numberFont:kGYHurmeBoldFont(16)];
            }
        } else {
            // 清理combo动画
            kGYLiveHelper.comboing = -1;
            [GYLiveComboViewManager.shared fb_removeCurrentViewFromSuperView];
            UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
        }
        
        if (gift.isBlindBox) {
            GYEvent(@"fb_liveClickLuckyBox", nil);
        }
        GYLiveThinking(GYLiveThinkingEventTypeEvent, GYLiveThinkingEventClickGift, (@{
            GYLiveThinkingKeyGiftId: @(gift.giftId).stringValue,
            GYLiveThinkingKeyGiftName: gift.giftName,
            GYLiveThinkingKeyGiftCoins: @(gift.giftPrice),
            GYLiveThinkingKeyIsLuckyBox: @(gift.isBlindBox),
            GYLiveThinkingKeyIsFast: @(index == 0),
            GYLiveThinkingKeyFrom: GYLiveThinkingValueLive
        }));
    }
}

#pragma mark - Methods

- (void)fb_reloadMyCoins
{
    self.coinsLabel.text = @(MAX(kGYLiveManager.inside.account.coins, 0)).stringValue;
}

- (void)fb_showInView:(UIView *)inView
{
    self.coinsLabel.text = @(MAX(kGYLiveManager.inside.account.coins, 0)).stringValue;
    [self fb_updateConstraints];
    for (UICollectionView *cv in self.collectionViews) {
        [cv reloadData];
    }
    [inView addSubview:self];
    self.contentView.y = kGYScreenHeight;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.y = kGYScreenHeight - (kGYBottomSafeHeight + 310);
    } completion:^(BOOL finished) {
    }];
    // 清理combo动画
    kGYLiveHelper.comboing = -1;
    [GYLiveComboViewManager.shared fb_removeCurrentViewFromSuperView];
    UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
}

- (void)fb_dismiss
{
    [UIView animateWithDuration:0.15 animations:^{
        self.contentView.y = kGYScreenHeight + self.luckyBoxBtn.height;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.17 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
    // 开启返回手势  
    if ([[GYLiveMethods fb_currentNavigationController] respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        [GYLiveMethods fb_currentNavigationController].interactivePopGestureRecognizer.enabled = YES;
    }
    // 清理combo动画
    kGYLiveHelper.comboing = -1;
    [GYLiveComboViewManager.shared fb_removeCurrentViewFromSuperView];
    UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
}

- (void)configBlindbox
{
    BOOL isblindBox = NO;
    BOOL isClosed = [kGYUserDefaults boolForKey:kGYLiveLuckyBoxCloseClicked];
    for (GYLiveGiftConfig *config in self.configs) {
        for (GYLiveGift *gift in config.gifts) {
            if (gift.isBlindBox) {
                isblindBox = YES;
                break;
            }
        }
    }
    if (isblindBox && !isClosed) {
        [self addSubview:self.luckyBoxBtn];
        [self.luckyBoxBtn addSubview:self.closeBoxBtn];
        [self.luckyBoxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-5);
            make.bottom.equalTo(self.contentView.mas_top).offset(-3);
            make.width.mas_equalTo(145);
            make.height.mas_equalTo(57);
        }];
        [self.closeBoxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.trailing.equalTo(self.luckyBoxBtn);
            make.width.height.mas_equalTo(20);
        }];
        BOOL isClicked = [kGYUserDefaults boolForKey:kGYLiveLuckyBoxClicked];
        if (isClicked) {
            self.closeBoxBtn.hidden = NO;
        }
    }
}

#pragma mark - Getter

- (UIButton *)maskButton
{
    if (!_maskButton) {
        _maskButton = [[UIButton alloc] initWithFrame:kGYScreenBounds];
        [_maskButton addTarget:self action:@selector(maskButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maskButton;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kGYScreenHeight - 310 - kGYBottomSafeHeight, kGYScreenWidth, 310 + kGYBottomSafeHeight + 12)];
//        _contentView.backgroundColor = UIColor.clearColor;
    }
    return _contentView;
}

- (GYLiveStripePageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[GYLiveStripePageControl alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        _pageControl.currentTagSize = CGSizeMake(12, 2);
    }
    return _pageControl;
}

- (UIImageView *)coinsImageView
{
    if (!_coinsImageView) {
        _coinsImageView = [[UIImageView alloc] init];
        _coinsImageView.image = kGYImageNamed(@"fb_live_recharge_coins_icon");
    }
    return _coinsImageView;
}

- (UILabel *)coinsLabel
{
    if (!_coinsLabel) {
        _coinsLabel = [[UILabel alloc] init];
        _coinsLabel.font = kGYHurmeBoldFont(17);
        _coinsLabel.textColor = UIColor.whiteColor;
    }
    return _coinsLabel;
}

- (UIButton *)rechargeButton
{
    if (!_rechargeButton) {
        _rechargeButton = [[UIButton alloc] init];
        [_rechargeButton addTarget:self action:@selector(rechargeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rechargeButton;;
}

- (UIButton *)luckyBoxBtn
{
    if (!_luckyBoxBtn) {
        _luckyBoxBtn = [[UIButton alloc] init];
        [_luckyBoxBtn setImage:kGYImageNamed(kGYLocalString(@"fb_live_luckybox")) forState:UIControlStateNormal];
        [_luckyBoxBtn addTarget:self action:@selector(luckyBoxAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _luckyBoxBtn;
}

- (UIButton *)closeBoxBtn
{
    if (!_closeBoxBtn) {
        _closeBoxBtn = [[UIButton alloc] init];
        [_closeBoxBtn setImage:kGYImageNamed(@"fb_live_white_close") forState:UIControlStateNormal];
        [_closeBoxBtn addTarget:self action:@selector(closeBoxAction:) forControlEvents:UIControlEventTouchUpInside];
        _closeBoxBtn.hidden = YES;
    }
    return _closeBoxBtn;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (GYLivePageMenu *)pageMenu
{
    if (!_pageMenu) {
        _pageMenu = [GYLivePageMenu pageMenuWithFrame:CGRectMake(0, 0, kGYScreenWidth, 44) trackerStyle:GYLivePageMenuTrackerStyleNothing];
        _pageMenu.backgroundColor = UIColor.clearColor;
        _pageMenu.unSelectedItemTitleColor = kGYColorFromRGBA(0xFFFFFF, 0.4);
        _pageMenu.unSelectedItemTitleFont = kGYHurmeBoldFont(16);
        _pageMenu.selectedItemTitleColor = kGYHexColor(0xFFFFFF);
        _pageMenu.selectedItemTitleFont = kGYHurmeBoldFont(16);
        _pageMenu.dividingLine.hidden = YES; // 隐藏分割线
        _pageMenu.delegate = self;
        _pageMenu.contentInset = (kGYLiveManager.inside.appRTL && kGYLiveManager.config.flipRTLEnable) ? UIEdgeInsetsZero : UIEdgeInsetsMake(0, kGYWidthScale(15), 0, 0);
        _pageMenu.spacing = kGYWidthScale(20);
        _pageMenu.flipButtonsByRTL = kGYLiveManager.config.flipRTLEnable && kGYLiveManager.inside.appRTL;
    }
    return _pageMenu;
}

- (UIImageView *)rightImageView
{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.image = [kGYImageNamed(@"fb_live_pk_right_icon") fb_flipedByRTL];
    }
    return _rightImageView;
}

#pragma mark - Setter

- (void)setConfigs:(NSArray<GYLiveGiftConfig *> *)configs
{
    _configs = configs;
    //
    for (UICollectionView *cv in self.collectionViews) {
        [cv removeFromSuperview];
    }
    for (UIImageView *iv in self.tagViews) {
        [iv removeFromSuperview];
    }
    [self.collectionViews removeAllObjects];
    [self.tagViews removeAllObjects];
    
    NSInteger totalTag = 0;
    
    NSMutableArray *marr1 = [@[] mutableCopy];
    NSMutableArray *marr2 = [@[] mutableCopy];
    NSMutableArray *marr3 = [@[] mutableCopy];
    for (int i = 0; i < configs.count; i++) {
        GYLiveGiftConfig *config = configs[i];
        // 标签标题
        [marr1 addObject:kGYLocalString(config.title)];
        
        // 标签
        UIImageView *tagView = [[UIImageView alloc] init];
        if (config.tagIconUrl.length > 0) {
            [tagView sd_setImageWithURL:[NSURL URLWithString:config.tagIconUrl]];
            tagView.hidden = !(config.tagIconType == 1 || config.tagIconType == 2);
        }
        [marr2 addObject:tagView];
        [self.pageMenu.itemScrollView addSubview:tagView];
        // 礼物
        NSInteger count = ceil(config.gifts.count / 8.0);
        for (int j = 0; j < count; j++) {
            CGFloat distance = (kGYScreenWidth - 75*4) / 5;
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            layout.itemSize = CGSizeMake(75, 105);
            layout.sectionInset = UIEdgeInsetsMake(12, distance, 12, distance);
            layout.minimumInteritemSpacing = 7;
            layout.minimumLineSpacing = distance;
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kGYScreenWidth, 105*2 + 12*2 + 7) collectionViewLayout:layout];
            collectionView.tag = kGYCollectionViewsTag + totalTag;
            collectionView.scrollEnabled = NO;
            collectionView.backgroundColor = UIColor.clearColor;
            collectionView.delegate = self;
            collectionView.dataSource = self;
            collectionView.showsHorizontalScrollIndicator = NO;
            NSString *cellId = [NSString stringWithFormat:@"%@_%ld", kGYCellID, totalTag];
            [collectionView registerNib:[UINib nibWithNibName:@"GYLiveControlGiftsItemCell" bundle:kGYLiveBundle] forCellWithReuseIdentifier:cellId];
            [marr3 addObject:collectionView];
            [self.scrollView addSubview:collectionView];
            [collectionView reloadData];
            
            totalTag ++;
        }
    }
    //
    self.tagViews = marr2;
    self.collectionViews = marr3;
    //
    [self.pageMenu setItems:marr1 selectedItemIndex:0];
    self.scrollView.contentSize = CGSizeMake(kGYScreenWidth * marr3.count, 105*2 + 15*2 + 7);
    // 盲盒
    [self configBlindbox];
    //
    [self fb_updateConstraints];
}

@end
