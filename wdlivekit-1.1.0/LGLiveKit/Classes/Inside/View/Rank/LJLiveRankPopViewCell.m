//
//  LJLiveRankPopViewCell.m
//  ActionSheetPicker-3.0
//
//  Created by Mimio on 2022/8/29.
//

#import "LJLiveRankPopViewCell.h"
#import "LJLiveMarkView.h"

@interface LJLiveRankPopViewCell ()





@property (strong, nonatomic) UILabel *coinsLabel;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIButton *avatarButton;
@property (nonatomic, strong) UIView *marksView;
@end

@implementation LJLiveRankPopViewCell



#pragma mark - Events


#pragma mark - Setter



#pragma mark - Getter






- (void)setMember:(LJLiveRoomMember *)member
{
    _member = member;
    
    [self.avatarButton sd_setImageWithURL:[NSURL URLWithString:member.avatar] forState:UIControlStateNormal placeholderImage:kLJLiveManager.config.avatar];
    self.nameLabel.text = member.nickName;
    self.coinsLabel.text = @(member.giftCost).stringValue;
    //
    [self lj_configMarksViewWithAnchor:member];
}
- (UIView *)marksView
{
    if (!_marksView) {
        _marksView = [[UIView alloc] initWithFrame:CGRectMake(81, 31, 200, 15)];
    }
    return _marksView;
}
- (void)lj_configMarksViewWithAnchor:(LJLiveRoomMember *)member
{
    for (UIView *subview in self.marksView.subviews) {
        [subview removeFromSuperview];
    }
    // age
    NSAttributedString *ageText = [[NSAttributedString alloc] initWithString:@(member.age).stringValue attributes:@{
        NSFontAttributeName: kLJHurmeBoldFont(9),
        NSForegroundColorAttributeName: UIColor.whiteColor
    }];
    CGFloat ageWidth = [LJLiveMarkView lj_widthForContent:ageText height:15];
    LJLiveMarkView *ageView = [[LJLiveMarkView alloc] initWithFrame:CGRectMake(0, 0, ageWidth, 15)];
    UIImage *ageImage = [UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
        graColor.fromColor = [member.gender isEqualToString:@"female"] ? kLJHexColor(0xFF6B6B) : kLJHexColor(0x6BAFFF);
        graColor.toColor = [member.gender isEqualToString:@"female"] ? kLJHexColor(0xFF578E) : kLJHexColor(0x478CFF);
        graColor.type = QQGradualChangeTypeLeftToRight;
    } size:CGSizeMake(ageWidth, 15) cornerRadius:QQRadiusMakeSame(7.5)];
    ageView.backgroundColor = [UIColor colorWithPatternImage:ageImage];
    ageView.icon = [member.gender isEqualToString:@"female"] ? kLJImageNamed(@"lj_live_rank_female_icon") : kLJImageNamed(@"lj_live_rank_male_icon");
    ageView.content = ageText;
    
    [self.marksView addSubview:ageView];
    
    CGFloat hotWidth = 0;
    CGFloat hostWidth = 0;
    if (member.roleType == LJLiveRoleTypeAnchor) {
        // hot
        NSAttributedString *hotText = [[NSAttributedString alloc] initWithString:@(member.commentUp).stringValue attributes:@{
            NSFontAttributeName: kLJHurmeBoldFont(9),
            NSForegroundColorAttributeName: UIColor.whiteColor
        }];
        hotWidth = [LJLiveMarkView lj_widthForContent:hotText height:15];
        LJLiveMarkView *hotView = [[LJLiveMarkView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(ageView.frame) + kLJWidthScale(3), 0, hotWidth, 15)];
        UIImage *hotImage = [UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
            graColor.fromColor = kLJHexColor(0xFEB570);
            graColor.toColor = kLJHexColor(0xFFA14E);
            graColor.type = QQGradualChangeTypeLeftToRight;
        } size:CGSizeMake(hotWidth, 15) cornerRadius:QQRadiusMakeSame(7.5)];
        hotView.backgroundColor = [UIColor colorWithPatternImage:hotImage];
        hotView.icon = kLJImageNamed(@"lj_live_rank_like_icon");
        hotView.content = hotText;
        [self.marksView addSubview:hotView];
        
        // anchor
        NSAttributedString *hostText = [[NSAttributedString alloc] initWithString:kLJLocalString(@"Anchor") attributes:@{
            NSFontAttributeName: kLJHurmeBoldFont(9),
            NSForegroundColorAttributeName: UIColor.whiteColor
        }];
        hostWidth = [LJLiveMarkView lj_widthForContent:hostText height:15];
        LJLiveMarkView *hostView = [[LJLiveMarkView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(hotView.frame) + kLJWidthScale(3), 0, hostWidth, 15)];
        UIImage *hostImage = [UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
            graColor.fromColor = kLJHexColor(0xFF459C);
            graColor.toColor = kLJHexColor(0xFE3F48);
            graColor.type = QQGradualChangeTypeLeftToRight;
        } size:CGSizeMake(hostWidth, 15) cornerRadius:QQRadiusMakeSame(7.5)];
        hostView.backgroundColor = [UIColor colorWithPatternImage:hostImage];
        hostView.icon = kLJImageNamed(@"lj_live_rank_anchor_icon");
        hostView.content = hostText;
        [self.marksView addSubview:hostView];
    }
    CGFloat width = ageWidth + hotWidth + hostWidth + kLJWidthScale(3)*2;
    self.marksView.frame = CGRectMake(76, 31, width, 15);
    
    // RTL
    self.marksView.frame = LJFlipedScreenBy(self.marksView.frame);
    for (UIView *subview in self.marksView.subviews) {
        subview.frame = LJFlipedBy(subview.frame, self.marksView.frame);
    }
}
- (void)avatarButtonClick:(UIButton *)sender
{
    if (self.avatarBlock) self.avatarBlock();
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
- (void)lj_setupViews
{
    [self.contentView addSubview:self.rankLabel];
    [self.contentView addSubview:self.avatarButton];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.maskView];
    [self.contentView addSubview:self.coinsLabel];
    [self.contentView addSubview:self.marksView];
}
- (UILabel *)coinsLabel{
    if (!_coinsLabel) {
        _coinsLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLJScreenWidth - 16 - 45 , 21, 45, 14.5)];
        _coinsLabel.textAlignment = NSTextAlignmentRight;
        _coinsLabel.font = kLJHurmeBoldFont(12);
        _coinsLabel.textColor = kLJHexColor(0x080808);
    }
    return _coinsLabel;
}
- (UILabel *)rankLabel{
    if (!_rankLabel) {
        _rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 19.5, 10, 16.5)];
        _rankLabel.textAlignment = NSTextAlignmentCenter;
        _rankLabel.font = kLJHurmeBoldFont(14);
    }
    return _rankLabel;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self lj_setupViews];
    }
    return self;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(81, 11, kLJScreenWidth - 81 - 60, 16.5)];
        _nameLabel.font = kLJHurmeBoldFont(14);
        _nameLabel.textColor = kLJHexColor(0x080808);
    }
    return _nameLabel;
}
@end
