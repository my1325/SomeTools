//
//  LJLivePkRankCell.m
//  Woohoo
//
//  Created by M2-mini on 2021/11/26.
//

#import "LJLivePkRankCell.h"

@interface LJLivePkRankCell ()

@property (weak, nonatomic) IBOutlet UIButton *avatarButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *pointLabel;

@property (nonatomic, strong) UIImageView *svipView;

@end

@implementation LJLivePkRankCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self lj_setupDataSource];
    [self lj_setupViews];
}

#pragma mark - Init

- (void)lj_setupDataSource
{
    
}

- (void)lj_setupViews
{
    self.avatarButton.layer.masksToBounds = YES;
    self.avatarButton.layer.cornerRadius = 33/2;
    self.avatarButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    //
    [self.contentView addSubview:self.svipView];
}

- (void)lj_updateConstraints
{
    kLJWeakSelf;
    [self.svipView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.nameLabel.mas_trailing).offset(10);
        make.centerY.equalTo(weakSelf.nameLabel);
    }];
}

#pragma mark - Events

- (IBAction)avatarButtonClick:(UIButton *)sender
{
    if (self.avatarBlock) self.avatarBlock();
}

#pragma mark - Getter

- (UIImageView *)svipView
{
    if (!_svipView) {
        _svipView = [[UIImageView alloc] init];
    }
    return _svipView;
}

#pragma mark - Setter

- (void)setFan:(LJLivePkTopFan *)fan
{
    _fan = fan;
    //
    [self.avatarButton sd_setImageWithURL:[NSURL URLWithString:fan.avatar] forState:UIControlStateNormal placeholderImage:kLJLiveManager.config.avatar];
    self.nameLabel.text = fan.userName;
    self.pointLabel.text = @(fan.points).stringValue;
    
    self.svipView.hidden = !(fan.isSVip || fan.isVip);
    if (fan.isVip) self.svipView.image = kLJImageNamed(@"lj_live_pk_rank_vip_icon");
    if (fan.isSVip) self.svipView.image = kLJImageNamed(@"lj_live_pk_rank_svip_icon");
    //
    [self lj_updateConstraints];
}

@end
