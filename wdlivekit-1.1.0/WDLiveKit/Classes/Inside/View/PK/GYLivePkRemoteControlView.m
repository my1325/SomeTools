//
//  GYLivePkRemoteControlView.m
//  Woohoo
//
//  Created by M2-mini on 2021/11/17.
//

#import "GYLivePkRemoteControlView.h"

@interface GYLivePkRemoteControlView ()

/// 主播信息
@property (weak, nonatomic) IBOutlet UIView *infoView;
/// 头像
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
/// 昵称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/// 连胜背景
@property (weak, nonatomic) IBOutlet UIImageView *winsBgdView;
/// 连胜次数
@property (weak, nonatomic) IBOutlet UILabel *winsCountLabel;

/// 静音
@property (weak, nonatomic) IBOutlet UIImageView *mutedIconView;
/// 胜利
@property (weak, nonatomic) IBOutlet UIImageView *winIconView;

@property (weak, nonatomic) IBOutlet UIImageView *readyIconView;

/// 跳转按钮
@property (weak, nonatomic) IBOutlet UIButton *oppositeButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelRight;

/// 连胜
@property (nonatomic, assign) NSInteger keepWins;
/// 是否胜利（-1，0，1）
@property (nonatomic, assign) NSInteger haveWon;

@end

@implementation GYLivePkRemoteControlView

#pragma mark - Life Cycle

+ (GYLivePkRemoteControlView *)fb_remoteControlView
{
    GYLivePkRemoteControlView *view = kGYLoadingXib(@"GYLivePkRemoteControlView");
    return view;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self fb_setupDataSource];
    [self fb_setupViews];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    for (UIView *subview in self.subviews) {
        // 进行坐标转化
        CGPoint coverPoint = [subview convertPoint:point fromView:self];
        // 调用子视图的 hitTest 重复上面的步骤。找到了，返回hitTest view ,没找到返回有自身处理
        UIView *hitTestView = [subview hitTest:coverPoint withEvent:event];
        if (hitTestView) {
            return hitTestView;
        }
    }
    return nil;
}

#pragma mark - Init

- (void)fb_setupDataSource
{
    
}

- (void)fb_setupViews
{
    self.infoView.layer.masksToBounds = YES;
    self.infoView.layer.cornerRadius = 12;
    self.avatarButton.layer.masksToBounds = YES;
    self.avatarButton.layer.cornerRadius = 12;
    self.oppositeButton.layer.masksToBounds = YES;
    self.oppositeButton.layer.cornerRadius = 12;
    self.avatarButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    //
    self.infoView.hidden = YES;
    self.oppositeButton.hidden = YES;
    
    if (kGYLiveManager.inside.appRTL && kGYLiveManager.config.flipRTLEnable) {
        self.oppositeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -22);
        self.oppositeButton.imageEdgeInsets = UIEdgeInsetsMake(6.5, 0, 6.5, 20);
    }
    
    [self.oppositeButton setTitle:kGYLocalString(@"Opposite") forState:UIControlStateNormal];
}

#pragma mark - Events

- (IBAction)maskButtonClick:(UIButton *)sender
{
    GYEvent(@"fb_PKClickAwayPlayerVideo", nil);
}

- (IBAction)avatarButtonClick:(UIButton *)sender
{
    GYLiveRoomMember *member = [[GYLiveRoomMember alloc] init];
    member.accountId = self.remotePlayer.hostAccountId;
    member.roleType = GYLiveRoleTypeAnchor;
    if (self.eventBlock) self.eventBlock(GYLiveEventPersonalData, member);
    // 统计
    GYEvent(@"fb_PKClickOtherHostAvatar", nil);
}

- (IBAction)oppositeButtonClick:(UIButton *)sender
{
    // 跳房间
    if (kGYLiveManager.inside.networkStatus == 0) {
        GYTipError(kGYLocalString(@"Please check your network."));
        return;
    }
    if (self.eventBlock && self.remotePlayer) self.eventBlock(GYLiveEventPKOpenAwayRoom, self.remotePlayer);
}

#pragma mark - Public Methods

- (void)fb_event:(GYLiveEvent)event withObj:(NSObject * __nullable )obj
{
    // 收到PK数据，刷新UI显示
    if (event == GYLiveEventPKReceiveMatchSuccessed) {
        //
        GYLivePkData *pkData = (GYLivePkData *)obj;
        // 个人信息
        self.remotePlayer = pkData.awayPlayer;
        // 连胜次数
        self.keepWins = pkData.awayPlayer.wins;
        // PK中
        self.haveWon = 2;
        //
        self.readyIconView.hidden = YES;
    }
    
    // PK时间到
    if (event == GYLiveEventPKReceiveTimeUp) {
        //
        GYLivePkWinner *winner = (GYLivePkWinner *)obj;
        // PK
        if (winner.hostAccountId == self.remotePlayer.hostAccountId) {
            // 胜利
            self.haveWon = 1;
            // 连胜次数
            self.keepWins = winner.wins;
            
        } else if (winner.hostAccountId == 0) {
            // 平局
            self.haveWon = 0;
            
        } else {
            // 失败
            self.haveWon = -1;
            // 终结连胜
            self.keepWins = 0;
        }
    }
    
    // 主播准备
    if (event == GYLiveEventPKReceiveReady) {
        NSInteger hostAccountId = [(NSNumber *)obj integerValue];
        if (hostAccountId == self.remotePlayer.hostAccountId) self.readyIconView.hidden = NO;
    }
    
    // 音频muted
    if (event == GYLiveEventPKReceiveAudioMuted) {
        if ([obj isKindOfClass:[NSNumber class]]) {
            BOOL isMuted = [(NSNumber*)obj boolValue];
            self.mutedIconView.hidden = !isMuted;
        }
    }
    
    if (event == GYLiveEventHideOpposite) {
        if ([obj isKindOfClass:[NSNumber class]]) {
            BOOL isHidden = [(NSNumber*)obj boolValue];
            self.oppositeButton.hidden = isHidden;
            if (!isHidden) {
                self.oppositeButton.enabled = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.oppositeButton.enabled = YES;
                });
            }
        }
    }
}

#pragma mark - Getter

#pragma mark - Setter

- (void)setRemotePlayer:(GYLivePkPlayer *)remotePlayer
{
    _remotePlayer = remotePlayer;
    // 头像
    [self.avatarButton sd_setImageWithURL:[NSURL URLWithString:remotePlayer.hostAvatar] forState:UIControlStateNormal placeholderImage:kGYLiveManager.config.avatar];
    self.nameLabel.text = remotePlayer.hostName;
    //
    self.infoView.hidden = NO;
    self.oppositeButton.hidden = NO;
}

- (void)setKeepWins:(NSInteger)keepWins
{
    _keepWins = keepWins;
    // 连胜
    self.winsBgdView.hidden = keepWins <= 1;
    self.winsCountLabel.hidden = keepWins <= 1;
    self.winsCountLabel.text = @(keepWins).stringValue;
}

- (void)setHaveWon:(NSInteger)haveWon
{
    _haveWon = haveWon;
    // PK中
    self.winIconView.hidden = YES;
    self.winIconView.image = nil;
    // 状态
    switch (haveWon) {
        case -1:
        {
            // 失败
            self.winIconView.hidden = NO;
            self.winIconView.image = kGYImageNamed(@"fb_live_pk_lose_icon");
        }
            break;
        case 0:
        {
            // 平局
            self.winIconView.hidden = NO;
            self.winIconView.image = kGYImageNamed(@"fb_live_pk_draw_icon");
        }
            break;
        case 1:
        {
            // 胜利
            self.winIconView.hidden = NO;
            self.winIconView.image = kGYImageNamed(@"fb_live_pk_win_icon");
        }
            break;
            
        default:
            break;
    }
}

- (void)setIsMuted:(BOOL)isMuted
{
    _isMuted = isMuted;
    self.mutedIconView.hidden = !isMuted;
}

@end
