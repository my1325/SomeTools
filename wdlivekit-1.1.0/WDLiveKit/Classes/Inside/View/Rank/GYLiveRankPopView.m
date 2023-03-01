//
//  GYLiveRankPopView.m
//  ActionSheetPicker-3.0
//
//  Created by Mimio on 2022/8/29.
//

#import "GYLiveRankPopView.h"
#import "GYLiveRankPopViewCell.h"

@interface GYLiveRankPopView () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIView *contentView;
@property (nonatomic, assign) CGFloat contentHeight;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UILabel *titleTagLabel;
@property (strong, nonatomic) UILabel *usersTagLabel;
@property (strong, nonatomic) UILabel *sendCoinsTagLabel;
@property (strong, nonatomic) UILabel *desTagLabel;

@end

@implementation GYLiveRankPopView

+ (GYLiveRankPopView *)rankView
{
    GYLiveRankPopView *rank = [[self alloc] init];
    return rank;
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
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    } completion:^(BOOL finished) {}];
}

- (void)fb_dismiss{
    [UIView animateWithDuration:0.1 animations:^{
        self.contentView.y = kGYScreenHeight;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

- (void)fb_reloadData
{
    [self.members removeAllObjects];
    [self.members addObjectsFromArray:kGYLiveHelper.data.current.videoChatRoomMembers];
    [self.tableView reloadData];
}

#pragma mark - UI
-(void)fb_creatUI{
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:self.bounds];
    [self addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(fb_dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    self.contentHeight = 400;
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kGYScreenHeight, kGYScreenWidth, self.contentHeight + kGYBottomSafeHeight)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView updateCornerRadius:^(QQCorner *corner) {
        corner.radius = QQRadiusMake(12, 12, 0, 0);
    }];
    [self addSubview:self.contentView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kGYScreenWidth, 47)];
    titleLabel.font = kGYHurmeBoldFont(16);
    titleLabel.textColor = kGYHexColor(0x080808);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = kGYLocalString(@"Audience");
    [self.contentView addSubview:titleLabel];
    
    UIView *splitLine = [[UIView alloc] initWithFrame:CGRectMake(0, 47, kGYScreenWidth, 0.5)];
    splitLine.backgroundColor = kGYHexColor(0xE1E2E3);
    [self.contentView addSubview:splitLine];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 47.5, kGYScreenWidth, 24.5)];
    topLine.backgroundColor = kGYHexColor(0xF3F4F7);
    [self.contentView addSubview:topLine];
    
    UILabel *usersLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 100, 24.5)];
    usersLabel.font = kGYHurmeBoldFont(12);
    usersLabel.textColor = kGYHexColor(0xB2B5B8);
    usersLabel.textAlignment = NSTextAlignmentLeft;
    usersLabel.text = kGYLocalString(@"Users");
    [topLine addSubview:usersLabel];
    
    UILabel *coinsLabel = [[UILabel alloc] initWithFrame:CGRectMake(kGYScreenWidth - 16 - 100, 0, 100, 24.5)];
    coinsLabel.font = kGYHurmeBoldFont(12);
    coinsLabel.textColor = kGYHexColor(0xB2B5B8);
    coinsLabel.textAlignment = NSTextAlignmentRight;
    coinsLabel.text = kGYLocalString(@"Send coins");
    [topLine addSubview:coinsLabel];
    
    [self.contentView addSubview:self.tableView];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 374, kGYScreenWidth, 26)];
    tipLabel.font = kGYHurmeBoldFont(12);
    tipLabel.textColor = kGYHexColor(0xB2B5B8);
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = kGYLocalString(@"Show only the top 100 users");
    [self.contentView addSubview:tipLabel];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.members.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    GYLiveRankPopViewCell *item = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!item) {
        item = [[GYLiveRankPopViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    item.selectionStyle = UITableViewCellSelectionStyleNone;
    GYLiveRoomMember *member = self.members[indexPath.row];
    item.member = member;
    item.rankLabel.text = indexPath.row+1 > 5 ? @"-" : @(indexPath.row + 1).stringValue;
    if (indexPath.row == 0) {
        item.rankLabel.textColor = kGYHexColor(0xFFA500);
    } else if (indexPath.row == 1) {
        item.rankLabel.textColor = kGYHexColor(0x99BECF);
    } else if (indexPath.row == 2) {
        item.rankLabel.textColor = kGYHexColor(0x9A8071);
    } else {
        item.rankLabel.textColor = kGYHexColor(0xB2B5B8);
    }
    kGYWeakSelf;
    item.avatarBlock = ^{
        if (weakSelf.eventBlock) weakSelf.eventBlock(GYLiveEventPersonalData, member);
        //
        GYEvent(@"fb_LiveRankTouchAvatar", nil);
    };
    return item;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYLiveRoomMember *member = self.members[indexPath.row];
    if (self.eventBlock) self.eventBlock(GYLiveEventPersonalData, member);
    //
    GYEvent(@"fb_LiveRankTouchAvatar", nil);
}

#pragma mark - Getter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 71, kGYScreenWidth, self.contentHeight - 71 - kGYBottomSafeHeight - 26)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.whiteColor;
    }
    return _tableView;
}

#pragma mark - Setter

- (void)setMembers:(NSMutableArray<GYLiveRoomMember *> *)members
{
    _members = members;
    [self.tableView reloadData];
}

@end
