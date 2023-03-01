//
//  GYLivePkRankView.m
//  Woohoo
//
//  Created by M2-mini on 2021/11/26.
//

#import "GYLivePkRankView.h"
#import "GYLivePkRankCell.h"

static NSString *kCellID = @"GYLivePkRankViewCellID";

@interface GYLivePkRankView () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIImageView *topBgdImageView;

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;

@property (weak, nonatomic) IBOutlet UIImageView *topIconView;

@property (weak, nonatomic) IBOutlet UIButton *topAvatarButton;

@property (weak, nonatomic) IBOutlet UILabel *topNicknameLabel;

@property (weak, nonatomic) IBOutlet UILabel *topPointLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIImageView *svipView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottom;

@end

@implementation GYLivePkRankView

#pragma mark - Life Cycle

+ (GYLivePkRankView *)fb_pkRankView
{
    GYLivePkRankView *view = kGYLoadingXib(@"GYLivePkRankView");
    view.frame = kGYScreenBounds;
    return view;
}

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
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 12;
    //
    self.topAvatarButton.layer.masksToBounds = YES;
    self.topAvatarButton.layer.cornerRadius = 33/2;
    self.topAvatarButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.topAvatarButton addTarget:self action:@selector(topAvatarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"GYLivePkRankCell" bundle:kGYLiveBundle] forCellReuseIdentifier:kCellID];
    //
    CGFloat y = CGRectGetMinY(kGYLiveHelper.ui.pkControlRect) + CGRectGetMaxY(kGYLiveHelper.ui.pkProgressRect);
    self.contentViewHeight.constant = kGYScreenHeight - y - 1 + 12;
    self.contentView.y = kGYScreenHeight;
    //
    [self.topView addSubview:self.svipView];
}

- (void)fb_updateConstraints
{
    kGYWeakSelf;
    [self.svipView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.topNicknameLabel.mas_trailing).offset(10);
        make.centerY.equalTo(weakSelf.topNicknameLabel);
    }];
}

#pragma mark - Events

- (IBAction)maskButtonClick:(UIButton *)sender
{
    [self fb_dismiss];
}

- (void)topAvatarButtonClick:(UIButton *)sender
{
    [self fb_didSelectedAtIndex:0];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fans.count-1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYLivePkRankCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];
    kGYWeakSelf;
    cell.avatarBlock = ^{
        [weakSelf fb_didSelectedAtIndex:indexPath.row+1];
    };
    cell.rankLabel.text = @(indexPath.row+2).stringValue;
    cell.fan = self.fans[indexPath.row+1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self fb_didSelectedAtIndex:indexPath.row + 1];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)fb_didSelectedAtIndex:(NSInteger)index
{
    if (index < self.fans.count) {
    } else {
        return;
    }
    GYLivePkTopFan *fan = self.fans[index];
    GYLiveRoomMember *member = [[GYLiveRoomMember alloc] init];
    member.accountId = fan.accountId;
    member.roleType = GYLiveRoleTypeUser;
    member.pkRoomId = self.isHome ? 0 : kGYLiveHelper.data.current.pkData.awayPlayer.roomId;
    if (self.eventBlock) self.eventBlock(GYLiveEventPersonalData, member);
}

#pragma mark - Methods

- (void)fb_pkRankOpenInView:(UIView *)inView
{
    [inView addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.y = kGYScreenHeight - self.height + 12;
    }];
}

- (void)fb_dismiss
{
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.y = kGYScreenHeight;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
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

- (void)setFans:(NSArray<GYLivePkTopFan *> *)fans
{
    _fans = fans;
    if (fans.count > 0) {
        // 头号粉丝
        GYLivePkTopFan *topFan = fans.firstObject;
        [self.topAvatarButton sd_setImageWithURL:[NSURL URLWithString:topFan.avatar] forState:UIControlStateNormal placeholderImage:kGYLiveManager.config.avatar];
        self.topNicknameLabel.text = topFan.userName;
        self.topPointLabel.text = @(topFan.points).stringValue;
        // svip vip
        self.svipView.hidden = !(topFan.isSVip || topFan.isVip);
        if (topFan.isVip) self.svipView.image = kGYImageNamed(@"fb_live_pk_rank_vip_icon");
        if (topFan.isSVip) self.svipView.image = kGYImageNamed(@"fb_live_pk_rank_svip_icon");
        [self fb_updateConstraints];
    }
    self.tableView.hidden = fans.count <= 1;
    [self.tableView reloadData];
}

- (void)setIsHome:(BOOL)isHome
{
    _isHome = isHome;
    
    self.topBgdImageView.image = isHome ? kGYImageNamed(@"fb_live_pk_rank_red_bgd") : kGYImageNamed(@"fb_live_pk_rank_blue_bgd");
    self.topImageView.image = isHome ? kGYImageNamed(kGYLocalString(@"fb_live_pk_rank_red_text")) : kGYImageNamed(kGYLocalString(@"fb_live_pk_rank_blue_text"));
    self.topIconView.image = isHome ? kGYImageNamed(@"fb_live_pk_rank_red_icon") : kGYImageNamed(@"fb_live_pk_rank_blue_icon");
}

@end
