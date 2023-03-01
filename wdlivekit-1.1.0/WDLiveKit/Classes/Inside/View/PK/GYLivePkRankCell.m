//
//  GYLivePkRankCell.m
//  Woohoo
//
//  Created by M2-mini on 2021/11/26.
//

#import "GYLivePkRankCell.h"

@interface GYLivePkRankCell ()

@property (weak, nonatomic) IBOutlet UIButton *avatarButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *pointLabel;

@property (nonatomic, strong) UIImageView *svipView;

@end

@implementation GYLivePkRankCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self fb_setupDataSource];
    [self fb_setupViews];
}

#pragma mark - Init

- (void)fb_setupDataSource
{
    
}

- (void)fb_setupViews
{
    self.avatarButton.layer.masksToBounds = YES;
    self.avatarButton.layer.cornerRadius = 33/2;
    self.avatarButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    //
    [self.contentView addSubview:self.svipView];
}

- (void)fb_updateConstraints
{
    kGYWeakSelf;
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

- (void)setFan:(GYLivePkTopFan *)fan
{
    _fan = fan;
    //
    [self.avatarButton sd_setImageWithURL:[NSURL URLWithString:fan.avatar] forState:UIControlStateNormal placeholderImage:kGYLiveManager.config.avatar];
    self.nameLabel.text = fan.userName;
    self.pointLabel.text = @(fan.points).stringValue;
    
    self.svipView.hidden = !(fan.isSVip || fan.isVip);
    if (fan.isVip) self.svipView.image = kGYImageNamed(@"fb_live_pk_rank_vip_icon");
    if (fan.isSVip) self.svipView.image = kGYImageNamed(@"fb_live_pk_rank_svip_icon");
    //
    [self fb_updateConstraints];
}

@end
