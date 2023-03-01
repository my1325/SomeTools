//
//  GYLivePkLocalControlView.m
//  Woohoo
//
//  Created by M2-mini on 2021/11/17.
//

#import "GYLivePkLocalControlView.h"

@interface GYLivePkLocalControlView ()

@property (weak, nonatomic) IBOutlet UIImageView *winsBgdView;

@property (weak, nonatomic) IBOutlet UILabel *winsCountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *readyIconView;

@property (weak, nonatomic) IBOutlet UIImageView *winIconView;
/// 连胜
@property (nonatomic, assign) NSInteger keepWins;
/// 是否胜利（-1，0，1）
@property (nonatomic, assign) NSInteger haveWon;

@end

@implementation GYLivePkLocalControlView

#pragma mark - Life Cycle

+ (GYLivePkLocalControlView *)fb_localControlView
{
    GYLivePkLocalControlView *view = kGYLoadingXib(@"GYLivePkLocalControlView");
    return view;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self fb_setupDataSource];
    [self fb_setupViews];
}

#pragma mark - Init

- (void)fb_setupDataSource
{
    
}

- (void)fb_setupViews
{
    
}

#pragma mark - Event

- (IBAction)maskButtonClick:(UIButton *)sender
{
    GYEvent(@"fb_PKClickHomePlayerVideo", nil);
}

#pragma mark - Public Methods

- (void)fb_event:(GYLiveEvent)event withObj:(NSObject * __nullable )obj
{
    // 开始PK
    if (event == GYLiveEventPKReceiveVideo) {
        
    }
    
    // 收到PK数据，刷新UI显示
    if (event == GYLiveEventPKReceiveMatchSuccessed) {
        //
        GYLivePkData *pkData = (GYLivePkData *)obj;
        self.homePlayer = pkData.homePlayer;
        // PK中
        self.haveWon = 2;
        // 连胜次数
        self.keepWins = pkData.homePlayer.wins;
        //
        self.readyIconView.hidden = YES;
    }
    
    // PK时间到
    if (event == GYLiveEventPKReceiveTimeUp) {
        //
        GYLivePkWinner *winner = (GYLivePkWinner *)obj;
        // PK
        if (winner.hostAccountId == self.homePlayer.hostAccountId) {
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
        if (hostAccountId == self.homePlayer.hostAccountId) self.readyIconView.hidden = NO;
    }
}

#pragma mark - Getter

#pragma mark - Setter

- (void)setHomePlayer:(GYLivePkPlayer *)homePlayer
{
    _homePlayer = homePlayer;
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

@end
