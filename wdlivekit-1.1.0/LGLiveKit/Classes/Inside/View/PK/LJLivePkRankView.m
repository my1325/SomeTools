//
//  LJLivePkRankView.m
//  Woohoo
//
//  Created by M2-mini on 2021/11/26.
//

#import "LJLivePkRankView.h"
#import "LJLivePkRankCell.h"

static NSString *kCellID = @"LJLivePkRankViewCellID";

@interface LJLivePkRankView () <UITableViewDelegate, UITableViewDataSource>

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

@implementation LJLivePkRankView

#pragma mark - Life Cycle

+ (LJLivePkRankView *)lj_pkRankView
{
    LJLivePkRankView *view = kLJLoadingXib(@"LJLivePkRankView");
    view.frame = kLJScreenBounds;
    return view;
}

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
    [self.tableView registerNib:[UINib nibWithNibName:@"LJLivePkRankCell" bundle:kLJLiveBundle] forCellReuseIdentifier:kCellID];
    //
    CGFloat y = CGRectGetMinY(kLJLiveHelper.ui.pkControlRect) + CGRectGetMaxY(kLJLiveHelper.ui.pkProgressRect);
    self.contentViewHeight.constant = kLJScreenHeight - y - 1 + 12;
    self.contentView.y = kLJScreenHeight;
    //
    [self.topView addSubview:self.svipView];
}

- (void)lj_updateConstraints
{
    kLJWeakSelf;
    [self.svipView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.topNicknameLabel.mas_trailing).offset(10);
        make.centerY.equalTo(weakSelf.topNicknameLabel);
    }];
}

#pragma mark - Events

- (IBAction)maskButtonClick:(UIButton *)sender
{
    [self lj_dismiss];
}

- (void)topAvatarButtonClick:(UIButton *)sender
{
    [self lj_didSelectedAtIndex:0];
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
    LJLivePkRankCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];
    kLJWeakSelf;
    cell.avatarBlock = ^{
        [weakSelf lj_didSelectedAtIndex:indexPath.row+1];
    };
    cell.rankLabel.text = @(indexPath.row+2).stringValue;
    cell.fan = self.fans[indexPath.row+1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self lj_didSelectedAtIndex:indexPath.row + 1];
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

- (void)lj_didSelectedAtIndex:(NSInteger)index
{
    if (index < self.fans.count) {
    } else {
        return;
    }
    LJLivePkTopFan *fan = self.fans[index];
    LJLiveRoomMember *member = [[LJLiveRoomMember alloc] init];
    member.accountId = fan.accountId;
    member.roleType = LJLiveRoleTypeUser;
    member.pkRoomId = self.isHome ? 0 : kLJLiveHelper.data.current.pkData.awayPlayer.roomId;
    if (self.eventBlock) self.eventBlock(LJLiveEventPersonalData, member);
}

#pragma mark - Methods

- (void)lj_pkRankOpenInView:(UIView *)inView
{
    [inView addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.y = kLJScreenHeight - self.height + 12;
    }];
}

- (void)lj_dismiss
{
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.y = kLJScreenHeight;
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

- (void)setFans:(NSArray<LJLivePkTopFan *> *)fans
{
    _fans = fans;
    if (fans.count > 0) {
        // 头号粉丝
        LJLivePkTopFan *topFan = fans.firstObject;
        [self.topAvatarButton sd_setImageWithURL:[NSURL URLWithString:topFan.avatar] forState:UIControlStateNormal placeholderImage:kLJLiveManager.config.avatar];
        self.topNicknameLabel.text = topFan.userName;
        self.topPointLabel.text = @(topFan.points).stringValue;
        // svip vip
        self.svipView.hidden = !(topFan.isSVip || topFan.isVip);
        if (topFan.isVip) self.svipView.image = kLJImageNamed(@"lj_live_pk_rank_vip_icon");
        if (topFan.isSVip) self.svipView.image = kLJImageNamed(@"lj_live_pk_rank_svip_icon");
        [self lj_updateConstraints];
    }
    self.tableView.hidden = fans.count <= 1;
    [self.tableView reloadData];
}

- (void)setIsHome:(BOOL)isHome
{
    _isHome = isHome;
    
    self.topBgdImageView.image = isHome ? kLJImageNamed(@"lj_live_pk_rank_red_bgd") : kLJImageNamed(@"lj_live_pk_rank_blue_bgd");
    self.topImageView.image = isHome ? kLJImageNamed(kLJLocalString(@"lj_live_pk_rank_red_text")) : kLJImageNamed(kLJLocalString(@"lj_live_pk_rank_blue_text"));
    self.topIconView.image = isHome ? kLJImageNamed(@"lj_live_pk_rank_red_icon") : kLJImageNamed(@"lj_live_pk_rank_blue_icon");
}

@end
