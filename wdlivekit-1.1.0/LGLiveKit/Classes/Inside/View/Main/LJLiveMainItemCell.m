//
//  LJLiveMainItemCell.m
//  Woohoo
//
//  Created by M2-mini on 2021/8/25.
//

#import "LJLiveMainItemCell.h"
#import "LJLivePkRemoteWaitingView.h"
#import "LJLivePkControlView.h"
#import "LJLiveGiftBarrageView.h"
#import <LGLiveKit/LGLiveKit-Swift.h>
#import "LJLiveRadioGift.h"
@interface LJLiveMainItemCell () <SVGAPlayerDelegate, UIScrollViewDelegate, LJRadioGiftDelegate>

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

@property (nonatomic, strong) LJLivePkRemoteWaitingView *pkWaitingView;
/// 礼物弹幕
@property (nonatomic, strong) LJLiveGiftBarrageView *giftBarrageView;

/// pk元素容器（不含视频）
@property (nonatomic, strong) LJLivePkControlView *pkControlView;

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

@implementation LJLiveMainItemCell

#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.svgaGifts = [@[] mutableCopy];
        [self lj_setupViews];
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

- (void)lj_setupViews
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
    [self.contentView addSubview:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, kLJScreenHeight)]];
    [self lj_adjustView:self.scrollView];
    
    // RTL
    if (kLJLiveManager.inside.appRTL && kLJLiveManager.config.flipRTLEnable) self.closeButton.frame = LJFlipedScreenBy(self.closeButton.frame);
}

- (void)lj_initTimer
{
    // 定时器
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    kLJWeakSelf;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
        LJLog(@"live debug - emitter countdown: %ld", weakSelf.emitterSec);
        if (weakSelf.emitterSec % 3 == 0) {
            NSString *imagename = [NSString stringWithFormat:@"lj_live_heart%ld", weakSelf.emitterSec%15];
            CAEmitterCell *cell = [weakSelf lj_emitterCellWithEffectImage:kLJImageNamed(imagename)];
            weakSelf.emitterLayer.emitterCells = @[cell];
        }
        weakSelf.emitterSec ++;
    } repeats:YES];
}

#pragma mark - Events

- (void)closeButtonClick:(UIButton *)sender
{
    if (self.eventBlock) self.eventBlock(LJLiveEventMinimize, nil);
    //
    LJEvent(@"lj_LiveTouchCloseForMinimize", nil);
    LJLiveThinking(LJLiveThinkingEventTypeEvent, LJLiveThinkingEventClickCloseButtonInLive, nil);
}

- (void)giftsButtonClick:(UIButton *)sender
{
    // 礼物
    self.eventBlock(LJLiveEventGifts, nil);
    //
    LJEvent(@"lj_LiveTouchGifts", nil);
    LJLiveThinking(LJLiveThinkingEventTypeEvent, LJLiveThinkingEventClickGiftsButtonInLive, nil);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    kLJLiveHelper.comboing = -1;
    [LJLiveComboViewManager.shared lj_removeCurrentViewFromSuperView];
    UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGPoint offset = CGPointMake(targetContentOffset->x, targetContentOffset->y);
    if (offset.x > 0) {
        //
        LJEvent(@"lj_LiveCleanScreen", nil);
    }
}

#pragma mark - SVGAPlayerDelegate

- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player
{
    if (player == self.giftSvgaPlayer) {
        if (self.svgaGifts.count > 0) {
            LJLiveGift *gift = self.svgaGifts.firstObject;
            [self.svgaGifts removeFirstObject];
            // 播放
            [self lj_playerWithGift:gift];
        } else {
            self.svgaPlaying = NO;
        }
    }
}

#pragma mark - Receive Event Methods

- (void)lj_event:(LJLiveEvent)event withObj:(NSObject * __nullable )obj
{
    // 内部同步更新
    [self.containerView lj_event:event withObj:obj];
    [self.pkControlView lj_event:event withObj:obj];
    [self.giftBarrageView lj_event:event withObj:obj];

    // 清理
    if (event == LJLiveEventRoomLeave) self.joinedRender = nil;
    
    // 接收到pk方视频
    if (event == LJLiveEventPKReceiveVideo) {
        // 收到视频，可能是滑动时收到的，先与数据，不执行动画
        [self lj_beginPKWithCompletion:nil];
    }
    
    // 接受到PK数据
    if (event == LJLiveEventPKReceiveMatchSuccessed) [self lj_beginPKWithCompletion:nil];
    
    // 结束PK
    if (event == LJLiveEventPKEnded) {
        [self lj_endPKWithCompletion:nil];
        // 更新RTC远端推流幕布大小（放在这儿，因为己方主播逃跑是通过服务器接收，而PK结束和对方逃跑走的是RTM）
        kLJLiveAgoraHelper.videoView.frame = kLJLiveHelper.ui.homeVideoRect;
    }
    
    // 视频muted
    if (event == LJLiveEventPKReceiveVideoMuted) {
        if ([obj isKindOfClass:[NSNumber class]]) { 
            BOOL isMuted = [(NSNumber*)obj boolValue];
            if (isMuted) {
                kLJWeakSelf;
                [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:self.room.pkData.awayPlayer.roomCover] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                    UIImage *blureImage = image ?: kLJLiveManager.config.avatar;
                    [weakSelf.pkRemoteView.backgroudImageView setImage:[blureImage imageByBlurDark]];
                }];
            }
        }
    }
    
    // 弹幕
    if (event == LJLiveEventReceivedBarrage && [obj isKindOfClass:[LJLiveBarrage class]]) {

        LJLiveBarrage *barrage = (LJLiveBarrage *)obj;
        // hint（加入rtm成功）
        if (barrage.type == LJLiveBarrageTypeHint && barrage.systemMsgType == 0) {
            [self lj_initTimer];
        }
        // 礼物弹幕
        if (barrage.type == LJLiveBarrageTypeGift) [self lj_receivedGiftBarrage:barrage];
        // 进场特效
        if (barrage.type == LJLiveBarrageTypeJoinLive && barrage.isPrivilege) [self lj_receivedJoinLiveBarrage:barrage];
    }
}

- (void)lj_beginPKWithCompletion:(LJLiveVoidBlock __nullable)completion
{
    // 全屏缩小动画
    self.pkControlView.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.remoteView.frame = kLJLiveHelper.ui.pkHomeVideoRect;
        self.giftBarrageView.frame = LJFlipedScreenBy(kLJLiveHelper.ui.pkGiftBarrageRect);
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
}

- (void)lj_endPKWithCompletion:(LJLiveVoidBlock __nullable)completion
{
    // 放大动画
    self.pkControlView.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.remoteView.frame = kLJLiveHelper.ui.homeVideoRect;
        self.giftBarrageView.frame = LJFlipedScreenBy(kLJLiveHelper.ui.giftBarrageRect);
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
}

- (void)lj_receivedJoinLiveBarrage:(LJLiveBarrage *)barrage
{
    // 进场特效
    kLJWeakSelf;
    [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:barrage.avatar] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        UIImage *avatar;
        if (image) {
            avatar = [[image imageByResizeToSize:CGSizeMake(124, 124) contentMode:UIViewContentModeScaleAspectFill] imageByAddingCornerRadius:QQRadiusMakeSame(124/2)];
        } else {
            avatar = [[kLJLiveManager.config.avatar imageByResizeToSize:CGSizeMake(124, 124) contentMode:UIViewContentModeScaleAspectFill] imageByAddingCornerRadius:QQRadiusMakeSame(124/2)];
        }
        if (avatar) [weakSelf.privilegeSvgaPlayer setImage:avatar forKey:@"head"];
    }];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:barrage.userName attributes:@{
        NSFontAttributeName: kLJHurmeBoldFont(30),
        NSForegroundColorAttributeName: UIColor.whiteColor,
        NSParagraphStyleAttributeName: style
    }];
    [self.privilegeSvgaPlayer setAttributedText:attText forKey:@"id"];
    [kLJLiveHelper lj_svgaPlayer:self.privilegeSvgaPlayer parser:self.privilegeSvgaParser playWithBundleSvga:@"lj_live_inroom" success:^{
    } failure:^{
    }];
}

- (void)lj_receivedGiftBarrage:(LJLiveBarrage *)barrage
{
    // 加入队列
    LJLiveGift *gift;
    for (LJLiveGift *config in kLJLiveManager.inside.accountConfig.liveConfig.giftConfigs) {//模型转换
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
            [self lj_playerWithGift:gift];
        }
    }
    
    // 收到弹幕礼物，显示combo喷泉动画
    if (gift && gift.comboIconUrl.length > 0 && barrage.combo >= 5) {
        //
        if (barrage.userId == kLJLiveManager.inside.account.accountId) {
            // 如果是自己送的
            [self lj_comboAnimationStartWithGift:gift combo:barrage.combo bySelf:YES];
        } else {
            // 别人送的
            if ((LJLiveComboAnimator.shared.isAnimating && LJLiveComboAnimator.shared.comboCount >= barrage.combo) ||
                (LJLiveComboAnimator.shared.isAnimating && LJLiveComboAnimator.shared.isPlayingSelf)) {
            } else {
                [self lj_comboAnimationStartWithGift:gift combo:barrage.combo bySelf:NO];
            }
        }
    }
}

#pragma mark - Private Methods

- (void)lj_playerLiveGoalDone
{
    // 完成目标特效
    NSString *str = [NSString stringWithFormat:kLJLocalString(@"%@ reached the room quota!"), self.room.hostName];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:str attributes:@{
        NSFontAttributeName: kLJHurmeBoldFont(26),
        NSForegroundColorAttributeName: UIColor.whiteColor,
        NSParagraphStyleAttributeName: style
    }];
    [self.goalDoneSvgaPlayer setAttributedText:attText forKey:@"id_msg"];
    [kLJLiveHelper lj_svgaPlayer:self.goalDoneSvgaPlayer parser:self.goalDoneSvgaParser playWithBundleSvga:@"lj_live_goalDone" success:^{
    } failure:^{
    }];
}

- (void)lj_playerWithGift:(LJLiveGift *)gift
{
    self.svgaPlaying = YES;
    kLJWeakSelf;
    [kLJLiveHelper lj_svgaPlayer:self.giftSvgaPlayer parser:self.giftSvgaParser playSvgaWithGift:gift success:^{
    } failure:^{
        weakSelf.svgaPlaying = NO;
        // 播放失败，接着播放
        if (weakSelf.svgaGifts.count > 0) {
            LJLiveGift *gift = weakSelf.svgaGifts.firstObject;
            [weakSelf.svgaGifts removeFirstObject];
            [weakSelf lj_playerWithGift:gift];
        }
    }];
}

- (CAEmitterCell *)lj_emitterCellWithEffectImage:(UIImage *)effectImage
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

- (void)lj_comboAnimationStartWithGift:(LJLiveGift *)gift combo:(NSInteger)combo bySelf:(BOOL)bySelf
{
    UIImage *image = [SDImageCache.sharedImageCache imageFromDiskCacheForKey:[SDWebImageManager.sharedManager cacheKeyForURL:[NSURL URLWithString:gift.comboIconUrl]]];
    if (!image) {
        [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:gift.comboIconUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        }];
    }
    [LJLiveComboAnimator.shared startComboAnimationWithImage:image
                                                imageSize:CGSizeMake(gift.comboSize, gift.comboSize)
                                            containerView:self
                                                    count:combo
                                                   isSelf:bySelf];
}

#pragma mark - LJLiveRadioGiftDelegate

- (void)lj_clickRadioGiftWithRoomType:(LJRadioGiftRoomType)roomType
                             andRoomId:(NSInteger)roomId
                        andAgoraRoomId:(NSString *)agoraRoomId
                      andHostAccountId:(NSInteger)hostAccountId
{
    if (roomType == LJRadioGiftRoomTypeLive) {
        if (hostAccountId == kLJLiveHelper.data.current.hostAccountId) {
            return;
        }
        kLJLiveManager.inside.joinFlag = YES;
        LJLivePkPlayer *player = [[LJLivePkPlayer alloc] init];
        player.hostAccountId = hostAccountId;
        player.roomId = roomId;
        player.agoraRoomId = agoraRoomId;
        self.eventBlock(LJLiveEventPKOpenAwayRoom, player);
    } else {
        if ([kLJLiveManager.delegate respondsToSelector:@selector(lj_broadcastWithType:hostAccountId:roomId:agoraRoomId:)]) {
            [kLJLiveManager.delegate lj_broadcastWithType:roomType hostAccountId:hostAccountId roomId:roomId agoraRoomId:agoraRoomId];
        }
    }
}

- (void)lj_thinkingEventName:(NSString *)eventName
{
    LJLiveThinking(LJLiveThinkingEventTypeEvent, eventName, nil);
}

#pragma mark - Getter

- (UIImageView *)backgroudImageView
{
    if (!_backgroudImageView) {
        _backgroudImageView = [[UIImageView alloc] initWithFrame:kLJScreenBounds];
        _backgroudImageView.image = kLJImageNamed(@"lj_live_pk_bgd");
    }
    return _backgroudImageView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kLJScreenWidth, kLJScreenHeight)];
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(kLJScreenWidth*2, kLJScreenHeight);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = UIColor.clearColor;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (LJLiveContainerView *)containerView
{
    if (!_containerView) {
        _containerView = [[LJLiveContainerView alloc] initWithFrame:kLJScreenBounds];
        _containerView.backgroundColor = UIColor.clearColor;
        kLJWeakSelf;
        _containerView.eventBlock = ^(LJLiveEvent event, id object) {
            weakSelf.eventBlock(event, object);
        };
    }
    return _containerView;
}

- (UIView *)cleanView
{
    if (!_cleanView) {
        _cleanView = [[UIView alloc] initWithFrame:CGRectMake(kLJScreenWidth, 0, kLJScreenWidth, kLJScreenHeight)];
        _cleanView.backgroundColor = UIColor.clearColor;
    }
    return _cleanView;
}

- (LJLiveRemoteView *)remoteView
{
    if (!_remoteView) {
        _remoteView = [[LJLiveRemoteView alloc] initWithFrame:kLJLiveHelper.ui.homeVideoRect];
        [_remoteView.backgroudImageView setImage:[kLJLiveManager.config.avatar imageByBlurDark]];
    }
    return _remoteView;
}

- (LJLiveRemoteView *)pkRemoteView
{
    if (!_pkRemoteView) {
        _pkRemoteView = [[LJLiveRemoteView alloc] initWithFrame:kLJLiveHelper.ui.pkAwayVideoRect];
        _pkRemoteView.promptLabel.hidden = YES;
        _pkRemoteView.backgroundColor = kLJHexColor(0x171455);
        [_pkRemoteView insertSubview:self.pkWaitingView atIndex:0];
    }
    return _pkRemoteView;
}

- (LJLivePkRemoteWaitingView *)pkWaitingView
{
    if (!_pkWaitingView) {
        _pkWaitingView = [LJLivePkRemoteWaitingView lj_waitingView];
    }
    return _pkWaitingView;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(kLJScreenWidth - 34, kLJStatusBarHeight + 15 + 3, 34, 34)];
        [_closeButton setImage:kLJImageNamed(@"lj_live_close_icon") forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)giftsButton
{
    if (!_giftsButton) {
        CGFloat x = kLJScreenWidth - kLJWidthScale(15) - 38;
        CGFloat y = kLJScreenHeight - kLJBottomSafeHeight - 15 - 38;
        _giftsButton = [[UIButton alloc] initWithFrame:LJFlipedScreenBy(CGRectMake(x, y, 38, 38))];
        [_giftsButton addTarget:self action:@selector(giftsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _giftsButton.layer.masksToBounds = YES;
        _giftsButton.layer.cornerRadius = 38/2;
    }
    return _giftsButton;
}

- (SVGAPlayer *)giftSvgaPlayer
{
    if (!_giftSvgaPlayer) {
        _giftSvgaPlayer = [[SVGAPlayer alloc] initWithFrame:kLJScreenBounds];
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
        _privilegeSvgaPlayer = [[SVGAPlayer alloc] initWithFrame:kLJScreenBounds];
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
        _goalDoneSvgaPlayer = [[SVGAPlayer alloc] initWithFrame:CGRectMake(0, 0, kLJScreenWidth, kLJScreenHeight - kLJBottomSafeHeight - kLJNavBarHeight)];
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

- (LJLivePkControlView *)pkControlView
{
    if (!_pkControlView) {
        _pkControlView = [[LJLivePkControlView alloc] initWithFrame:kLJLiveHelper.ui.pkControlRect];
        kLJWeakSelf;
        _pkControlView.eventBlock = ^(LJLiveEvent event, id object) {
            weakSelf.eventBlock(event, object);
        };
        _pkControlView.hidden = YES;
    }
    return _pkControlView;
}

- (LJLiveGiftBarrageView *)giftBarrageView
{
    if (!_giftBarrageView) {
        _giftBarrageView = [[LJLiveGiftBarrageView alloc] initWithFrame:LJFlipedScreenBy(kLJLiveHelper.ui.giftBarrageRect)];
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
    [self.pkControlView lj_event:LJLiveEventHideOpposite withObj:[NSNumber numberWithBool:hidden]];
}

- (void)setPkHostVideo:(UIView *)pkHostVideo
{
    _pkHostVideo = pkHostVideo;
    // 进来视频流
    self.pkRemoteView.videoView = pkHostVideo;
    
    if (self.room.pking) {
        kLJWeakSelf;
        [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:self.room.pkData.awayPlayer.roomCover] options:SDWebImageDelayPlaceholder progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            UIImage *blureImage = image ?: kLJLiveManager.config.avatar;
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
                NSString *text = kLJLocalString(@"The host is offline. Chat with other online hosts.");
                if (kLJLiveManager.inside.account.isGreen) text = kLJLocalString(@"The user is offline. Chat with other online users.");
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
            NSString *text = kLJLocalString(@"The host is in a private call. Please come back later.");
            if (kLJLiveManager.inside.account.isGreen) text = kLJLocalString(@"The user is offline. Chat with other online users.");
            self.remoteView.promptText = text;
        }
            break;
            
        default:
            break;
    }
}

- (void)setRoom:(LJLiveRoom *)room
{
    _room = room;
}

- (void)setJoinedRender:(LJLiveRoom *)joinedRender
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
        
        self.remoteView.frame = kLJLiveHelper.ui.homeVideoRect;
        self.remoteView.promptText = @"";
        self.remoteView.videoView = nil;
        
    } else {
        
        self.pkControlView.hidden = YES;
        // PK布局
        if (joinedRender.pking) {
            // 展开PK布局
            self.pkControlView.hidden = NO;
            kLJLiveAgoraHelper.videoView.frame = CGRectMake(0, 0, kLJLiveHelper.ui.pkHomeVideoRect.size.width, kLJLiveHelper.ui.pkHomeVideoRect.size.height);
            self.remoteView.frame = kLJLiveHelper.ui.pkHomeVideoRect;
            self.giftBarrageView.frame = LJFlipedScreenBy(kLJLiveHelper.ui.pkGiftBarrageRect);
            // 同步内部视图
            [self lj_event:LJLiveEventPKReceiveMatchSuccessed withObj:joinedRender.pkData];
            // 分数更新（PK中，PK结束都要刷新）
            LJLivePkPointUpdatedMsg *msg = [[LJLivePkPointUpdatedMsg alloc] init];
            msg.homePoint = joinedRender.pkData.homePoint;
            msg.awayPoint = joinedRender.pkData.awayPoint;
            [self lj_event:LJLiveEventPKReceivePointUpdate withObj:msg];
            // 准备
            if (joinedRender.pkData.homePlayer.roomStatus == 7) {
                [self lj_event:LJLiveEventPKReceiveReady withObj:@(joinedRender.pkData.homePlayer.hostAccountId)];
            }
            if (joinedRender.pkData.awayPlayer.roomStatus == 7) {
                [self lj_event:LJLiveEventPKReceiveReady withObj:@(joinedRender.pkData.awayPlayer.hostAccountId)];
            }
            // 惩罚状态
            if (joinedRender.pkData.pkLeftTime <= 0) {
                [self lj_event:LJLiveEventPKReceiveTimeUp withObj:joinedRender.pkData.winner];
                kLJLiveHelper.pkTimeUpEnd = 0;
            } else {
                // 开始计时
                kLJLiveHelper.pkInTimeUp = joinedRender.pkData.pkMaxDuration - joinedRender.pkData.pkLeftTime;
            }
            kLJLiveHelper.pkInEnd = 0;
            LJLiveThinking(LJLiveThinkingEventTypeTimeEvent, LJLiveThinkingEventTimeForOnePk, nil);
        } else {
            self.remoteView.frame = kLJLiveHelper.ui.homeVideoRect;
            self.giftBarrageView.frame = LJFlipedScreenBy(kLJLiveHelper.ui.giftBarrageRect);
            // 更新RTC远端推流幕布大小（放在这儿，因为己方主播逃跑是通过服务器接收，而PK结束和对方逃跑走的是RTM）
            kLJLiveAgoraHelper.videoView.frame = kLJLiveHelper.ui.homeVideoRect;
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
        [self.scrollView lj_flippedSubviewsByRTL];
        // 礼物按钮
        NSData *imageData = [NSData dataWithContentsOfFile:[kLJLiveBundle pathForResource:@"lj_live_gifts" ofType:@"gif"]];
        UIImage *image = [UIImage sd_imageWithGIFData:imageData];
        [self.giftsButton setImage:image forState:UIControlStateNormal];
                
        LJLiveRadioGift.shared.delegate = self;
        [LJLiveRadioGift.shared lj_initRadioGiftViewInView:self.contentView boldFontName:@"HurmeGeometricSans1-Bold"];
    }
}

- (void)setRefreshRender:(LJLiveRoom *)refreshRender
{
    _refreshRender = refreshRender;
    // 刷新数据
    self.room = refreshRender;
    // 刷新UI
    self.containerView.liveRoom = refreshRender;
    // 高斯模糊背景
    kLJWeakSelf;
    [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:refreshRender.roomCover]
                                              options:SDWebImageRefreshCached
                                             progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        UIImage *blureImage = image ?: kLJLiveManager.config.avatar;
        [weakSelf.remoteView.backgroudImageView setImage:blureImage];
    }];
    if (refreshRender.pking) {
        [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:refreshRender.pkData.awayPlayer.roomCover]
                                                  options:SDWebImageRefreshCached
                                                 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            UIImage *blureImage = image ?: kLJLiveManager.config.avatar;
            [weakSelf.pkRemoteView.backgroudImageView setImage:blureImage];
        }];
    }
}

@end
