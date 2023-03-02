//
//  LJLiveHeadAnchorInfoView.m
//  Woohoo
//
//  Created by M2-mini on 2021/8/25.
//

#import "LJLiveHeadAnchorInfoView.h"

@interface LJLiveHeadAnchorInfoView ()

@property (weak, nonatomic) IBOutlet UIButton *headButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *followButton;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation LJLiveHeadAnchorInfoView

#pragma mark - Life Cycle

+ (LJLiveHeadAnchorInfoView *)anchorInfoView
{
    LJLiveHeadAnchorInfoView *infoView = kLJLoadingXib(@"LJLiveHeadAnchorInfoView");
    infoView.frame = CGRectMake(0, 0, kLJIpxsWidthScale(177), 40);
    return infoView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self lj_setupViews];
}

#pragma mark - Init

- (void)lj_setupViews
{
    [self.followButton setImage:kLJImageNamed(@"lj_live_follow_icon") forState:UIControlStateNormal];
    //
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 20;
    self.headButton.layer.masksToBounds = YES;
    self.headButton.layer.cornerRadius = 20;
    self.headButton.layer.borderWidth = 1.5;
    self.headButton.layer.borderColor = UIColor.whiteColor.CGColor;
    
    self.headButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
}

#pragma mark - Event

- (IBAction)headButtonClick:(UIButton *)sender
{
    // 请求数据
    LJLiveRoomMember *member = [[LJLiveRoomMember alloc] init];
    member.accountId = self.liveRoom.hostAccountId;
    member.roleType = 2;
    if (self.eventBlock) self.eventBlock(LJLiveEventPersonalData, member);
    //
    LJEvent(@"lj_LiveTouchCurrentHostAvatar", nil);
    LJLiveThinking(LJLiveThinkingEventTypeEvent, LJLiveThinkingEventClickHostAvatarInLive, nil);
}

- (IBAction)followButtonClick:(UIButton *)sender
{
    kLJLiveManager.inside.from = LJLiveThinkingValueLive;
    kLJLiveManager.inside.fromDetail = LJLiveThinkingValueDetailHead;
    
    self.eventBlock(LJLiveEventFollow, @[@(self.liveRoom.hostAccountId), @(1)]);
    self.followButton.hidden = YES;
    //
    LJEvent(@"lj_LiveTouchCurrentHostFollow", nil);
}

#pragma mark - Getter

- (void)setLiveRoom:(LJLiveRoom *)liveRoom
{
    _liveRoom = liveRoom;
    //
    [self.headButton sd_setImageWithURL:[NSURL URLWithString:liveRoom.hostAvatar] forState:UIControlStateNormal placeholderImage:kLJLiveManager.config.avatar];
    self.nameLabel.text = liveRoom.hostName;
    self.countLabel.text = @(liveRoom.memberCount).stringValue;
    self.followed = liveRoom.isHostFollowed;
}

- (void)setFollowed:(BOOL)followed
{
    _followed = followed;
    self.followButton.hidden = followed;
}

@end
