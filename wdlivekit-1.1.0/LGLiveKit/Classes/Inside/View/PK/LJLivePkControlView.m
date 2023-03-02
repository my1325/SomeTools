//
//  LJLivePkControlView.m
//  Woohoo
//
//  Created by M2-mini on 2021/11/17.
//

#import "LJLivePkControlView.h"
#import "LJLivePkLocalControlView.h"
#import "LJLivePkRemoteControlView.h"
#import "LJLivePkPromptView.h"
#import "LJLivePkProgressView.h"
#import "LJLivePkAvatarsView.h"

@interface LJLivePkControlView ()


/// 提示（倒计时，惩罚等）
// gif
/// 远端控制视图
/// PK进度条
/// 头像视图
/// 本地控制视图
@property (nonatomic, strong) LJLivePkPromptView *promptView;
@property (nonatomic, strong) UIImageView *vsGifView;
@property (nonatomic, strong) LJLivePkAvatarsView *avatarsView;
@property (nonatomic, strong) LJLivePkLocalControlView *localView;
@property (nonatomic, strong) LJLivePkRemoteControlView *remoteView;
@property (nonatomic, strong) LJLivePkProgressView *progressView;
@end

@implementation LJLivePkControlView

#pragma mark - Life Cycle



#pragma mark - Init



#pragma mark - Public Methods


#pragma mark - Event Methods


#pragma mark - Getter







- (LJLivePkLocalControlView *)localView
{
    if (!_localView) {
        _localView = [LJLivePkLocalControlView lj_localControlView];
        _localView.frame = CGRectMake(0, 0, kLJLiveHelper.ui.pkHomeVideoRect.size.width, kLJLiveHelper.ui.pkHomeVideoRect.size.height);
    }
    return _localView;
}
- (LJLivePkRemoteControlView *)remoteView
{
    if (!_remoteView) {
        _remoteView = [LJLivePkRemoteControlView lj_remoteControlView];
        _remoteView.frame = CGRectMake(kLJScreenWidth/2, 0, kLJLiveHelper.ui.pkAwayVideoRect.size.width, kLJLiveHelper.ui.pkAwayVideoRect.size.height);
    }
    return _remoteView;
}
- (LJLivePkPromptView *)promptView
{
    if (!_promptView) {
        _promptView = [LJLivePkPromptView lj_promptView];
        _promptView.frame = kLJLiveHelper.ui.pkPromptRect;
    }
    return _promptView;
}
- (void)lj_receivePkData:(LJLivePkData *)pkData
{

}
- (UIImageView *)vsGifView
{
    if (!_vsGifView) {
        _vsGifView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 210, 210)];
        _vsGifView.center = CGPointMake(kLJScreenWidth/2, CGRectGetMinY(self.progressView.frame) - 210/2);
        NSMutableArray *marr = [@[] mutableCopy];
        for (int i = 0; i < 57; i++) {
            NSString *imagename = [NSString stringWithFormat:@"lj_live_pk_vs_%02d", i];
            [marr addObject:kLJImageNamed(imagename)];
        }
        _vsGifView.animationImages = marr;
        _vsGifView.animationDuration = 2.5;
        _vsGifView.animationRepeatCount = 1;
    }
    return _vsGifView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self lj_setupDataSource];
        [self lj_setupViews];
    }
    return self;
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    for (UIView *subview in self.subviews) {
        // 进行坐标转化
        CGPoint coverPoint = [subview convertPoint:point fromView:self];
        // 调用子视图的 hitTest 重复上面的步骤。找到了，返回hitTest view ,没找到返回有自身处理
        UIView *hitTestView = [subview hitTest:coverPoint withEvent:event];
        if (hitTestView) {
            if (![self.subviews containsObject:hitTestView]) {
                return hitTestView;
            }
        }
    }
    return nil;
}
- (void)lj_event:(LJLiveEvent)event withObj:(NSObject * __nullable )obj
{
    // 同步到子视图
    [self.localView lj_event:event withObj:obj];
    [self.remoteView lj_event:event withObj:obj];
    [self.promptView lj_event:event withObj:obj];
    [self.progressView lj_event:event withObj:obj];
    [self.avatarsView lj_event:event withObj:obj];
    
    // 收到PK数据，刷新UI显示
    if (event == LJLiveEventPKReceiveMatchSuccessed) {
        if (self.vsGifView.isAnimating) [self.vsGifView stopAnimating];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.vsGifView startAnimating];
        });
    }
}
- (void)lj_setupDataSource
{
    kLJWeakSelf;
    self.remoteView.eventBlock = ^(LJLiveEvent event, id object) {
        if (weakSelf.eventBlock) weakSelf.eventBlock(event, object);
    };
    self.avatarsView.eventBlock = ^(LJLiveEvent event, id object) {
        if (weakSelf.eventBlock) weakSelf.eventBlock(event, object);
    };
}
- (LJLivePkAvatarsView *)avatarsView
{
    if (!_avatarsView) {
        _avatarsView = [LJLivePkAvatarsView lj_avatarsView];
        _avatarsView.frame = kLJLiveHelper.ui.pkAvatarsRect;
    }
    return _avatarsView;
}
- (LJLivePkProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[LJLivePkProgressView alloc] initWithFrame:kLJLiveHelper.ui.pkProgressRect];
    }
    return _progressView;
}
- (void)lj_setupViews
{
    [self addSubview:self.localView];
    [self addSubview:self.remoteView];
    [self addSubview:self.promptView];
    [self addSubview:self.progressView];
    [self addSubview:self.avatarsView];
    [self addSubview:self.vsGifView];
}
@end


