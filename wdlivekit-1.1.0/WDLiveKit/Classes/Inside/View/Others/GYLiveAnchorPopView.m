//
//  GYLiveAnchorPopView.m
//  ActionSheetPicker-3.0
//
//  Created by Mimio on 2022/8/15.
//

#import "GYLiveAnchorPopView.h"
#import "GYLiveMedalListView.h"

@interface GYLiveAnchorPopView()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *genderBgView;
@property (nonatomic, strong) UIImageView *genderImageView;
@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) UIImageView *anchorBgView;
@property (nonatomic, strong) UILabel *signLabel;
@property (nonatomic, strong) UILabel *followingLabel;
@property (nonatomic, strong) UILabel *followersLabel;
@property (nonatomic, strong) UILabel *medalsLabel;
@property (nonatomic, strong) UILabel *followingTitleLabel;
@property (nonatomic, strong) UILabel *followersTitleLabel;
@property (nonatomic, strong) UILabel *medalsTitleLabel;
@property (nonatomic, strong) UIView *medalView;
@property (nonatomic, strong) UIScrollView *medalScroll;
@property (nonatomic, strong) UIButton *messageButton;
@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, strong) UIButton *reportButton;
@end

@implementation GYLiveAnchorPopView
+ (GYLiveAnchorPopView *)anchorView
{
    GYLiveAnchorPopView *anchorView = [[self alloc] init];
    return anchorView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, kGYScreenHeight, kGYScreenWidth, kGYScreenHeight);
        [self fb_creatUI];
    }
    return self;
}

- (void)fb_showInView:(UIView *)inView{
    for (UIView *subview in inView.subviews) {
        if ([subview isKindOfClass:[self class]]) {
            return;
        }
    }
    [inView addSubview:self];
    self.y = 0;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.y = kGYScreenHeight - (kGYBottomSafeHeight + self.contentHeight);
        self.avatar.y = kGYScreenHeight - self.contentHeight - 41 - kGYBottomSafeHeight;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    } completion:^(BOOL finished) {}];
}

- (void)fb_dismiss{
    [UIView animateWithDuration:0.1 animations:^{
        self.contentView.y = kGYScreenHeight;
        self.avatar.y = kGYScreenHeight;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

#pragma mark - UI
-(void)fb_creatUI{
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:self.bounds];
    [self addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(fb_dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    self.contentHeight = 360;
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kGYScreenHeight, kGYScreenWidth, self.contentHeight + kGYBottomSafeHeight)];
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
    if (!kGYLiveHelper.data.current.isUgc) {
        [self.contentView addSubview:self.messageButton];
        [self.contentView addSubview:self.followButton];
    }
}

- (void)setAnchor:(GYLiveRoomAnchor *)anchor{
    _anchor = anchor;
    [self.avatar sd_setImageWithURL:anchor.avatar.mj_url placeholderImage:kGYLiveManager.config.avatar];
    self.nameLabel.text = anchor.anchorName;
    self.signLabel.text = anchor.mood.length == 0 ? kGYLiveManager.config.mood : anchor.mood;
    self.ageLabel.text = @(anchor.age).stringValue;
    self.genderImageView.image = [anchor.gender isEqualToString:@"female"] ? kGYImageNamed(@"fb_live_rank_female_icon") : kGYImageNamed(@"fb_live_rank_male_icon");
    UIImage *ageImage = [UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
        graColor.fromColor = [anchor.gender isEqualToString:@"female"] ? kGYHexColor(0xFF6B6B) : kGYHexColor(0x6BAFFF);
        graColor.toColor = [anchor.gender isEqualToString:@"female"] ? kGYHexColor(0xFF578E) : kGYHexColor(0x478CFF);
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
                make.leading.equalTo(i==0?self.medalScroll.mas_leading:((UIView *)[self.medalScroll viewWithTag:100+i-1]).mas_trailing).offset((i==0 && kGYLiveManager.inside.appRTL)?-(kGYScreenWidth - 30 - 98):5);
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

#pragma mark - 点击事件
- (void)avatarButtonClick:(UIButton *)sender
{
    if (self.avatarBlock) self.avatarBlock();
    GYEvent(@"fb_LiveInfoTouchAvatar", nil);
}

- (void)reportButtonClick:(UIButton *)sender
{
    kGYWeakSelf;
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVc addAction:[UIAlertAction actionWithTitle:kGYLocalString(@"Report") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (weakSelf.reportBlock) weakSelf.reportBlock();
        //
        GYEvent(@"fb_LiveTouchReport", nil);
    }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:(_anchor.blacklistStatus == 2)?kGYLocalString(@"Unblock"):kGYLocalString(@"Block") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [GYLiveInside fb_loading];
        if (weakSelf.anchor.blacklistStatus == 2){
            [GYLiveNetworkHelper fb_cancelBlockByTargetAccountId:weakSelf.anchor.accountId success:^{
                [GYLiveInside fb_hideLoading];
                GYTipSuccess(kGYLocalString(@"Unblock Successfully."));
                weakSelf.anchor.blacklistStatus = 1;
            } failure:^{
                [GYLiveInside fb_hideLoading];
            }];
        }else{
            [GYLiveNetworkHelper fb_blockByTargetAccountId:weakSelf.anchor.accountId success:^{
                [GYLiveInside fb_hideLoading];
                GYTipSuccess(kGYLocalString(@"Block Successfully."));
                weakSelf.anchor.blacklistStatus = 2;
            } failure:^{
                [GYLiveInside fb_hideLoading];
            }];
        }
    }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:kGYLocalString(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [[GYLiveMethods fb_currentViewController] presentViewController:alertVc animated:YES completion:nil];
}

- (void)messageButtonClick:(UIButton *)sender
{
    if (self.messageBlock) self.messageBlock();
}

- (void)followButtonClick:(UIButton *)sender
{
    self.followButton.selected = !self.followButton.selected;
    if (self.followBlock) self.followBlock(self.followButton.selected);
}

-(void)medalClick{
    GYLiveMedalListView *medalList = [[GYLiveMedalListView alloc] init];
    [medalList fb_showInView:self.superview withAccountId:_anchor.accountId];
    [self fb_dismiss];
}

#pragma mark - Get
- (UIImageView *)avatar{
    if (!_avatar) {
        _avatar = [[UIImageView alloc] initWithFrame:CGRectMake(kGYScreenWidth/2 - 41, kGYScreenHeight, 82, 82)];
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

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, kGYScreenWidth, 20)];
        _nameLabel.font = kGYHurmeBoldFont(17);
        _nameLabel.textColor = kGYHexColor(0x080808);
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UIButton *)reportButton{
    if (!_reportButton) {
        _reportButton = [[UIButton alloc] initWithFrame:CGRectMake(kGYScreenWidth - 15 - 24, 10, 29, 26)];
        [_reportButton setImage:kGYImageNamed(@"fb_live_report_icon") forState:UIControlStateNormal];
        [_reportButton addTarget:self action:@selector(reportButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reportButton;
}

- (UIImageView *)genderBgView{
    if (!_genderBgView) {
        _genderBgView = [[UIImageView alloc] initWithFrame:CGRectMake(kGYScreenWidth/2 - 117/2, 79, 40.5, 18)];
        _genderBgView.layer.cornerRadius = 9;
        _genderBgView.layer.masksToBounds = YES;
    }
    return _genderBgView;
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
        _ageLabel.font = kGYHurmeBoldFont(11);
        _ageLabel.textColor = UIColor.whiteColor;
        _ageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _ageLabel;
}

- (UIImageView *)anchorBgView{
    if (!_anchorBgView) {
        _anchorBgView = [[UIImageView alloc] initWithFrame:CGRectMake(kGYScreenWidth/2 - 117/2 + 50, 79, 67, 18)];
        UIImage *hostImage = [UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
            graColor.fromColor = kGYHexColor(0xFF459C);
            graColor.toColor = kGYHexColor(0xFE3F48);
            graColor.type = QQGradualChangeTypeLeftToRight;
        } size:CGSizeMake(67, 18) cornerRadius:QQRadiusMakeSame(9)];
        _anchorBgView.backgroundColor = [UIColor colorWithPatternImage:hostImage];
        
        UIImageView *anchorIcon = [[UIImageView alloc] initWithFrame:CGRectMake(6, 2, 13, 14.5)];
        anchorIcon.image = kGYImageNamed(@"fb_live_rank_anchor_icon");
        [_anchorBgView addSubview:anchorIcon];
        
        UILabel *anchorTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 40, 18)];
        anchorTitle.text = kGYLocalString(@"Anchor");
        anchorTitle.textAlignment = NSTextAlignmentCenter;
        anchorTitle.textColor = UIColor.whiteColor;
        anchorTitle.font = kGYHurmeBoldFont(11);
        [_anchorBgView addSubview:anchorTitle];
    }
    return _anchorBgView;
}

- (UILabel *)signLabel{
    if (!_signLabel) {
        _signLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 106, kGYScreenWidth - 96, 29)];
        _signLabel.font = kGYHurmeRegularFont(12);
        _signLabel.textColor = kGYHexColor(0xA09E9E);
        _signLabel.numberOfLines = 2;
        _signLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _signLabel;
}

- (UILabel *)followingLabel{
    if (!_followingLabel) {
        _followingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 163.5, kGYScreenWidth/3, 22)];
        _followingLabel.font = [UIFont fontWithName:@"DINCondensed-Bold" size:22];
        _followingLabel.textColor = kGYHexColor(0x080808);
        _followingLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _followingLabel;
}

- (UILabel *)followersLabel{
    if (!_followersLabel) {
        _followersLabel = [[UILabel alloc] initWithFrame:CGRectMake(kGYScreenWidth/3, 163.5, kGYScreenWidth/3, 22)];
        _followersLabel.font = [UIFont fontWithName:@"DINCondensed-Bold" size:22];
        _followersLabel.textColor = kGYHexColor(0x080808);
        _followersLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _followersLabel;
}

- (UILabel *)medalsLabel{
    if (!_medalsLabel) {
        _medalsLabel = [[UILabel alloc] initWithFrame:CGRectMake(kGYScreenWidth/3*2, 163.5, kGYScreenWidth/3, 22)];
        _medalsLabel.font = [UIFont fontWithName:@"DINCondensed-Bold" size:22];
        _medalsLabel.textColor = kGYHexColor(0x080808);
        _medalsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _medalsLabel;
}

- (UILabel *)followingTitleLabel{
    if (!_followingTitleLabel) {
        _followingTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 186, kGYScreenWidth/3, 14)];
        _followingTitleLabel.font = kGYHurmeRegularFont(12);
        _followingTitleLabel.text = kGYLocalString(@"Following");
        _followingTitleLabel.textColor = kGYHexColor(0xA09E9E);
        _followingTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _followingTitleLabel;
}

- (UILabel *)followersTitleLabel{
    if (!_followersTitleLabel) {
        _followersTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kGYScreenWidth/3, 186, kGYScreenWidth/3, 14)];
        _followersTitleLabel.font = kGYHurmeRegularFont(12);
        _followersTitleLabel.text = kGYLocalString(@"Followers");
        _followersTitleLabel.textColor = kGYHexColor(0xA09E9E);
        _followersTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _followersTitleLabel;
}

- (UILabel *)medalsTitleLabel{
    if (!_medalsTitleLabel) {
        _medalsTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kGYScreenWidth/3*2, 186, kGYScreenWidth/3, 14)];
        _medalsTitleLabel.font = kGYHurmeRegularFont(12);
        _medalsTitleLabel.text = kGYLocalString(@"Medals");
        _medalsTitleLabel.textColor = kGYHexColor(0xA09E9E);
        _medalsTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _medalsTitleLabel;
}

- (UIView *)medalView{
    if (!_medalView) {
        _medalView = [[UIView alloc] initWithFrame:CGRectMake(15, 221, kGYScreenWidth - 30, 50)];
        UIImage *hostImage = [UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
            graColor.fromColor = kGYHexColor(0xFFEEE7);
            graColor.toColor = kGYHexColor(0xFFE0E0);
            graColor.type = QQGradualChangeTypeLeftToRight;
        } size:CGSizeMake(kGYScreenWidth - 30, 50) cornerRadius:QQRadiusMakeSame(10)];
        _medalView.backgroundColor = [UIColor colorWithPatternImage:hostImage];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(medalClick)];
        [_medalView addGestureRecognizer:tap];
        
        UILabel *medalTitle = [[UILabel alloc] initWithFrame:CGRectMake(kGYScreenWidth - 30 - 31 -47, 17, 50, 17)];
        medalTitle.text = kGYLocalString(@"Medals");
        medalTitle.textColor = kGYHexColor(0xC8B2B3);
        medalTitle.font = kGYHurmeRegularFont(14);
        [_medalView addSubview:medalTitle];
        
        UIImageView *medalArrow = [[UIImageView alloc] initWithFrame:CGRectMake(kGYScreenWidth - 30 - 12 - 11, 19.5, 11, 11)];
        medalArrow.image = [kGYImageNamed(@"fb_live_medal_arrow") fb_flipedByRTL];
        [_medalView addSubview:medalArrow];
        
        if (kGYLiveManager.inside.appRTL) {
            medalTitle.frame = GYFlipedBy(medalTitle.frame, _medalView.bounds);
            medalArrow.frame = GYFlipedBy(medalArrow.frame, _medalView.bounds);
        }
    }
    return _medalView;
}

- (UIScrollView *)medalScroll{
    if (!_medalScroll) {
        _medalScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 15, kGYScreenWidth - 30 - 98, 20)];
        UIColor *color1 = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        UIColor *color2 = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        UIColor *color3 = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
        NSArray *locations = [NSArray arrayWithObjects:@(0.0), @(0.85),@(1.0), nil];
        NSArray *colors = [NSArray arrayWithObjects:(id)color1.CGColor, color2.CGColor,color3.CGColor, nil];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        //设置开始和结束位置(设置渐变的方向)
        gradient.startPoint = kGYLiveManager.inside.appRTL?CGPointMake(1, 0):CGPointMake(0, 0);
        gradient.endPoint = kGYLiveManager.inside.appRTL?CGPointMake(0, 0):CGPointMake(1, 0);

        gradient.locations = locations;
        gradient.colors = colors;
        gradient.frame = CGRectMake(0, 0 , kGYScreenWidth - 30 - 98, 50);
        _medalScroll.layer.mask = gradient;
        
        if (kGYLiveManager.inside.appRTL) {
            _medalScroll.frame = GYFlipedBy(_medalScroll.frame, _medalView.bounds);
        }
    }
    return _medalScroll;
}

- (UIButton *)messageButton{
    if (!_messageButton) {
        _messageButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 296, 120, 50)];
        _messageButton.layer.masksToBounds = YES;
        _messageButton.layer.borderWidth = 2;
        _messageButton.layer.borderColor = kGYHexColor(0xFF32A1).CGColor;
        _messageButton.layer.cornerRadius = 25;
        [_messageButton setTitle:kGYLocalString(@"Message") forState:UIControlStateNormal];
        _messageButton.titleLabel.font = kGYHurmeBoldFont(17);
        [_messageButton setTitleColor:kGYHexColor(0xFF32A1) forState:UIControlStateNormal];
        [_messageButton addTarget:self action:@selector(messageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageButton;
}

- (UIButton *)followButton{
    if (!_followButton) {
        _followButton = [[UIButton alloc] initWithFrame:CGRectMake(150, 296, kGYScreenWidth - 45 - 120, 50)];
        _followButton.titleLabel.font = kGYHurmeBoldFont(17);
        [_followButton setTitle:kGYLocalString(@"+ Follow") forState:UIControlStateNormal];
        UIImage *image = [UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
            graColor.fromColor = kGYHexColor(0xFF32A1);
            graColor.toColor = kGYHexColor(0xFC5F7C);
            graColor.type = QQGradualChangeTypeLeftToRight;
        } size:CGSizeMake(_followButton.width, 50) cornerRadius:QQRadiusMakeSame(25)];
        [_followButton setBackgroundImage:image forState:UIControlStateNormal];
        [_followButton setLayerShadow:kGYColorFromRGBA(0xFF32A1, 0.56) offset:CGSizeMake(0, 5) radius:8];
        
        [_followButton setTitle:kGYLocalString(@"Followed") forState:UIControlStateSelected];
        UIImage *selectImage = [UIImage imageWithQQCorner:^(QQCorner *corner) {
            corner.fillColor = kGYHexColor(0xDDE0E4);
            corner.radius = QQRadiusMakeSame(25);
        } size:CGSizeMake(_followButton.width, 50)];
        [_followButton setBackgroundImage:selectImage forState:UIControlStateSelected];
        [_followButton setLayerShadow:kGYColorFromRGBA(0xDDE0E4, 0.56) offset:CGSizeMake(0, 5) radius:8];
        [_followButton addTarget:self action:@selector(followButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _followButton;
}

@end
