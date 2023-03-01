//
//  GYLiveMainItemCell.m
//  Woohoo
//
//  Created by M2-mini on 2021/8/25.
//

#import "GYLiveMainItemCell.h"
#import "GYLivePkRemoteWaitingView.h"
#import "GYLivePkControlView.h"
#import "GYLiveGiftBarrageView.h"
#import <WDLiveKit/WDLiveKit-Swift.h>
#import "GYLiveRadioGift.h"
@interface GYLiveMainItemCell () <SVGAPlayerDelegate, UIScrollViewDelegate, GYRadioGiftDelegate>

@property (nonatomic, strong) UIImageView *backgroudImageView;

@property (nonatomic, strong) UIScrollView *scrollView;

/// 空视图
@property (nonatomic, strong) UIView *cleanView;
/// ID
//@property (nonatomic, strong) UILabel *idLabel;
/// close
@property (nonatomic, strong) UIButton *closeButton;
/// 礼物
@property (nonatomic, strong) UIButton *giftsButton;

@property (nonatomic, strong) GYLivePkRemoteWaitingView *pkWaitingView;
/// 礼物弹幕
@property (nonatomic, strong) GYLiveGiftBarrageView *giftBarrageView;

/// pk元素容器（不含视频）
@property (nonatomic, strong) GYLivePkControlView *pkControlView;

@property (nonatomic, strong) SVGAPlayer *giftSvgaPlayer;

@property (nonatomic, strong) SVGAParser *giftSvgaParser;

@property (nonatomic, strong) SVGAPlayer *privilegeSvgaPlayer;

@property (nonatomic, strong) SVGAParser *privilegeSvgaParser;

@property (nonatomic, strong) SVGAPlayer *goalDoneSvgaPlayer;

@property (nonatomic, strong) SVGAParser *goalDoneSvgaParser;



@property (nonatomic, strong) NSMutableArray *svgaGifts;

@property (nonatomic, assign) BOOL svgaPlaying;

@property (nonatomic, strong) CAEmitterLayer *emitterLayer;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger emitterSec;

@property (nonatomic, assign) BOOL isRendered, pkLoading;

@end

@implementation GYLiveMainItemCell

#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.svgaGifts = [@[] mutableCopy];
        [self fb_setupViews];
    }
    return self;
}

- (void)dealloc
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitTestView = nil;
    UIView *subview = nil;
    NSMutableArray *marr = [@[] mutableCopy];
    [marr addObjectsFromArray:self.contentView.subviews];
    NSInteger index = [marr indexOfObject:self.scrollView];
    [marr removeObjectAtIndex:index];
    NSArray *containerSubViews = self.containerView.subviews;
    [marr insertObjects:containerSubViews atIndex:index];
    NSInteger count = marr.count;
    for (int i = (int)count - 1; i > 0; i--) {
        subview = marr[i];
        // 进行坐标转化
        CGPoint coverPoint = [subview convertPoint:point fromView:self];
        // 调用子视图的 hitTest 重复上面的步骤。找到了，返回hitTest view ,没找到返回有自身处理
        hitTestView = [subview hitTest:coverPoint withEvent:event];
        if ([hitTestView isKindOfClass:[UIButton class]]) {
            if ([containerSubViews containsObject:subview]) break;
            return hitTestView;
        }
    }
    return [super hitTest:point withEvent:event];
}

#pragma mark - Init

- (void)fb_setupViews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColor.clearColor;
    self.contentView.backgroundColor = UIColor.clearColor;
    
    [self.contentView addSubview:self.backgroudImageView];
    [self.contentView addSubview:self.pkRemoteView];
    [self.contentView addSubview:self.remoteView];
    [self.contentView addSubview:self.pkControlView];
    [self.contentView addSubview:self.scrollView];
    [self.contentView addSubview:self.giftBarrageView];
    [self.contentView addSubview:self.closeButton];
    //侧滑返回和主包冲突的问题
    [self.contentView addSubview:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, kGYScreenHeight)]];
    [self fb_adjustView:self.scrollView];
    
    // RTL
    if (kGYLiveManager.inside.appRTL && kGYLiveManager.config.flipRTLEnable) self.closeButton.frame = GYFlipedScreenBy(self.closeButton.frame);
}

- (void)fb_initTimer
{
    // 定时器
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    kGYWeakSelf;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
        GYLog(@"live debug - emitter countdown: %ld", weakSelf.emitterSec);
        if (weakSelf.emitterSec % 3 == 0) {
            NSString *imagename = [NSString stringWithFormat:@"fb_live_heart%ld", weakSelf.emitterSec%15];
            CAEmitterCell *cell = [weakSelf fb_emitterCellWithEffectImage:kGYImageNamed(imagename)];
            weakSelf.emitterLayer.emitterCells = @[cell];
        }
        weakSelf.emitterSec ++;
    } repeats:YES];
}

#pragma mark - Events

- (void)closeButtonClick:(UIButton *)sender
{
    if (self.eventBlock) self.eventBlock(GYLiveEventMinimize, nil);
    //
    GYEvent(@"fb_LiveTouchCloseForMinimize", nil);
    GYLiveThinking(GYLiveThinkingEventTypeEvent, GYLiveThinkingEventClickCloseButtonInLive, nil);
}

- (void)giftsButtonClick:(UIButton *)sender
{
    // 礼物
    self.eventBlock(GYLiveEventGifts, nil);
    //
    GYEvent(@"fb_LiveTouchGifts", nil);
    GYLiveThinking(GYLiveThinkingEventTypeEvent, GYLiveThinkingEventClickGiftsButtonInLive, nil);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    kGYLiveHelper.comboing = -1;
    [GYLiveComboViewManager.shared fb_removeCurrentViewFromSuperView];
    UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGPoint offset = CGPointMake(targetContentOffset->x, targetContentOffset->y);
    if (offset.x > 0) {
        //
        GYEvent(@"fb_LiveCleanScreen", nil);
    }
}

#pragma mark - SVGAPlayerDelegate

- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player
{
    if (player == self.giftSvgaPlayer) {
        if (self.svgaGifts.count > 0) {
            GYLiveGift *gift = self.svgaGifts.firstObject;
            [self.svgaGifts removeFirstObject];
            // 播放
            [self fb_playerWithGift:gift];
        } else {
            self.svgaPlaying = NO;
        }
    }
}

#pragma mark - Receive Event Methods

- (void)fb_event:(GYLiveEvent)event withObj:(NSObject * __nullable )obj
{
    // 内部同步更新
    [self.containerView fb_event:event withObj:obj];
    [self.pkControlView fb_event:event withObj:obj];
    [self.giftBarrageView fb_event:event withObj:obj];

    // 清理
    if (event == GYLiveEventRoomLeave) self.joinedRender = nil;
    
    // 接收到pk方视频
    if (event == GYLiveEventPKReceiveVideo) {
        // 收到视频，可能是滑动时收到的，先与数据，不执行动画
        [self fb_beginPKWithCompletion:nil];
    }
    
    // 接受到PK数据
    if (event == GYLiveEventPKReceiveMatchSuccessed) [self fb_beginPKWithCompletion:nil];
    
    // 结束PK
    if (event == GYLiveEventPKEnded) {
        [self fb_endPKWithCompletion:nil];
        // 更新RTC远端推流幕布大小（放在这儿，因为己方主播逃跑是通过服务器接收，而PK结束和对方逃跑走的是RTM）
        kGYLiveAgoraHelper.videoView.frame = kGYLiveHelper.ui.homeVideoRect;
    }
    
    // 视频muted
    if (event == GYLiveEventPKReceiveVideoMuted) {
        if ([obj isKindOfClass:[NSNumber class]]) { 
            BOOL isMuted = [(NSNumber*)obj boolValue];
            if (isMuted) {
                kGYWeakSelf;
                [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:self.room.pkData.awayPlayer.roomCover] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                    UIImage *blureImage = image ?: kGYLiveManager.config.avatar;
                    [weakSelf.pkRemoteView.backgroudImageView setImage:[blureImage imageByBlurDark]];
                }];
            }
        }
    }
    
    // 弹幕
    if (event == GYLiveEventReceivedBarrage && [obj isKindOfClass:[GYLiveBarrage class]]) {

        GYLiveBarrage *barrage = (GYLiveBarrage *)obj;
        // hint（加入rtm成功）
        if (barrage.type == GYLiveBarrageTypeHint && barrage.systemMsgType == 0) {
            [self fb_initTimer];
        }
        // 礼物弹幕
        if (barrage.type == GYLiveBarrageTypeGift) [self fb_receivedGiftBarrage:barrage];
        // 进场特效
        if (barrage.type == GYLiveBarrageTypeJoinLive && barrage.isPrivilege) [self fb_receivedJoinLiveBarrage:barrage];
    }
}

- (void)fb_beginPKWithCompletion:(GYLiveVoidBlock __nullable)completion
{
    // 全屏缩小动画
    self.pkControlView.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.remoteView.frame = kGYLiveHelper.ui.pkHomeVideoRect;
        self.giftBarrageView.frame = GYFlipedScreenBy(kGYLiveHelper.ui.pkGiftBarrageRect);
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
}

- (void)fb_endPKWithCompletion:(GYLiveVoidBlock __nullable)completion
{
    // 放大动画
    self.pkControlView.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.remoteView.frame = kGYLiveHelper.ui.homeVideoRect;
        self.giftBarrageView.frame = GYFlipedScreenBy(kGYLiveHelper.ui.giftBarrageRect);
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
}

- (void)fb_receivedJoinLiveBarrage:(GYLiveBarrage *)barrage
{
    // 进场特效
    kGYWeakSelf;
    [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:barrage.avatar] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        UIImage *avatar;
        if (image) {
            avatar = [[image imageByResizeToSize:CGSizeMake(124, 124) contentMode:UIViewContentModeScaleAspectFill] imageByAddingCornerRadius:QQRadiusMakeSame(124/2)];
        } else {
            avatar = [[kGYLiveManager.config.avatar imageByResizeToSize:CGSizeMake(124, 124) contentMode:UIViewContentModeScaleAspectFill] imageByAddingCornerRadius:QQRadiusMakeSame(124/2)];
        }
        if (avatar) [weakSelf.privilegeSvgaPlayer setImage:avatar forKey:@"head"];
    }];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:barrage.userName attributes:@{
        NSFontAttributeName: kGYHurmeBoldFont(30),
        NSForegroundColorAttributeName: UIColor.whiteColor,
        NSParagraphStyleAttributeName: style
    }];
    [self.privilegeSvgaPlayer setAttributedText:attText forKey:@"id"];
    [kGYLiveHelper fb_svgaPlayer:self.privilegeSvgaPlayer parser:self.privilegeSvgaParser playWithBundleSvga:@"fb_live_inroom" success:^{
    } failure:^{
    }];
}

- (void)fb_receivedGiftBarrage:(GYLiveBarrage *)barrage
{
    // 加入队列
    GYLiveGift *gift;
    for (GYLiveGift *config in kGYLiveManager.inside.accountConfig.liveConfig.giftConfigs) {//模型转换
        if (config.giftId == barrage.giftId) {
            gift = config;
            break;
        }
    }
    if (gift && gift.svgUrl.length > 0) {
        // 有队列
        if (self.svgaGifts.count > 0 || self.svgaPlaying) {
            [self.svgaGifts addObject:gift];
        } else {
            // 播放svg
            [self fb_playerWithGift:gift];
        }
    }
    
    // 收到弹幕礼物，显示combo喷泉动画
    if (gift && gift.comboIconUrl.length > 0 && barrage.combo >= 5) {
        //
        if (barrage.userId == kGYLiveManager.inside.account.accountId) {
            // 如果是自己送的
            [self fb_comboAnimationStartWithGift:gift combo:barrage.combo bySelf:YES];
        } else {
            // 别人送的
            if ((GYLiveComboAnimator.shared.isAnimating && GYLiveComboAnimator.shared.comboCount >= barrage.combo) ||
                (GYLiveComboAnimator.shared.isAnimating && GYLiveComboAnimator.shared.isPlayingSelf)) {
            } else {
                [self fb_comboAnimationStartWithGift:gift combo:barrage.combo bySelf:NO];
            }
        }
    }
}

#pragma mark - Private Methods

- (void)fb_playerLiveGoalDone
{
    // 完成目标特效
    NSString *str = [NSString stringWithFormat:kGYLocalString(@"%@ reached the room quota!"), self.room.hostName];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:str attributes:@{
        NSFontAttributeName: kGYHurmeBoldFont(26),
        NSForegroundColorAttributeName: UIColor.whiteColor,
        NSParagraphStyleAttributeName: style
    }];
    [self.goalDoneSvgaPlayer setAttributedText:attText forKey:@"id_msg"];
    [kGYLiveHelper fb_svgaPlayer:self.goalDoneSvgaPlayer parser:self.goalDoneSvgaParser playWithBundleSvga:@"fb_live_goalDone" success:^{
    } failure:^{
    }];
}

- (void)fb_playerWithGift:(GYLiveGift *)gift
{
    self.svgaPlaying = YES;
    kGYWeakSelf;
    [kGYLiveHelper fb_svgaPlayer:self.giftSvgaPlayer parser:self.giftSvgaParser playSvgaWithGift:gift success:^{
    } failure:^{
        weakSelf.svgaPlaying = NO;
        // 播放失败，接着播放
        if (weakSelf.svgaGifts.count > 0) {
            GYLiveGift *gift = weakSelf.svgaGifts.firstObject;
            [weakSelf.svgaGifts removeFirstObject];
            [weakSelf fb_playerWithGift:gift];
        }
    }];
}

- (CAEmitterCell *)fb_emitterCellWithEffectImage:(UIImage *)effectImage
{
    //create a particle template
    CAEmitterCell *cell = [[CAEmitterCell alloc] init];
    cell.contents = (__bridge id)effectImage.CGImage;
    //每秒创建的粒子个数
    cell.birthRate = 0.33;
    //每个粒子的存在时间
    cell.lifetime = 3;
    //发射方向
    cell.emissionLongitude = -M_PI_2;
    cell.emissionRange = M_PI_2 * 0.6;
    //粒子透明度变化到0的速度，单位为秒
    cell.alphaSpeed = -0.5;
    //粒子的扩散速度
    cell.velocity = 100;
    //粒子向外扩散区域大小
    cell.velocityRange = 20;
    // 4.6.旋转速度
    cell.spin = M_PI_4;
    cell.spinRange = M_PI_4 * 1/5;
    return cell;
}

- (void)fb_comboAnimationStartWithGift:(GYLiveGift *)gift combo:(NSInteger)combo bySelf:(BOOL)bySelf
{
    UIImage *image = [SDImageCache.sharedImageCache imageFromDiskCacheForKey:[SDWebImageManager.sharedManager cacheKeyForURL:[NSURL URLWithString:gift.comboIconUrl]]];
    if (!image) {
        [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:gift.comboIconUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        }];
    }
    [GYLiveComboAnimator.shared startComboAnimationWithImage:image
                                                imageSize:CGSizeMake(gift.comboSize, gift.comboSize)
                                            containerView:self
                                                    count:combo
                                                   isSelf:bySelf];
}

#pragma mark - GYLiveRadioGiftDelegate

- (void)fb_clickRadioGiftWithRoomType:(GYRadioGiftRoomType)roomType
                             andRoomId:(NSInteger)roomId
                        andAgoraRoomId:(NSString *)agoraRoomId
                      andHostAccountId:(NSInteger)hostAccountId
{
    if (roomType == GYRadioGiftRoomTypeLive) {
        if (hostAccountId == kGYLiveHelper.data.current.hostAccountId) {
            return;
        }
        kGYLiveManager.inside.joinFlag = YES;
        GYLivePkPlayer *player = [[GYLivePkPlayer alloc] init];
        player.hostAccountId = hostAccountId;
        player.roomId = roomId;
        player.agoraRoomId = agoraRoomId;
        self.eventBlock(GYLiveEventPKOpenAwayRoom, player);
    } else {
        if ([kGYLiveManager.delegate respondsToSelector:@selector(fb_broadcastWithType:hostAccountId:roomId:agoraRoomId:)]) {
            [kGYLiveManager.delegate fb_broadcastWithType:roomType hostAccountId:hostAccountId roomId:roomId agoraRoomId:agoraRoomId];
        }
    }
}

- (void)fb_thinkingEventName:(NSString *)eventName
{
    GYLiveThinking(GYLiveThinkingEventTypeEvent, eventName, nil);
}

#pragma mark - Getter

- (UIImageView *)backgroudImageView
{
    if (!_backgroudImageView) {
        _backgroudImageView = [[UIImageView alloc] initWithFrame:kGYScreenBounds];
        _backgroudImageView.image = kGYImageNamed(@"fb_live_pk_bgd");
    }
    return _backgroudImageView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kGYScreenWidth, kGYScreenHeight)];
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(kGYScreenWidth*2, kGYScreenHeight);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = UIColor.clearColor;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (GYLiveContainerView *)containerView
{
    if (!_containerView) {
        _containerView = [[GYLiveContainerView alloc] initWithFrame:kGYScreenBounds];
        _containerView.backgroundColor = UIColor.clearColor;
        kGYWeakSelf;
        _containerView.eventBlock = ^(GYLiveEvent event, id object) {
            weakSelf.eventBlock(event, object);
        };
    }
    return _containerView;
}

- (UIView *)cleanView
{
    if (!_cleanView) {
        _cleanView = [[UIView alloc] initWithFrame:CGRectMake(kGYScreenWidth, 0, kGYScreenWidth, kGYScreenHeight)];
        _cleanView.backgroundColor = UIColor.clearColor;
    }
    return _cleanView;
}

- (GYLiveRemoteView *)remoteView
{
    if (!_remoteView) {
        _remoteView = [[GYLiveRemoteView alloc] initWithFrame:kGYLiveHelper.ui.homeVideoRect];
        [_remoteView.backgroudImageView setImage:[kGYLiveManager.config.avatar imageByBlurDark]];
    }
    return _remoteView;
}

- (GYLiveRemoteView *)pkRemoteView
{
    if (!_pkRemoteView) {
        _pkRemoteView = [[GYLiveRemoteView alloc] initWithFrame:kGYLiveHelper.ui.pkAwayVideoRect];
        _pkRemoteView.promptLabel.hidden = YES;
        _pkRemoteView.backgroundColor = kGYHexColor(0x171455);
        [_pkRemoteView insertSubview:self.pkWaitingView atIndex:0];
    }
    return _pkRemoteView;
}

- (GYLivePkRemoteWaitingView *)pkWaitingView
{
    if (!_pkWaitingView) {
        _pkWaitingView = [GYLivePkRemoteWaitingView fb_waitingView];
    }
    return _pkWaitingView;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(kGYScreenWidth - 34, kGYStatusBarHeight + 15 + 3, 34, 34)];
        [_closeButton setImage:kGYImageNamed(@"fb_live_close_icon") forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)giftsButton
{
    if (!_giftsButton) {
        CGFloat x = kGYScreenWidth - kGYWidthScale(15) - 38;
        CGFloat y = kGYScreenHeight - kGYBottomSafeHeight - 15 - 38;
        _giftsButton = [[UIButton alloc] initWithFrame:GYFlipedScreenBy(CGRectMake(x, y, 38, 38))];
        [_giftsButton addTarget:self action:@selector(giftsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _giftsButton.layer.masksToBounds = YES;
        _giftsButton.layer.cornerRadius = 38/2;
    }
    return _giftsButton;
}

- (SVGAPlayer *)giftSvgaPlayer
{
    if (!_giftSvgaPlayer) {
        _giftSvgaPlayer = [[SVGAPlayer alloc] initWithFrame:kGYScreenBounds];
        _giftSvgaPlayer.delegate = self;
        _giftSvgaPlayer.loops = 1;
        _giftSvgaPlayer.clearsAfterStop = YES;
        _giftSvgaPlayer.contentMode = UIViewContentModeBottom;
        _giftSvgaPlayer.userInteractionEnabled = NO;
    }
    return _giftSvgaPlayer;
}

- (SVGAParser *)giftSvgaParser
{
    if (!_giftSvgaParser) {
        _giftSvgaParser = [[SVGAParser alloc] init];
        _giftSvgaParser.enabledMemoryCache = YES;
    }
    return _giftSvgaParser;
}

- (SVGAPlayer *)privilegeSvgaPlayer
{
    if (!_privilegeSvgaPlayer) {
        _privilegeSvgaPlayer = [[SVGAPlayer alloc] initWithFrame:kGYScreenBounds];
        _privilegeSvgaPlayer.delegate = self;
        _privilegeSvgaPlayer.loops = 1;
        _privilegeSvgaPlayer.clearsAfterStop = YES;
        _privilegeSvgaPlayer.contentMode = UIViewContentModeScaleAspectFit;
        _privilegeSvgaPlayer.userInteractionEnabled = NO;
    }
    return _privilegeSvgaPlayer;
}

- (SVGAParser *)privilegeSvgaParser
{
    if (!_privilegeSvgaParser) {
        _privilegeSvgaParser = [[SVGAParser alloc] init];
    }
    return _privilegeSvgaParser;
}

- (SVGAPlayer *)goalDoneSvgaPlayer
{
    if (!_goalDoneSvgaPlayer) {
        _goalDoneSvgaPlayer = [[SVGAPlayer alloc] initWithFrame:CGRectMake(0, 0, kGYScreenWidth, kGYScreenHeight - kGYBottomSafeHeight - kGYNavBarHeight)];
        _goalDoneSvgaPlayer.delegate = self;
        _goalDoneSvgaPlayer.loops = 1;
        _goalDoneSvgaPlayer.clearsAfterStop = YES;
        _goalDoneSvgaPlayer.contentMode = UIViewContentModeScaleAspectFit;
        _goalDoneSvgaPlayer.userInteractionEnabled = NO;
    }
    return _goalDoneSvgaPlayer;
}

- (SVGAParser *)goalDoneSvgaParser
{
    if (!_goalDoneSvgaParser) {
        _goalDoneSvgaParser = [[SVGAParser alloc] init];
    }
    return _goalDoneSvgaParser;
}

- (CAEmitterLayer *)emitterLayer
{
    if (!_emitterLayer) {
        _emitterLayer = [[CAEmitterLayer alloc] init];
        _emitterLayer.frame = CGRectMake(self.giftsButton.x+self.giftsButton.width/2, self.giftsButton.y, 200, 200);
        _emitterLayer.preservesDepth = YES;
    }
    return _emitterLayer;
}

- (GYLivePkControlView *)pkControlView
{
    if (!_pkControlView) {
        _pkControlView = [[GYLivePkControlView alloc] initWithFrame:kGYLiveHelper.ui.pkControlRect];
        kGYWeakSelf;
        _pkControlView.eventBlock = ^(GYLiveEvent event, id object) {
            weakSelf.eventBlock(event, object);
        };
        _pkControlView.hidden = YES;
    }
    return _pkControlView;
}

- (GYLiveGiftBarrageView *)giftBarrageView
{
    if (!_giftBarrageView) {
        _giftBarrageView = [[GYLiveGiftBarrageView alloc] initWithFrame:GYFlipedScreenBy(kGYLiveHelper.ui.giftBarrageRect)];
        _giftBarrageView.backgroundColor = UIColor.clearColor;
        _giftBarrageView.userInteractionEnabled = NO;
    }
    return _giftBarrageView;
}

#pragma mark - Setter

- (void)setKeyboardChangedHeight:(CGFloat)keyboardChangedHeight
{
    _keyboardChangedHeight = keyboardChangedHeight;
    self.containerView.keyboardChangedHeight = keyboardChangedHeight;
    // 隐藏opposite
    BOOL hidden = keyboardChangedHeight != 0;
    [self.pkControlView fb_event:GYLiveEventHideOpposite withObj:[NSNumber numberWithBool:hidden]];
}

- (void)setPkHostVideo:(UIView *)pkHostVideo
{
    _pkHostVideo = pkHostVideo;
    // 进来视频流
    self.pkRemoteView.videoView = pkHostVideo;
    
    if (self.room.pking) {
        kGYWeakSelf;
        [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:self.room.pkData.awayPlayer.roomCover] options:SDWebImageDelayPlaceholder progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            UIImage *blureImage = image ?: kGYLiveManager.config.avatar;
            [weakSelf.pkRemoteView.backgroudImageView setImage:[blureImage imageByBlurDark]];
        }];
    }
}

- (void)setMyHostVideo:(UIView *)myHostVideo
{
    _myHostVideo = myHostVideo;
    if (myHostVideo) self.myHostStatus = 2;
    self.remoteView.videoView = myHostVideo;
}

- (void)setMyHostStatus:(NSInteger)myHostStatus
{
    _myHostStatus = myHostStatus;
    switch (myHostStatus) {
        case 1:
        case 4:
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 未开播，结束
                self.remoteView.videoView = nil;
                NSString *text = kGYLocalString(@"The host is offline. Chat with other online hosts.");
                if (kGYLiveManager.inside.account.isGreen) text = kGYLocalString(@"The user is offline. Chat with other online users.");
                self.remoteView.promptText = text;
            });
        }
            break;
        case 2:
        {
            // 直播中
            self.remoteView.promptText = @"";
        }
            break;
        case 3:
        {
            // 私聊带走
            self.remoteView.videoView = nil;
            NSString *text = kGYLocalString(@"The host is in a private call. Please come back later.");
            if (kGYLiveManager.inside.account.isGreen) text = kGYLocalString(@"The user is offline. Chat with other online users.");
            self.remoteView.promptText = text;
        }
            break;
            
        default:
            break;
    }
}

- (void)setRoom:(GYLiveRoom *)room
{
    _room = room;
}

- (void)setJoinedRender:(GYLiveRoom *)joinedRender
{
    _joinedRender = joinedRender;
    
    if (joinedRender == nil) {
        // 清理
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        self.svgaGifts = [@[] mutableCopy];
        self.svgaPlaying = NO;
        [self.giftSvgaPlayer removeFromSuperview];
        [self.privilegeSvgaPlayer removeFromSuperview];
        [self.goalDoneSvgaPlayer removeFromSuperview];
        
        [self.containerView removeFromSuperview];
        [self.cleanView removeFromSuperview];
        [self.emitterLayer removeAllAnimations];
        [self.emitterLayer removeFromSuperlayer];
        [self.giftsButton removeFromSuperview];
        
        self.containerView = nil;
        self.emitterLayer = nil;
        self.pkControlView.hidden = YES;
        
        self.remoteView.frame = kGYLiveHelper.ui.homeVideoRect;
        self.remoteView.promptText = @"";
        self.remoteView.videoView = nil;
        
    } else {
        
        self.pkControlView.hidden = YES;
        // PK布局
        if (joinedRender.pking) {
            // 展开PK布局
            self.pkControlView.hidden = NO;
            kGYLiveAgoraHelper.videoView.frame = CGRectMake(0, 0, kGYLiveHelper.ui.pkHomeVideoRect.size.width, kGYLiveHelper.ui.pkHomeVideoRect.size.height);
            self.remoteView.frame = kGYLiveHelper.ui.pkHomeVideoRect;
            self.giftBarrageView.frame = GYFlipedScreenBy(kGYLiveHelper.ui.pkGiftBarrageRect);
            // 同步内部视图
            [self fb_event:GYLiveEventPKReceiveMatchSuccessed withObj:joinedRender.pkData];
            // 分数更新（PK中，PK结束都要刷新）
            GYLivePkPointUpdatedMsg *msg = [[GYLivePkPointUpdatedMsg alloc] init];
            msg.homePoint = joinedRender.pkData.homePoint;
            msg.awayPoint = joinedRender.pkData.awayPoint;
            [self fb_event:GYLiveEventPKReceivePointUpdate withObj:msg];
            // 准备
            if (joinedRender.pkData.homePlayer.roomStatus == 7) {
                [self fb_event:GYLiveEventPKReceiveReady withObj:@(joinedRender.pkData.homePlayer.hostAccountId)];
            }
            if (joinedRender.pkData.awayPlayer.roomStatus == 7) {
                [self fb_event:GYLiveEventPKReceiveReady withObj:@(joinedRender.pkData.awayPlayer.hostAccountId)];
            }
            // 惩罚状态
            if (joinedRender.pkData.pkLeftTime <= 0) {
                [self fb_event:GYLiveEventPKReceiveTimeUp withObj:joinedRender.pkData.winner];
                kGYLiveHelper.pkTimeUpEnd = 0;
            } else {
                // 开始计时
                kGYLiveHelper.pkInTimeUp = joinedRender.pkData.pkMaxDuration - joinedRender.pkData.pkLeftTime;
            }
            kGYLiveHelper.pkInEnd = 0;
            GYLiveThinking(GYLiveThinkingEventTypeTimeEvent, GYLiveThinkingEventTimeForOnePk, nil);
        } else {
            self.remoteView.frame = kGYLiveHelper.ui.homeVideoRect;
            self.giftBarrageView.frame = GYFlipedScreenBy(kGYLiveHelper.ui.giftBarrageRect);
            // 更新RTC远端推流幕布大小（放在这儿，因为己方主播逃跑是通过服务器接收，而PK结束和对方逃跑走的是RTM）
            kGYLiveAgoraHelper.videoView.frame = kGYLiveHelper.ui.homeVideoRect;
        }
        // 刷新数据
        self.room = joinedRender;
        // 刷新UI
        self.refreshRender = joinedRender;
        // 渲染界面
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
        [self.scrollView addSubview:self.containerView];
        [self.scrollView addSubview:self.cleanView];
        [self.contentView.layer addSublayer:self.emitterLayer];
        [self.contentView addSubview:self.giftsButton];
        [self.contentView insertSubview:self.giftSvgaPlayer belowSubview:self.giftBarrageView];
        [self.contentView insertSubview:self.privilegeSvgaPlayer aboveSubview:self.giftBarrageView];
        [self.contentView insertSubview:self.goalDoneSvgaPlayer aboveSubview:self.privilegeSvgaPlayer];
        // RTL
        [self.scrollView fb_flippedSubviewsByRTL];
        // 礼物按钮
        NSData *imageData = [NSData dataWithContentsOfFile:[kGYLiveBundle pathForResource:@"fb_live_gifts" ofType:@"gif"]];
        UIImage *image = [UIImage sd_imageWithGIFData:imageData];
        [self.giftsButton setImage:image forState:UIControlStateNormal];
                
        GYLiveRadioGift.shared.delegate = self;
        [GYLiveRadioGift.shared fb_initRadioGiftViewInView:self.contentView boldFontName:@"HurmeGeometricSans1-Bold"];
    }
}

- (void)setRefreshRender:(GYLiveRoom *)refreshRender
{
    _refreshRender = refreshRender;
    // 刷新数据
    self.room = refreshRender;
    // 刷新UI
    self.containerView.liveRoom = refreshRender;
    // 高斯模糊背景
    kGYWeakSelf;
    [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:refreshRender.roomCover]
                                              options:SDWebImageRefreshCached
                                             progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        UIImage *blureImage = image ?: kGYLiveManager.config.avatar;
        [weakSelf.remoteView.backgroudImageView setImage:blureImage];
    }];
    if (refreshRender.pking) {
        [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:refreshRender.pkData.awayPlayer.roomCover]
                                                  options:SDWebImageRefreshCached
                                                 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            UIImage *blureImage = image ?: kGYLiveManager.config.avatar;
            [weakSelf.pkRemoteView.backgroudImageView setImage:blureImage];
        }];
    }
}

@end
