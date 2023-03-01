//
//  GYLiveGiftBarrageView.m
//  Woohoo
//
//  Created by M2-mini on 2021/8/27.
//

#import "GYLiveGiftBarrageView.h"
#import "GYLiveGiftBarrageItemView.h"

@interface GYLiveGiftBarrageView ()

@property (nonatomic, strong) GYLiveGiftBarrageItemView *topView, *bottomView, *busyView;

/// 等待队列
@property (nonatomic, strong) NSMutableArray *waittings;

@end

@implementation GYLiveGiftBarrageView

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
    self.waittings = [@[] mutableCopy];
}

- (void)fb_setupViews
{
    [self addSubview:self.busyView];
    [self addSubview:self.topView];
    [self addSubview:self.bottomView];
}

#pragma mark - Methods

/// 刷新内部
/// @param event 事件
/// @param obj 对象
- (void)fb_event:(GYLiveEvent)event withObj:(NSObject * __nullable )obj
{
    if (event == GYLiveEventReceivedBarrage && [obj isKindOfClass:[GYLiveBarrage class]]) {
        // 收到礼物弹幕
        GYLiveBarrage *barrage = (GYLiveBarrage *)obj;
        if (barrage.type == GYLiveBarrageTypeGift) {
            // 加入队列
            [self fb_intoGift:barrage];
        }
    }
}

- (void)fb_giftViewAutoDismiss
{
    if (self.waittings.count > 0) {
        GYLiveBarrage *gift = self.waittings.firstObject;
        [self.waittings removeFirstObject];
        [self fb_intoGift:gift];
    }
}

- (void)fb_intoGift:(GYLiveBarrage *)gift
{
    // 显示
    NSTimeInterval dismissDelay = self.waittings.count > 0 ? 2 : 3;
    if (self.topView.gift == nil || [self.topView.gift fb_isSameGiftBarrageWith:gift]) {
        // 顶部一样的，或者为nil
        if (self.bottomView.gift == nil ||
            (self.bottomView.gift && ![self.bottomView.gift fb_isSameGiftBarrageWith:gift])) {
            // 底部
            if (self.busyView.gift == nil ||
                (self.busyView.gift && ![self.busyView.gift fb_isSameGiftBarrageWith:gift])) {
                // busy
                self.topView.gift = gift;
                [self.topView fb_loadingFromLeftWithDismissDelay:dismissDelay completion:^{
                }];
                return;
            }
        }
    }
    if (self.bottomView.gift == nil || [self.bottomView.gift fb_isSameGiftBarrageWith:gift]) {
        if (self.busyView.gift == nil ||
            (self.busyView.gift && ![self.busyView.gift fb_isSameGiftBarrageWith:gift])) {
            //
            self.bottomView.gift = gift;
            [self.bottomView fb_loadingFromLeftWithDismissDelay:dismissDelay completion:^{
            }];
            return;
        }
    }
    if (self.busyView.gift && [self.busyView.gift fb_isSameGiftBarrageWith:gift]) {
        self.busyView.gift = gift;
        [self.busyView fb_loadingFromLeftWithDismissDelay:dismissDelay completion:^{
        }];
        return;
    }
    if (self.busyView.gift == nil && self.waittings.count > 0) {
        self.busyView.gift = gift;
        [self.busyView fb_loadingFromLeftWithDismissDelay:dismissDelay completion:^{
        }];
        return;
    }
    NSInteger index = -1;
    for (int i = 0; i < self.waittings.count; i++) {
        GYLiveBarrage *barrage = self.waittings[i];
        if ([barrage fb_isSameGiftBarrageWith:gift]) {
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

#pragma mark - Getter

- (GYLiveGiftBarrageItemView *)topView
{
    if (!_topView) {
        _topView = [GYLiveGiftBarrageItemView giftBarrageWithFrame:GYFlipedBy(CGRectMake(-250, 42+6, 250, 42), self.frame)];
        _topView.hidden = YES;
        kGYWeakSelf;
        _topView.dismissBlock = ^{
            weakSelf.topView.gift = nil;
            [weakSelf fb_giftViewAutoDismiss];
        };
    }
    return _topView;
}

- (GYLiveGiftBarrageItemView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [GYLiveGiftBarrageItemView giftBarrageWithFrame:GYFlipedBy(CGRectMake(-250, 42+6+42+6, 250, 42), self.frame)];
        _bottomView.hidden = YES;
        kGYWeakSelf;
        _bottomView.dismissBlock = ^{
            weakSelf.bottomView.gift = nil;
            [weakSelf fb_giftViewAutoDismiss];
        };
    }
    return _bottomView;
}

- (GYLiveGiftBarrageItemView *)busyView
{
    if (!_busyView) {
        _busyView = [GYLiveGiftBarrageItemView giftBarrageWithFrame:GYFlipedBy(CGRectMake(-250, 0, 250, 42), self.frame)];
        _busyView.hidden = YES;
        kGYWeakSelf;
        _busyView.dismissBlock = ^{
            weakSelf.busyView.gift = nil;
            [weakSelf fb_giftViewAutoDismiss];
        };
    }
    return _busyView;
}

#pragma mark - Setter


@end
