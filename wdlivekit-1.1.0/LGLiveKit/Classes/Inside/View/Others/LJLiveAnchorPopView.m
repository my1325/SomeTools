//
//  LJLiveAnchorPopView.m
//  ActionSheetPicker-3.0
//
//  Created by Mimio on 2022/8/15.
//

#import "LJLiveAnchorPopView.h"
#import "LJLiveMedalListView.h"

@interface LJLiveAnchorPopView()
@property (nonatomic, strong) UIView *medalView;
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UIButton *reportButton;
@property (nonatomic, strong) UILabel *signLabel;
@property (nonatomic, strong) UIScrollView *medalScroll;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, strong) UIButton *messageButton;
@property (nonatomic, strong) UILabel *followingTitleLabel;
@property (nonatomic, strong) UILabel *followersLabel;
@property (nonatomic, strong) UILabel *followersTitleLabel;
@property (nonatomic, strong) UILabel *medalsTitleLabel;
@property (nonatomic, strong) UILabel *medalsLabel;
@property (nonatomic, strong) UIImageView *genderImageView;
@property (nonatomic, strong) UIImageView *genderBgView;
@property (nonatomic, strong) UILabel *followingLabel;
@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *anchorBgView;
@end

@implementation LJLiveAnchorPopView
+ (LJLiveAnchorPopView *)anchorView
{
    LJLiveAnchorPopView *anchorView = [[self alloc] init];
    return anchorView;
}




#pragma mark - UI


#pragma mark - 点击事件





#pragma mark - Get


















- (UIButton *)followButton{
    if (!_followButton) {
        _followButton = [[UIButton alloc] initWithFrame:CGRectMake(150, 296, kLJScreenWidth - 45 - 120, 50)];
        _followButton.titleLabel.font = kLJHurmeBoldFont(17);
        [_followButton setTitle:kLJLocalString(@"+ Follow") forState:UIControlStateNormal];
        UIImage *image = [UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
            graColor.fromColor = kLJHexColor(0xFF32A1);
            graColor.toColor = kLJHexColor(0xFC5F7C);
            graColor.type = QQGradualChangeTypeLeftToRight;
        } size:CGSizeMake(_followButton.width, 50) cornerRadius:QQRadiusMakeSame(25)];
        [_followButton setBackgroundImage:image forState:UIControlStateNormal];
        [_followButton setLayerShadow:kLJColorFromRGBA(0xFF32A1, 0.56) offset:CGSizeMake(0, 5) radius:8];
        
        [_followButton setTitle:kLJLocalString(@"Followed") forState:UIControlStateSelected];
        UIImage *selectImage = [UIImage imageWithQQCorner:^(QQCorner *corner) {
            corner.fillColor = kLJHexColor(0xDDE0E4);
            corner.radius = QQRadiusMakeSame(25);
        } size:CGSizeMake(_followButton.width, 50)];
        [_followButton setBackgroundImage:selectImage forState:UIControlStateSelected];
        [_followButton setLayerShadow:kLJColorFromRGBA(0xDDE0E4, 0.56) offset:CGSizeMake(0, 5) radius:8];
        [_followButton addTarget:self action:@selector(followButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _followButton;
}
- (void)lj_showInView:(UIView *)inView{
    for (UIView *subview in inView.subviews) {
        if ([subview isKindOfClass:[self class]]) {
            return;
        }
    }
    [inView addSubview:self];
    self.y = 0;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.y = kLJScreenHeight - (kLJBottomSafeHeight + self.contentHeight);
        self.avatar.y = kLJScreenHeight - self.contentHeight - 41 - kLJBottomSafeHeight;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    } completion:^(BOOL finished) {}];
}
- (UIButton *)messageButton{
    if (!_messageButton) {
        _messageButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 296, 120, 50)];
        _messageButton.layer.masksToBounds = YES;
        _messageButton.layer.borderWidth = 2;
        _messageButton.layer.borderColor = kLJHexColor(0xFF32A1).CGColor;
        _messageButton.layer.cornerRadius = 25;
        [_messageButton setTitle:kLJLocalString(@"Message") forState:UIControlStateNormal];
        _messageButton.titleLabel.font = kLJHurmeBoldFont(17);
        [_messageButton setTitleColor:kLJHexColor(0xFF32A1) forState:UIControlStateNormal];
        [_messageButton addTarget:self action:@selector(messageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageButton;
}
- (UILabel *)signLabel{
    if (!_signLabel) {
        _signLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 106, kLJScreenWidth - 96, 29)];
        _signLabel.font = kLJHurmeRegularFont(12);
        _signLabel.textColor = kLJHexColor(0xA09E9E);
        _signLabel.numberOfLines = 2;
        _signLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _signLabel;
}
- (UIImageView *)genderImageView{
    if (!_genderImageView) {
        _genderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 3, 13, 13)];
    }
    return _genderImageView;
}
- (UILabel *)ageLabel{
    if (!_ageLabel) {
        _ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 16, 18)];
        _ageLabel.font = kLJHurmeBoldFont(11);
        _ageLabel.textColor = UIColor.whiteColor;
        _ageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _ageLabel;
}
- (UILabel *)followersLabel{
    if (!_followersLabel) {
        _followersLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLJScreenWidth/3, 163.5, kLJScreenWidth/3, 22)];
        _followersLabel.font = [UIFont fontWithName:@"DINCondensed-Bold" size:22];
        _followersLabel.textColor = kLJHexColor(0x080808);
        _followersLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _followersLabel;
}
- (UILabel *)medalsLabel{
    if (!_medalsLabel) {
        _medalsLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLJScreenWidth/3*2, 163.5, kLJScreenWidth/3, 22)];
        _medalsLabel.font = [UIFont fontWithName:@"DINCondensed-Bold" size:22];
        _medalsLabel.textColor = kLJHexColor(0x080808);
        _medalsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _medalsLabel;
}
- (UIImageView *)genderBgView{
    if (!_genderBgView) {
        _genderBgView = [[UIImageView alloc] initWithFrame:CGRectMake(kLJScreenWidth/2 - 117/2, 79, 40.5, 18)];
        _genderBgView.layer.cornerRadius = 9;
        _genderBgView.layer.masksToBounds = YES;
    }
    return _genderBgView;
}
- (void)reportButtonClick:(UIButton *)sender
{
    kLJWeakSelf;
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVc addAction:[UIAlertAction actionWithTitle:kLJLocalString(@"Report") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (weakSelf.reportBlock) weakSelf.reportBlock();
        //
        LJEvent(@"lj_LiveTouchReport", nil);
    }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:(_anchor.blacklistStatus == 2)?kLJLocalString(@"Unblock"):kLJLocalString(@"Block") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [LJLiveInside lj_loading];
        if (weakSelf.anchor.blacklistStatus == 2){
            [LJLiveNetworkHelper lj_cancelBlockByTargetAccountId:weakSelf.anchor.accountId success:^{
                [LJLiveInside lj_hideLoading];
                LJTipSuccess(kLJLocalString(@"Unblock Successfully."));
                weakSelf.anchor.blacklistStatus = 1;
            } failure:^{
                [LJLiveInside lj_hideLoading];
            }];
        }else{
            [LJLiveNetworkHelper lj_blockByTargetAccountId:weakSelf.anchor.accountId success:^{
                [LJLiveInside lj_hideLoading];
                LJTipSuccess(kLJLocalString(@"Block Successfully."));
                weakSelf.anchor.blacklistStatus = 2;
            } failure:^{
                [LJLiveInside lj_hideLoading];
            }];
        }
    }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:kLJLocalString(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [[LJLiveMethods lj_currentViewController] presentViewController:alertVc animated:YES completion:nil];
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, kLJScreenWidth, 20)];
        _nameLabel.font = kLJHurmeBoldFont(17);
        _nameLabel.textColor = kLJHexColor(0x080808);
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, kLJScreenHeight, kLJScreenWidth, kLJScreenHeight);
        [self lj_creatUI];
    }
    return self;
}
- (UIScrollView *)medalScroll{
    if (!_medalScroll) {
        _medalScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 15, kLJScreenWidth - 30 - 98, 20)];
        UIColor *color1 = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        UIColor *color2 = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        UIColor *color3 = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
        NSArray *locations = [NSArray arrayWithObjects:@(0.0), @(0.85),@(1.0), nil];
        NSArray *colors = [NSArray arrayWithObjects:(id)color1.CGColor, color2.CGColor,color3.CGColor, nil];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        //设置开始和结束位置(设置渐变的方向)
        gradient.startPoint = kLJLiveManager.inside.appRTL?CGPointMake(1, 0):CGPointMake(0, 0);
        gradient.endPoint = kLJLiveManager.inside.appRTL?CGPointMake(0, 0):CGPointMake(1, 0);

        gradient.locations = locations;
        gradient.colors = colors;
        gradient.frame = CGRectMake(0, 0 , kLJScreenWidth - 30 - 98, 50);
        _medalScroll.layer.mask = gradient;
        
        if (kLJLiveManager.inside.appRTL) {
            _medalScroll.frame = LJFlipedBy(_medalScroll.frame, _medalView.bounds);
        }
    }
    return _medalScroll;
}
- (UIView *)medalView{
    if (!_medalView) {
        _medalView = [[UIView alloc] initWithFrame:CGRectMake(15, 221, kLJScreenWidth - 30, 50)];
        UIImage *hostImage = [UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
            graColor.fromColor = kLJHexColor(0xFFEEE7);
            graColor.toColor = kLJHexColor(0xFFE0E0);
            graColor.type = QQGradualChangeTypeLeftToRight;
        } size:CGSizeMake(kLJScreenWidth - 30, 50) cornerRadius:QQRadiusMakeSame(10)];
        _medalView.backgroundColor = [UIColor colorWithPatternImage:hostImage];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(medalClick)];
        [_medalView addGestureRecognizer:tap];
        
        UILabel *medalTitle = [[UILabel alloc] initWithFrame:CGRectMake(kLJScreenWidth - 30 - 31 -47, 17, 50, 17)];
        medalTitle.text = kLJLocalString(@"Medals");
        medalTitle.textColor = kLJHexColor(0xC8B2B3);
        medalTitle.font = kLJHurmeRegularFont(14);
        [_medalView addSubview:medalTitle];
        
        UIImageView *medalArrow = [[UIImageView alloc] initWithFrame:CGRectMake(kLJScreenWidth - 30 - 12 - 11, 19.5, 11, 11)];
        medalArrow.image = [kLJImageNamed(@"lj_live_medal_arrow") lj_flipedByRTL];
        [_medalView addSubview:medalArrow];
        
        if (kLJLiveManager.inside.appRTL) {
            medalTitle.frame = LJFlipedBy(medalTitle.frame, _medalView.bounds);
            medalArrow.frame = LJFlipedBy(medalArrow.frame, _medalView.bounds);
        }
    }
    return _medalView;
}
- (void)avatarButtonClick:(UIButton *)sender
{
    if (self.avatarBlock) self.avatarBlock();
    LJEvent(@"lj_LiveInfoTouchAvatar", nil);
}
-(void)medalClick{
    LJLiveMedalListView *medalList = [[LJLiveMedalListView alloc] init];
    [medalList lj_showInView:self.superview withAccountId:_anchor.accountId];
    [self lj_dismiss];
}
- (UIImageView *)avatar{
    if (!_avatar) {
        _avatar = [[UIImageView alloc] initWithFrame:CGRectMake(kLJScreenWidth/2 - 41, kLJScreenHeight, 82, 82)];
        _avatar.userInteractionEnabled = YES;
        _avatar.contentMode = UIViewContentModeScaleAspectFill;
        _avatar.backgroundColor = UIColor.whiteColor;
        _avatar.layer.borderColor = UIColor.whiteColor.CGColor;
        _avatar.layer.borderWidth = 2;
        _avatar.layer.cornerRadius = 41;
        _avatar.layer.masksToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarButtonClick:)];
        [_avatar addGestureRecognizer:tap];
    }
    return _avatar;
}
- (UILabel *)followersTitleLabel{
    if (!_followersTitleLabel) {
        _followersTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLJScreenWidth/3, 186, kLJScreenWidth/3, 14)];
        _followersTitleLabel.font = kLJHurmeRegularFont(12);
        _followersTitleLabel.text = kLJLocalString(@"Followers");
        _followersTitleLabel.textColor = kLJHexColor(0xA09E9E);
        _followersTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _followersTitleLabel;
}
-(void)lj_creatUI{
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:self.bounds];
    [self addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(lj_dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    self.contentHeight = 360;
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kLJScreenHeight, kLJScreenWidth, self.contentHeight + kLJBottomSafeHeight)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView updateCornerRadius:^(QQCorner *corner) {
        corner.radius = QQRadiusMake(12, 12, 0, 0);
    }];
    [self addSubview:self.contentView];

    [self addSubview:self.avatar];
    [self.contentView addSubview:self.reportButton];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.genderBgView];
    [self.genderBgView addSubview:self.genderImageView];
    [self.genderBgView addSubview:self.ageLabel];
    [self.contentView addSubview:self.anchorBgView];
    [self.contentView addSubview:self.signLabel];
    [self.contentView addSubview:self.followingLabel];
    [self.contentView addSubview:self.followersLabel];
    [self.contentView addSubview:self.medalsLabel];
    [self.contentView addSubview:self.followingTitleLabel];
    [self.contentView addSubview:self.followersTitleLabel];
    [self.contentView addSubview:self.medalsTitleLabel];
    [self.contentView addSubview:self.medalView];
    [self.medalView addSubview:self.medalScroll];
    if (!kLJLiveHelper.data.current.isUgc) {
        [self.contentView addSubview:self.messageButton];
        [self.contentView addSubview:self.followButton];
    }
}
- (void)followButtonClick:(UIButton *)sender
{
    self.followButton.selected = !self.followButton.selected;
    if (self.followBlock) self.followBlock(self.followButton.selected);
}
- (UILabel *)followingTitleLabel{
    if (!_followingTitleLabel) {
        _followingTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 186, kLJScreenWidth/3, 14)];
        _followingTitleLabel.font = kLJHurmeRegularFont(12);
        _followingTitleLabel.text = kLJLocalString(@"Following");
        _followingTitleLabel.textColor = kLJHexColor(0xA09E9E);
        _followingTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _followingTitleLabel;
}
- (UILabel *)followingLabel{
    if (!_followingLabel) {
        _followingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 163.5, kLJScreenWidth/3, 22)];
        _followingLabel.font = [UIFont fontWithName:@"DINCondensed-Bold" size:22];
        _followingLabel.textColor = kLJHexColor(0x080808);
        _followingLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _followingLabel;
}
- (void)setAnchor:(LJLiveRoomAnchor *)anchor{
    _anchor = anchor;
    [self.avatar sd_setImageWithURL:anchor.avatar.mj_url placeholderImage:kLJLiveManager.config.avatar];
    self.nameLabel.text = anchor.anchorName;
    self.signLabel.text = anchor.mood.length == 0 ? kLJLiveManager.config.mood : anchor.mood;
    self.ageLabel.text = @(anchor.age).stringValue;
    self.genderImageView.image = [anchor.gender isEqualToString:@"female"] ? kLJImageNamed(@"lj_live_rank_female_icon") : kLJImageNamed(@"lj_live_rank_male_icon");
    UIImage *ageImage = [UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
        graColor.fromColor = [anchor.gender isEqualToString:@"female"] ? kLJHexColor(0xFF6B6B) : kLJHexColor(0x6BAFFF);
        graColor.toColor = [anchor.gender isEqualToString:@"female"] ? kLJHexColor(0xFF578E) : kLJHexColor(0x478CFF);
        graColor.type = QQGradualChangeTypeLeftToRight;
    } size:CGSizeMake(self.genderBgView.width, 18) cornerRadius:QQRadiusMakeSame(9)];
    self.genderBgView.backgroundColor = [UIColor colorWithPatternImage:ageImage];
    self.followingLabel.text = anchor.followerings>1000?[NSString stringWithFormat:@"%.2fk",anchor.followerings/1000.0]:@(anchor.followerings).stringValue;
    self.followersLabel.text = anchor.followers>1000?[NSString stringWithFormat:@"%.2fk",anchor.followers/1000.0]:@(anchor.followers).stringValue;
    self.medalsLabel.text = @(anchor.eventLables.count).stringValue;
    self.followButton.selected = anchor.isFollowed;
    
    if (anchor.eventLables.count == 0) {
        self.medalView.hidden = YES;
        self.contentHeight = 295;
        self.messageButton.top = 231;
        self.followButton.top = 231;
    }else{
        for (int i = 0;i < anchor.eventLables.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 0, 20)];
            imageView.tag = 100 + i;
            [self.medalScroll addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(i==0?self.medalScroll.mas_leading:((UIView *)[self.medalScroll viewWithTag:100+i-1]).mas_trailing).offset((i==0 && kLJLiveManager.inside.appRTL)?-(kLJScreenWidth - 30 - 98):5);
                make.top.equalTo(self.medalScroll);
                make.height.mas_equalTo(20);
            }];
            [imageView sd_setImageWithURL:anchor.eventLables[i] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                
                [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(image?(image.size.width*20.0/image.size.height):0);
                }];
            }];
        }
    }
    
}
- (UIButton *)reportButton{
    if (!_reportButton) {
        _reportButton = [[UIButton alloc] initWithFrame:CGRectMake(kLJScreenWidth - 15 - 24, 10, 29, 26)];
        [_reportButton setImage:kLJImageNamed(@"lj_live_report_icon") forState:UIControlStateNormal];
        [_reportButton addTarget:self action:@selector(reportButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reportButton;
}
- (void)lj_dismiss{
    [UIView animateWithDuration:0.1 animations:^{
        self.contentView.y = kLJScreenHeight;
        self.avatar.y = kLJScreenHeight;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}
- (void)messageButtonClick:(UIButton *)sender
{
    if (self.messageBlock) self.messageBlock();
}
- (UILabel *)medalsTitleLabel{
    if (!_medalsTitleLabel) {
        _medalsTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLJScreenWidth/3*2, 186, kLJScreenWidth/3, 14)];
        _medalsTitleLabel.font = kLJHurmeRegularFont(12);
        _medalsTitleLabel.text = kLJLocalString(@"Medals");
        _medalsTitleLabel.textColor = kLJHexColor(0xA09E9E);
        _medalsTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _medalsTitleLabel;
}
- (UIImageView *)anchorBgView{
    if (!_anchorBgView) {
        _anchorBgView = [[UIImageView alloc] initWithFrame:CGRectMake(kLJScreenWidth/2 - 117/2 + 50, 79, 67, 18)];
        UIImage *hostImage = [UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
            graColor.fromColor = kLJHexColor(0xFF459C);
            graColor.toColor = kLJHexColor(0xFE3F48);
            graColor.type = QQGradualChangeTypeLeftToRight;
        } size:CGSizeMake(67, 18) cornerRadius:QQRadiusMakeSame(9)];
        _anchorBgView.backgroundColor = [UIColor colorWithPatternImage:hostImage];
        
        UIImageView *anchorIcon = [[UIImageView alloc] initWithFrame:CGRectMake(6, 2, 13, 14.5)];
        anchorIcon.image = kLJImageNamed(@"lj_live_rank_anchor_icon");
        [_anchorBgView addSubview:anchorIcon];
        
        UILabel *anchorTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 40, 18)];
        anchorTitle.text = kLJLocalString(@"Anchor");
        anchorTitle.textAlignment = NSTextAlignmentCenter;
        anchorTitle.textColor = UIColor.whiteColor;
        anchorTitle.font = kLJHurmeBoldFont(11);
        [_anchorBgView addSubview:anchorTitle];
    }
    return _anchorBgView;
}
@end
