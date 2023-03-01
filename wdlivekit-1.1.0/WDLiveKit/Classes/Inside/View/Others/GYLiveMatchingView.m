//
//  GYLiveMatchingView.m
//  Woohoo
//
//  Created by M2-mini on 2021/9/1.
//

#import "GYLiveMatchingView.h"

@interface GYLiveMatchingView () <SVGAPlayerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *successLabelCenterY;

@property (nonatomic, copy) GYLiveVoidBlock dismissBlock;

@property (nonatomic, strong) SVGAPlayer *matchingPlayer, *countdownPlayer;

@property (nonatomic, strong) SVGAParser *svgaParser;

@property (nonatomic, assign) BOOL countdownEnable;

@end

@implementation GYLiveMatchingView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self fb_setupViews];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self fb_setupViews];
}

#pragma mark - Init

- (void)fb_setupViews
{
    [self addSubview:self.matchingPlayer];
    [self addSubview:self.countdownPlayer];
    self.countdownPlayer.hidden = YES;
}

#pragma mark - Methods

- (void)fb_svgaAddText:(NSString *)text forKey:(NSString *)key alignment:(NSTextAlignment)alignment
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = alignment;
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:text attributes:@{
        NSFontAttributeName: kGYHurmeBoldFont(40),
        NSForegroundColorAttributeName: UIColor.whiteColor,
        NSParagraphStyleAttributeName: style
    }];
    [self.matchingPlayer setAttributedText:attText forKey:key];
}

- (void)fb_playSvgaWithFilename:(NSString *)svga player:(SVGAPlayer *)player
{
    [self.svgaParser parseWithNamed:svga inBundle:kGYLiveBundle completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
        if (videoItem != nil) {
            player.videoItem = videoItem;
            [player startAnimation];
        }
    } failureBlock:^(NSError * _Nonnull error) {
    }];
}

#pragma mark - SVGAPlayerDelegate

- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player
{
    if (self.countdownEnable) {
        // 上一个动画之后
        self.matchingPlayer.hidden = YES;
        self.countdownPlayer.hidden = NO;
        // 配对倒计时
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self fb_playSvgaWithFilename:@"fb_live_countdown" player:self.countdownPlayer];
        });
        // 执行dismiss
        self.countdownEnable = NO;
    } else {
        [self fb_dismiss];
    }
}

#pragma mark - Methods

- (void)fb_dismiss
{
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
        if (self.dismissBlock) self.dismissBlock();
    });
}

- (void)fb_matchingSuccessed:(UIView *)inView
                anchorAvatar:(NSString *)anchorAvatar
                  anchorName:(NSString *)anchorName
                  userAvatar:(NSString *)userAvatar
                    userName:(NSString *)userName
            withDelayDismiss:(GYLiveVoidBlock)dismissBlock
{
    self.dismissBlock = dismissBlock;
    [inView addSubview:self];
    // 插入数据
    [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:anchorAvatar] options:SDWebImageAvoidDecodeImage progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        UIImage *avatar;
        if (image) {
            avatar = [[image imageByResizeToSize:CGSizeMake(124, 124) contentMode:UIViewContentModeScaleAspectFill] imageByAddingCornerRadius:QQRadiusMakeSame(124/2)];
        } else {
            avatar = [[kGYLiveManager.config.avatar imageByResizeToSize:CGSizeMake(124, 124) contentMode:UIViewContentModeScaleAspectFill] imageByAddingCornerRadius:QQRadiusMakeSame(124/2)];
        }
        if (avatar) [self.matchingPlayer setImage:avatar forKey:@"Avatar_girl"];
    }];
    [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:userAvatar] options:SDWebImageAvoidDecodeImage progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        UIImage *avatar;
        if (image) {
            avatar = [[image imageByResizeToSize:CGSizeMake(124, 124) contentMode:UIViewContentModeScaleAspectFill] imageByAddingCornerRadius:QQRadiusMakeSame(124/2)];
        } else {
            avatar = [[kGYLiveManager.config.avatar imageByResizeToSize:CGSizeMake(124, 124) contentMode:UIViewContentModeScaleAspectFill] imageByAddingCornerRadius:QQRadiusMakeSame(124/2)];
        }
        if (avatar) [self.matchingPlayer setImage:avatar forKey:@"Avatar_boy"];
    }];
    [self fb_svgaAddText:anchorName forKey:@"id_girl" alignment:NSTextAlignmentRight];
    [self fb_svgaAddText:userName forKey:@"id_boy" alignment:NSTextAlignmentLeft];
    // 播放svg
    [self fb_playSvgaWithFilename:@"fb_live_pair" player:self.matchingPlayer];
    // 不执行倒计时
    self.countdownEnable = NO;
}

- (void)fb_matchingCountdown:(UIView *)inView
                anchorAvatar:(NSString *)anchorAvatar
                  anchorName:(NSString *)anchorName
                  userAvatar:(NSString *)userAvatar
                    userName:(NSString *)userName
            withDelayDismiss:(GYLiveVoidBlock)dismissBlock
{
    [self fb_matchingSuccessed:inView
                  anchorAvatar:anchorAvatar
                    anchorName:anchorName
                    userAvatar:userAvatar
                      userName:userName
              withDelayDismiss:dismissBlock];
    // 执行倒计时
    self.countdownEnable = YES;
}

#pragma mark - Getter

- (SVGAPlayer *)matchingPlayer
{
    if (!_matchingPlayer) {
        _matchingPlayer = [[SVGAPlayer alloc] initWithFrame:kGYScreenBounds];
        _matchingPlayer.delegate = self;
        _matchingPlayer.loops = 1;
        _matchingPlayer.clearsAfterStop = YES;
        _matchingPlayer.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _matchingPlayer;
}

- (SVGAPlayer *)countdownPlayer
{
    if (!_countdownPlayer) {
        _countdownPlayer = [[SVGAPlayer alloc] initWithFrame:kGYScreenBounds];
        _countdownPlayer.delegate = self;
        _countdownPlayer.loops = 1;
        _countdownPlayer.clearsAfterStop = YES;
        _countdownPlayer.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _countdownPlayer;
}

- (SVGAParser *)svgaParser
{
    if (!_svgaParser) {
        _svgaParser = [[SVGAParser alloc] init];
    }
    return _svgaParser;
}

@end
