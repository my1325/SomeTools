//
//  LJLiveGiftBarrageView.m
//  Woohoo
//
//  Created by M2-mini on 2021/8/27.
//

#import "LJLiveGiftBarrageView.h"
#import "LJLiveGiftBarrageItemView.h"

@interface LJLiveGiftBarrageView ()



/// 等待队列
@property (nonatomic, strong) NSMutableArray *waittings;
@property (nonatomic, strong) LJLiveGiftBarrageItemView *topView, *bottomView, *busyView;
@end

@implementation LJLiveGiftBarrageView

#pragma mark - Life Cycle


#pragma mark - Init



#pragma mark - Methods




#pragma mark - Getter




#pragma mark - Setter


/// @param event 事件
/// @param obj 对象
/// 刷新内部
- (LJLiveGiftBarrageItemView *)topView
{
    if (!_topView) {
        _topView = [LJLiveGiftBarrageItemView giftBarrageWithFrame:LJFlipedBy(CGRectMake(-250, 42+6, 250, 42), self.frame)];
        _topView.hidden = YES;
        kLJWeakSelf;
        _topView.dismissBlock = ^{
            weakSelf.topView.gift = nil;
            [weakSelf lj_giftViewAutoDismiss];
        };
    }
    return _topView;
}
- (LJLiveGiftBarrageItemView *)busyView
{
    if (!_busyView) {
        _busyView = [LJLiveGiftBarrageItemView giftBarrageWithFrame:LJFlipedBy(CGRectMake(-250, 0, 250, 42), self.frame)];
        _busyView.hidden = YES;
        kLJWeakSelf;
        _busyView.dismissBlock = ^{
            weakSelf.busyView.gift = nil;
            [weakSelf lj_giftViewAutoDismiss];
        };
    }
    return _busyView;
}
- (void)lj_setupViews
{
    [self addSubview:self.busyView];
    [self addSubview:self.topView];
    [self addSubview:self.bottomView];
}
- (void)lj_event:(LJLiveEvent)event withObj:(NSObject * __nullable )obj
{
    if (event == LJLiveEventReceivedBarrage && [obj isKindOfClass:[LJLiveBarrage class]]) {
        // 收到礼物弹幕
        LJLiveBarrage *barrage = (LJLiveBarrage *)obj;
        if (barrage.type == LJLiveBarrageTypeGift) {
            // 加入队列
            [self lj_intoGift:barrage];
        }
    }
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
- (LJLiveGiftBarrageItemView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [LJLiveGiftBarrageItemView giftBarrageWithFrame:LJFlipedBy(CGRectMake(-250, 42+6+42+6, 250, 42), self.frame)];
        _bottomView.hidden = YES;
        kLJWeakSelf;
        _bottomView.dismissBlock = ^{
            weakSelf.bottomView.gift = nil;
            [weakSelf lj_giftViewAutoDismiss];
        };
    }
    return _bottomView;
}
- (void)lj_giftViewAutoDismiss
{
    if (self.waittings.count > 0) {
        LJLiveBarrage *gift = self.waittings.firstObject;
        [self.waittings removeFirstObject];
        [self lj_intoGift:gift];
    }
}
- (void)lj_setupDataSource
{
    self.waittings = [@[] mutableCopy];
}
- (void)lj_intoGift:(LJLiveBarrage *)gift
{
    // 显示
    NSTimeInterval dismissDelay = self.waittings.count > 0 ? 2 : 3;
    if (self.topView.gift == nil || [self.topView.gift lj_isSameGiftBarrageWith:gift]) {
        // 顶部一样的，或者为nil
        if (self.bottomView.gift == nil ||
            (self.bottomView.gift && ![self.bottomView.gift lj_isSameGiftBarrageWith:gift])) {
            // 底部
            if (self.busyView.gift == nil ||
                (self.busyView.gift && ![self.busyView.gift lj_isSameGiftBarrageWith:gift])) {
                // busy
                self.topView.gift = gift;
                [self.topView lj_loadingFromLeftWithDismissDelay:dismissDelay completion:^{
                }];
                return;
            }
        }
    }
    if (self.bottomView.gift == nil || [self.bottomView.gift lj_isSameGiftBarrageWith:gift]) {
        if (self.busyView.gift == nil ||
            (self.busyView.gift && ![self.busyView.gift lj_isSameGiftBarrageWith:gift])) {
            //
            self.bottomView.gift = gift;
            [self.bottomView lj_loadingFromLeftWithDismissDelay:dismissDelay completion:^{
            }];
            return;
        }
    }
    if (self.busyView.gift && [self.busyView.gift lj_isSameGiftBarrageWith:gift]) {
        self.busyView.gift = gift;
        [self.busyView lj_loadingFromLeftWithDismissDelay:dismissDelay completion:^{
        }];
        return;
    }
    if (self.busyView.gift == nil && self.waittings.count > 0) {
        self.busyView.gift = gift;
        [self.busyView lj_loadingFromLeftWithDismissDelay:dismissDelay completion:^{
        }];
        return;
    }
    NSInteger index = -1;
    for (int i = 0; i < self.waittings.count; i++) {
        LJLiveBarrage *barrage = self.waittings[i];
        if ([barrage lj_isSameGiftBarrageWith:gift]) {
            index = i;
            break;
        }
    }
    if (index == -1) {
        [self.waittings addObject:gift];
    } else {
        [self.waittings replaceObjectAtIndex:index withObject:gift];
    }
}
@end
