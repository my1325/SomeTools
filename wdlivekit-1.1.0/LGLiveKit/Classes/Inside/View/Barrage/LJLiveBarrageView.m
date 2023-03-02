//
//  LJLiveBarrageView.m
//  Woohoo
//
//  Created by M2-mini on 2021/8/24.
//

#import "LJLiveBarrageView.h"
#import "LJLiveBarrageCell.h"
#import "LJLiveBarrageAutoEventView.h"

static NSString *const kCellID1 = @"LJLiveBarrageViewCellID1";
static NSString *const kCellID2 = @"LJLiveBarrageViewCellID2";
static NSString *const kCellID3 = @"LJLiveBarrageViewCellID3";

@interface LJLiveBarrageView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) LJLiveBarrageAutoEventView *autoEventView;

@property (nonatomic, strong) UIButton *privateButton, *newMessageButton;

@property (nonatomic, strong) NSMutableArray *barrages;

@property (nonatomic, assign) BOOL autoScrollToBottom, newMessageShowing;
/// 第一条消息底部的优化处理
@property (nonatomic, assign) CGFloat autoHeadHeight;
/// system/autoEvent是否展示中
@property (nonatomic, assign) BOOL autoEventShowing;
/// 做了的那些操作
@property (nonatomic, assign) BOOL didSayHi, didSendGift, didFollow, haveSayHi, haveSendGift, haveFollow;
/// autoEvent计时器
@property (nonatomic, strong) NSTimer *autoEventTimer;
/// 计时器事件
@property (nonatomic, assign) NSInteger autoEventSec, systemSec;

@end

@implementation LJLiveBarrageView

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

- (void)dealloc
{
    if (self.autoEventTimer) {
        [self.autoEventTimer invalidate];
        self.autoEventTimer = nil;
    }
}

#pragma mark - Init

- (void)lj_setupDataSource
{
    // 数据
    self.autoHeadHeight = 25;
    self.barrages = [@[] mutableCopy];
    self.autoScrollToBottom = YES;
    self.didSayHi = self.didSendGift = self.didFollow = NO;
    self.haveSayHi = self.haveSendGift = self.haveFollow = NO;
    self.newMessageShowing = NO;
    self.autoEventShowing = NO;
}

- (void)lj_setupViews
{
    // 渐变遮罩
    CGFloat height = kLJLiveHelper.ui.barrageRect.size.height;
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.bounds = CGRectMake(0, 0, kLJLiveHelper.ui.barrageRect.size.width, height);
    gradientLayer.locations = @[@(0), @(30/height), @(1)];
    gradientLayer.anchorPoint = CGPointZero;
    NSArray *colors = @[(__bridge id)UIColor.clearColor.CGColor,
                        (__bridge id)UIColor.whiteColor.CGColor,
                        (__bridge id)UIColor.whiteColor.CGColor];
    gradientLayer.colors = colors;
    self.layer.mask = gradientLayer;
    
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.tableView];
    [self.containerView addSubview:self.autoEventView];
    [self.containerView addSubview:self.newMessageButton];
    [self.containerView addSubview:self.privateButton];
    [self lj_adjustView:self.tableView];
    
    // RTL
    self.tableView.frame = LJFlipedScreenBy(self.tableView.frame);
    self.autoEventView.frame = LJFlipedScreenBy(self.autoEventView.frame);
    self.newMessageButton.frame = LJFlipedScreenBy(self.newMessageButton.frame);
    self.privateButton.frame = LJFlipedScreenBy(self.privateButton.frame);
    
    // autoEvent
    kLJWeakSelf;
    self.autoEventView.eventBlock = ^(LJLiveEvent event, id object) {
        if (event == LJLiveEventSendBarrage) weakSelf.didSayHi = YES;
        if (event == LJLiveEventFollow) {
            weakSelf.didFollow = YES;
            object = @[@(self.liveRoom.hostAccountId), @(1)];
        }
        if (event == LJLiveEventSendGift) weakSelf.didSendGift = YES;
        if (weakSelf.eventBlock) weakSelf.eventBlock(event, object);
        // 点了就消失
        [weakSelf lj_autoEventDownWithCompletion:^{
        }];
    };
}

- (void)lj_setupTimers
{
    // 关闭定时器
    self.systemSec = 3;
    self.autoEventSec = 0;
    // 进来系统弹幕
    kLJWeakSelf;
    // nstimer
    self.autoEventTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        LJLog(@"live debug - barrage auto event: %ld  system: %ld", weakSelf.autoEventSec, weakSelf.systemSec);
        
        if (weakSelf.liveRoom.hostAccountId == kLJLiveHelper.data.current.hostAccountId) {
        } else {
            [weakSelf.autoEventTimer invalidate];
            weakSelf.autoEventTimer = nil;
        }
        
        // auto event
        if (weakSelf.autoEventSec % 12 == 0 && weakSelf.autoEventSec / 12 > 0) {
            // 每12s执行autoEvent
            if (weakSelf.autoEventSec/12 % 2 == 0) {
                // 偶数 2 4 6 消失
                [weakSelf lj_autoEventDismiss];
            } else {
                // 1 3 5 展示
                [weakSelf lj_autoEventLoading];
            }
        }
        weakSelf.autoEventSec ++;
        
        // 展示sayhi的时候，被禁言，取消sayhi弹窗
        if (weakSelf.autoEventShowing && weakSelf.autoEventView.type == LJLiveBarrageAutoEventTypeSayHi) {
            if (kLJLiveHelper.barrageMute) [weakSelf lj_autoEventDismiss];
        }
        
        // system cell
        if (weakSelf.systemSec == 0) {
            LJLiveBarrageViewModel *lastBarrage = weakSelf.barrages.lastObject;
            if (lastBarrage && lastBarrage.barrage.lj_isSystemBarrage) {
                // 最后一个cell消失
                [weakSelf.barrages removeLastObject];
                [weakSelf.tableView deleteSection:weakSelf.barrages.count withRowAnimation:UITableViewRowAnimationNone];
                [weakSelf lj_scrollToBottomAutoControl];
            }
        }
        weakSelf.systemSec --;
        
    }];
}

#pragma mark - Event

- (void)privateButtonClick:(UIButton *)sender
{
    // 私聊带走
    kLJWeakSelf;
    [LJLiveAuth lj_requestCameraAuthSuccess:^{
        [LJLiveAuth lj_requestMicrophoneAuth:^{
            
            weakSelf.eventBlock(LJLiveEventPrivateChat, nil);
            
        } failure:^{
        }];
    } failure:^{
    }];
}

- (void)newMessageButtonClick:(UIButton *)sender
{
    // NewMessage
    kLJWeakSelf;
    [self lj_newMessageDownAnimationCompletion:^{
        weakSelf.autoScrollToBottom = YES;
        [weakSelf lj_scrollToBottomAutoControl];
    }];
}

#pragma mark - UITableViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGPoint offset = CGPointMake(targetContentOffset->x, targetContentOffset->y);
    // 底部剩余50内，自动滚动至底部，
    self.autoScrollToBottom = scrollView.contentSize.height - (offset.y + scrollView.height) < 50;
    if (self.newMessageShowing && self.autoScrollToBottom) {
        // 显示着newMessage并且已经滚动至底部
        [self lj_newMessageDownAnimationCompletion:^{
        }];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.barrages.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    kLJWeakSelf;
    LJLiveBarrageViewModel *barrage = self.barrages[indexPath.section];
    if (barrage.barrageType == LJLiveBarrageTypeHint) {
        // Hint
        LJLiveBarrageCell *hint = [tableView dequeueReusableCellWithIdentifier:kCellID1 forIndexPath:indexPath];
        if (!hint) {
            hint = [[LJLiveBarrageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID1];
        }
        hint.viewModel = barrage;
        return hint;
    }
    if (barrage.barrageType == LJLiveBarrageTypeTextMessage) {
        // TextMessage
        LJLiveBarrageCell *normal = [tableView dequeueReusableCellWithIdentifier:kCellID2 forIndexPath:indexPath];
        if (!normal) {
            normal = [[LJLiveBarrageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID2];
        }
        normal.viewModel = barrage;
        normal.nameBlock = ^{
            LJLiveRoomMember *member = [[LJLiveRoomMember alloc] init];
            member.accountId = barrage.barrage.userId;
            member.roleType = barrage.barrage.userType == LJLiveUserTypeUser ? 1 : 2;
            if (weakSelf.eventBlock) weakSelf.eventBlock(LJLiveEventPersonalData, member);
            //
            LJEvent(@"lj_LiveTouchBarrage", nil);
        };
        return normal;
    }
    // system
    LJLiveBarrageCell *system = [tableView dequeueReusableCellWithIdentifier:kCellID3 forIndexPath:indexPath];
    if (!system) {
        system = [[LJLiveBarrageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID3];
    }
    system.viewModel = barrage;
    system.nameBlock = ^{
        LJLiveRoomMember *member = [[LJLiveRoomMember alloc] init];
        member.accountId = barrage.barrage.userId;
        member.roleType = barrage.barrage.userType == LJLiveUserTypeUser ? 1 : 2;
        if (weakSelf.eventBlock) weakSelf.eventBlock(LJLiveEventPersonalData, member);
        //
        LJEvent(@"lj_LiveTouchBarrage", nil);
    };
    return system;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    self.eventBlock(LJLiveEventPersonalData, nil);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? self.autoHeadHeight : 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LJLiveBarrageViewModel *barrage = self.barrages[indexPath.section];
    return barrage.contentSize.height;
}

#pragma mark - Methods

/// AutoEvent自动加载
- (void)lj_autoEventLoading
{
    NSMutableArray *waitting = [@[] mutableCopy];
    if (self.didSayHi) {
    } else {
        if (!kLJLiveHelper.barrageMute) {
            if (self.haveSayHi) {
            } else {
                [waitting addObject:@(LJLiveBarrageAutoEventTypeSayHi)];
            }
        }
    }
    if (self.didSendGift) {
    } else {
        if (self.haveSendGift) {
        } else {
            [waitting addObject:@(LJLiveBarrageAutoEventTypeSendGift)];
        }
    }
    if (self.didFollow) {
    } else {
        if (self.haveFollow) {
        } else {
            [waitting addObject:@(LJLiveBarrageAutoEventTypeFollow)];
        }
    }
    if (waitting.count == 0) {
        
    } else {
        // 自动显示
        NSInteger type = [waitting.firstObject integerValue];
        // 展示
        [self lj_autoEventUp:type withCompletion:^{
        }];
    }
}

/// AutoEvent自动消失
- (void)lj_autoEventDismiss
{
    [self lj_autoEventDownWithCompletion:^{
    }];
}

/// 自动滚动至底部
- (void)lj_scrollToBottomAutoControl
{
    if (self.autoScrollToBottom) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.barrages.count > 0) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.barrages.count - 1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        });
    }
}

/// autoEvent展示动画
/// @param completion 完成
- (void)lj_autoEventUp:(LJLiveBarrageAutoEventType)type withCompletion:(LJLiveVoidBlock)completion
{
    // 加载newMessage
    self.autoEventView.avatarUrl = self.liveRoom.hostAvatar;
    self.autoEventView.type = type;
    self.autoEventView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.autoEventView.transform = CGAffineTransformMakeTranslation(0, -44);
        self.autoEventView.alpha = 1;
        // table上移
        self.tableView.transform = CGAffineTransformMakeTranslation(0, -44);
        // newMessage
        if (self.newMessageShowing) {
            self.newMessageButton.transform = CGAffineTransformMakeTranslation(0, -44+3-30);
        }
    } completion:^(BOOL finished) {
        if (type == LJLiveBarrageAutoEventTypeSayHi) self.haveSayHi = YES;
        if (type == LJLiveBarrageAutoEventTypeFollow) self.haveFollow = YES;
        if (type == LJLiveBarrageAutoEventTypeSendGift) self.haveSendGift = YES;
        if (completion) completion();
    }];
    self.autoEventShowing = YES;
}

/// autoEvent消失动画
- (void)lj_autoEventDownWithCompletion:(LJLiveVoidBlock)completion
{
    [UIView animateWithDuration:0.3 animations:^{
        self.autoEventView.transform = CGAffineTransformIdentity;
        self.autoEventView.alpha = 0;
        // table下移
        self.tableView.transform = CGAffineTransformIdentity;
        // newMessage
        if (self.newMessageShowing) {
            self.newMessageButton.transform = CGAffineTransformMakeTranslation(0, -30+3);
        }
    } completion:^(BOOL finished) {
        self.autoEventView.hidden = YES;
        self.autoEventShowing = NO;
        if (completion) completion();
    }];
}

/// newMessage展示动画
/// @param completion 完成
- (void)lj_newMessageAutoUpAnimationCompletion:(LJLiveVoidBlock)completion
{
    if (self.autoScrollToBottom) {
    } else {
        if (self.newMessageShowing) {
        } else {
            // 加载newMessage
            self.newMessageButton.hidden = NO;
            [UIView animateWithDuration:0.3 animations:^{
                self.newMessageButton.transform = CGAffineTransformMakeTranslation(0, self.autoEventShowing ? -44-30+3 : -30+3);
                self.newMessageButton.alpha = 1;
            } completion:^(BOOL finished) {
                if (completion) completion();
            }];
            self.newMessageShowing = YES;
        }
    }
}

/// newMessage消失动画
/// @param completion 完成
- (void)lj_newMessageDownAnimationCompletion:(LJLiveVoidBlock)completion
{
    [UIView animateWithDuration:0.3 animations:^{
        self.newMessageButton.transform = CGAffineTransformIdentity;
        self.newMessageButton.alpha = 0;
    } completion:^(BOOL finished) {
        self.newMessageButton.hidden = YES;
        self.newMessageShowing = NO;
        if (completion) completion();
    }];
}

#pragma mark - Public Methods

- (void)lj_event:(LJLiveEvent)event withObj:(NSObject * __nullable )obj
{
    // 开始PK
    if (event == LJLiveEventPKReceiveVideo) [self lj_receiveFrameUpdate:YES];
    
    // 收到PK数据，刷新UI显示
    if (event == LJLiveEventPKReceiveMatchSuccessed) [self lj_receiveFrameUpdate:YES];
    
    // 结束PK
    if (event == LJLiveEventPKEnded) [self lj_receiveFrameUpdate:NO];
    
    // 关注状态
    if (event == LJLiveEventFollow && [obj isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)obj;
        BOOL followed = [array.lastObject boolValue];
        self.didFollow = followed;
    }
    
    // 清屏
    if (event == LJLiveEventRoomLeave) {
        // 关闭定时器
        if (self.autoEventTimer) {
            [self.autoEventTimer invalidate];
            self.autoEventTimer = nil;
        }
        // 清空
        [self lj_setupDataSource];
        [self.tableView reloadData];
        //
        [self lj_newMessageDownAnimationCompletion:^{
        }];
        [self lj_autoEventDownWithCompletion:^{
        }];
        self.privateButton.hidden = YES;
        LJLog(@"live debug - barrage leave.");
    }

    // 更新私聊按钮
    if (event == LJLiveEventUpdatePrivateChat && [obj isKindOfClass:[LJLivePrivateChatFlagMsg class]]) {
        if (kLJLiveManager.config.privateEnable) {
            if (self.liveRoom.isUgc) {
                self.privateButton.hidden = YES;
            } else {
                LJLivePrivateChatFlagMsg *private = (LJLivePrivateChatFlagMsg *)obj;
                self.privateButton.hidden = private.privateChatFlag == 2;
            }
        } else {
            self.privateButton.hidden = YES;
        }
    }
    
    // 收到弹幕
    if (event == LJLiveEventReceivedBarrage && [obj isKindOfClass:[LJLiveBarrage class]]) {
        [self lj_receiveBarrage:(LJLiveBarrage *)obj];
    }
}

#pragma mark - Receive Event Methods

- (void)lj_receiveBarrage:(LJLiveBarrage *)obj
{
    // 加入房间
    if (obj.type == LJLiveBarrageTypeHint && obj.systemMsgType == 0) {
        [self lj_setupDataSource];
        [self lj_setupTimers];
        LJLog(@"live debug - barrage setup.");
    }
    
    // didsayhi
    if (obj.userId == kLJLiveManager.inside.account.accountId && obj.type == LJLiveBarrageTypeTextMessage) self.didSayHi = YES;
    
    // didsendgift
    if (obj.userId == kLJLiveManager.inside.account.accountId && obj.type == LJLiveBarrageTypeGift) self.didSendGift = YES;
    
    // 重置自动消失时间
    if (obj.lj_isSystemBarrage) self.systemSec = 3;
    
    // 需要显示的弹幕
    if (obj.lj_isDisplayedBarrage) {
        // 超过120条，移除最顶层历史弹幕
        if (self.barrages.count >= 120) [self.barrages removeFirstObject];
        //
        LJLiveBarrageViewModel *barrage = [[LJLiveBarrageViewModel alloc] initWithBarrage:obj];
        // 上一条消息
        LJLiveBarrageViewModel *barrageLast = self.barrages.lastObject;
        if (barrageLast.barrage.lj_isSystemBarrage) {
            // 系统消息
            if (obj.lj_isSystemBarrage) {
                // 进入的新消息为系统消息，替换
                [self.barrages replaceObjectAtIndex:self.barrages.count-1 withObject:barrage];
                [self.tableView reloadData];
                // 控制滚动至底部
                [self lj_scrollToBottomAutoControl];
            } else {
                // 进入的新消息为保留消息，插入-1
                [self.barrages insertObject:barrage atIndex:self.barrages.count-1];
                // 刷新
                [self.tableView reloadData];
                // 控制滚动至底部
                [self lj_scrollToBottomAutoControl];
                // 控制显示NewMessage
                [self lj_newMessageAutoUpAnimationCompletion:^{
                }];
            }
        } else {
            // 保留消息
            [self.barrages addObject:barrage];
            [self.tableView reloadData];
            // 控制滚动至底部
            [self lj_scrollToBottomAutoControl];
            // 控制显示NewMessage
            [self lj_newMessageAutoUpAnimationCompletion:^{
            }];
        }
    }
}

- (void)lj_receiveFrameUpdate:(BOOL)isPk
{
    // 更新布局
    CGFloat height = isPk ? kLJLiveHelper.ui.pkBarrageRect.size.height : kLJLiveHelper.ui.barrageRect.size.height;
    if (self.tableView.height == height) return;
    self.tableView.height = height;
    self.autoEventView.y = height;
    self.privateButton.y = height - 104/2 - 5;
    self.newMessageButton.y = height;
    // 更新遮罩
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.bounds = CGRectMake(0, 0, self.width, height);
    gradientLayer.locations = @[@(0), @(30/height), @(1)];
    gradientLayer.anchorPoint = CGPointZero;
    NSArray *colors = @[(__bridge id)UIColor.clearColor.CGColor,
                        (__bridge id)UIColor.whiteColor.CGColor,
                        (__bridge id)UIColor.whiteColor.CGColor];
    gradientLayer.colors = colors;
    self.layer.mask = gradientLayer;
    // 滚动至底部
    [self lj_scrollToBottomAutoControl];
}

#pragma mark - Getter

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:self.bounds];
        _containerView.backgroundColor = UIColor.clearColor;
    }
    return _containerView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(kLJIpnsWidthScale(15), 0, kLJWidthScale(256), self.height) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.clipsToBounds = NO;
        [_tableView registerClass:[LJLiveBarrageCell class] forCellReuseIdentifier:kCellID1];
        [_tableView registerClass:[LJLiveBarrageCell class] forCellReuseIdentifier:kCellID2];
        [_tableView registerClass:[LJLiveBarrageCell class] forCellReuseIdentifier:kCellID3];
    }
    return _tableView;
}

- (UIButton *)privateButton
{
    if (!_privateButton) {
        _privateButton = [[UIButton alloc] initWithFrame:CGRectMake(kLJScreenWidth - 200/2, self.height - 104/2 - 5, 200/2, 104/2)];
        [_privateButton addTarget:self action:@selector(privateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        NSMutableArray *marr = [@[] mutableCopy];
        for (int i = 0; i < 40; i++) {
            NSString *imagename = [NSString stringWithFormat:@"lj_live_private_%@_%02d", kLJLiveManager.inside.localizableAbbr, i];
            [marr addObject:kLJImageNamed(imagename)];
        }
        [_privateButton setImage:marr.firstObject forState:UIControlStateNormal];
        _privateButton.imageView.animationImages = marr;
        _privateButton.imageView.animationDuration = 5;
        [_privateButton.imageView startAnimating];
        _privateButton.hidden = YES;
    }
    return _privateButton;
}

- (UIButton *)newMessageButton
{
    if (!_newMessageButton) {
        _newMessageButton = [[UIButton alloc] initWithFrame:CGRectMake(kLJIpnsWidthScale(15), self.height, 104, 20)];
        [_newMessageButton addTarget:self action:@selector(newMessageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_newMessageButton setImage:kLJImageNamed(kLJLocalString(@"lj_live_newmessage_icon")) forState:UIControlStateNormal];
        _newMessageButton.alpha = 0;
        _newMessageButton.hidden = YES;
    }
    return _newMessageButton;
}

- (LJLiveBarrageAutoEventView *)autoEventView
{
    if (!_autoEventView) {
        _autoEventView = [[LJLiveBarrageAutoEventView alloc] initWithFrame:CGRectMake(kLJIpnsWidthScale(15), self.height, 190, 44)];
        _autoEventView.alpha = 0;
        _autoEventView.hidden = YES;
    }
    return _autoEventView;
}

#pragma mark - Setter

- (void)setLiveRoom:(LJLiveRoom *)liveRoom
{
    _liveRoom = liveRoom;
    // 私聊按钮
    if (kLJLiveManager.config.privateEnable) {
        if (liveRoom.isUgc) {
            self.privateButton.hidden = YES;
        } else {
            if (liveRoom.pking) {
                self.privateButton.hidden = YES;
            } else {
                self.privateButton.hidden = liveRoom.privateChatFlag == 2;
            }
        }
    } else {
        self.privateButton.hidden = YES;
    }
    self.didFollow = liveRoom.isHostFollowed;
}

@end
