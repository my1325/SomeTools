//
//  LJLivePkProgressView.m
//  Woohoo
//
//  Created by M2-mini on 2021/11/17.
//

#import "LJLivePkProgressView.h"

@interface LJLivePkProgressView ()

@property (nonatomic, strong) UIImageView *localImageView, *remoteImageView;

@property (nonatomic, strong) UILabel *localProgressLabel, *remoteProgressLabel;

@property (nonatomic, strong) UIImageView *shiningView;

@property (nonatomic, assign) CGFloat homeProgress;

@end

@implementation LJLivePkProgressView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self lj_setupDataSource];
        [self lj_setupViews];
    }
    return self;
}

#pragma mark - Init

- (void)lj_setupDataSource
{
    
}

- (void)lj_setupViews
{
    [self addSubview:self.localImageView];
    [self addSubview:self.remoteImageView];
    [self addSubview:self.localProgressLabel];
    [self addSubview:self.remoteProgressLabel];
    [self addSubview:self.shiningView];
    //
    self.homePoint = 0;
    self.awayPoint = 0;
}

#pragma mark - Public Methods

- (void)lj_event:(LJLiveEvent)event withObj:(NSObject * __nullable )obj
{
    // PK匹配成功
    if (event == LJLiveEventPKReceiveMatchSuccessed) {
        self.homePoint = 0;
        self.awayPoint = 0;
        // 进度条gif
        NSString *flagUrl = kLJLiveManager.inside.accountConfig.liveConfig.pkScoreFlagUrl;
        if (flagUrl.length != 0) {
            [self.shiningView sd_setImageWithURL:[NSURL URLWithString:flagUrl]];
        } else {
            [self.shiningView sd_setImageWithURL:[NSURL fileURLWithPath:[kLJLiveBundle pathForResource:@"lj_live_pk_shining" ofType:@"gif"]]];
        }
    }
    
    // 分数更新
    if (event == LJLiveEventPKReceivePointUpdate) {
        //
        LJLivePkPointUpdatedMsg *msg = (LJLivePkPointUpdatedMsg *)obj;
        self.homePoint = msg.homePoint.points;
        self.awayPoint = msg.awayPoint.points;
    }
}

#pragma mark - Getter

- (UIImageView *)localImageView
{
    if (!_localImageView) {
        _localImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kLJScreenWidth/2, 16)];
        _localImageView.contentMode = UIViewContentModeScaleToFill;
        //
        UIImage *local = [UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
            graColor.fromColor = kLJHexColor(0xFF5DAD);
            graColor.toColor = kLJHexColor(0xFC8EA4);
            graColor.type = QQGradualChangeTypeLeftToRight;
        } size:CGSizeMake(kLJScreenWidth/2, 16) cornerRadius:QQRadiusZero];
        
        [_localImageView setImage:local];
    }
    return _localImageView;
}

- (UIImageView *)remoteImageView
{
    if (!_remoteImageView) {
        _remoteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kLJScreenWidth/2, 0, kLJScreenWidth/2, 16)];
        _remoteImageView.contentMode = UIViewContentModeScaleToFill;
        //
        UIImage *remote = [UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
            graColor.fromColor = kLJHexColor(0x67BDFF);
            graColor.toColor = kLJHexColor(0x5DB8FF);
            graColor.type = QQGradualChangeTypeLeftToRight;
        } size:CGSizeMake(kLJScreenWidth/2, 16) cornerRadius:QQRadiusZero];
        
        [_remoteImageView setImage:remote];
    }
    return _remoteImageView;
}

- (UILabel *)localProgressLabel
{
    if (!_localProgressLabel) {
        _localProgressLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLJWidthScale(15), 0, kLJScreenWidth/2 - kLJWidthScale(30), 16)];
        _localProgressLabel.font = kLJHurmeBoldFont(12);
        _localProgressLabel.textColor = kLJHexColor(0x8E0341);
        _localProgressLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _localProgressLabel;
}

- (UILabel *)remoteProgressLabel
{
    if (!_remoteProgressLabel) {
        _remoteProgressLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLJScreenWidth/2 + kLJWidthScale(15), 0, kLJScreenWidth/2 - kLJWidthScale(30), 16)];
        _remoteProgressLabel.font = kLJHurmeBoldFont(12);
        _remoteProgressLabel.textColor = kLJHexColor(0x034792);
        _remoteProgressLabel.textAlignment = NSTextAlignmentRight;
    }
    return _remoteProgressLabel;
}

- (UIImageView *)shiningView
{
    if (!_shiningView) {
        _shiningView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40 * 20/16, 20)];
        _shiningView.contentMode = UIViewContentModeScaleAspectFill;
        _shiningView.center = CGPointMake(self.width/2, self.height/2);
    }
    return _shiningView;
}

#pragma mark - Setter

- (void)setHomeProgress:(CGFloat)homeProgress
{
    _homeProgress = homeProgress;
    //
    CGFloat localWidth = kLJScreenWidth * homeProgress;
    localWidth = MAX(kLJWidthScale(38), MIN(localWidth, kLJScreenWidth - kLJWidthScale(38)));
    //
    self.localImageView.width = localWidth;
    //
    self.remoteImageView.x = localWidth;
    self.remoteImageView.width = kLJScreenWidth - localWidth;
    self.shiningView.centerX = localWidth;
}

- (void)setHomePoint:(NSInteger)homePoint
{
    _homePoint = homePoint;
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentLeft;
    NSAttributedString *attText = [[NSAttributedString alloc] initWithString:@(MAX(homePoint, 0)).stringValue attributes:@{
        NSFontAttributeName: kLJHurmeBoldFont(12),
        NSForegroundColorAttributeName: kLJHexColor(0x8E0341),
        NSParagraphStyleAttributeName: paraStyle
    }];
    self.localProgressLabel.attributedText = attText;
    //
    NSInteger total = self.awayPoint + homePoint;
    CGFloat progress = 0.5;
    if (total != 0) progress = (float)homePoint/total;
    if (progress != self.homeProgress) self.homeProgress = progress;
}

- (void)setAwayPoint:(NSInteger)awayPoint
{
    _awayPoint = awayPoint;
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentRight;
    NSAttributedString *attText = [[NSAttributedString alloc] initWithString:@(MAX(awayPoint, 0)).stringValue attributes:@{
        NSFontAttributeName: kLJHurmeBoldFont(12),
        NSForegroundColorAttributeName: kLJHexColor(0x034792),
        NSParagraphStyleAttributeName: paraStyle
    }];
    self.remoteProgressLabel.attributedText = attText;
    //
    NSInteger total = awayPoint + self.homePoint;
    CGFloat progress = 0.5;
    if (total != 0) progress = (float)(total - awayPoint)/total;
    if (progress != self.homeProgress) self.homeProgress = progress;
}

@end
