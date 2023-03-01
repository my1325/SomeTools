//
//  GYLiveHeadMembersView.m
//  Woohoo
//
//  Created by M2-mini on 2021/8/25.
//

#import "GYLiveHeadMembersView.h"

static NSString *const kCellID = @"GYLiveHeadMembersViewCellID";

@interface GYLiveHeadMembersView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *membersButton;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, assign) BOOL isCollection;

@end

@implementation GYLiveHeadMembersView

#pragma mark - Life Cycle

+ (GYLiveHeadMembersView *)membersView
{
    GYLiveHeadMembersView *membersView = kGYLoadingXib(@"GYLiveHeadMembersView");
    membersView.frame = CGRectMake(0, 0, 200, 40);
    return membersView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self fb_setupViews];
}

#pragma mark - Init

- (void)fb_setupViews
{
    self.membersButton.layer.masksToBounds = YES;
    self.membersButton.layer.cornerRadius = 15;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellID];
    [self.membersButton addTarget:self action:@selector(membersButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Event

- (void)membersButtonClick:(UIButton *)sender
{
    // 成员列表
    self.eventBlock(GYLiveEventMembers, nil);
    //
    GYEvent(@"fb_LiveTouchRank", nil);
    GYLiveThinking(GYLiveThinkingEventTypeEvent, GYLiveThinkingEventClickAudienceListInLive, nil);
}

- (void)closeButtonClick:(UIButton *)sender
{
    // 关闭房间
    self.eventBlock(GYLiveEventMinimize, nil);
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.liveRoom.videoChatRoomMembers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *headCell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    if (!headCell) {
        headCell = [[UICollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        headCell.backgroundColor = UIColor.clearColor;
        headCell.contentView.backgroundColor = UIColor.clearColor;
    }
    
    UIImageView *headImageView;
    for (UIView *subview in headCell.contentView.subviews) {
        if ([subview isKindOfClass:[UIImageView class]] && subview.height == 30) {
            headImageView = (UIImageView *)subview;
            break;
        }
    }
    if (headImageView) {
    } else {
        headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        headImageView.layer.masksToBounds = YES;
        headImageView.layer.cornerRadius = 15;
        headImageView.layer.borderWidth = 1;
        headImageView.layer.borderColor = UIColor.whiteColor.CGColor;
        headImageView.contentMode = UIViewContentModeScaleAspectFill;
        [headCell.contentView addSubview:headImageView];
    }
    GYLiveRoomMember *member = self.liveRoom.videoChatRoomMembers[indexPath.row];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:member.avatar] placeholderImage:kGYLiveManager.config.avatar];
    return headCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GYLiveRoomMember *member = self.liveRoom.videoChatRoomMembers[indexPath.row];
    self.eventBlock(GYLiveEventPersonalData, member);
    //
    GYEvent(@"fb_LiveTouchRightTopAvatar", nil);
}

#pragma mark - Setter

- (void)setLiveRoom:(GYLiveRoom *)liveRoom
{
    _liveRoom = liveRoom;
    [self.collectionView reloadData];
}

@end
