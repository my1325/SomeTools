//
//  GYLiveGoalView.m
//  YKBong
//
//  Created by Mac on 2021/4/6.
//  Copyright © 2021 YKBong. All rights reserved.
//

#import "GYLiveGoalView.h"
#import "GYLiveAutoScrollLabel.h"

@interface GYLiveGoalView ()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) GYLiveAutoScrollLabel *noticeLB;
@property (nonatomic, strong) UIProgressView *progress;
@property (nonatomic, strong) UILabel *goalLB;
@property (nonatomic, strong) UILabel *currentLB;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *openIcon;
@property (nonatomic, strong) GYLiveRoomGoal *model;

@end
@implementation GYLiveGoalView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self fb_setupViews];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self fb_setupViews];
    }
    return self;
}

- (void)fb_setupViews
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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fb_tapView)];
    [self.contentView addGestureRecognizer:tap];
    
}

- (void)fb_tapView
{
    self.isOpen = !self.isOpen;
    if (self.openAction) {
        self.openAction(self.isOpen);
    }
}

- (void)updateUIWithModel:(GYLiveRoomGoal *)model
{
    self.model = model;
    self.noticeLB.text = model.goalDesc;
    self.currentLB.text = model.currentIncome.stringValue;
    [self.progress setProgress:(model.currentIncome.floatValue / model.goalIncome.floatValue)];
    
    if (kGYLiveManager.inside.appRTL && kGYLiveManager.config.flipRTLEnable) {
        self.goalLB.text = [NSString stringWithFormat:@"%@/", model.goalIncome];
    } else {
        self.goalLB.text = [NSString stringWithFormat:@"/%@", model.goalIncome];
    }
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.layer.backgroundColor = kGYColorFromRGBA(0x000000, 0.2).CGColor;
        _contentView.layer.cornerRadius = 14;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UIImageView *)icon
{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.image = kGYImageNamed(@"fb_live_gift_coin");
    }
    return _icon;
}
- (GYLiveAutoScrollLabel *)noticeLB
{
    if (!_noticeLB) {
        _noticeLB = [[GYLiveAutoScrollLabel alloc] initWithFrame:CGRectMake(24, 4, self.width - 48, 11)];
        _noticeLB.textColor = [UIColor whiteColor];
        _noticeLB.font = kGYHurmeBoldFont(9);
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
- (UILabel *)goalLB
{
    if (!_goalLB) {
        _goalLB = [[UILabel alloc] init];
        _goalLB.textColor = [UIColor whiteColor];
        _goalLB.font = kGYHurmeBoldFont(7);
        _goalLB.text = @"--";
    }
    return _goalLB;
}
- (UILabel *)currentLB
{if (!_currentLB) {
    _currentLB = [[UILabel alloc] init];
    _currentLB.textColor = kGYHexColor(0xFFEB46);
    _currentLB.font = kGYHurmeBoldFont(7);
    _currentLB.text = @"--";
}
return _currentLB;
    
}
- (UIImageView *)openIcon
{
    if (!_openIcon) {
        _openIcon = [[UIImageView alloc] init];
        _openIcon.image = [kGYImageNamed(@"fb_live_more") fb_flipedByRTL];
    }
    return _openIcon;
}
@end
