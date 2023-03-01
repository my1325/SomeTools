//
//  GYLiveRankPopViewCell.m
//  ActionSheetPicker-3.0
//
//  Created by Mimio on 2022/8/29.
//

#import "GYLiveRankPopViewCell.h"
#import "GYLiveMarkView.h"

@interface GYLiveRankPopViewCell ()

@property (strong, nonatomic) UIButton *avatarButton;

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UILabel *coinsLabel;

@property (nonatomic, strong) UIView *marksView;

@end

@implementation GYLiveRankPopViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self fb_setupViews];
    }
    return self;
}

- (void)fb_setupViews
{
    [self.contentView addSubview:self.rankLabel];
    [self.contentView addSubview:self.avatarButton];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.maskView];
    [self.contentView addSubview:self.coinsLabel];
    [self.contentView addSubview:self.marksView];
}

#pragma mark - Events

- (void)avatarButtonClick:(UIButton *)sender
{
    if (self.avatarBlock) self.avatarBlock();
}

#pragma mark - Setter

- (void)setMember:(GYLiveRoomMember *)member
{
    _member = member;
    
    [self.avatarButton sd_setImageWithURL:[NSURL URLWithString:member.avatar] forState:UIControlStateNormal placeholderImage:kGYLiveManager.config.avatar];
    self.nameLabel.text = member.nickName;
    self.coinsLabel.text = @(member.giftCost).stringValue;
    //
    [self fb_configMarksViewWithAnchor:member];
}

- (void)fb_configMarksViewWithAnchor:(GYLiveRoomMember *)member
{
    for (UIView *subview in self.marksView.subviews) {
        [subview removeFromSuperview];
    }
    // age
    NSAttributedString *ageText = [[NSAttributedString alloc] initWithString:@(member.age).stringValue attributes:@{
        NSFontAttributeName: kGYHurmeBoldFont(9),
        NSForegroundColorAttributeName: UIColor.whiteColor
    }];
    CGFloat ageWidth = [GYLiveMarkView fb_widthForContent:ageText height:15];
    GYLiveMarkView *ageView = [[GYLiveMarkView alloc] initWithFrame:CGRectMake(0, 0, ageWidth, 15)];
    UIImage *ageImage = [UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
        graColor.fromColor = [member.gender isEqualToString:@"female"] ? kGYHexColor(0xFF6B6B) : kGYHexColor(0x6BAFFF);
        graColor.toColor = [member.gender isEqualToString:@"female"] ? kGYHexColor(0xFF578E) : kGYHexColor(0x478CFF);
        graColor.type = QQGradualChangeTypeLeftToRight;
    } size:CGSizeMake(ageWidth, 15) cornerRadius:QQRadiusMakeSame(7.5)];
    ageView.backgroundColor = [UIColor colorWithPatternImage:ageImage];
    ageView.icon = [member.gender isEqualToString:@"female"] ? kGYImageNamed(@"fb_live_rank_female_icon") : kGYImageNamed(@"fb_live_rank_male_icon");
    ageView.content = ageText;
    
    [self.marksView addSubview:ageView];
    
    CGFloat hotWidth = 0;
    CGFloat hostWidth = 0;
    if (member.roleType == GYLiveRoleTypeAnchor) {
        // hot
        NSAttributedString *hotText = [[NSAttributedString alloc] initWithString:@(member.commentUp).stringValue attributes:@{
            NSFontAttributeName: kGYHurmeBoldFont(9),
            NSForegroundColorAttributeName: UIColor.whiteColor
        }];
        hotWidth = [GYLiveMarkView fb_widthForContent:hotText height:15];
        GYLiveMarkView *hotView = [[GYLiveMarkView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(ageView.frame) + kGYWidthScale(3), 0, hotWidth, 15)];
        UIImage *hotImage = [UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
            graColor.fromColor = kGYHexColor(0xFEB570);
            graColor.toColor = kGYHexColor(0xFFA14E);
            graColor.type = QQGradualChangeTypeLeftToRight;
        } size:CGSizeMake(hotWidth, 15) cornerRadius:QQRadiusMakeSame(7.5)];
        hotView.backgroundColor = [UIColor colorWithPatternImage:hotImage];
        hotView.icon = kGYImageNamed(@"fb_live_rank_like_icon");
        hotView.content = hotText;
        [self.marksView addSubview:hotView];
        
        // anchor
        NSAttributedString *hostText = [[NSAttributedString alloc] initWithString:kGYLocalString(@"Anchor") attributes:@{
            NSFontAttributeName: kGYHurmeBoldFont(9),
            NSForegroundColorAttributeName: UIColor.whiteColor
        }];
        hostWidth = [GYLiveMarkView fb_widthForContent:hostText height:15];
        GYLiveMarkView *hostView = [[GYLiveMarkView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(hotView.frame) + kGYWidthScale(3), 0, hostWidth, 15)];
        UIImage *hostImage = [UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
            graColor.fromColor = kGYHexColor(0xFF459C);
            graColor.toColor = kGYHexColor(0xFE3F48);
            graColor.type = QQGradualChangeTypeLeftToRight;
        } size:CGSizeMake(hostWidth, 15) cornerRadius:QQRadiusMakeSame(7.5)];
        hostView.backgroundColor = [UIColor colorWithPatternImage:hostImage];
        hostView.icon = kGYImageNamed(@"fb_live_rank_anchor_icon");
        hostView.content = hostText;
        [self.marksView addSubview:hostView];
    }
    CGFloat width = ageWidth + hotWidth + hostWidth + kGYWidthScale(3)*2;
    self.marksView.frame = CGRectMake(76, 31, width, 15);
    
    // RTL
    self.marksView.frame = GYFlipedScreenBy(self.marksView.frame);
    for (UIView *subview in self.marksView.subviews) {
        subview.frame = GYFlipedBy(subview.frame, self.marksView.frame);
    }
}

#pragma mark - Getter

- (UIView *)marksView
{
    if (!_marksView) {
        _marksView = [[UIView alloc] initWithFrame:CGRectMake(81, 31, 200, 15)];
    }
    return _marksView;
}

- (UILabel *)rankLabel{
    if (!_rankLabel) {
        _rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 19.5, 10, 16.5)];
        _rankLabel.textAlignment = NSTextAlignmentCenter;
        _rankLabel.font = kGYHurmeBoldFont(14);
    }
    return _rankLabel;
}

- (UIButton *)avatarButton{
    if (!_avatarButton) {
        _avatarButton = [[UIButton alloc] initWithFrame:CGRectMake(37, 9, 38, 38)];
        _avatarButton.layer.masksToBounds = YES;
        _avatarButton.layer.cornerRadius = 38/2;
        _avatarButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_avatarButton addTarget:self action:@selector(avatarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _avatarButton;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(81, 11, kGYScreenWidth - 81 - 60, 16.5)];
        _nameLabel.font = kGYHurmeBoldFont(14);
        _nameLabel.textColor = kGYHexColor(0x080808);
    }
    return _nameLabel;
}

- (UILabel *)coinsLabel{
    if (!_coinsLabel) {
        _coinsLabel = [[UILabel alloc] initWithFrame:CGRectMake(kGYScreenWidth - 16 - 45 , 21, 45, 14.5)];
        _coinsLabel.textAlignment = NSTextAlignmentRight;
        _coinsLabel.font = kGYHurmeBoldFont(12);
        _coinsLabel.textColor = kGYHexColor(0x080808);
    }
    return _coinsLabel;
}

@end
