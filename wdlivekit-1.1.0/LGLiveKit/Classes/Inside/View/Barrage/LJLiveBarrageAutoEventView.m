//
//  LJLiveBarrageAutoEventView.m
//  Woohoo
//
//  Created by M2-mini on 2021/9/4.
//

#import "LJLiveBarrageAutoEventView.h"

@interface LJLiveBarrageAutoEventView ()

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIImageView *typeImageView;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIButton *avatarButton, *touchButton;

@end

@implementation LJLiveBarrageAutoEventView

#pragma mark - Life Cycle

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
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.typeImageView];
    [self.containerView addSubview:self.contentLabel];
    [self.containerView addSubview:self.avatarButton];
    [self.containerView addSubview:self.touchButton];
    //
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.cornerRadius = 38/2;
    self.containerView.backgroundColor = kLJHexColor(0xFF5655);
}

- (void)lj_updateConstraints
{
    kLJWeakSelf;
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(weakSelf);
        make.top.mas_equalTo(@(3));
        make.bottom.mas_equalTo(@(-3));
    }];
    [self.typeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.leading.mas_equalTo(@(10));
        make.centerY.equalTo(weakSelf.containerView);
    }];
    [self.avatarButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(weakSelf.type == LJLiveBarrageAutoEventTypeFollow ? CGSizeMake(30, 30) : CGSizeZero);
        make.centerY.equalTo(weakSelf.containerView);
        make.leading.equalTo(weakSelf.contentLabel.mas_trailing).offset(0);
        make.trailing.equalTo(weakSelf.containerView).offset(-4);
    }];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.typeImageView.mas_trailing).offset(5);
        make.centerY.equalTo(weakSelf.containerView);
        make.trailing.equalTo(weakSelf.avatarButton.mas_leading);
    }];
    [self.touchButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.containerView);
    }];
}

#pragma mark - Event

- (void)touchButtonClick:(UIButton *)sender
{
    if (self.eventBlock) {
        // 打开礼物
        if (self.type == LJLiveBarrageAutoEventTypeSendGift) {
            self.eventBlock(LJLiveEventGifts, nil);
            //
            LJEvent(@"lj_LiveTouchAutoSendGift", nil);
            LJLiveThinking(LJLiveThinkingEventTypeEvent, LJLiveThinkingEventClickAutoSendGiftInLive, nil);
        }
        // 发送消息
        if (self.type == LJLiveBarrageAutoEventTypeSayHi) {
            self.eventBlock(LJLiveEventSendBarrage, [LJLiveBarrage sayHiMessage]);
            //
            LJEvent(@"lj_LiveTouchAutoSayHi", nil);
            LJLiveThinking(LJLiveThinkingEventTypeEvent, LJLiveThinkingEventClickAutoSayHiInLive, nil);
        }
        // 关注
        if (self.type == LJLiveBarrageAutoEventTypeFollow) {
            //
            LJEvent(@"lj_LiveTouchAutoFollow", nil);
            LJLiveThinking(LJLiveThinkingEventTypeEvent, LJLiveThinkingEventClickAutoFollowInLive, nil);
            //
            kLJLiveManager.inside.from = LJLiveThinkingValueLive;
            kLJLiveManager.inside.fromDetail = LJLiveThinkingValueDetailAutoMessage;
            self.eventBlock(LJLiveEventFollow, @[@(kLJLiveHelper.data.current.hostAccountId), @(1)]);
        }
    }
}

#pragma mark - Getter

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = UIColor.clearColor;
    }
    return _containerView;
}

- (UIImageView *)typeImageView
{
    if (!_typeImageView) {
        _typeImageView = [[UIImageView alloc] init];
        _typeImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _typeImageView;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = kLJHurmeBoldFont(12);
        _contentLabel.textColor = UIColor.whiteColor;
        _contentLabel.numberOfLines = 2;
    }
    return _contentLabel;
}

- (UIButton *)avatarButton
{
    if (!_avatarButton) {
        _avatarButton = [[UIButton alloc] init];
        _avatarButton.layer.masksToBounds = YES;
        _avatarButton.layer.borderColor = UIColor.whiteColor.CGColor;
        _avatarButton.layer.cornerRadius = 15;
        _avatarButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _avatarButton;
}

- (UIButton *)touchButton
{
    if (!_touchButton) {
        _touchButton = [[UIButton alloc] init];
        [_touchButton addTarget:self action:@selector(touchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _touchButton;
}

#pragma mark - Setter

- (void)setType:(LJLiveBarrageAutoEventType)type
{
    _type = type;
    switch (type) {
        case LJLiveBarrageAutoEventTypeSayHi:
        {
            self.width = 185;
            self.typeImageView.image = kLJImageNamed(@"lj_live_barrage_message_icon");
            self.contentLabel.text = kLJLocalString(@"Say hi to the livestreamer.");
            [self.avatarButton setImage:nil forState:UIControlStateNormal];
            self.avatarButton.layer.borderWidth = 0;
        }
            break;
        case LJLiveBarrageAutoEventTypeFollow:
        {
            self.width = 200;
            self.typeImageView.image = kLJImageNamed(@"lj_live_barrage_follow_icon");
            self.contentLabel.text = kLJLocalString(@"Don't miss any precious moments with her");
            self.avatarButton.layer.borderWidth = 1;
        }
            break;
        case LJLiveBarrageAutoEventTypeSendGift:
        {
            self.width = 160;
            self.typeImageView.image = kLJImageNamed(@"lj_live_barrage_gift_icon");
            self.contentLabel.text = kLJLocalString(@"Like her? Send a gift!");
            [self.avatarButton setImage:nil forState:UIControlStateNormal];
            self.avatarButton.layer.borderWidth = 0;
        }
            break;
            
        default:
            break;
    }
    // RTL
    if (kLJLiveManager.inside.appRTL && kLJLiveManager.config.flipRTLEnable) {
        self.x = kLJScreenWidth - kLJIpnsWidthScale(15) - self.width;
    }
    
    [self lj_updateConstraints];
}

- (void)setAvatarUrl:(NSString *)avatarUrl
{
    _avatarUrl = avatarUrl;
    [self.avatarButton sd_setImageWithURL:[NSURL URLWithString:avatarUrl] forState:UIControlStateNormal placeholderImage:kLJLiveManager.config.avatar];
}

@end
