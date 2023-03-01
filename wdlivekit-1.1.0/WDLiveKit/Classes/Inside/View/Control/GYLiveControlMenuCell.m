//
//  GYLiveControlMenuCell.m
//  WDLiveKit
//
//  Created by M1-mini on 2022/6/28.
//

#import "GYLiveControlMenuCell.h"

@interface GYLiveControlMenuCell ()


@end

@implementation GYLiveControlMenuCell

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
    self.contentView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.offImageView];
    [self.contentView addSubview:self.textLabel];
    
    [self fb_updateConstraints];
}

- (void)fb_updateConstraints
{
    kGYWeakSelf;
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(38, 38));
        make.top.mas_offset(@(5));
        make.centerX.equalTo(weakSelf);
    }];
    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(weakSelf);
        make.top.equalTo(weakSelf.iconImageView.mas_bottom).offset(2.5);
    }];
    [self.offImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(19, 11));
        make.trailing.equalTo(weakSelf.iconImageView.mas_trailing).offset(4);
        make.bottom.equalTo(weakSelf.iconImageView.mas_bottom).offset(-1);
    }];
}

#pragma mark - Getter

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UIImageView *)offImageView
{
    if (!_offImageView) {
        _offImageView = [[UIImageView alloc] init];
    }
    return _offImageView;
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = kGYHurmeRegularFont(12);
        _textLabel.textColor = kGYHexColor(0xA09E9E);
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

@end
