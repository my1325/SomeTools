//
//  GYLiveControlView.m
//  Woohoo
//
//  Created by M2-mini on 2021/8/25.
//

#import "GYLiveControlView.h"
#import "GYLiveControlChatView.h"
#import <WDLiveKit/WDLiveKit-Swift.h>
@interface GYLiveControlView ()

@property (nonatomic, strong) GYLiveControlChatView *chatView;

@property (nonatomic, strong) UIButton *walletButton, *fastGiftButton, *giftsButton, *blockButton;
///
@property (nonatomic, strong) UILongPressGestureRecognizer *longGes;

@end

@implementation GYLiveControlView

#pragma mark - Life Cycle

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
    [self addSubview:self.giftsButton];
    [self addSubview:self.fastGiftButton];
    [self addSubview:self.walletButton];
//    [self addSubview:self.chatView];
    [self fb_updateConstraints];
    //
    kGYWeakSelf;
    // 特殊定制
    if (kGYLiveManager.config.channel == GYLiveChannelDama) {
        // DAMA
        self.blockButton.hidden = NO;
        [self addSubview:self.blockButton];
        [self.blockButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.centerY.equalTo(weakSelf.walletButton);
            make.trailing.equalTo(weakSelf.walletButton.mas_leading).offset(kGYWidthScale(-10));
        }];
        //
        CGFloat width = kGYScreenWidth - kGYWidthScale(15 + 10 + 10 + 10 + 15 + 15) - 38*4;
        self.chatView = [[GYLiveControlChatView alloc] initWithFrame:CGRectMake(kGYWidthScale(15), 6, width, 38)];
        [self addSubview:self.chatView];
    } else {
        self.blockButton.hidden = YES;
        //
        CGFloat width = kGYScreenWidth - kGYWidthScale(15 + 10 + 10 + 15 + 15) - 38*3;
        self.chatView = [[GYLiveControlChatView alloc] initWithFrame:CGRectMake(kGYWidthScale(15), 6, width, 38)];
        [self addSubview:self.chatView];
    }
    self.chatView.eventBlock = ^(GYLiveEvent event, id object) {
        weakSelf.eventBlock(event, object);
    };
}

- (void)fb_updateConstraints
{
    kGYWeakSelf;
    [self.giftsButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(38, 38));
        make.trailing.equalTo(weakSelf).offset(kGYWidthScale(-15));
        make.centerY.equalTo(weakSelf);
    }];
    [self.fastGiftButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.centerY.equalTo(weakSelf.giftsButton);
        make.trailing.equalTo(weakSelf.giftsButton.mas_leading).offset(kGYWidthScale(-10));
    }];
    [self.walletButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.centerY.equalTo(weakSelf.giftsButton);
        make.trailing.equalTo(weakSelf.fastGiftButton.mas_leading).offset(kGYWidthScale(-10));
    }];
}

#pragma mark - Event

- (void)walletButtonClick:(UIButton *)sender
{
    self.eventBlock(GYLiveEventOpenMenu, nil);
    
    kGYLiveHelper.comboing = -1;
    [GYLiveComboViewManager.shared fb_removeCurrentViewFromSuperView];
    UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
}

- (void)fastGiftButtonClick:(UIButton *)sender
{
    // 快速礼物
    GYLiveGift *gift = kGYLiveHelper.data.current.lovelyGift;
    if (!gift) {
        GYLiveGiftConfig *config = kGYLiveHelper.data.current.gifts.firstObject;
        gift = config.gifts.firstObject;
    }
    if (gift) {
        
        self.eventBlock(GYLiveEventFastGift, gift);
        
        NSInteger coins = kGYLiveManager.inside.account.coins - gift.giftPrice;
        if (coins >= 0) {
            kGYLiveManager.inside.account.coins -= gift.giftPrice;
            // 动画
            if (gift.comboIconUrl.length > 0) {
                [GYLiveComboViewManager.shared fb_clickedGiftWithGiftId:gift.giftId roomId:kGYLiveHelper.data.current.hostAccountId frame:[self.fastGiftButton convertRect:self.fastGiftButton.bounds toView:self.superview] containerView:self.superview isQuick:YES numberFont:kGYHurmeBoldFont(10)];
            }
        } else {
            // 清理combo动画
            kGYLiveHelper.comboing = -1;
            [GYLiveComboViewManager.shared fb_removeCurrentViewFromSuperView];
            UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
        }
        
        GYEvent(@"fb_LiveTouchFastGift", nil);
        GYLiveThinking(GYLiveThinkingEventTypeEvent, GYLiveThinkingEventClickGift, (@{
            GYLiveThinkingKeyGiftId: @(gift.giftId).stringValue,
            GYLiveThinkingKeyGiftName: gift.giftName,
            GYLiveThinkingKeyGiftCoins: @(gift.giftPrice),
            GYLiveThinkingKeyIsLuckyBox: @(gift.isBlindBox),
            GYLiveThinkingKeyIsFast: @(1),
            GYLiveThinkingKeyFrom: GYLiveThinkingValueLive
        }));
    }
}

- (void)fastGiftButtonLongTouch:(UILongPressGestureRecognizer *)ges
{
    GYLiveGift *gift = kGYLiveHelper.data.current.lovelyGift;
    if (!gift) {
        GYLiveGiftConfig *config = kGYLiveHelper.data.current.gifts.firstObject;
        gift = config.gifts.firstObject;
    }
    
    if (gift) {
        if (gift.comboIconUrl.length > 0) {
        } else {
            [ges setState:UIGestureRecognizerStateEnded];
            return;
        }
        if (ges.state == UIGestureRecognizerStateBegan) {
            // 开始触发
            kGYLiveHelper.comboing = 1;
            [self fb_giftFast];
            UIApplication.sharedApplication.delegate.window.userInteractionEnabled = NO;
        }
        if (ges.state == UIGestureRecognizerStateEnded ||
            ges.state == UIGestureRecognizerStateCancelled) {
            kGYLiveHelper.comboing = -1;
            UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
        }
        if (ges.state == UIGestureRecognizerStateChanged) {
            CGPoint point = [ges locationInView:self];
            BOOL b = [self.layer containsPoint:point];
            if (b) {
            } else {
                [ges setState:UIGestureRecognizerStateEnded];
            }
        }
    }
}

- (void)fb_giftFast
{
    if (kGYLiveHelper.comboing == -1) {
        [self.longGes setState:UIGestureRecognizerStateEnded];
        return;
    }
    if (kGYLiveHelper.comboing == 1) {
        [self fastGiftButtonClick:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self fb_giftFast];
        });
    }
}

- (void)giftsButtonClick:(UIButton *)sender
{
    // 礼物
    self.eventBlock(GYLiveEventGifts, nil);
}

- (void)blockButtonClick:(UIButton *)sender
{
    // 举报
    self.eventBlock(GYLiveEventReport, nil);
}

#pragma mark - Methods

- (void)fb_openChatView
{
    [self.chatView fb_openClose:YES animated:YES];
    //
    GYEvent(@"fb_LiveTouchBarrageInputText", nil);
}

- (void)fb_closeChatView
{
    [self.chatView fb_openClose:NO animated:YES];
}

#pragma mark - Getter

- (UIButton *)walletButton
{
    if (!_walletButton) {
        _walletButton = [[UIButton alloc] init];
        [_walletButton addTarget:self action:@selector(walletButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_walletButton setImage:kGYImageNamed(@"fb_live_icon_menu") forState:UIControlStateNormal];
        _walletButton.layer.masksToBounds = YES;
        _walletButton.layer.cornerRadius = 38/2;
    }
    return _walletButton;
}

- (UIButton *)fastGiftButton
{
    if (!_fastGiftButton) {
        _fastGiftButton = [[UIButton alloc] init];
        [_fastGiftButton addTarget:self action:@selector(fastGiftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _fastGiftButton.layer.masksToBounds = YES;
        _fastGiftButton.layer.cornerRadius = 38/2;
        _fastGiftButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _fastGiftButton.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
        
        self.longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(fastGiftButtonLongTouch:)];
        self.longGes.minimumPressDuration = 0.3;
        [_fastGiftButton addGestureRecognizer:self.longGes];
    }
    return _fastGiftButton;
}

- (UIButton *)giftsButton
{
    if (!_giftsButton) {
        _giftsButton = [[UIButton alloc] init];
        [_giftsButton addTarget:self action:@selector(giftsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _giftsButton.layer.masksToBounds = YES;
        _giftsButton.layer.cornerRadius = 38/2;
        _giftsButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _giftsButton.hidden = YES;
    }
    return _giftsButton;
}

- (UIButton *)blockButton
{
    if (!_blockButton) {
        _blockButton = [[UIButton alloc] init];
        [_blockButton addTarget:self action:@selector(blockButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_blockButton setImage:kGYImageNamed(@"fb_live_icon_matchroom_report") forState:UIControlStateNormal];
        _blockButton.layer.masksToBounds = YES;
        _blockButton.layer.cornerRadius = 38/2;
        _blockButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _blockButton.hidden = YES;
    }
    return _blockButton;
}

#pragma mark - Setter

- (void)setLiveRoom:(GYLiveRoom *)liveRoom
{
    _liveRoom = liveRoom;
    
    if (liveRoom.lovelyGift) {
        [self.fastGiftButton sd_setImageWithURL:[NSURL URLWithString:liveRoom.lovelyGift.iconUrl] forState:UIControlStateNormal];
    } else {
        if (liveRoom.gifts.count > 0) {
            GYLiveGiftConfig *config = liveRoom.gifts.firstObject;
            GYLiveGift *gift = config.gifts.firstObject;
            if (gift) {
                [self.fastGiftButton sd_setImageWithURL:[NSURL URLWithString:gift.iconUrl] forState:UIControlStateNormal];
            }
        }
    }
}

@end
