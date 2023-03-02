//
//  LJLiveHeadView.m
//  Woohoo
//
//  Created by M2-mini on 2021/8/25.
//

#import "LJLiveHeadView.h"
#import "LJLiveHeadAnchorInfoView.h"
#import "LJLiveHeadMembersView.h"

@interface LJLiveHeadView ()




/// ID
/// 主播信息
/// 成员
@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, strong) LJLiveHeadAnchorInfoView *anchorInfoView;
@property (nonatomic, strong) LJLiveHeadMembersView *membersView;
@property (nonatomic, copy) LJLiveVoidBlock headBlock, closeBlock, membersBlock;
@property (nonatomic, copy) LJLiveBoolBlock followBlock;
@end

@implementation LJLiveHeadView

#pragma mark - Life Cycle


#pragma mark - Init



#pragma mark - Public Methods

#pragma mark - Getter




#pragma mark - Setter


- (LJLiveHeadAnchorInfoView *)anchorInfoView
{
    if (!_anchorInfoView) {
        _anchorInfoView = [LJLiveHeadAnchorInfoView anchorInfoView];
    }
    return _anchorInfoView;
}
- (LJLiveHeadMembersView *)membersView
{
    if (!_membersView) {
        _membersView = [LJLiveHeadMembersView membersView];
    }
    return _membersView;
}
- (void)setLiveRoom:(LJLiveRoom *)liveRoom
{
    _liveRoom = liveRoom;
    //
    self.anchorInfoView.liveRoom = liveRoom;
    self.membersView.liveRoom = liveRoom;
    
    if (liveRoom.isHostFollowed) {
        self.anchorInfoView.width = kLJIpxsWidthScale(177) - 30;
    } else {
        self.anchorInfoView.width = kLJIpxsWidthScale(177);
    }
    // ID
    NSString *idText = [NSString stringWithFormat:@"ID: %@", liveRoom.agoraRoomId];
    self.idLabel.text = idText;
    CGSize size = kLJTextSize_MutiLine(idText, kLJHurmeBoldFont(11), CGSizeMake(MAXFLOAT, 18));
    self.idLabel.x = kLJScreenWidth - size.width - 12 - kLJWidthScale(5);
    self.idLabel.width = size.width + 12;
    
    if (kLJLiveManager.inside.appRTL && kLJLiveManager.config.flipRTLEnable) self.idLabel.frame = LJFlipedScreenBy(self.idLabel.frame);
    [self lj_updateConstraints];
}
- (void)lj_updateConstraints
{
    CGFloat x = kLJWidthScale(15);
    if (kLJLiveManager.inside.appRTL && kLJLiveManager.config.flipRTLEnable) {
        x = kLJScreenWidth - kLJWidthScale(15) - self.anchorInfoView.width;
    }
    self.anchorInfoView.x = x;
    self.anchorInfoView.y = 15;
    
    CGFloat m_x = CGRectGetMaxX(self.anchorInfoView.frame) + kLJWidthScale(8);
    CGFloat m_width = kLJScreenWidth - m_x - kLJIpxsWidthScale(5);
    
    if (kLJLiveManager.inside.appRTL && kLJLiveManager.config.flipRTLEnable) {
        m_x = kLJIpnsWidthScale(5);
        m_width = CGRectGetMinX(self.anchorInfoView.frame) - kLJWidthScale(8) - m_x;
    }
    
    self.membersView.x = m_x;
    self.membersView.y = 15;
    self.membersView.width = m_width;
}
- (void)lj_event:(LJLiveEvent)event withObj:(NSObject * __nullable )obj
{
    if (event == LJLiveEventFollow && [obj isKindOfClass:[NSArray class]]) {
        // 关注
        NSArray *array = (NSArray *)obj;
//        NSInteger accountId = [array.firstObject integerValue];
        BOOL followed = [array.lastObject boolValue];
        self.anchorInfoView.followed = followed;
        //
        if (followed) {
            self.anchorInfoView.width = kLJIpxsWidthScale(177) - 30;
        } else {
            self.anchorInfoView.width = kLJIpxsWidthScale(177);
        }
        [self lj_updateConstraints];
    }
}
- (UILabel *)idLabel
{
    if (!_idLabel) {
        _idLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height - 18, 85, 18)];
        _idLabel.font = kLJHurmeBoldFont(11);
        _idLabel.textColor = [UIColor colorWithWhite:1 alpha:0.6];
        _idLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _idLabel.textAlignment = NSTextAlignmentCenter;
        _idLabel.layer.masksToBounds = YES;
        _idLabel.layer.cornerRadius = 9;
    }
    return _idLabel;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self lj_setupViews];
    }
    return self;
}
- (void)lj_setupViews
{
    [self addSubview:self.anchorInfoView];
    [self addSubview:self.membersView];
    [self addSubview:self.idLabel];
    //
    kLJWeakSelf;
    self.anchorInfoView.eventBlock = ^(LJLiveEvent event, id object) {
        weakSelf.eventBlock(event, object);
    };
    self.membersView.eventBlock = ^(LJLiveEvent event, id object) {
        weakSelf.eventBlock(event, object);
    };
//    [self lj_updateConstraints];
}
@end
