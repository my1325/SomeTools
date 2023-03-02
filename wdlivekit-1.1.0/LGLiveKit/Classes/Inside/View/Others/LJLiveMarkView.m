//
//  LJLiveMarkView.m
//  Woohoo
//
//  Created by M2-mini on 2021/9/14.
//

#import "LJLiveMarkView.h"

@interface LJLiveMarkView ()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation LJLiveMarkView

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
    [self addSubview:self.iconImageView];
    [self addSubview:self.contentLabel];
}

- (void)lj_updateConstraints
{
    kLJWeakSelf;
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@(4));
        make.top.mas_equalTo(@(2));
        make.bottom.mas_equalTo(@(-2));
        make.width.mas_equalTo(weakSelf.iconImageView.mas_height);
    }];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(2);
        make.right.equalTo(weakSelf).offset(-5);
        make.centerY.equalTo(weakSelf);
    }];
}

#pragma mark - Methods

+ (CGFloat)lj_widthForContent:(NSAttributedString *)content
                       height:(CGFloat)height
{
    CGFloat width = 4 + 5 + 2 + (height-4);
    CGSize size = [content boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    return width + ceil(size.width);
}

#pragma mark - Getter

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
    }
    return _contentLabel;
}

- (void)setIcon:(UIImage *)icon
{
    _icon = icon;
    self.iconImageView.image = icon;
    [self lj_updateConstraints];
}

- (void)setContent:(NSAttributedString *)content
{
    _content = content;
    self.contentLabel.attributedText = content;
    [self lj_updateConstraints];
}

@end
