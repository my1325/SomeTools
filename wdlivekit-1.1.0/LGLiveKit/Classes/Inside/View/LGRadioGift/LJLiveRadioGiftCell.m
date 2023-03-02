//
//  LJRadioGiftView.m
//  wdLive
//
//  Created by Mimio on 2022/6/21.
//  Copyright © 2022 Mimio. All rights reserved.
//

#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define StatusH (IPHONE_X ? 44.f : 20.f)
#define KSW     [UIScreen mainScreen].bounds.size.width

#import "LJLiveRadioGiftCell.h"
#import "LJLiveRadioMarqueeView.h"
#import <SDWebImage/SDWebImage.h>
@interface LJLiveRadioGiftCell()<LJMarqueeViewDelegate>
@property (nonatomic, strong) LJLiveRadioMarqueeView *crosswiseMarquee;
@end
@implementation LJLiveRadioGiftCell



#pragma mark - KVO


#pragma mark - 跑马灯代理



#pragma mark 横向滚动时执行



- (CGFloat)itemViewWidthAtIndex:(NSUInteger)index forMarqueeView:(LJLiveRadioMarqueeView*)marqueeView {
    return 100 + [_model.senderName sizeWithFont:[UIFont boldSystemFontOfSize:15] forWidth:MAXFLOAT lineBreakMode:NSLineBreakByWordWrapping].width + [_model.recieverName sizeWithFont:[UIFont boldSystemFontOfSize:15] forWidth:MAXFLOAT lineBreakMode:NSLineBreakByWordWrapping].width;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 367, 48.5)];
        bgImg.image = [UIImage imageNamed:@"lj_radio_gift_bg" inBundle:[NSBundle bundleForClass:[LJLiveRadioGiftCell class]] compatibleWithTraitCollection:nil];
        [self addSubview:bgImg];
        
        self.state = LJLiveRadioGiftCellStateWait;
        [self addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        
    }
    return self;
}
- (void)setModel:(LJLiveRadioGiftModel *)model{
    _model = model;
    self.crosswiseMarquee = [[LJLiveRadioMarqueeView alloc] initWithFrame:CGRectMake(70, 0, 227, 48.5) direction:LJMarqueeViewDirectionLeftward];
    self.crosswiseMarquee.delegate = self;
    self.crosswiseMarquee.userInteractionEnabled = NO;
    self.crosswiseMarquee.timeIntervalPerScroll = 0.0f;
    self.crosswiseMarquee.scrollSpeed = 50.0f;
    self.crosswiseMarquee.itemSpacing = 100.0f;
    [self.crosswiseMarquee reloadData];
    [self addSubview:self.crosswiseMarquee];
    [self.crosswiseMarquee pause];
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (self.state == LJLiveRadioGiftCellStateEnter) {
        
        [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect frame = self.frame;
            frame.origin.x = (KSW - 367)/2.0;
            self.frame = frame;
        } completion:^(BOOL finished) {
            self.state = LJLiveRadioGiftCellStateShow;
    
            if ([[NSString stringWithFormat:@"\u202A%@ Send a         to %@",_model.senderName,_model.recieverName] sizeWithFont:[UIFont fontWithName:LJLiveRadioGift.shared.boldFontName size:15] forWidth:MAXFLOAT lineBreakMode:NSLineBreakByWordWrapping].width > 227) {
                [self.crosswiseMarquee start];
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.state == LJLiveRadioGiftCellStateShow) {
                    self.state = LJLiveRadioGiftCellStateExit;
                    LJLiveRadioGift.shared.radioGiftView.userInteractionEnabled = NO;
                }
            });
        }];
    }else if(self.state == LJLiveRadioGiftCellStateExit){
        [self.crosswiseMarquee pause];
        
        [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect frame = self.frame;
            frame.origin.x = -KSW;
            self.frame = frame;
        } completion:^(BOOL finished) {
            
            self.crosswiseMarquee = nil;
            if([self hasKey:@"state"]){
                NSLog(@"正常移除");
                [self removeObserver:self forKeyPath:@"state"];
            }else{
                NSLog(@"错误移除");
            }
            [self removeFromSuperview];
        }];
    }
    
}
- (void)updateItemView:(UIView *)itemView atIndex:(NSUInteger)index forMarqueeView:(LJLiveRadioMarqueeView *)marqueeView{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\u202A%@ Send a         to %@",_model.senderName,_model.recieverName]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:229/255.0 green:92/255.0 blue:255/255.0 alpha:1] range:[attributedString.string rangeOfString:_model.senderName]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:229/255.0 green:92/255.0 blue:255/255.0 alpha:1] range:[attributedString.string rangeOfString:_model.recieverName]];
    
    UILabel *contentLab = [itemView viewWithTag:1001];
    contentLab.userInteractionEnabled = NO;
    contentLab.attributedText = attributedString;
    CGRect frame = contentLab.frame;
    frame.size.width = [contentLab.text sizeWithFont:contentLab.font forWidth:MAXFLOAT lineBreakMode:NSLineBreakByWordWrapping].width;
    contentLab.frame = frame;
    if (contentLab.frame.size.width<227) {
        CGRect frame = contentLab.frame;
        frame.origin.x = (227 - contentLab.frame.size.width)/2;
        contentLab.frame = frame;

        [self.crosswiseMarquee pause];
    }

    float senderNameWidth = [_model.senderName sizeWithFont:contentLab.font forWidth:MAXFLOAT lineBreakMode:NSLineBreakByWordWrapping].width;

    UIImageView *giftImage = [itemView viewWithTag:1003];
    CGRect frame2 = giftImage.frame;
    frame2.origin.x = contentLab.frame.origin.x + senderNameWidth + [@" Send a " sizeWithFont:contentLab.font forWidth:MAXFLOAT lineBreakMode:NSLineBreakByWordWrapping].width;
    giftImage.frame = frame2;
    
    [giftImage sd_setImageWithURL:[NSURL URLWithString:_model.giftIconUrl] placeholderImage:[UIImage imageNamed:@"lj_radio_gift_default" inBundle:[NSBundle bundleForClass:[LJLiveRadioGiftCell class]] compatibleWithTraitCollection:nil] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
}
- (void)createItemView:(UIView *)itemView forMarqueeView:(LJLiveRadioMarqueeView *)marqueeView{

    UILabel *contentLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 227, 48)];
    contentLab.font = [UIFont fontWithName:LJLiveRadioGift.shared.boldFontName size:15];
    contentLab.textColor = [UIColor colorWithRed:122/255.0 green:79/255.0 blue:233/255.0 alpha:1];
    contentLab.tag = 1001;
    [itemView addSubview:contentLab];
    
    UIImageView *giftImage = [[UIImageView alloc] initWithFrame:CGRectMake(150, 12, 25, 25)];
    giftImage.tag = 1003;
    [itemView addSubview:giftImage];
}
- (BOOL)hasKey:(NSString *)kvoKey {
    BOOL hasKey = NO;
    id info = self.observationInfo;
    NSArray *arr = [info valueForKeyPath:@"_observances._property._keyPath"];
    for (id keypath in arr) {
        // 存在kvo 的key
        if ([keypath isEqualToString:kvoKey]) {
            hasKey = YES;
            break;
        }
    }
    return hasKey;
}
- (NSUInteger)numberOfDataForMarqueeView:(LJLiveRadioMarqueeView *)marqueeView {
    return 1;
}
@end
