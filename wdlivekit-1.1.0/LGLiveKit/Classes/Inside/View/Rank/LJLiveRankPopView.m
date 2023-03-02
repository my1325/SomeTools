//
//  LJLiveRankPopView.m
//  ActionSheetPicker-3.0
//
//  Created by Mimio on 2022/8/29.
//

#import "LJLiveRankPopView.h"
#import "LJLiveRankPopViewCell.h"

@interface LJLiveRankPopView () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIView *contentView;
@property (nonatomic, assign) CGFloat contentHeight;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UILabel *titleTagLabel;
@property (strong, nonatomic) UILabel *usersTagLabel;
@property (strong, nonatomic) UILabel *sendCoinsTagLabel;
@property (strong, nonatomic) UILabel *desTagLabel;

@end

@implementation LJLiveRankPopView

+ (LJLiveRankPopView *)rankView
{
    LJLiveRankPopView *rank = [[self alloc] init];
    return rank;
}





#pragma mark - UI

#pragma mark - UITableViewDelegate





#pragma mark - Getter


#pragma mark - Setter


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 71, kLJScreenWidth, self.contentHeight - 71 - kLJBottomSafeHeight - 26)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.whiteColor;
    }
    return _tableView;
}
-(void)lj_creatUI{
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:self.bounds];
    [self addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(lj_dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    self.contentHeight = 400;
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kLJScreenHeight, kLJScreenWidth, self.contentHeight + kLJBottomSafeHeight)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView updateCornerRadius:^(QQCorner *corner) {
        corner.radius = QQRadiusMake(12, 12, 0, 0);
    }];
    [self addSubview:self.contentView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kLJScreenWidth, 47)];
    titleLabel.font = kLJHurmeBoldFont(16);
    titleLabel.textColor = kLJHexColor(0x080808);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = kLJLocalString(@"Audience");
    [self.contentView addSubview:titleLabel];
    
    UIView *splitLine = [[UIView alloc] initWithFrame:CGRectMake(0, 47, kLJScreenWidth, 0.5)];
    splitLine.backgroundColor = kLJHexColor(0xE1E2E3);
    [self.contentView addSubview:splitLine];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 47.5, kLJScreenWidth, 24.5)];
    topLine.backgroundColor = kLJHexColor(0xF3F4F7);
    [self.contentView addSubview:topLine];
    
    UILabel *usersLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 100, 24.5)];
    usersLabel.font = kLJHurmeBoldFont(12);
    usersLabel.textColor = kLJHexColor(0xB2B5B8);
    usersLabel.textAlignment = NSTextAlignmentLeft;
    usersLabel.text = kLJLocalString(@"Users");
    [topLine addSubview:usersLabel];
    
    UILabel *coinsLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLJScreenWidth - 16 - 100, 0, 100, 24.5)];
    coinsLabel.font = kLJHurmeBoldFont(12);
    coinsLabel.textColor = kLJHexColor(0xB2B5B8);
    coinsLabel.textAlignment = NSTextAlignmentRight;
    coinsLabel.text = kLJLocalString(@"Send coins");
    [topLine addSubview:coinsLabel];
    
    [self.contentView addSubview:self.tableView];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 374, kLJScreenWidth, 26)];
    tipLabel.font = kLJHurmeBoldFont(12);
    tipLabel.textColor = kLJHexColor(0xB2B5B8);
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = kLJLocalString(@"Show only the top 100 users");
    [self.contentView addSubview:tipLabel];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LJLiveRoomMember *member = self.members[indexPath.row];
    if (self.eventBlock) self.eventBlock(LJLiveEventPersonalData, member);
    //
    LJEvent(@"lj_LiveRankTouchAvatar", nil);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    LJLiveRankPopViewCell *item = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!item) {
        item = [[LJLiveRankPopViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    item.selectionStyle = UITableViewCellSelectionStyleNone;
    LJLiveRoomMember *member = self.members[indexPath.row];
    item.member = member;
    item.rankLabel.text = indexPath.row+1 > 5 ? @"-" : @(indexPath.row + 1).stringValue;
    if (indexPath.row == 0) {
        item.rankLabel.textColor = kLJHexColor(0xFFA500);
    } else if (indexPath.row == 1) {
        item.rankLabel.textColor = kLJHexColor(0x99BECF);
    } else if (indexPath.row == 2) {
        item.rankLabel.textColor = kLJHexColor(0x9A8071);
    } else {
        item.rankLabel.textColor = kLJHexColor(0xB2B5B8);
    }
    kLJWeakSelf;
    item.avatarBlock = ^{
        if (weakSelf.eventBlock) weakSelf.eventBlock(LJLiveEventPersonalData, member);
        //
        LJEvent(@"lj_LiveRankTouchAvatar", nil);
    };
    return item;
}
- (void)lj_reloadData
{
    [self.members removeAllObjects];
    [self.members addObjectsFromArray:kLJLiveHelper.data.current.videoChatRoomMembers];
    [self.tableView reloadData];
}
- (void)lj_dismiss{
    [UIView animateWithDuration:0.1 animations:^{
        self.contentView.y = kLJScreenHeight;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}
- (void)setMembers:(NSMutableArray<LJLiveRoomMember *> *)members
{
    _members = members;
    [self.tableView reloadData];
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
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    } completion:^(BOOL finished) {}];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.members.count;
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
@end
