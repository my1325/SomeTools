//
//  LJLivePkPromptView.m
//  Woohoo
//
//  Created by M2-mini on 2021/11/18.
//

#import "LJLivePkPromptView.h"

@interface LJLivePkPromptView ()

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

@implementation LJLivePkPromptView

#pragma mark - Life Cycle

+ (LJLivePkPromptView *)lj_promptView
{
    LJLivePkPromptView *view = kLJLoadingXib(@"LJLivePkPromptView");
    return view;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self lj_setupDataSource];
    [self lj_setupViews];
}

#pragma mark - Init

- (void)lj_setupDataSource
{
    
}

- (void)lj_setupViews
{
    self.promptLabel.hidden = YES;
    self.vsView.hidden = YES;
    self.countdownLabel.hidden = YES;
    self.punishingView.hidden = YES;
    self.bgdView.hidden = YES;
    //
    self.bgdView.image = [kLJImageNamed(@"lj_live_pk_prompt_bgd_icon") stretchableImageWithLeftCapWidth:30 topCapHeight:0];
}

- (void)lj_initTimer
{
    [self lj_clearTimer];
    kLJWeakSelf;
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
        
        LJLog(@"live debug - pk countdown: %ld", weakSelf.countdown);
        
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
            [self lj_clearTimer];
        }
        if (weakSelf.countdown == 0) weakSelf.promptLabel.transform = CGAffineTransformIdentity;

        weakSelf.countdown --;
        
    } repeats:YES];
}

- (void)lj_clearTimer
{
    if (self.countdownTimer) {
        self.countdown = 0;
        [self.countdownTimer setFireDate:[NSDate distantFuture]];
        [self.countdownTimer invalidate];
        self.countdownTimer = nil;
    }
}

#pragma mark - Public Methods

- (void)lj_event:(LJLiveEvent)event withObj:(NSObject * __nullable )obj
{
    // 收到PK数据，刷新UI显示
    if (event == LJLiveEventPKReceiveMatchSuccessed) {
        //
        LJLivePkData *pkData = (LJLivePkData *)obj;
        self.countdown = MAX(pkData.pkLeftTime-1, 0);
        // 更新显示
        NSInteger min = self.countdown / 60;
        NSInteger sec = self.countdown % 60;
        self.countdownLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", min, sec];

        [self lj_initTimer];
        //
        self.bgdView.hidden = NO;
        self.promptLabel.hidden = YES;
        self.vsView.hidden = NO;
        self.countdownLabel.hidden = NO;
        self.punishingView.hidden = YES;
    }
    
    // PK时间到
    if (event == LJLiveEventPKReceiveTimeUp) {
        [self lj_clearTimer];
        // 变更为惩罚、或者打平显示
        LJLivePkWinner *winner = (LJLivePkWinner *)obj;
        if (winner.hostAccountId == 0) {
            // 打平
            if (self.countdown == 0) self.promptLabel.transform = CGAffineTransformIdentity;
            self.promptLabel.text = kLJLocalString(@"Draw");
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
    
    if (event == LJLiveEventPKEnded) {
        [self lj_clearTimer];
    }
    
    // 清理定时器
    if (event == LJLiveEventRoomLeave) [self lj_clearTimer];
}

#pragma mark - Methods

#pragma mark - Getter

#pragma mark - Setter

@end
