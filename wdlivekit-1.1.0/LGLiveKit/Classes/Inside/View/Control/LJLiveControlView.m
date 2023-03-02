//
//  LJLiveControlView.m
//  Woohoo
//
//  Created by M2-mini on 2021/8/25.
//

#import "LJLiveControlView.h"
#import "LJLiveControlChatView.h"
#import <LGLiveKit/LGLiveKit-Swift.h>
@interface LJLiveControlView ()



///
@property (nonatomic, strong) UIButton *walletButton, *fastGiftButton, *giftsButton, *blockButton;
@property (nonatomic, strong) LJLiveControlChatView *chatView;
@property (nonatomic, strong) UILongPressGestureRecognizer *longGes;
@end

@implementation LJLiveControlView

#pragma mark - Life Cycle


#pragma mark - Init



#pragma mark - Event







#pragma mark - Methods



#pragma mark - Getter





#pragma mark - Setter


- (void)walletButtonClick:(UIButton *)sender
{
    self.eventBlock(LJLiveEventOpenMenu, nil);
    
    kLJLiveHelper.comboing = -1;
    [LJLiveComboViewManager.shared lj_removeCurrentViewFromSuperView];
    UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
}
- (void)setLiveRoom:(LJLiveRoom *)liveRoom
{
    _liveRoom = liveRoom;
    
    if (liveRoom.lovelyGift) {
        [self.fastGiftButton sd_setImageWithURL:[NSURL URLWithString:liveRoom.lovelyGift.iconUrl] forState:UIControlStateNormal];
    } else {
        if (liveRoom.gifts.count > 0) {
            LJLiveGiftConfig *config = liveRoom.gifts.firstObject;
            LJLiveGift *gift = config.gifts.firstObject;
            if (gift) {
                [self.fastGiftButton sd_setImageWithURL:[NSURL URLWithString:gift.iconUrl] forState:UIControlStateNormal];
            }
        }
    }
}
- (void)giftsButtonClick:(UIButton *)sender
{
    // 礼物
    self.eventBlock(LJLiveEventGifts, nil);
}
- (void)lj_openChatView
{
    [self.chatView lj_openClose:YES animated:YES];
    //
    LJEvent(@"lj_LiveTouchBarrageInputText", nil);
}
- (void)fastGiftButtonLongTouch:(UILongPressGestureRecognizer *)ges
{
    LJLiveGift *gift = kLJLiveHelper.data.current.lovelyGift;
    if (!gift) {
        LJLiveGiftConfig *config = kLJLiveHelper.data.current.gifts.firstObject;
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
            kLJLiveHelper.comboing = 1;
            [self lj_giftFast];
            UIApplication.sharedApplication.delegate.window.userInteractionEnabled = NO;
        }
        if (ges.state == UIGestureRecognizerStateEnded ||
            ges.state == UIGestureRecognizerStateCancelled) {
            kLJLiveHelper.comboing = -1;
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
- (void)fastGiftButtonClick:(UIButton *)sender
{
    // 快速礼物
    LJLiveGift *gift = kLJLiveHelper.data.current.lovelyGift;
    if (!gift) {
        LJLiveGiftConfig *config = kLJLiveHelper.data.current.gifts.firstObject;
        gift = config.gifts.firstObject;
    }
    if (gift) {
        
        self.eventBlock(LJLiveEventFastGift, gift);
        
        NSInteger coins = kLJLiveManager.inside.account.coins - gift.giftPrice;
        if (coins >= 0) {
            kLJLiveManager.inside.account.coins -= gift.giftPrice;
            // 动画
            if (gift.comboIconUrl.length > 0) {
                [LJLiveComboViewManager.shared lj_clickedGiftWithGiftId:gift.giftId roomId:kLJLiveHelper.data.current.hostAccountId frame:[self.fastGiftButton convertRect:self.fastGiftButton.bounds toView:self.superview] containerView:self.superview isQuick:YES numberFont:kLJHurmeBoldFont(10)];
            }
        } else {
            // 清理combo动画
            kLJLiveHelper.comboing = -1;
            [LJLiveComboViewManager.shared lj_removeCurrentViewFromSuperView];
            UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
        }
        
        LJEvent(@"lj_LiveTouchFastGift", nil);
        LJLiveThinking(LJLiveThinkingEventTypeEvent, LJLiveThinkingEventClickGift, (@{
            LJLiveThinkingKeyGiftId: @(gift.giftId).stringValue,
            LJLiveThinkingKeyGiftName: gift.giftName,
            LJLiveThinkingKeyGiftCoins: @(gift.giftPrice),
            LJLiveThinkingKeyIsLuckyBox: @(gift.isBlindBox),
            LJLiveThinkingKeyIsFast: @(1),
            LJLiveThinkingKeyFrom: LJLiveThinkingValueLive
        }));
    }
}
- (void)blockButtonClick:(UIButton *)sender
{
    // 举报
    self.eventBlock(LJLiveEventReport, nil);
}
- (UIButton *)walletButton
{
    if (!_walletButton) {
        _walletButton = [[UIButton alloc] init];
        [_walletButton addTarget:self action:@selector(walletButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_walletButton setImage:kLJImageNamed(@"lj_live_icon_menu") forState:UIControlStateNormal];
        _walletButton.layer.masksToBounds = YES;
        _walletButton.layer.cornerRadius = 38/2;
    }
    return _walletButton;
}
- (void)lj_setupViews
{
    [self addSubview:self.giftsButton];
    [self addSubview:self.fastGiftButton];
    [self addSubview:self.walletButton];
//    [self addSubview:self.chatView];
    [self lj_updateConstraints];
    //
    kLJWeakSelf;
    // 特殊定制
    if (kLJLiveManager.config.channel == LJLiveChannelDama) {
        // DAMA
        self.blockButton.hidden = NO;
        [self addSubview:self.blockButton];
        [self.blockButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.centerY.equalTo(weakSelf.walletButton);
            make.trailing.equalTo(weakSelf.walletButton.mas_leading).offset(kLJWidthScale(-10));
        }];
        //
        CGFloat width = kLJScreenWidth - kLJWidthScale(15 + 10 + 10 + 10 + 15 + 15) - 38*4;
        self.chatView = [[LJLiveControlChatView alloc] initWithFrame:CGRectMake(kLJWidthScale(15), 6, width, 38)];
        [self addSubview:self.chatView];
    } else {
        self.blockButton.hidden = YES;
        //
        CGFloat width = kLJScreenWidth - kLJWidthScale(15 + 10 + 10 + 15 + 15) - 38*3;
        self.chatView = [[LJLiveControlChatView alloc] initWithFrame:CGRectMake(kLJWidthScale(15), 6, width, 38)];
        [self addSubview:self.chatView];
    }
    self.chatView.eventBlock = ^(LJLiveEvent event, id object) {
        weakSelf.eventBlock(event, object);
    };
}
- (UIButton *)blockButton
{
    if (!_blockButton) {
        _blockButton = [[UIButton alloc] init];
        [_blockButton addTarget:self action:@selector(blockButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_blockButton setImage:kLJImageNamed(@"lj_live_icon_matchroom_report") forState:UIControlStateNormal];
        _blockButton.layer.masksToBounds = YES;
        _blockButton.layer.cornerRadius = 38/2;
        _blockButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _blockButton.hidden = YES;
    }
    return _blockButton;
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
- (void)lj_giftFast
{
    if (kLJLiveHelper.comboing == -1) {
        [self.longGes setState:UIGestureRecognizerStateEnded];
        return;
    }
    if (kLJLiveHelper.comboing == 1) {
        [self fastGiftButtonClick:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self lj_giftFast];
        });
    }
}
- (void)lj_closeChatView
{
    [self.chatView lj_openClose:NO animated:YES];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self lj_setupViews];
    }
    return self;
}
- (void)lj_updateConstraints
{
    kLJWeakSelf;
    [self.giftsButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(38, 38));
        make.trailing.equalTo(weakSelf).offset(kLJWidthScale(-15));
        make.centerY.equalTo(weakSelf);
    }];
    [self.fastGiftButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.centerY.equalTo(weakSelf.giftsButton);
        make.trailing.equalTo(weakSelf.giftsButton.mas_leading).offset(kLJWidthScale(-10));
    }];
    [self.walletButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.centerY.equalTo(weakSelf.giftsButton);
        make.trailing.equalTo(weakSelf.fastGiftButton.mas_leading).offset(kLJWidthScale(-10));
    }];
}
@end
