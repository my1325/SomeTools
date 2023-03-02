//
//  LJLiveGoalPopView.m
//  YKBong
//
//  Created by Mac on 2021/4/6.
//  Copyright © 2021 YKBong. All rights reserved.
//

#import "LJLiveGoalPopView.h"

@interface LJLiveGoalPopView ()
@property (nonatomic, strong) UILabel *noticeLB;
@property (nonatomic, strong) UIImageView *noticeIcon;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *currentLB;
@property (nonatomic, strong) LJLiveRoomGoal *model;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *goalLB;
@property (nonatomic, strong) UIButton *sendGiftButton;
@property (nonatomic, strong) UIProgressView *progress;
@end
@implementation LJLiveGoalPopView









- (UIImageView *)icon
{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.image = kLJImageNamed(@"lj_live_gift_coin");
    }
    return _icon;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self lj_setupViews];
    }
    return self;
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
- (void)lj_sendGift
{
    if (self.sendGiftBlock) {
        self.sendGiftBlock();
    }
}
- (void)updateUIWithModel:(LJLiveRoomGoal *)model
{
    self.model = model;
    self.noticeLB.text = model.goalDesc;
    self.currentLB.text = model.currentIncome.stringValue;
    
    if (kLJLiveManager.inside.appRTL && kLJLiveManager.config.flipRTLEnable) {
        self.goalLB.text = [NSString stringWithFormat:@"%@/", model.goalIncome];
    } else {
        self.goalLB.text = [NSString stringWithFormat:@"/%@", model.goalIncome];
    }
    
    [self.progress setProgress:(model.currentIncome.floatValue / model.goalIncome.floatValue)];
    [self jd_updateConstraints];
}
- (UILabel *)goalLB
{
    if (!_goalLB) {
        _goalLB = [[UILabel alloc] init];
        _goalLB.textColor = [UIColor whiteColor];
        _goalLB.font = kLJHurmeBoldFont(12);
        _goalLB.text = @"--";
    }
    return _goalLB;
}
- (UILabel *)titleLB
{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.textColor = kLJColorFromRGBA(0xffffff, 0.5);
        _titleLB.font = kLJHurmeBoldFont(10);
        _titleLB.text = kLJLocalString(@"Room Income");
    }
    return _titleLB;
}
- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = kLJImageNamed(@"lj_live_target_bg");
    }
    return _bgImageView;
}
- (void)jd_updateConstraints
{
    // 图文混排
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] init];
    // 图
    NSTextAttachment *attach = [[NSTextAttachment alloc]init];
    attach.image= kLJImageNamed(@"lj_live_target_notice");
    attach.bounds = CGRectMake(0, -3, 14, 14);
    NSAttributedString *imageText = [NSAttributedString attributedStringWithAttachment:attach];
    [attText appendAttributedString:imageText];
    //
    NSAttributedString *goalText = [[NSAttributedString alloc] initWithString:self.model.goalDesc attributes:@{
        NSForegroundColorAttributeName: UIColor.whiteColor,
        NSFontAttributeName: kLJHurmeBoldFont(10)
    }];
    [attText appendAttributedString:goalText];
    //
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc]init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.lineSpacing = 2;
    
    [attText addAttributes:@{
        NSParagraphStyleAttributeName: paraStyle,
        NSForegroundColorAttributeName: UIColor.whiteColor,
        NSFontAttributeName: kLJHurmeBoldFont(10)
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
- (void)lj_setupViews
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
- (UILabel *)currentLB
{if (!_currentLB) {
    _currentLB = [[UILabel alloc] init];
    _currentLB.textColor = [UIColor whiteColor];
    _currentLB.font = kLJHurmeBoldFont(12);
    _currentLB.text = @"--";
}
return _currentLB;
    
}
- (UIImageView *)noticeIcon
{
    if (!_noticeIcon) {
        _noticeIcon = [[UIImageView alloc] init];
        _noticeIcon.image = [kLJImageNamed(@"lj_live_target_notice") lj_flipedByRTL];
    }
    return _noticeIcon;
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
- (UIButton *)sendGiftButton
{
    if (!_sendGiftButton) {
        _sendGiftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendGiftButton setBackgroundImage:kLJImageNamed(kLJLocalString(@"lj_live_target_send")) forState:UIControlStateNormal];
        [_sendGiftButton addTarget:self action:@selector(lj_sendGift) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendGiftButton;
}
@end
