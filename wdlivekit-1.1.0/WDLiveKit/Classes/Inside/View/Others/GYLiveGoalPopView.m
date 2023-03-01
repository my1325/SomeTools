//
//  GYLiveGoalPopView.m
//  YKBong
//
//  Created by Mac on 2021/4/6.
//  Copyright © 2021 YKBong. All rights reserved.
//

#import "GYLiveGoalPopView.h"

@interface GYLiveGoalPopView ()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *noticeLB;
@property (nonatomic, strong) UIImageView *noticeIcon;
@property (nonatomic, strong) UIProgressView *progress;
@property (nonatomic, strong) UILabel *goalLB;
@property (nonatomic, strong) UILabel *currentLB;
@property (nonatomic, strong) UIButton *sendGiftButton;
@property (nonatomic, strong) GYLiveRoomGoal *model;
@end
@implementation GYLiveGoalPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self fb_setupViews];
    }
    return self;
}

- (void)fb_setupViews
{
    [self addSubview:self.bgImageView];
    [self addSubview:self.icon];
    [self addSubview:self.titleLB];
    [self addSubview:self.goalLB];
    [self addSubview:self.currentLB];
    [self addSubview:self.progress];
    [self addSubview:self.noticeLB];
    [self addSubview:self.sendGiftButton];
   
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(5);
        make.top.equalTo(self).offset(15);
        make.width.height.mas_equalTo(12);
    }];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.icon.mas_trailing).offset(5);
        make.centerY.equalTo(self.icon);
        make.height.mas_equalTo(12);
    }];
    [self.currentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.icon);
        make.top.equalTo(self.icon.mas_bottom).offset(3);
        make.height.mas_equalTo(15);
    }];
    [self.goalLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentLB.mas_trailing).offset(0);
        make.centerY.equalTo(self.currentLB);
        make.height.mas_equalTo(15);
    }];
   
    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentLB);
        make.top.equalTo(self.currentLB.mas_bottom).offset(4);
        make.trailing.equalTo(self).offset(-5);
        make.height.mas_equalTo(3);
    }];
    
    [self.sendGiftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgImageView).offset(-10);
        make.centerX.equalTo(self.bgImageView);
        make.width.mas_equalTo(84);
        make.height.mas_equalTo(28);
    }];
    [self.noticeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.progress);
        make.trailing.equalTo(self.bgImageView).offset(-5);
        make.top.equalTo(self.progress.mas_bottom).offset(10);
    }];

}

- (void)jd_updateConstraints
{
    // 图文混排
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] init];
    // 图
    NSTextAttachment *attach = [[NSTextAttachment alloc]init];
    attach.image= kGYImageNamed(@"fb_live_target_notice");
    attach.bounds = CGRectMake(0, -3, 14, 14);
    NSAttributedString *imageText = [NSAttributedString attributedStringWithAttachment:attach];
    [attText appendAttributedString:imageText];
    //
    NSAttributedString *goalText = [[NSAttributedString alloc] initWithString:self.model.goalDesc attributes:@{
        NSForegroundColorAttributeName: UIColor.whiteColor,
        NSFontAttributeName: kGYHurmeBoldFont(10)
    }];
    [attText appendAttributedString:goalText];
    //
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc]init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.lineSpacing = 2;
    
    [attText addAttributes:@{
        NSParagraphStyleAttributeName: paraStyle,
        NSForegroundColorAttributeName: UIColor.whiteColor,
        NSFontAttributeName: kGYHurmeBoldFont(10)
    } range:NSMakeRange(0, attText.length)];
        
    self.noticeLB.attributedText = attText;
    
    CGSize descSize = [attText boundingRectWithSize:CGSizeMake(90, 100) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil].size;

    CGFloat height = descSize.height + 5;
    
    [self.bgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.mas_equalTo(110 + height);
    }];
    [self.sendGiftButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgImageView).offset(-10);
        make.centerX.equalTo(self.bgImageView);
        make.width.mas_equalTo(84);
        make.height.mas_equalTo(28);
    }];
    [self.noticeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.progress);
        make.trailing.equalTo(self.bgImageView).offset(-5);
        make.top.equalTo(self.progress.mas_bottom).offset(10);
        make.height.mas_equalTo(height);
    }];
}

- (void)updateUIWithModel:(GYLiveRoomGoal *)model
{
    self.model = model;
    self.noticeLB.text = model.goalDesc;
    self.currentLB.text = model.currentIncome.stringValue;
    
    if (kGYLiveManager.inside.appRTL && kGYLiveManager.config.flipRTLEnable) {
        self.goalLB.text = [NSString stringWithFormat:@"%@/", model.goalIncome];
    } else {
        self.goalLB.text = [NSString stringWithFormat:@"/%@", model.goalIncome];
    }
    
    [self.progress setProgress:(model.currentIncome.floatValue / model.goalIncome.floatValue)];
    [self jd_updateConstraints];
}

- (void)fb_sendGift
{
    if (self.sendGiftBlock) {
        self.sendGiftBlock();
    }
}

- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = kGYImageNamed(@"fb_live_target_bg");
    }
    return _bgImageView;
}

- (UIImageView *)icon
{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.image = kGYImageNamed(@"fb_live_gift_coin");
    }
    return _icon;
}
- (UILabel *)titleLB
{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.textColor = kGYColorFromRGBA(0xffffff, 0.5);
        _titleLB.font = kGYHurmeBoldFont(10);
        _titleLB.text = kGYLocalString(@"Room Income");
    }
    return _titleLB;
}
- (UILabel *)goalLB
{
    if (!_goalLB) {
        _goalLB = [[UILabel alloc] init];
        _goalLB.textColor = [UIColor whiteColor];
        _goalLB.font = kGYHurmeBoldFont(12);
        _goalLB.text = @"--";
    }
    return _goalLB;
}
- (UILabel *)currentLB
{if (!_currentLB) {
    _currentLB = [[UILabel alloc] init];
    _currentLB.textColor = [UIColor whiteColor];
    _currentLB.font = kGYHurmeBoldFont(12);
    _currentLB.text = @"--";
}
return _currentLB;
    
}

- (UIProgressView *)progress
{
    if (!_progress) {
        _progress = [[UIProgressView alloc] init];
        _progress.progress = 0;
        _progress.progressTintColor = [UIColor whiteColor];
        _progress.trackTintColor = [UIColor colorWithWhite:1 alpha:0.3];
    }
    return _progress;
}
- (UILabel *)noticeLB
{
    if (!_noticeLB) {
        _noticeLB = [[UILabel alloc] init];
        _noticeLB.numberOfLines = 0;
//        _noticeLB.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _noticeLB;
}
- (UIImageView *)noticeIcon
{
    if (!_noticeIcon) {
        _noticeIcon = [[UIImageView alloc] init];
        _noticeIcon.image = [kGYImageNamed(@"fb_live_target_notice") fb_flipedByRTL];
    }
    return _noticeIcon;
}

- (UIButton *)sendGiftButton
{
    if (!_sendGiftButton) {
        _sendGiftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendGiftButton setBackgroundImage:kGYImageNamed(kGYLocalString(@"fb_live_target_send")) forState:UIControlStateNormal];
        [_sendGiftButton addTarget:self action:@selector(fb_sendGift) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendGiftButton;
}
@end
