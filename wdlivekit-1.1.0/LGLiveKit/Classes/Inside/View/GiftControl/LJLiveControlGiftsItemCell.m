//
//  LJLiveControlGiftsItemCell.m
//  Woohoo
//
//  Created by M2-mini on 2021/8/28.
//

#import "LJLiveControlGiftsItemCell.h"

@interface LJLiveControlGiftsItemCell ()


///
///
@property (nonatomic, assign) NSInteger combo;
@property (nonatomic, strong) UILongPressGestureRecognizer *longGes;
@property (weak, nonatomic) IBOutlet UILabel *giftNameLabel;
@end

@implementation LJLiveControlGiftsItemCell

#pragma mark - Life Cycle


#pragma mark - Init




#pragma mark - Setter



- (IBAction)topRightButtonClick:(UIButton *)sender {
    if (self.clickBlindboxDetail) {
        self.clickBlindboxDetail();
    }
}
- (void)setGiftConfig:(LJLiveGift *)giftConfig
{
    _giftConfig = giftConfig;
    
    [self.giftImageView sd_setImageWithURL:[NSURL URLWithString:giftConfig.iconUrl]];
    self.coinsLabel.text = @(giftConfig.giftPrice).stringValue;
    self.giftNameLabel.text = giftConfig.giftName;
    if ([giftConfig.giftName isEqualToString:@"face_manKiss"]) {//特殊改名
        self.giftNameLabel.text = @"True Love's Kiss";
    }
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
        kLJLiveHelper.comboing = 1;
        [self lj_giftFast];
        UIApplication.sharedApplication.delegate.window.userInteractionEnabled = NO;
    }
    if (ges.state == UIGestureRecognizerStateEnded ||
        ges.state == UIGestureRecognizerStateCancelled) {
        kLJLiveHelper.comboing = -1;
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
- (void)lj_setupViews
{
    self.longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTouch:)];
    self.longGes.minimumPressDuration = 0.3;
    [self.contentView addGestureRecognizer:self.longGes];
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self lj_setupViews];
}
- (void)lj_giftFast
{
    if (kLJLiveHelper.comboing == -1) {
        [self.longGes setState:UIGestureRecognizerStateEnded];
        return;
    }
    if (kLJLiveHelper.comboing == 1) {
        if (self.sendGiftBlock) self.sendGiftBlock();
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self lj_giftFast];
        });
    }
}
@end
