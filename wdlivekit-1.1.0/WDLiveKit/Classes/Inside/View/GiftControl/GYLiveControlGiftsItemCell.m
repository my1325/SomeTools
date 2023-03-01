//
//  GYLiveControlGiftsItemCell.m
//  Woohoo
//
//  Created by M2-mini on 2021/8/28.
//

#import "GYLiveControlGiftsItemCell.h"

@interface GYLiveControlGiftsItemCell ()

@property (weak, nonatomic) IBOutlet UILabel *giftNameLabel;
///
@property (nonatomic, assign) NSInteger combo;
///
@property (nonatomic, strong) UILongPressGestureRecognizer *longGes;

@end

@implementation GYLiveControlGiftsItemCell

#pragma mark - Life Cycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self fb_setupViews];
}

#pragma mark - Init

- (void)fb_setupViews
{
    self.longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTouch:)];
    self.longGes.minimumPressDuration = 0.3;
    [self.contentView addGestureRecognizer:self.longGes];
}

- (void)longTouch:(UILongPressGestureRecognizer *)ges
{
    if (self.giftConfig.comboIconUrl.length > 0) {
    } else {
        [ges setState:UIGestureRecognizerStateEnded];
        return;
    }
    if (ges.state == UIGestureRecognizerStateBegan) {
        // 开始触发
        kGYLiveHelper.comboing = 1;
        [self fb_giftFast];
        UIApplication.sharedApplication.delegate.window.userInteractionEnabled = NO;
    }
    if (ges.state == UIGestureRecognizerStateEnded ||
        ges.state == UIGestureRecognizerStateCancelled) {
        kGYLiveHelper.comboing = -1;
        UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
    }
    if (ges.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [ges locationInView:self];
        BOOL b = [self.layer containsPoint:point];
        if (b) {
        } else {
            [ges setState:UIGestureRecognizerStateEnded];
        }
    }
}

- (void)fb_giftFast
{
    if (kGYLiveHelper.comboing == -1) {
        [self.longGes setState:UIGestureRecognizerStateEnded];
        return;
    }
    if (kGYLiveHelper.comboing == 1) {
        if (self.sendGiftBlock) self.sendGiftBlock();
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self fb_giftFast];
        });
    }
}

#pragma mark - Setter

- (void)setGiftConfig:(GYLiveGift *)giftConfig
{
    _giftConfig = giftConfig;
    
    [self.giftImageView sd_setImageWithURL:[NSURL URLWithString:giftConfig.iconUrl]];
    self.coinsLabel.text = @(giftConfig.giftPrice).stringValue;
    self.giftNameLabel.text = giftConfig.giftName;
    if ([giftConfig.giftName isEqualToString:@"face_manKiss"]) {//特殊改名
        self.giftNameLabel.text = @"True Love's Kiss";
    }
}

- (IBAction)topRightButtonClick:(UIButton *)sender {
    if (self.clickBlindboxDetail) {
        self.clickBlindboxDetail();
    }
}

@end
