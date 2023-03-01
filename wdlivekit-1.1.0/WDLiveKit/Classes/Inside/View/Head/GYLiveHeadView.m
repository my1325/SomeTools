//
//  GYLiveHeadView.m
//  Woohoo
//
//  Created by M2-mini on 2021/8/25.
//

#import "GYLiveHeadView.h"
#import "GYLiveHeadAnchorInfoView.h"
#import "GYLiveHeadMembersView.h"

@interface GYLiveHeadView ()

/// 主播信息
@property (nonatomic, strong) GYLiveHeadAnchorInfoView *anchorInfoView;
/// 成员
@property (nonatomic, strong) GYLiveHeadMembersView *membersView;
/// ID
@property (nonatomic, strong) UILabel *idLabel;

@property (nonatomic, copy) GYLiveVoidBlock headBlock, closeBlock, membersBlock;

@property (nonatomic, copy) GYLiveBoolBlock followBlock;

@end

@implementation GYLiveHeadView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self fb_setupViews];
    }
    return self;
}

#pragma mark - Init

- (void)fb_setupViews
{
    [self addSubview:self.anchorInfoView];
    [self addSubview:self.membersView];
    [self addSubview:self.idLabel];
    //
    kGYWeakSelf;
    self.anchorInfoView.eventBlock = ^(GYLiveEvent event, id object) {
        weakSelf.eventBlock(event, object);
    };
    self.membersView.eventBlock = ^(GYLiveEvent event, id object) {
        weakSelf.eventBlock(event, object);
    };
//    [self fb_updateConstraints];
}

- (void)fb_updateConstraints
{
    CGFloat x = kGYWidthScale(15);
    if (kGYLiveManager.inside.appRTL && kGYLiveManager.config.flipRTLEnable) {
        x = kGYScreenWidth - kGYWidthScale(15) - self.anchorInfoView.width;
    }
    self.anchorInfoView.x = x;
    self.anchorInfoView.y = 15;
    
    CGFloat m_x = CGRectGetMaxX(self.anchorInfoView.frame) + kGYWidthScale(8);
    CGFloat m_width = kGYScreenWidth - m_x - kGYIpxsWidthScale(5);
    
    if (kGYLiveManager.inside.appRTL && kGYLiveManager.config.flipRTLEnable) {
        m_x = kGYIpnsWidthScale(5);
        m_width = CGRectGetMinX(self.anchorInfoView.frame) - kGYWidthScale(8) - m_x;
    }
    
    self.membersView.x = m_x;
    self.membersView.y = 15;
    self.membersView.width = m_width;
}

#pragma mark - Public Methods

- (void)fb_event:(GYLiveEvent)event withObj:(NSObject * __nullable )obj
{
    if (event == GYLiveEventFollow && [obj isKindOfClass:[NSArray class]]) {
        // 关注
        NSArray *array = (NSArray *)obj;
//        NSInteger accountId = [array.firstObject integerValue];
        BOOL followed = [array.lastObject boolValue];
        self.anchorInfoView.followed = followed;
        //
        if (followed) {
            self.anchorInfoView.width = kGYIpxsWidthScale(177) - 30;
        } else {
            self.anchorInfoView.width = kGYIpxsWidthScale(177);
        }
        [self fb_updateConstraints];
    }
}
#pragma mark - Getter

- (GYLiveHeadAnchorInfoView *)anchorInfoView
{
    if (!_anchorInfoView) {
        _anchorInfoView = [GYLiveHeadAnchorInfoView anchorInfoView];
    }
    return _anchorInfoView;
}

- (GYLiveHeadMembersView *)membersView
{
    if (!_membersView) {
        _membersView = [GYLiveHeadMembersView membersView];
    }
    return _membersView;
}

- (UILabel *)idLabel
{
    if (!_idLabel) {
        _idLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height - 18, 85, 18)];
        _idLabel.font = kGYHurmeBoldFont(11);
        _idLabel.textColor = [UIColor colorWithWhite:1 alpha:0.6];
        _idLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _idLabel.textAlignment = NSTextAlignmentCenter;
        _idLabel.layer.masksToBounds = YES;
        _idLabel.layer.cornerRadius = 9;
    }
    return _idLabel;
}

#pragma mark - Setter

- (void)setLiveRoom:(GYLiveRoom *)liveRoom
{
    _liveRoom = liveRoom;
    //
    self.anchorInfoView.liveRoom = liveRoom;
    self.membersView.liveRoom = liveRoom;
    
    if (liveRoom.isHostFollowed) {
        self.anchorInfoView.width = kGYIpxsWidthScale(177) - 30;
    } else {
        self.anchorInfoView.width = kGYIpxsWidthScale(177);
    }
    // ID
    NSString *idText = [NSString stringWithFormat:@"ID: %@", liveRoom.agoraRoomId];
    self.idLabel.text = idText;
    CGSize size = kGYTextSize_MutiLine(idText, kGYHurmeBoldFont(11), CGSizeMake(MAXFLOAT, 18));
    self.idLabel.x = kGYScreenWidth - size.width - 12 - kGYWidthScale(5);
    self.idLabel.width = size.width + 12;
    
    if (kGYLiveManager.inside.appRTL && kGYLiveManager.config.flipRTLEnable) self.idLabel.frame = GYFlipedScreenBy(self.idLabel.frame);
    [self fb_updateConstraints];
}

@end
