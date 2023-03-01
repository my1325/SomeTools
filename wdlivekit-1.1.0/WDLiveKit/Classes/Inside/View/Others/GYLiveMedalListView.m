//
//  GYLiveMedalListView.m
//  ActionSheetPicker-3.0
//
//  Created by Mimio on 2022/8/16.
//

#import "GYLiveMedalListView.h"
#import "GYLiveMedalListCell.h"

@interface GYLiveMedalListView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, strong) UILabel *medalTitle;
@property (nonatomic, strong) UILabel *medalTips;
@property (nonatomic, strong) NSMutableArray<GYUniqueTag *> *dataSource;
@property (nonatomic, strong) UICollectionView *collectionView; //单元格视图
@property (nonatomic, assign) NSInteger currentAccountId;
@end

@implementation GYLiveMedalListView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, kGYScreenHeight, kGYScreenWidth, kGYScreenHeight);
        [self fb_creatUI];
    }
    return self;
}

- (void)fb_showInView:(UIView *)inView withAccountId:(NSInteger)accountId{
    _currentAccountId = accountId;
    for (UIView *subview in inView.subviews) {
        if ([subview isKindOfClass:[self class]]) {
            return;
        }
    }
    [inView addSubview:self];
    self.y = 0;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.y = kGYScreenHeight - (kGYBottomSafeHeight + self.contentHeight);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    } completion:^(BOOL finished) {}];

    [GYLiveInside fb_loading];
    [GYLiveNetworkHelper fb_getEventLabelListWithAccountId:_currentAccountId success:^(__kindof id  _Nullable responseObj) {
        [GYLiveInside fb_hideLoading];
        self.dataSource = [GYUniqueTag mj_objectArrayWithKeyValuesArray:responseObj];
        [self.collectionView reloadData];
    } failure:^{
        [GYLiveInside fb_hideLoading];
    }];
    
    if (_currentAccountId != kGYLiveManager.inside.account.accountId) {
        _medalTips.hidden = YES;
        _medalTitle.height = 28;
    }else{
        //此处给其增加长按手势，用此手势触发cell移动效果
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
        longGesture.minimumPressDuration = 0.3f;//触发长按事件时间
        [self.collectionView addGestureRecognizer:longGesture];
    }
}

- (void)fb_dismiss{
    [UIView animateWithDuration:0.1 animations:^{
        self.contentView.y = kGYScreenHeight;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

#pragma mark - UI
-(void)fb_creatUI{
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:self.bounds];
    [self addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(fb_dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    self.contentHeight = 432 + kGYBottomSafeHeight;
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kGYScreenHeight, kGYScreenWidth, self.contentHeight + kGYBottomSafeHeight)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView updateCornerRadius:^(QQCorner *corner) {
        corner.radius = QQRadiusMake(12, 12, 0, 0);
    }];
    [self addSubview:self.contentView];
    
    _medalTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 8.5, kGYScreenWidth, 19)];
    _medalTitle.text = kGYLocalString(@"Medal list");
    _medalTitle.font = kGYHurmeBoldFont(16);
    _medalTitle.textColor = kGYHexColor(0x080808);
    _medalTitle.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_medalTitle];
    
    _medalTips = [[UILabel alloc] initWithFrame:CGRectMake(0, 30.5, kGYScreenWidth, 12)];
    _medalTips.text = kGYLocalString(@"Drag your favorite medal to the top, it will be displayed on profile");
    _medalTips.font = kGYHurmeRegularFont(11);
    _medalTips.textColor = kGYHexColor(0xA09E9E);
    _medalTips.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_medalTips];

    UIView *split = [[UIView alloc] initWithFrame:CGRectMake(15, 45.5, kGYScreenWidth - 30, 0.5)];
    split.backgroundColor = kGYHexColor(0xD8D8D8);
    [self.contentView addSubview:split];
    
    [self.contentView addSubview:self.collectionView];
}

#pragma mark 创建collectionView并设置代理
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(kGYScreenWidth -30, 63);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 46, kGYScreenWidth, self.contentHeight + kGYBottomSafeHeight -  46) collectionViewLayout:layout];
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.contentInset = UIEdgeInsetsMake(10, 0, 30, 0);
        layout.minimumLineSpacing = 10;
//        layout.minimumInteritemSpacing = 5;
        [_collectionView registerClass:[GYLiveMedalListCell class] forCellWithReuseIdentifier:@"Cell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}


#pragma mark UICollectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GYLiveMedalListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.eventLabel = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark -
#pragma mark 监听手势，并设置其允许移动cell和交换资源
- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {

    [self action:longGesture];
    
}

#pragma mark item拖动
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;//返回YES允许其item移动
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    //取出源item数据 更新
    id objc = [_dataSource objectAtIndex:sourceIndexPath.item];
    //从资源数组中移除该数据
    [_dataSource removeObject:objc];
    //将数据插入到资源数组中的目标位置上
    [_dataSource insertObject:objc atIndex:destinationIndexPath.item];
}

- (void)action:(UILongPressGestureRecognizer *)longGesture{
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{//手势开始
            //判断手势落点位置是否在Item上
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[longGesture locationInView:self.collectionView]];
            if (indexPath == nil) {
                break;
            }
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
            [self.collectionView bringSubviewToFront:cell];
            //在Item上则开始移动该Item的cell
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            
            CGPoint touchPoint = [longGesture locationInView:self.collectionView];
            
            [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationCurveLinear | UIViewAnimationOptionLayoutSubviews animations:^{
                cell.center = touchPoint;
            } completion:NULL];
        }
            break;
        case UIGestureRecognizerStateChanged:{//手势改变
            //移动过程当中随时更新cell位置
            [self.collectionView updateInteractiveMovementTargetPosition:[longGesture locationInView:self.collectionView]];
        }
            break;
        case UIGestureRecognizerStateEnded:{//手势结束
            //移动结束后关闭cell移动
            [self.collectionView endInteractiveMovement];
            NSMutableArray *arr = [NSMutableArray new];
            for (int i = 0;i < _dataSource.count; i++) {
                
                NSDictionary *dic = @{
                    @"title":_dataSource[i].title,
                    @"sequence":@(i).stringValue
                };
                [arr addObject:dic];
            }
            [GYLiveNetworkHelper fb_setEventLabelListSequence:arr success:^(__kindof id  _Nullable responseObj) {} failure:^{}];
        }
            break;
        default://手势其他状态
            [self.collectionView cancelInteractiveMovement];
            break;
    }
}


@end
