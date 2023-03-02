//
//  LJLiveRemoteView.m
//  Woohoo
//
//  Created by M2-mini on 2021/9/8.
//

#import "LJLiveRemoteView.h"
#import "LJLiveThrottle.h"

@interface LJLiveRemoteView ()

///
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) LJLiveThrottle *throttle;
@end

@implementation LJLiveRemoteView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self lj_setupViews];
        
        _throttle = [[LJLiveThrottle alloc] init];
        _throttle.threshold = 2.0;
    }
    return self;
}

- (void)layoutSubviews
{
    self.effectView.frame = self.bounds;
    self.backgroudImageView.frame = self.bounds;
    self.maskButton.frame = self.bounds;
}

#pragma mark - Init

- (void)lj_setupViews
{
    [self addSubview:self.backgroudImageView];
    [self addSubview:self.effectView];
    
    [self addSubview:self.promptLabel];
    //
    [self addSubview:self.maskButton];
    [self addSubview:self.closeButton];
    
    self.closeButton.hidden = YES;
    self.maskButton.hidden = YES;
    //
    self.clipsToBounds = YES;
}

- (void)lj_updateConstraints
{
    kLJWeakSelf;
    [self.promptLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf).offset(-kLJHeightScale(30)-kLJBottomSafeHeight);
        make.centerX.equalTo(weakSelf);
        make.left.equalTo(weakSelf).offset(kLJWidthScale(65));
    }];
}

#pragma mark - Events

- (void)closeButtonClick:(UIButton *)sender
{
    if (self.closeBlock) self.closeBlock();
}

- (void)maskButtonClick:(UIButton *)sender
{
    [self.throttle doAction:^{
        if (self.maskBlock) self.maskBlock();
    }];
}

#pragma mark - Getter

- (UIImageView *)backgroudImageView
{
    if (!_backgroudImageView) {
        _backgroudImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroudImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backgroudImageView;
}

- (UIVisualEffectView *)effectView
{
    if (!_effectView) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        _effectView.frame = self.bounds;
        _effectView.alpha = 0.97;
    }
    return _effectView;
}

- (UILabel *)promptLabel
{
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.font = kLJHurmeBoldFont(16);
        _promptLabel.textColor = [UIColor colorWithWhite:1 alpha:0.75];
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.numberOfLines = 0;
    }
    return _promptLabel;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 30, 0, 30, 30)];
        [_closeButton setImage:kLJImageNamed(@"lj_live_remote_close_icon") forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)maskButton
{
    if (!_maskButton) {
        _maskButton = [[UIButton alloc] initWithFrame:self.bounds];
        [_maskButton addTarget:self action:@selector(maskButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maskButton;
}

#pragma mark - Setter

- (void)setPromptText:(NSString *)promptText
{
    _promptText = promptText;
    self.promptLabel.text = promptText;
    [self lj_updateConstraints];
}

- (void)setVideoView:(UIView *)videoView
{
    // 移除
    if (_videoView) {
        [_videoView removeFromSuperview];
    }
    if (videoView) {
        [self insertSubview:videoView belowSubview:self.maskButton];
    }
    _videoView = videoView;
}

- (void)setPkVideoView:(UIView *)pkVideoView{
    // 移除
    if (_pkVideoView) {
        [_pkVideoView removeFromSuperview];
    }
    if (pkVideoView) {
        [self insertSubview:pkVideoView belowSubview:self.maskButton];
    }
    _pkVideoView = pkVideoView;
}
@end
