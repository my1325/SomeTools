//
//  LJLiveControlChatView.m
//  Woohoo
//
//  Created by M2-mini on 2021/8/25.
//

#import "LJLiveControlChatView.h"
#import "LJLiveUniqueTagView.h"
#import <LGLiveKit/LGLiveKit-Swift.h>

@interface LJLiveControlChatView () <UITextViewDelegate>

@property (nonatomic, strong) UIImageView *chatImageView;

@property (nonatomic, strong) UIButton *uniqueTagButton;

@property (nonatomic, strong) UILabel *placeholderLabel;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UIButton *touchButton, *sendButton;

@property (nonatomic, assign) BOOL isOpened;

@property (nonatomic, assign) BOOL enableSent;

@end

@implementation LJLiveControlChatView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.orginWidth = frame.size.width;
        [self lj_setupViews];
    }
    return self;
}

#pragma mark - Init

- (void)lj_setupViews
{
    self.layer.masksToBounds = YES;
    [self addSubview:self.uniqueTagButton];
    [self addSubview:self.placeholderLabel];
    [self addSubview:self.touchButton];
    [self addSubview:self.textView];
    [self addSubview:self.sendButton];
    //
    self.isOpened = YES;
    [self lj_openClose:NO animated:NO];
    
    // RTL
    if (kLJLiveManager.inside.appRTL && kLJLiveManager.config.flipRTLEnable) {
        self.uniqueTagButton.frame = LJFlipedBy(self.uniqueTagButton.frame, self.bounds);
        self.placeholderLabel.frame = LJFlipedBy(self.placeholderLabel.frame, self.bounds);
        self.touchButton.frame = LJFlipedBy(self.touchButton.frame, self.bounds);
        self.sendButton.frame = LJFlipedScreenBy(self.sendButton.frame);
    }
}

#pragma mark - Event

- (void)uniqueTagButtonClick:(UIButton *)sender
{
    LJLiveUniqueTagView *tagView = [LJLiveUniqueTagView tagView];
    [tagView showInView:[LJLiveMethods lj_currentViewController].view];
    kLJWeakSelf;
    tagView.selectTagBlcok = ^(id  _Nullable object) {
        LJUniqueTag *model = object;
        if (model.selected) {
            kLJLiveManager.inside.accountConfig.defaultEventLabel = model;
            [weakSelf.uniqueTagButton sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                [weakSelf.uniqueTagButton setTitle:@"" forState:UIControlStateNormal];
                weakSelf.uniqueTagButton.layer.borderWidth = 0;
            }];
        } else {
            kLJLiveManager.inside.accountConfig.defaultEventLabel = nil;
            [self.uniqueTagButton setTitle:kLJLocalString(@"No Medal") forState:UIControlStateNormal];
            self.uniqueTagButton.layer.borderWidth = 1;
            [self.uniqueTagButton setImage:nil forState:UIControlStateNormal];
        }
        kLJLiveManager.inside.uniqueTagDidSelected(model.selected ? model : nil);
    };
    // 清理combo动画
    kLJLiveHelper.comboing = -1;
    [LJLiveComboViewManager.shared lj_removeCurrentViewFromSuperView];
    UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
}

- (void)touchButtonClick:(UIButton *)sender
{
    if (kLJLiveHelper.barrageMute) {
        LJTipWarning(kLJLocalString(@"You have been muted."));
    } else {
        if (self.textView.isFirstResponder) {
        } else {
            [self.textView becomeFirstResponder];
        }
    }
}

- (void)sendButtonClick:(UIButton *)sender
{
    NSString *text = [self.textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (text.length == 0 || !self.enableSent) {
        LJTipWarning(kLJLocalString(@"Content cannot be empty."));
        return;
    }
    // 发送
    LJLiveBarrage *barrage = [[LJLiveBarrage alloc] init];
    barrage.type = LJLiveBarrageTypeTextMessage;
    barrage.userId = kLJLiveManager.inside.account.accountId;
    barrage.userName = kLJLiveManager.inside.account.nickName;
    barrage.userType = LJLiveUserTypeUser;
    // 敏感词屏蔽
    NSString *content = @"";
    if ([kLJLiveManager.dataSource respondsToSelector:@selector(lj_sensitiveReplaceByText:)]) {
        content = [kLJLiveManager.dataSource lj_sensitiveReplaceByText:self.textView.text];
    } else {
        content = self.textView.text;
    }
    barrage.content = content;
    barrage.isSvip = kLJLiveManager.inside.account.isSVip;
    barrage.isVip = kLJLiveManager.inside.account.rechargeAmount > 0;
    barrage.uniqueTagUrl = [kLJLiveManager.inside.accountConfig.defaultEventLabel lj_activityUrl];
    self.textView.text = @"";
    self.enableSent = NO;
    if (self.eventBlock) self.eventBlock(LJLiveEventSendBarrage, barrage);
    //
    [self.textView resignFirstResponder];
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        // 发送
        [self performSelector:@selector(sendButtonClick:) withObject:self.sendButton];
        return NO;
    }
    NSString *content = [textView.text stringByReplacingCharactersInRange:range withString:text];
    self.enableSent = content.length > 0;
    if (content.length > 80) {
        return NO;
    }
    return YES;
}

#pragma mark - Methods

- (void)lj_openClose:(BOOL)openClose animated:(BOOL)animated
{
    if (openClose && !self.isOpened) {
        self.textView.hidden = NO;
        self.sendButton.hidden = NO;
        self.touchButton.hidden = YES;
        if (animated) {
            self.sendButton.alpha = 0;
            [UIView animateWithDuration:0.2 animations:^{
                [self lj_open];
            }];
            [UIView animateWithDuration:0.1 animations:^{
                self.textView.alpha = 1;
            }];
        } else {
            [self lj_open];
        }
    }
    if (!openClose && self.isOpened) {
        if (animated) {
            [UIView animateWithDuration:0.2 animations:^{
                [self lj_close];
            } completion:^(BOOL finished) {
                self.sendButton.hidden = YES;
                self.textView.hidden = YES;
                self.touchButton.hidden = NO;
            }];
            [UIView animateWithDuration:0.1 animations:^{
                self.textView.alpha = 0;
            }];
        } else {
            [self lj_close];
            self.sendButton.hidden = YES;
            self.textView.hidden = YES;
            self.touchButton.hidden = NO;
        }
        if (self.textView.isFirstResponder) [self.textView resignFirstResponder];
    }
}

- (void)lj_open
{
    self.x = 0;
    self.y = 0;
    self.width = kLJScreenWidth;
    self.height = 50;
    //
    self.textView.x = kLJWidthScale(15);
    self.textView.y = 5;
    self.textView.width = self.width - 50 - kLJWidthScale(5) - kLJWidthScale(15)*2;
    self.textView.height = 40;
    // RTL
    if (kLJLiveManager.inside.appRTL && kLJLiveManager.config.flipRTLEnable) self.textView.frame = LJFlipedScreenBy(self.textView.frame);

    self.uniqueTagButton.alpha = 0;
    
    self.placeholderLabel.alpha = 0;
    self.sendButton.alpha = 1;
    //
    self.layer.cornerRadius = 0;
    self.backgroundColor = UIColor.whiteColor;
    
    self.isOpened = YES;
}

- (void)lj_close
{
    self.x = kLJWidthScale(15);
    self.y = 6;
    self.width = self.orginWidth;
    self.height = 38;
    // RTL
    if (kLJLiveManager.inside.appRTL && kLJLiveManager.config.flipRTLEnable) self.frame = LJFlipedScreenBy(self.frame);
    //
    self.textView.x = CGRectGetMaxX(self.uniqueTagButton.frame) + 5;
    self.textView.y = 10;
    self.textView.width = self.width - self.textView.x - 5;
    self.textView.height = 18;
    // RTL
    if (kLJLiveManager.inside.appRTL && kLJLiveManager.config.flipRTLEnable) self.textView.frame = LJFlipedBy(self.textView.frame, self.bounds);

    self.uniqueTagButton.alpha = 1;
    
    self.placeholderLabel.alpha = 1;
    self.sendButton.alpha = 0;
    //
    self.layer.cornerRadius = 38/2;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    self.isOpened = NO;
}

#pragma mark - Getter

- (UIButton *)uniqueTagButton
{
    if (!_uniqueTagButton) {
        _uniqueTagButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 45, 18)];
        _uniqueTagButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _uniqueTagButton.titleLabel.font = kLJHurmeBoldFont(8);
        _uniqueTagButton.layer.masksToBounds = YES;
        _uniqueTagButton.layer.cornerRadius = 3;
        _uniqueTagButton.layer.borderWidth = 1;
        _uniqueTagButton.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.25].CGColor;
        [_uniqueTagButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateNormal];
        [_uniqueTagButton setTitle:kLJLocalString(@"No Medal") forState:UIControlStateNormal];
        NSString *activityUrl = [kLJLiveManager.inside.accountConfig.defaultEventLabel lj_activityUrl];
        if (activityUrl.length > 0) {
            kLJWeakSelf;
            [_uniqueTagButton sd_setImageWithURL:[NSURL URLWithString:activityUrl] forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                [weakSelf.uniqueTagButton setTitle:@"" forState:UIControlStateNormal];
                weakSelf.uniqueTagButton.layer.borderWidth = 0;
            }];
        }
        [_uniqueTagButton addTarget:self action:@selector(uniqueTagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _uniqueTagButton;
}

- (UILabel *)placeholderLabel
{
    if (!_placeholderLabel) {
        CGFloat x = CGRectGetMaxX(self.uniqueTagButton.frame) + 7;
        _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 10, self.width - x, 18)];
        _placeholderLabel.font = kLJHurmeBoldFont(14);
        _placeholderLabel.textColor = UIColor.whiteColor;
        _placeholderLabel.text = kLJLocalString(@"Say hi...");
    }
    return _placeholderLabel;
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.font = kLJHurmeBoldFont(14);
        _textView.delegate = self;
        _textView.textColor = kLJHexColor(0xB8BBBF);
        _textView.backgroundColor = UIColor.clearColor;
        _textView.textContainerInset = UIEdgeInsetsMake(12, 0, 10, 0);
        _textView.returnKeyType = UIReturnKeySend;
    }
    return _textView;
}

- (UIButton *)sendButton
{
    if (!_sendButton) {
        _sendButton = [[UIButton alloc] initWithFrame:CGRectMake(kLJScreenWidth - 50 - kLJWidthScale(5), 0, 50, 50)];
        [_sendButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.sendButton setImage:kLJImageNamed(@"lj_live_send_disable_icon") forState:UIControlStateNormal];
    }
    return _sendButton;
}

- (UIButton *)touchButton
{
    if (!_touchButton) {
        _touchButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.placeholderLabel.frame), 0, self.width - CGRectGetMinX(self.placeholderLabel.frame), self.height)];
        [_touchButton addTarget:self action:@selector(touchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _touchButton;
}

#pragma mark - Setter

- (void)setEnableSent:(BOOL)enableSent
{
    if (_enableSent == enableSent) return;
    if (enableSent) {
        [self.sendButton setImage:kLJImageNamed(@"lj_live_send_enable_icon") forState:UIControlStateNormal];
    } else {
        [self.sendButton setImage:kLJImageNamed(@"lj_live_send_disable_icon") forState:UIControlStateNormal];
    }
    _enableSent = enableSent;
}

@end
