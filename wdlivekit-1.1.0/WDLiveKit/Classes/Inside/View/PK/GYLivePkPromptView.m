//
//  GYLivePkPromptView.m
//  Woohoo
//
//  Created by M2-mini on 2021/11/18.
//

#import "GYLivePkPromptView.h"

@interface GYLivePkPromptView ()

/// 中间背景
@property (weak, nonatomic) IBOutlet UIImageView *bgdView;
/// vs
@property (weak, nonatomic) IBOutlet UIStackView *vsView;
/// 惩罚中
@property (weak, nonatomic) IBOutlet UIImageView *punishingView;
/// 提示文案
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
/// 倒计时
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;

@property (nonatomic, strong) NSTimer *countdownTimer;

@property (nonatomic, assign) NSInteger countdown;

@end

@implementation GYLivePkPromptView

#pragma mark - Life Cycle

+ (GYLivePkPromptView *)fb_promptView
{
    GYLivePkPromptView *view = kGYLoadingXib(@"GYLivePkPromptView");
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
    self.promptLabel.hidden = YES;
    self.vsView.hidden = YES;
    self.countdownLabel.hidden = YES;
    self.punishingView.hidden = YES;
    self.bgdView.hidden = YES;
    //
    self.bgdView.image = [kGYImageNamed(@"fb_live_pk_prompt_bgd_icon") stretchableImageWithLeftCapWidth:30 topCapHeight:0];
}

- (void)fb_initTimer
{
    [self fb_clearTimer];
    kGYWeakSelf;
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
        
        GYLog(@"live debug - pk countdown: %ld", weakSelf.countdown);
        
        // 更新显示
        NSInteger min = weakSelf.countdown / 60;
        NSInteger sec = weakSelf.countdown % 60;
        if (weakSelf.countdown < 10) {
            weakSelf.countdownLabel.hidden = YES;
            weakSelf.vsView.hidden = YES;
            weakSelf.promptLabel.hidden = NO;
            self.promptLabel.text = [NSString stringWithFormat:@"%ld", sec];
            [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                weakSelf.promptLabel.transform = CGAffineTransformMakeScale(2.7, 2.7);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    if (weakSelf.countdown == 0) {
                        weakSelf.promptLabel.transform = CGAffineTransformIdentity;
                    } else {
                        weakSelf.promptLabel.transform = CGAffineTransformMakeScale(1.2, 1.2);
                    }
                } completion:^(BOOL finished) {
                    if (weakSelf.countdown == 0) weakSelf.promptLabel.transform = CGAffineTransformIdentity;
                }];
            }];
        } else {
            weakSelf.countdownLabel.hidden = NO;
            weakSelf.vsView.hidden = NO;
            weakSelf.promptLabel.hidden = YES;
            weakSelf.countdownLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", min, sec];
        }
        if (weakSelf.countdown < 0) {
            // 手动结束 惩罚
            weakSelf.promptLabel.hidden = YES;
            weakSelf.vsView.hidden = YES;
            weakSelf.countdownLabel.hidden = YES;
            weakSelf.punishingView.hidden = NO;
            [self fb_clearTimer];
        }
        if (weakSelf.countdown == 0) weakSelf.promptLabel.transform = CGAffineTransformIdentity;

        weakSelf.countdown --;
        
    } repeats:YES];
}

- (void)fb_clearTimer
{
    if (self.countdownTimer) {
        self.countdown = 0;
        [self.countdownTimer setFireDate:[NSDate distantFuture]];
        [self.countdownTimer invalidate];
        self.countdownTimer = nil;
    }
}

#pragma mark - Public Methods

- (void)fb_event:(GYLiveEvent)event withObj:(NSObject * __nullable )obj
{
    // 收到PK数据，刷新UI显示
    if (event == GYLiveEventPKReceiveMatchSuccessed) {
        //
        GYLivePkData *pkData = (GYLivePkData *)obj;
        self.countdown = MAX(pkData.pkLeftTime-1, 0);
        // 更新显示
        NSInteger min = self.countdown / 60;
        NSInteger sec = self.countdown % 60;
        self.countdownLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", min, sec];

        [self fb_initTimer];
        //
        self.bgdView.hidden = NO;
        self.promptLabel.hidden = YES;
        self.vsView.hidden = NO;
        self.countdownLabel.hidden = NO;
        self.punishingView.hidden = YES;
    }
    
    // PK时间到
    if (event == GYLiveEventPKReceiveTimeUp) {
        [self fb_clearTimer];
        // 变更为惩罚、或者打平显示
        GYLivePkWinner *winner = (GYLivePkWinner *)obj;
        if (winner.hostAccountId == 0) {
            // 打平
            if (self.countdown == 0) self.promptLabel.transform = CGAffineTransformIdentity;
            self.promptLabel.text = kGYLocalString(@"Draw");
            self.promptLabel.hidden = NO;
            self.vsView.hidden = YES;
            self.countdownLabel.hidden = YES;
            self.punishingView.hidden = YES;
        } else {
            // 惩罚
            self.promptLabel.hidden = YES;
            self.vsView.hidden = YES;
            self.countdownLabel.hidden = YES;
            self.punishingView.hidden = NO;
        }
        self.bgdView.hidden = NO;
    }
    
    if (event == GYLiveEventPKEnded) {
        [self fb_clearTimer];
    }
    
    // 清理定时器
    if (event == GYLiveEventRoomLeave) [self fb_clearTimer];
}

#pragma mark - Methods

#pragma mark - Getter

#pragma mark - Setter

@end
