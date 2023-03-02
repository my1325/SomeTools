//
//  LJLiveHeadMembersView.m
//  Woohoo
//
//  Created by M2-mini on 2021/8/25.
//

#import "LJLiveHeadMembersView.h"

static NSString *const kCellID = @"LJLiveHeadMembersViewCellID";

@interface LJLiveHeadMembersView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *membersButton;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, assign) BOOL isCollection;

@end

@implementation LJLiveHeadMembersView

#pragma mark - Life Cycle

+ (LJLiveHeadMembersView *)membersView
{
    LJLiveHeadMembersView *membersView = kLJLoadingXib(@"LJLiveHeadMembersView");
    membersView.frame = CGRectMake(0, 0, 200, 40);
    return membersView;
}


#pragma mark - Init


#pragma mark - Event



#pragma mark - UICollectionViewDelegate





#pragma mark - Setter


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LJLiveRoomMember *member = self.liveRoom.videoChatRoomMembers[indexPath.row];
    self.eventBlock(LJLiveEventPersonalData, member);
    //
    LJEvent(@"lj_LiveTouchRightTopAvatar", nil);
}
- (void)closeButtonClick:(UIButton *)sender
{
    // 关闭房间
    self.eventBlock(LJLiveEventMinimize, nil);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.liveRoom.videoChatRoomMembers.count;
}
- (void)lj_setupViews
{
    self.membersButton.layer.masksToBounds = YES;
    self.membersButton.layer.cornerRadius = 15;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellID];
    [self.membersButton addTarget:self action:@selector(membersButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)membersButtonClick:(UIButton *)sender
{
    // 成员列表
    self.eventBlock(LJLiveEventMembers, nil);
    //
    LJEvent(@"lj_LiveTouchRank", nil);
    LJLiveThinking(LJLiveThinkingEventTypeEvent, LJLiveThinkingEventClickAudienceListInLive, nil);
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self lj_setupViews];
}
- (void)setLiveRoom:(LJLiveRoom *)liveRoom
{
    _liveRoom = liveRoom;
    [self.collectionView reloadData];
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
    LJLiveRoomMember *member = self.liveRoom.videoChatRoomMembers[indexPath.row];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:member.avatar] placeholderImage:kLJLiveManager.config.avatar];
    return headCell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
@end
