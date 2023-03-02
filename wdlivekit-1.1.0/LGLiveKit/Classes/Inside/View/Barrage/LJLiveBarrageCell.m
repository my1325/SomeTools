//
//  LJLiveBarrageCell.m
//  Woohoo
//
//  Created by M2-mini on 2021/8/24.
//

#import "LJLiveBarrageCell.h"

@interface LJLiveBarrageCell ()

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIButton *nameButton;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIImageView *backgroudImageView;

@end

@implementation LJLiveBarrageCell

#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self lj_setupViews];
    }
    return self;
}

#pragma mark - Init

- (void)lj_setupViews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColor.clearColor;
    self.contentView.backgroundColor = UIColor.clearColor;
    
    self.containerView.layer.cornerRadius = 6;
    self.containerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.backgroudImageView];
    [self.containerView addSubview:self.contentLabel];
    [self.containerView addSubview:self.nameButton];
    [self lj_updateConstraints];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentLabel sizeToFit];
}

- (void)lj_updateConstraints
{
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(2, 6, 4, 6));
    }];
}

#pragma mark - Event

- (void)nameButtonClick:(UIButton *)sender
{
    // 点击名字
    if (self.nameBlock) self.nameBlock();
}

#pragma mark - Getter

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

- (UIButton *)nameButton
{
    if (!_nameButton) {
        _nameButton = [[UIButton alloc] init];
        [_nameButton addTarget:self action:@selector(nameButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nameButton;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UIImageView *)backgroudImageView
{
    if (!_backgroudImageView) {
        _backgroudImageView = [[UIImageView alloc] init];
    }
    return _backgroudImageView;;
}

#pragma mark - Setter

- (void)setViewModel:(LJLiveBarrageViewModel *)viewModel
{
    _viewModel = viewModel;
    
    CGRect superRect = CGRectMake(kLJIpnsWidthScale(15), 0, kLJWidthScale(256), kLJHeightScale(160));
    self.containerView.frame = LJFlipedBy(CGRectMake(0, 0, viewModel.contentSize.width, viewModel.contentSize.height), superRect);
    
    self.nameButton.frame = LJFlipedBy(viewModel.nameButtonRect, self.containerView.frame);
    self.backgroudImageView.frame = LJFlipedBy(self.containerView.bounds, self.containerView.frame);
    //
    self.contentLabel.attributedText = viewModel.barrageText;
    self.nameButton.hidden = viewModel.barrageType == LJLiveBarrageTypeHint;
    if (!viewModel.barrage.lj_isSystemBarrage &&
        viewModel.barrage.type != LJLiveBarrageTypeHint &&
        (viewModel.isVip || viewModel.isSvip)) {
        [self.backgroudImageView setImage:[kLJImageNamed(@"lj_live_bg_vip") stretchableImageWithLeftCapWidth:12 topCapHeight:12]];
    } else {
        [self.backgroudImageView setImage:nil];
    }
    [self lj_updateConstraints];
}

@end
