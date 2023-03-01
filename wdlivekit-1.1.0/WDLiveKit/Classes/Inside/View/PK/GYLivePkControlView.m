//
//  GYLivePkControlView.m
//  Woohoo
//
//  Created by M2-mini on 2021/11/17.
//

#import "GYLivePkControlView.h"
#import "GYLivePkLocalControlView.h"
#import "GYLivePkRemoteControlView.h"
#import "GYLivePkPromptView.h"
#import "GYLivePkProgressView.h"
#import "GYLivePkAvatarsView.h"

@interface GYLivePkControlView ()

/// 本地控制视图
@property (nonatomic, strong) GYLivePkLocalControlView *localView;
/// 远端控制视图
@property (nonatomic, strong) GYLivePkRemoteControlView *remoteView;
/// 提示（倒计时，惩罚等）
@property (nonatomic, strong) GYLivePkPromptView *promptView;
/// PK进度条
@property (nonatomic, strong) GYLivePkProgressView *progressView;
/// 头像视图
@property (nonatomic, strong) GYLivePkAvatarsView *avatarsView;
// gif
@property (nonatomic, strong) UIImageView *vsGifView;

@end

@implementation GYLivePkControlView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self fb_setupDataSource];
        [self fb_setupViews];
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

#pragma mark - Init

- (void)fb_setupDataSource
{
    kGYWeakSelf;
    self.remoteView.eventBlock = ^(GYLiveEvent event, id object) {
        if (weakSelf.eventBlock) weakSelf.eventBlock(event, object);
    };
    self.avatarsView.eventBlock = ^(GYLiveEvent event, id object) {
        if (weakSelf.eventBlock) weakSelf.eventBlock(event, object);
    };
}

- (void)fb_setupViews
{
    [self addSubview:self.localView];
    [self addSubview:self.remoteView];
    [self addSubview:self.promptView];
    [self addSubview:self.progressView];
    [self addSubview:self.avatarsView];
    [self addSubview:self.vsGifView];
}

#pragma mark - Public Methods

- (void)fb_event:(GYLiveEvent)event withObj:(NSObject * __nullable )obj
{
    // 同步到子视图
    [self.localView fb_event:event withObj:obj];
    [self.remoteView fb_event:event withObj:obj];
    [self.promptView fb_event:event withObj:obj];
    [self.progressView fb_event:event withObj:obj];
    [self.avatarsView fb_event:event withObj:obj];
    
    // 收到PK数据，刷新UI显示
    if (event == GYLiveEventPKReceiveMatchSuccessed) {
        if (self.vsGifView.isAnimating) [self.vsGifView stopAnimating];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.vsGifView startAnimating];
        });
    }
}

#pragma mark - Event Methods

- (void)fb_receivePkData:(GYLivePkData *)pkData
{

}

#pragma mark - Getter

- (GYLivePkLocalControlView *)localView
{
    if (!_localView) {
        _localView = [GYLivePkLocalControlView fb_localControlView];
        _localView.frame = CGRectMake(0, 0, kGYLiveHelper.ui.pkHomeVideoRect.size.width, kGYLiveHelper.ui.pkHomeVideoRect.size.height);
    }
    return _localView;
}

- (GYLivePkRemoteControlView *)remoteView
{
    if (!_remoteView) {
        _remoteView = [GYLivePkRemoteControlView fb_remoteControlView];
        _remoteView.frame = CGRectMake(kGYScreenWidth/2, 0, kGYLiveHelper.ui.pkAwayVideoRect.size.width, kGYLiveHelper.ui.pkAwayVideoRect.size.height);
    }
    return _remoteView;
}

- (GYLivePkPromptView *)promptView
{
    if (!_promptView) {
        _promptView = [GYLivePkPromptView fb_promptView];
        _promptView.frame = kGYLiveHelper.ui.pkPromptRect;
    }
    return _promptView;
}

- (GYLivePkProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[GYLivePkProgressView alloc] initWithFrame:kGYLiveHelper.ui.pkProgressRect];
    }
    return _progressView;
}

- (GYLivePkAvatarsView *)avatarsView
{
    if (!_avatarsView) {
        _avatarsView = [GYLivePkAvatarsView fb_avatarsView];
        _avatarsView.frame = kGYLiveHelper.ui.pkAvatarsRect;
    }
    return _avatarsView;
}

- (UIImageView *)vsGifView
{
    if (!_vsGifView) {
        _vsGifView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 210, 210)];
        _vsGifView.center = CGPointMake(kGYScreenWidth/2, CGRectGetMinY(self.progressView.frame) - 210/2);
        NSMutableArray *marr = [@[] mutableCopy];
        for (int i = 0; i < 57; i++) {
            NSString *imagename = [NSString stringWithFormat:@"fb_live_pk_vs_%02d", i];
            [marr addObject:kGYImageNamed(imagename)];
        }
        _vsGifView.animationImages = marr;
        _vsGifView.animationDuration = 2.5;
        _vsGifView.animationRepeatCount = 1;
    }
    return _vsGifView;
}

@end


