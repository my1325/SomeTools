//
//  LJLiveGiftBarrageViewModel.m
//  Woohoo
//
//  Created by M2-mini on 2021/9/14.
//

#import "LJLiveGiftBarrageViewModel.h"

@interface LJLiveGiftBarrageViewModel ()


@property (nonatomic, strong) NSTimer *timer;
@end

@implementation LJLiveGiftBarrageViewModel



- (void)dealloc
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
- (void)setCountdown:(NSInteger)countdown
{
    _countdown = countdown;
    if (self.timer) {
    } else {
        kLJWeakSelf;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            LJLog(@"countdown: %ld", weakSelf.countdown);
            if (weakSelf.countdown == 0) {
                // 自动消失
                if (weakSelf.dismissBlock) weakSelf.dismissBlock(weakSelf.barrage);
                [weakSelf.timer setFireDate:[NSDate distantFuture]];
            }
            weakSelf.countdown --;
        }];
    }
}
@end
