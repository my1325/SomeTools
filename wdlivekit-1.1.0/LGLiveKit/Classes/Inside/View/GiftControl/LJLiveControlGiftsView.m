//
//  LJLiveControlGiftsView.m
//  Woohoo
//
//  Created by M2-mini on 2021/8/28.
//

#import "LJLiveControlGiftsView.h"
#import "LJLiveControlGiftsItemCell.h"
#import "LJLiveLBoxExplainView.h"
#import "LJLiveStripePageControl.h"
#import <LGLiveKit/LGLiveKit-Swift.h>
static NSInteger const kLJCollectionViewsTag = 289;
static NSString *const kLJCellID = @"LJLiveControlGiftsViewCellID";

@interface LJLiveControlGiftsView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, LJLivePageMenuDelegate>

@property (nonatomic, strong) UIButton *maskButton;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIImageView *coinsImageView, *rightImageView;

@property (nonatomic, strong) UILabel *coinsLabel;

@property (nonatomic, strong) UIButton *rechargeButton;

@property (nonatomic, strong) LJLiveStripePageControl *pageControl;

@property (nonatomic, assign) BOOL isEnough;

@property (nonatomic, strong) UIButton *luckyBoxBtn;

@property (nonatomic, strong) UIButton *closeBoxBtn;

@property (nonatomic, strong) LJLivePageMenu *pageMenu;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *collectionViews;

@property (nonatomic, strong) NSMutableArray *tagViews;

@end

@implementation LJLiveControlGiftsView

#pragma mark - Life Cycle


#pragma mark - Init




#pragma mark - Events





#pragma mark - LJLivePageMenuDelegate


#pragma mark - UICollectionViewDelegate







#pragma mark - Methods





#pragma mark - Getter












#pragma mark - Setter


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 8;
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
- (LJLiveStripePageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[LJLiveStripePageControl alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        _pageControl.currentTagSize = CGSizeMake(12, 2);
    }
    return _pageControl;
}
- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kLJScreenHeight - 310 - kLJBottomSafeHeight, kLJScreenWidth, 310 + kLJBottomSafeHeight + 12)];
//        _contentView.backgroundColor = UIColor.clearColor;
    }
    return _contentView;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger idx = collectionView.tag - kLJCollectionViewsTag;
    LJLiveGiftConfig *config;
    
    NSMutableArray *marr = [@[] mutableCopy];
    NSInteger a = 0;
    for (LJLiveGiftConfig *model in self.configs) {
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
    if (config && [[config.title lowercaseString] isEqualToString:@"svip"] && !kLJLiveManager.inside.account.svipInfo.isSVip) {
        if (kLJLiveManager.delegate && [kLJLiveManager.delegate respondsToSelector:@selector(lj_toDisplaySvipRechargePage)]) {
            [kLJLiveManager.delegate lj_toDisplaySvipRechargePage];
        }
        [self lj_dismiss];
        return;
    }
    
    BOOL isDual = indexPath.row % 2 == 0;
    NSInteger index = 0;
    if (isDual) {
        index = indexPath.row / 2 + indexPath.section * 8;
    } else {
        index = indexPath.row + 4 - (indexPath.row + 1) / 2 + indexPath.section * 8;
    }
    if (kLJLiveManager.inside.networkStatus == 0) {
        LJTipError(kLJLocalString(@"Please check your network."));
        return;
    }
    
    if (index > marr.count-1) {
    } else {
        LJLiveGift *gift = marr[index];
        
        if (self.eventBlock) self.eventBlock(LJLiveEventSendGift, gift);
        // 刷新UI
        NSInteger coins = kLJLiveManager.inside.account.coins - gift.giftPrice;
        self.isEnough = coins >= 0;
        if (self.isEnough) {
            //
            coins = MAX(coins, 0);
            kLJLiveManager.inside.account.coins = coins;
            
            self.coinsLabel.text = @(coins).stringValue;
            [self lj_updateConstraints];
            // combo动画
            if (gift.comboIconUrl.length > 0) {
                UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
                [LJLiveComboViewManager.shared lj_clickedGiftWithGiftId:gift.giftId roomId:kLJLiveHelper.data.current.hostAccountId frame:[cell convertRect:cell.bounds toView:self.superview] containerView:self.superview isQuick:NO numberFont:kLJHurmeBoldFont(16)];
            }
        } else {
            // 清理combo动画
            kLJLiveHelper.comboing = -1;
            [LJLiveComboViewManager.shared lj_removeCurrentViewFromSuperView];
            UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
        }
        
        if (gift.isBlindBox) {
            LJEvent(@"lj_liveClickLuckyBox", nil);
        }
        LJLiveThinking(LJLiveThinkingEventTypeEvent, LJLiveThinkingEventClickGift, (@{
            LJLiveThinkingKeyGiftId: @(gift.giftId).stringValue,
            LJLiveThinkingKeyGiftName: gift.giftName,
            LJLiveThinkingKeyGiftCoins: @(gift.giftPrice),
            LJLiveThinkingKeyIsLuckyBox: @(gift.isBlindBox),
            LJLiveThinkingKeyIsFast: @(index == 0),
            LJLiveThinkingKeyFrom: LJLiveThinkingValueLive
        }));
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 清理combo动画
    kLJLiveHelper.comboing = -1;
    [LJLiveComboViewManager.shared lj_removeCurrentViewFromSuperView];
    UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
}
- (UIButton *)maskButton
{
    if (!_maskButton) {
        _maskButton = [[UIButton alloc] initWithFrame:kLJScreenBounds];
        [_maskButton addTarget:self action:@selector(maskButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maskButton;
}
- (UIButton *)rechargeButton
{
    if (!_rechargeButton) {
        _rechargeButton = [[UIButton alloc] init];
        [_rechargeButton addTarget:self action:@selector(rechargeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rechargeButton;;
}
- (void)luckyBoxAction:(UIButton *)sender
{
    LJEvent(@"lj_clickBlindboxRules", nil);
    LJLiveLBoxExplainView *view = [LJLiveLBoxExplainView luckyboxExplainView];
    [view showInView:[LJLiveMethods lj_currentViewController].view];
    [kLJUserDefaults setBool:YES forKey:kLJLiveLuckyBoxClicked];
    self.closeBoxBtn.hidden = NO;
}
- (UIButton *)luckyBoxBtn
{
    if (!_luckyBoxBtn) {
        _luckyBoxBtn = [[UIButton alloc] init];
        [_luckyBoxBtn setImage:kLJImageNamed(kLJLocalString(@"lj_live_luckybox")) forState:UIControlStateNormal];
        [_luckyBoxBtn addTarget:self action:@selector(luckyBoxAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _luckyBoxBtn;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (void)maskButtonClick:(UIButton *)sender
{
    [self lj_dismiss];
}
- (void)lj_updateConstraints
{
    kLJWeakSelf;
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
            make.left.mas_equalTo(@(i * kLJScreenWidth));
            make.size.equalTo(weakSelf.scrollView);
            make.top.equalTo(weakSelf.scrollView);
        }];
        // RTL
        if (kLJLiveManager.inside.appRTL && kLJLiveManager.config.flipRTLEnable) {
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
    if (kLJLiveManager.inside.appRTL && kLJLiveManager.config.flipRTLEnable) {
        self.pageControl.transform = CGAffineTransformMakeRotation(M_PI);
        self.scrollView.transform = CGAffineTransformMakeRotation(M_PI);
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / kLJScreenWidth;
    
    NSInteger currentTag = 0;
    for (int i = 0; i < self.configs.count; i++) {
        LJLiveGiftConfig *config = self.configs[i];
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
- (UIImageView *)rightImageView
{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.image = [kLJImageNamed(@"lj_live_pk_right_icon") lj_flipedByRTL];
    }
    return _rightImageView;
}
- (void)closeBoxAction:(UIButton *)sender
{
    [kLJUserDefaults setBool:YES forKey:kLJLiveLuckyBoxCloseClicked];
    [self.luckyBoxBtn removeFromSuperview];
}
- (void)lj_setupViews
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
//    effectView.contentView.backgroundColor = kLJColorFromRGBA(0x270F42, 0.7);
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
    
    [self lj_adjustView:self.scrollView];
}
- (void)lj_dismiss
{
    [UIView animateWithDuration:0.15 animations:^{
        self.contentView.y = kLJScreenHeight + self.luckyBoxBtn.height;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.17 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
    // 开启返回手势  
    if ([[LJLiveMethods lj_currentNavigationController] respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        [LJLiveMethods lj_currentNavigationController].interactivePopGestureRecognizer.enabled = YES;
    }
    // 清理combo动画
    kLJLiveHelper.comboing = -1;
    [LJLiveComboViewManager.shared lj_removeCurrentViewFromSuperView];
    UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
}
- (void)lj_reloadMyCoins
{
    self.coinsLabel.text = @(MAX(kLJLiveManager.inside.account.coins, 0)).stringValue;
}
- (void)configBlindbox
{
    BOOL isblindBox = NO;
    BOOL isClosed = [kLJUserDefaults boolForKey:kLJLiveLuckyBoxCloseClicked];
    for (LJLiveGiftConfig *config in self.configs) {
        for (LJLiveGift *gift in config.gifts) {
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
        BOOL isClicked = [kLJUserDefaults boolForKey:kLJLiveLuckyBoxClicked];
        if (isClicked) {
            self.closeBoxBtn.hidden = NO;
        }
    }
}
- (UILabel *)coinsLabel
{
    if (!_coinsLabel) {
        _coinsLabel = [[UILabel alloc] init];
        _coinsLabel.font = kLJHurmeBoldFont(17);
        _coinsLabel.textColor = UIColor.whiteColor;
    }
    return _coinsLabel;
}
- (void)lj_setupDataSource
{
    self.collectionViews = [@[] mutableCopy];
    self.tagViews = [@[] mutableCopy];
}
- (LJLivePageMenu *)pageMenu
{
    if (!_pageMenu) {
        _pageMenu = [LJLivePageMenu pageMenuWithFrame:CGRectMake(0, 0, kLJScreenWidth, 44) trackerStyle:LJLivePageMenuTrackerStyleNothing];
        _pageMenu.backgroundColor = UIColor.clearColor;
        _pageMenu.unSelectedItemTitleColor = kLJColorFromRGBA(0xFFFFFF, 0.4);
        _pageMenu.unSelectedItemTitleFont = kLJHurmeBoldFont(16);
        _pageMenu.selectedItemTitleColor = kLJHexColor(0xFFFFFF);
        _pageMenu.selectedItemTitleFont = kLJHurmeBoldFont(16);
        _pageMenu.dividingLine.hidden = YES; // 隐藏分割线
        _pageMenu.delegate = self;
        _pageMenu.contentInset = (kLJLiveManager.inside.appRTL && kLJLiveManager.config.flipRTLEnable) ? UIEdgeInsetsZero : UIEdgeInsetsMake(0, kLJWidthScale(15), 0, 0);
        _pageMenu.spacing = kLJWidthScale(20);
        _pageMenu.flipButtonsByRTL = kLJLiveManager.config.flipRTLEnable && kLJLiveManager.inside.appRTL;
    }
    return _pageMenu;
}
- (void)pageMenu:(LJLivePageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    LJLiveGiftConfig *config = self.configs[toIndex];
    self.pageControl.numbersOfPage = ceil(config.gifts.count/8.0);
    
    // 隐藏标签
    UIImageView *tag = self.tagViews[toIndex];
    if (!tag.isHidden) {
        [LJLiveNetworkHelper lj_setGiftViewdByTitle:config.title success:nil failure:nil];
        tag.hidden = YES;
        //
        for (LJLiveGiftConfig *gift in kLJLiveHelper.data.current.gifts) {
            if ([gift.title isEqualToString:config.title]) {
                gift.tagIconUrl = @"";
                break;
            }
        }
    }
    
    NSInteger currentTag = 0;
    for (int i = 0; i < self.configs.count; i++) {
        LJLiveGiftConfig *config = self.configs[i];
        NSInteger count = ceil(config.gifts.count/8.0);
        for (int j = 0; j < count; j++) {
            if (i == toIndex) {
                
                NSInteger index = self.scrollView.contentOffset.x / kLJScreenWidth;
                if (index < currentTag + count &&
                    index >= currentTag) {
                } else {
                    self.pageControl.currentPage = 0;
                    [self.scrollView setContentOffset:CGPointMake(kLJScreenWidth * currentTag, 0) animated:YES];
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
        kLJLiveHelper.comboing = -1;
        [LJLiveComboViewManager.shared lj_removeCurrentViewFromSuperView];
        UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
    }
}
- (UIImageView *)coinsImageView
{
    if (!_coinsImageView) {
        _coinsImageView = [[UIImageView alloc] init];
        _coinsImageView.image = kLJImageNamed(@"lj_live_recharge_coins_icon");
    }
    return _coinsImageView;
}
- (void)rechargeButtonClick:(UIButton *)sender
{
    if (self.eventBlock) self.eventBlock(LJLiveEventWallet, nil);
    [self lj_dismiss];
    //
    if (!self.isEnough) {
        LJEvent(@"lj_LiveNotEnoughCoinsTouchRechargeInGifts", nil);
    }
    LJEvent(@"lj_LiveTouchRechargeByGifts", nil);
}
- (void)setConfigs:(NSArray<LJLiveGiftConfig *> *)configs
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
        LJLiveGiftConfig *config = configs[i];
        // 标签标题
        [marr1 addObject:kLJLocalString(config.title)];
        
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
            CGFloat distance = (kLJScreenWidth - 75*4) / 5;
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            layout.itemSize = CGSizeMake(75, 105);
            layout.sectionInset = UIEdgeInsetsMake(12, distance, 12, distance);
            layout.minimumInteritemSpacing = 7;
            layout.minimumLineSpacing = distance;
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kLJScreenWidth, 105*2 + 12*2 + 7) collectionViewLayout:layout];
            collectionView.tag = kLJCollectionViewsTag + totalTag;
            collectionView.scrollEnabled = NO;
            collectionView.backgroundColor = UIColor.clearColor;
            collectionView.delegate = self;
            collectionView.dataSource = self;
            collectionView.showsHorizontalScrollIndicator = NO;
            NSString *cellId = [NSString stringWithFormat:@"%@_%ld", kLJCellID, totalTag];
            [collectionView registerNib:[UINib nibWithNibName:@"LJLiveControlGiftsItemCell" bundle:kLJLiveBundle] forCellWithReuseIdentifier:cellId];
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
    self.scrollView.contentSize = CGSizeMake(kLJScreenWidth * marr3.count, 105*2 + 15*2 + 7);
    // 盲盒
    [self configBlindbox];
    //
    [self lj_updateConstraints];
}
- (UIButton *)closeBoxBtn
{
    if (!_closeBoxBtn) {
        _closeBoxBtn = [[UIButton alloc] init];
        [_closeBoxBtn setImage:kLJImageNamed(@"lj_live_white_close") forState:UIControlStateNormal];
        [_closeBoxBtn addTarget:self action:@selector(closeBoxAction:) forControlEvents:UIControlEventTouchUpInside];
        _closeBoxBtn.hidden = YES;
    }
    return _closeBoxBtn;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self lj_setupDataSource];
        [self lj_setupViews];
    }
    return self;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger idx = collectionView.tag - kLJCollectionViewsTag;
    LJLiveGiftConfig *config;
    
    NSMutableArray *marr = [@[] mutableCopy];
    NSInteger a = 0;
    for (LJLiveGiftConfig *model in self.configs) {
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
    NSString *cellId = [NSString stringWithFormat:@"%@_%ld", kLJCellID, idx];
    LJLiveControlGiftsItemCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (index > marr.count-1) {
        // 占位
        item.hidden = YES;
    } else {
        item.hidden = NO;
        LJLiveGift *gift = marr[index];
        item.giftConfig = gift;
        // svip & 盲盒
        BOOL isClosed = [kLJUserDefaults boolForKey:kLJLiveLuckyBoxCloseClicked];
        item.topRightButton.hidden = YES;
        if (config && [[config.title lowercaseString] isEqualToString:@"svip"]) {
            if (kLJLiveManager.inside.account.svipInfo.isSVip) {
                if (gift.isBlindBox && isClosed) {
                    item.topRightButton.hidden = NO;
                    [item.topRightButton setImage:kLJImageNamed(@"lj_live_luckybox_?") forState:UIControlStateNormal];
                    //
                    item.clickBlindboxDetail = ^{
                        LJEvent(@"lj_clickBlindboxQuestion", nil);
                        LJLiveLBoxExplainView *view = [LJLiveLBoxExplainView luckyboxExplainView];
                        [view showInView:[LJLiveMethods lj_currentViewController].view];
                    };
                }
                item.giftImageView.alpha = 1;
            } else {
                item.topRightButton.hidden = NO;
                [item.topRightButton setImage:kLJImageNamed(@"lj_live_gift_lock_icon") forState:UIControlStateNormal];
                item.giftImageView.alpha = 0.65;
            }
        }
    }
    
    item.sendGiftBlock = ^{
        [collectionView.delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    };
    return item;
}
- (void)lj_showInView:(UIView *)inView
{
    self.coinsLabel.text = @(MAX(kLJLiveManager.inside.account.coins, 0)).stringValue;
    [self lj_updateConstraints];
    for (UICollectionView *cv in self.collectionViews) {
        [cv reloadData];
    }
    [inView addSubview:self];
    self.contentView.y = kLJScreenHeight;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.y = kLJScreenHeight - (kLJBottomSafeHeight + 310);
    } completion:^(BOOL finished) {
    }];
    // 清理combo动画
    kLJLiveHelper.comboing = -1;
    [LJLiveComboViewManager.shared lj_removeCurrentViewFromSuperView];
    UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
}
@end
