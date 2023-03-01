//
//  GYLiveControlMenuView.m
//  WDLiveKit
//
//  Created by M1-mini on 2022/6/28.
//

#import "GYLiveControlMenuView.h"
#import "GYLiveControlMenuCell.h"
#import "GYLiveRadioGift.h"
static NSString *const kCellID = @"GYLiveControlMenuViewCellID";

@interface GYLiveControlMenuView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
///
@property (nonatomic, strong) UIButton *maskButton;
///
@property (nonatomic, strong) UIView *contentView;
///
@property (nonatomic, strong) UICollectionView *collectionView;
///
@property (nonatomic, strong) NSArray *images, *titles;

@end

@implementation GYLiveControlMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self fb_setupViews];
    }
    return self;
}

#pragma mark - Init

- (void)fb_setupViews
{
    self.images = @[kGYImageNamed(@"fb_live_icon_circular"), kGYImageNamed(@"fb_live_icon_wallet")];
    self.titles = @[kGYLocalString(@"Broadcast"), kGYLocalString(@"Recharge")];
    
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.maskButton];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GYLiveControlMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    NSInteger index = indexPath.row;
    cell.iconImageView.image = self.images[index];
    cell.textLabel.text = self.titles[index];
    if (indexPath.row == 0) {
        cell.offImageView.hidden = NO;
        cell.offImageView.image = GYLiveRadioGift.shared.enable ? kGYImageNamed(@"fb_live_icon_on") : kGYImageNamed(@"fb_live_icon_off");
    } else {
        cell.offImageView.hidden = YES;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            // 开关横幅
            GYLiveRadioGift.shared.enable = !GYLiveRadioGift.shared.enable;
            [self.collectionView reloadData];
        }
            break;
        case 1:
        {
            // 钱包
            self.eventBlock(GYLiveEventWallet, nil);
            //
            GYEvent(@"fb_LiveTouchRecharge", nil);
            GYLiveThinking(GYLiveThinkingEventTypeEvent, GYLiveThinkingEventClickRechargeButtonInLive, nil);
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Events

- (void)maskButtonClick:(UIButton *)sender
{
    [self fb_dismiss];
}

#pragma mark - Methods

- (void)fb_showInView:(UIView *)inView
{
    [inView addSubview:self];
    CGFloat height = 120-15;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:18 options:UIViewAnimationOptionCurveLinear animations:^{
        self.contentView.transform = CGAffineTransformMakeTranslation(0, -height);
    } completion:^(BOOL finished) {
    }];
}

- (void)fb_dismiss
{
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

#pragma mark - Getter

- (UIButton *)maskButton
{
    if (!_maskButton) {
        _maskButton = [[UIButton alloc] initWithFrame:self.bounds];
        [_maskButton addTarget:self action:@selector(maskButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maskButton;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kGYScreenHeight, kGYScreenWidth, 120 + kGYBottomSafeHeight)];
        _contentView.backgroundColor = UIColor.whiteColor;
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 12;
    }
    return _contentView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        CGFloat itemWidth = 38 + 15*2;
        CGFloat itemHeight = 64;
        CGFloat leading = kGYWidthScale(8);
        CGFloat space = (kGYScreenWidth - itemWidth * 5 - leading * 2) / 4;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.sectionInset = UIEdgeInsetsMake(15, leading, 25, leading);
        layout.minimumInteritemSpacing = space;
        layout.minimumLineSpacing = space;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        [_collectionView registerClass:[GYLiveControlMenuCell class] forCellWithReuseIdentifier:kCellID];
    }
    return _collectionView;
}

@end
