//
//  LJLiveControlMenuView.m
//  LGLiveKit
//
//  Created by M1-mini on 2022/6/28.
//

#import "LJLiveControlMenuView.h"
#import "LJLiveControlMenuCell.h"
#import "LJLiveRadioGift.h"
static NSString *const kCellID = @"LJLiveControlMenuViewCellID";

@interface LJLiveControlMenuView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
///
@property (nonatomic, strong) UIButton *maskButton;
///
@property (nonatomic, strong) UIView *contentView;
///
@property (nonatomic, strong) UICollectionView *collectionView;
///
@property (nonatomic, strong) NSArray *images, *titles;

@end

@implementation LJLiveControlMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self lj_setupViews];
    }
    return self;
}

#pragma mark - Init

- (void)lj_setupViews
{
    self.images = @[kLJImageNamed(@"lj_live_icon_circular"), kLJImageNamed(@"lj_live_icon_wallet")];
    self.titles = @[kLJLocalString(@"Broadcast"), kLJLocalString(@"Recharge")];
    
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
    LJLiveControlMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    NSInteger index = indexPath.row;
    cell.iconImageView.image = self.images[index];
    cell.textLabel.text = self.titles[index];
    if (indexPath.row == 0) {
        cell.offImageView.hidden = NO;
        cell.offImageView.image = LJLiveRadioGift.shared.enable ? kLJImageNamed(@"lj_live_icon_on") : kLJImageNamed(@"lj_live_icon_off");
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
            LJLiveRadioGift.shared.enable = !LJLiveRadioGift.shared.enable;
            [self.collectionView reloadData];
        }
            break;
        case 1:
        {
            // 钱包
            self.eventBlock(LJLiveEventWallet, nil);
            //
            LJEvent(@"lj_LiveTouchRecharge", nil);
            LJLiveThinking(LJLiveThinkingEventTypeEvent, LJLiveThinkingEventClickRechargeButtonInLive, nil);
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Events

- (void)maskButtonClick:(UIButton *)sender
{
    [self lj_dismiss];
}

#pragma mark - Methods

- (void)lj_showInView:(UIView *)inView
{
    [inView addSubview:self];
    CGFloat height = 120-15;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:18 options:UIViewAnimationOptionCurveLinear animations:^{
        self.contentView.transform = CGAffineTransformMakeTranslation(0, -height);
    } completion:^(BOOL finished) {
    }];
}

- (void)lj_dismiss
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
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kLJScreenHeight, kLJScreenWidth, 120 + kLJBottomSafeHeight)];
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
        CGFloat leading = kLJWidthScale(8);
        CGFloat space = (kLJScreenWidth - itemWidth * 5 - leading * 2) / 4;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.sectionInset = UIEdgeInsetsMake(15, leading, 25, leading);
        layout.minimumInteritemSpacing = space;
        layout.minimumLineSpacing = space;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        [_collectionView registerClass:[LJLiveControlMenuCell class] forCellWithReuseIdentifier:kCellID];
    }
    return _collectionView;
}

@end
