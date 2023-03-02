//
//  LJLivePkLocalControlView.m
//  Woohoo
//
//  Created by M2-mini on 2021/11/17.
//

#import "LJLivePkLocalControlView.h"

@interface LJLivePkLocalControlView ()





/// 是否胜利（-1，0，1）
/// 连胜
@property (weak, nonatomic) IBOutlet UIImageView *readyIconView;
@property (weak, nonatomic) IBOutlet UIImageView *winsBgdView;
@property (weak, nonatomic) IBOutlet UILabel *winsCountLabel;
@property (nonatomic, assign) NSInteger keepWins;
@property (nonatomic, assign) NSInteger haveWon;
@property (weak, nonatomic) IBOutlet UIImageView *winIconView;
@end

@implementation LJLivePkLocalControlView

#pragma mark - Life Cycle

+ (LJLivePkLocalControlView *)lj_localControlView
{
    LJLivePkLocalControlView *view = kLJLoadingXib(@"LJLivePkLocalControlView");
    return view;
}


#pragma mark - Init



#pragma mark - Event


#pragma mark - Public Methods


#pragma mark - Getter

#pragma mark - Setter




- (void)lj_event:(LJLiveEvent)event withObj:(NSObject * __nullable )obj
{
    // 开始PK
    if (event == LJLiveEventPKReceiveVideo) {
        
    }
    
    // 收到PK数据，刷新UI显示
    if (event == LJLiveEventPKReceiveMatchSuccessed) {
        //
        LJLivePkData *pkData = (LJLivePkData *)obj;
        self.homePlayer = pkData.homePlayer;
        // PK中
        self.haveWon = 2;
        // 连胜次数
        self.keepWins = pkData.homePlayer.wins;
        //
        self.readyIconView.hidden = YES;
    }
    
    // PK时间到
    if (event == LJLiveEventPKReceiveTimeUp) {
        //
        LJLivePkWinner *winner = (LJLivePkWinner *)obj;
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
    if (event == LJLiveEventPKReceiveReady) {
        NSInteger hostAccountId = [(NSNumber *)obj integerValue];
        if (hostAccountId == self.homePlayer.hostAccountId) self.readyIconView.hidden = NO;
    }
}
- (void)lj_setupViews
{
    
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
            self.winIconView.image = kLJImageNamed(@"lj_live_pk_lose_icon");
        }
            break;
        case 0:
        {
            // 平局
            self.winIconView.hidden = NO;
            self.winIconView.image = kLJImageNamed(@"lj_live_pk_draw_icon");
        }
            break;
        case 1:
        {
            // 胜利
            self.winIconView.hidden = NO;
            self.winIconView.image = kLJImageNamed(@"lj_live_pk_win_icon");
        }
            break;
            
        default:
            break;
    }
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self lj_setupDataSource];
    [self lj_setupViews];
}
- (IBAction)maskButtonClick:(UIButton *)sender
{
    LJEvent(@"lj_PKClickHomePlayerVideo", nil);
}
- (void)lj_setupDataSource
{
    
}
- (void)setHomePlayer:(LJLivePkPlayer *)homePlayer
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
@end
