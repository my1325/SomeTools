//
//  LJLiveGoalView.m
//  YKBong
//
//  Created by Mac on 2021/4/6.
//  Copyright © 2021 YKBong. All rights reserved.
//

#import "LJLiveGoalView.h"
#import "LJLiveAutoScrollLabel.h"

@interface LJLiveGoalView ()


@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIProgressView *progress;
@property (nonatomic, strong) UIImageView *openIcon;
@property (nonatomic, strong) UILabel *currentLB;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *goalLB;
@property (nonatomic, strong) LJLiveAutoScrollLabel *noticeLB;
@property (nonatomic, strong) LJLiveRoomGoal *model;
@end
@implementation LJLiveGoalView







- (void)updateUIWithModel:(LJLiveRoomGoal *)model
{
    self.model = model;
    self.noticeLB.text = model.goalDesc;
    self.currentLB.text = model.currentIncome.stringValue;
    [self.progress setProgress:(model.currentIncome.floatValue / model.goalIncome.floatValue)];
    
    if (kLJLiveManager.inside.appRTL && kLJLiveManager.config.flipRTLEnable) {
        self.goalLB.text = [NSString stringWithFormat:@"%@/", model.goalIncome];
    } else {
        self.goalLB.text = [NSString stringWithFormat:@"/%@", model.goalIncome];
    }
}
- (UILabel *)goalLB
{
    if (!_goalLB) {
        _goalLB = [[UILabel alloc] init];
        _goalLB.textColor = [UIColor whiteColor];
        _goalLB.font = kLJHurmeBoldFont(7);
        _goalLB.text = @"--";
    }
    return _goalLB;
}
- (UIImageView *)openIcon
{
    if (!_openIcon) {
        _openIcon = [[UIImageView alloc] init];
        _openIcon.image = [kLJImageNamed(@"lj_live_more") lj_flipedByRTL];
    }
    return _openIcon;
}
- (void)lj_tapView
{
    self.isOpen = !self.isOpen;
    if (self.openAction) {
        self.openAction(self.isOpen);
    }
}
- (UIImageView *)icon
{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.image = kLJImageNamed(@"lj_live_gift_coin");
    }
    return _icon;
}
- (void)lj_setupViews
{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.openIcon];
    [self.contentView addSubview:self.noticeLB];
    [self.contentView addSubview:self.progress];
    [self.contentView addSubview:self.goalLB];
    [self.contentView addSubview:self.currentLB];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(5);
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(16);
    }];
    [self.openIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentView).offset(-7);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(6);
    }];
//    [self.noticeLB mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView).offset(4);
//        make.leading.equalTo(self.icon.mas_trailing).offset(3);
//        make.trailing.equalTo(self.openIcon.mas_leading).offset(-3);
//        make.height.mas_equalTo(11);
//    }];
    [self.goalLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentView).offset(-16);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-2);
        make.height.mas_equalTo(8);
    }];
    [self.currentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.goalLB.mas_leading).offset(0);
        make.centerY.equalTo(self.goalLB);
        make.height.mas_equalTo(8);
    }];
    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.icon.mas_trailing).offset(3);
        make.centerY.equalTo(self.currentLB);
        make.trailing.equalTo(self.currentLB.mas_leading).offset(-4);
        make.height.mas_equalTo(3);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lj_tapView)];
    [self.contentView addGestureRecognizer:tap];
    
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self lj_setupViews];
    }
    return self;
}
- (UILabel *)currentLB
{if (!_currentLB) {
    _currentLB = [[UILabel alloc] init];
    _currentLB.textColor = kLJHexColor(0xFFEB46);
    _currentLB.font = kLJHurmeBoldFont(7);
    _currentLB.text = @"--";
}
return _currentLB;
    
}
- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.layer.backgroundColor = kLJColorFromRGBA(0x000000, 0.2).CGColor;
        _contentView.layer.cornerRadius = 14;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}
- (LJLiveAutoScrollLabel *)noticeLB
{
    if (!_noticeLB) {
        _noticeLB = [[LJLiveAutoScrollLabel alloc] initWithFrame:CGRectMake(24, 4, self.width - 48, 11)];
        _noticeLB.textColor = [UIColor whiteColor];
        _noticeLB.font = kLJHurmeBoldFont(9);
        _noticeLB.text = @"Hot dance Hot dance Hot dance dance dance hot";
        _noticeLB.labelSpacing = 40;
    }
    return _noticeLB;
}
- (UIProgressView *)progress
{
    if (!_progress) {
        _progress = [[UIProgressView alloc] init];
        _progress.progress = 0;
        _progress.progressTintColor = [UIColor whiteColor];
        _progress.trackTintColor = [UIColor colorWithWhite:1 alpha:0.16];
    }
    return _progress;
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
@end
