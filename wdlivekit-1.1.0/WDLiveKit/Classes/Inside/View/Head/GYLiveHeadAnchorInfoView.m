//
//  GYLiveHeadAnchorInfoView.m
//  Woohoo
//
//  Created by M2-mini on 2021/8/25.
//

#import "GYLiveHeadAnchorInfoView.h"

@interface GYLiveHeadAnchorInfoView ()

@property (weak, nonatomic) IBOutlet UIButton *headButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *followButton;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation GYLiveHeadAnchorInfoView

#pragma mark - Life Cycle

+ (GYLiveHeadAnchorInfoView *)anchorInfoView
{
    GYLiveHeadAnchorInfoView *infoView = kGYLoadingXib(@"GYLiveHeadAnchorInfoView");
    infoView.frame = CGRectMake(0, 0, kGYIpxsWidthScale(177), 40);
    return infoView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self fb_setupViews];
}

#pragma mark - Init

- (void)fb_setupViews
{
    [self.followButton setImage:kGYImageNamed(@"fb_live_follow_icon") forState:UIControlStateNormal];
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
    GYLiveRoomMember *member = [[GYLiveRoomMember alloc] init];
    member.accountId = self.liveRoom.hostAccountId;
    member.roleType = 2;
    if (self.eventBlock) self.eventBlock(GYLiveEventPersonalData, member);
    //
    GYEvent(@"fb_LiveTouchCurrentHostAvatar", nil);
    GYLiveThinking(GYLiveThinkingEventTypeEvent, GYLiveThinkingEventClickHostAvatarInLive, nil);
}

- (IBAction)followButtonClick:(UIButton *)sender
{
    kGYLiveManager.inside.from = GYLiveThinkingValueLive;
    kGYLiveManager.inside.fromDetail = GYLiveThinkingValueDetailHead;
    
    self.eventBlock(GYLiveEventFollow, @[@(self.liveRoom.hostAccountId), @(1)]);
    self.followButton.hidden = YES;
    //
    GYEvent(@"fb_LiveTouchCurrentHostFollow", nil);
}

#pragma mark - Getter

- (void)setLiveRoom:(GYLiveRoom *)liveRoom
{
    _liveRoom = liveRoom;
    //
    [self.headButton sd_setImageWithURL:[NSURL URLWithString:liveRoom.hostAvatar] forState:UIControlStateNormal placeholderImage:kGYLiveManager.config.avatar];
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
