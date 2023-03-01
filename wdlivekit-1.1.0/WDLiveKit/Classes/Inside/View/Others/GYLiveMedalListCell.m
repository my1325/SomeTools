//
//  GYLiveMedalListCell.m
//  ActionSheetPicker-3.0
//
//  Created by Mimio on 2022/8/16.
//

#import "GYLiveMedalListCell.h"

@interface GYLiveMedalListCell()
@property (nonatomic, strong) UIImageView *medalImage;
@property (nonatomic, strong) UILabel *medalTitle;
@property (nonatomic, strong) UILabel *medalTip;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation GYLiveMedalListCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = kGYHexColor(0xF3F4F7);
        self.contentView.layer.cornerRadius = 15;
        self.contentView.layer.masksToBounds = YES;
        
        _medalImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 21.5, 86, 20)];
        _medalImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_medalImage];
        
        _medalTitle = [[UILabel alloc] initWithFrame:CGRectMake(105.5, 15, kGYScreenWidth - 30 - 105.5 - 15, 16.5)];
        _medalTitle.font = kGYHurmeBoldFont(14);
        _medalTitle.textColor = kGYHexColor(0x080808);
        [self.contentView addSubview:_medalTitle];
        
        _medalTip = [[UILabel alloc] initWithFrame:CGRectMake(105.5, 35.5, kGYScreenWidth - 30 - 105.5 - 15, 12.5)];
        _medalTip.font = kGYHurmeRegularFont(11);
        _medalTip.textColor = kGYHexColor(0x080808);
        [self.contentView addSubview:_medalTip];
        
        UIView *timeBg = [[UIView alloc] initWithFrame:CGRectMake(kGYScreenWidth - 30 - 62, 0, 62, 16)];
        timeBg.backgroundColor = kGYHexColor(0xE6E8EE);
        [timeBg updateCornerRadius:^(QQCorner *corner) {
            corner.radius = kGYLiveManager.inside.appRTL?QQRadiusMake(15, 0, 0, 15):QQRadiusMake(0, 15, 15, 0);
        }];
        [self.contentView addSubview:timeBg];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kGYScreenWidth - 30 - 62, 0, 62, 16)];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = kGYHurmeRegularFont(9);
        _timeLabel.textColor = kGYHexColor(0x838393);
        [self.contentView addSubview:_timeLabel];
        
        if (kGYLiveManager.inside.appRTL) {
            _medalImage.frame = GYFlipedBy(_medalImage.frame, self.contentView.bounds);
            _medalTitle.frame = GYFlipedBy(_medalTitle.frame, self.contentView.bounds);
            _medalTip.frame = GYFlipedBy(_medalTip.frame, self.contentView.bounds);
            timeBg.frame = GYFlipedBy(timeBg.frame, self.contentView.bounds);
            _timeLabel.frame = GYFlipedBy(_timeLabel.frame, self.contentView.bounds);
        }
    }
    return self;
}

- (void)setEventLabel:(GYUniqueTag *)eventLabel{
    [_medalImage sd_setImageWithURL:eventLabel.imageUrl.mj_url];
    _medalTitle.text = eventLabel.title;
    _medalTip.text = eventLabel.desc;
    NSInteger day = eventLabel.timeInterval / 3600 / 24;
    if (day > 3650) {
        _timeLabel.text = kGYLocalString(@"Permanent");
    }else if (day >= 0 && day < 3650) {
        _timeLabel.text = [NSString stringWithFormat:kGYLocalString(@"%ld days"), day];
    }
}

@end
