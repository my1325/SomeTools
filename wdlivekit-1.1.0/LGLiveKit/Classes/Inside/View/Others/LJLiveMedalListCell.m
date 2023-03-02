//
//  LJLiveMedalListCell.m
//  ActionSheetPicker-3.0
//
//  Created by Mimio on 2022/8/16.
//

#import "LJLiveMedalListCell.h"

@interface LJLiveMedalListCell()
@property (nonatomic, strong) UIImageView *medalImage;
@property (nonatomic, strong) UILabel *medalTitle;
@property (nonatomic, strong) UILabel *medalTip;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation LJLiveMedalListCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = kLJHexColor(0xF3F4F7);
        self.contentView.layer.cornerRadius = 15;
        self.contentView.layer.masksToBounds = YES;
        
        _medalImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 21.5, 86, 20)];
        _medalImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_medalImage];
        
        _medalTitle = [[UILabel alloc] initWithFrame:CGRectMake(105.5, 15, kLJScreenWidth - 30 - 105.5 - 15, 16.5)];
        _medalTitle.font = kLJHurmeBoldFont(14);
        _medalTitle.textColor = kLJHexColor(0x080808);
        [self.contentView addSubview:_medalTitle];
        
        _medalTip = [[UILabel alloc] initWithFrame:CGRectMake(105.5, 35.5, kLJScreenWidth - 30 - 105.5 - 15, 12.5)];
        _medalTip.font = kLJHurmeRegularFont(11);
        _medalTip.textColor = kLJHexColor(0x080808);
        [self.contentView addSubview:_medalTip];
        
        UIView *timeBg = [[UIView alloc] initWithFrame:CGRectMake(kLJScreenWidth - 30 - 62, 0, 62, 16)];
        timeBg.backgroundColor = kLJHexColor(0xE6E8EE);
        [timeBg updateCornerRadius:^(QQCorner *corner) {
            corner.radius = kLJLiveManager.inside.appRTL?QQRadiusMake(15, 0, 0, 15):QQRadiusMake(0, 15, 15, 0);
        }];
        [self.contentView addSubview:timeBg];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLJScreenWidth - 30 - 62, 0, 62, 16)];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = kLJHurmeRegularFont(9);
        _timeLabel.textColor = kLJHexColor(0x838393);
        [self.contentView addSubview:_timeLabel];
        
        if (kLJLiveManager.inside.appRTL) {
            _medalImage.frame = LJFlipedBy(_medalImage.frame, self.contentView.bounds);
            _medalTitle.frame = LJFlipedBy(_medalTitle.frame, self.contentView.bounds);
            _medalTip.frame = LJFlipedBy(_medalTip.frame, self.contentView.bounds);
            timeBg.frame = LJFlipedBy(timeBg.frame, self.contentView.bounds);
            _timeLabel.frame = LJFlipedBy(_timeLabel.frame, self.contentView.bounds);
        }
    }
    return self;
}

- (void)setEventLabel:(LJUniqueTag *)eventLabel{
    [_medalImage sd_setImageWithURL:eventLabel.imageUrl.mj_url];
    _medalTitle.text = eventLabel.title;
    _medalTip.text = eventLabel.desc;
    NSInteger day = eventLabel.timeInterval / 3600 / 24;
    if (day > 3650) {
        _timeLabel.text = kLJLocalString(@"Permanent");
    }else if (day >= 0 && day < 3650) {
        _timeLabel.text = [NSString stringWithFormat:kLJLocalString(@"%ld days"), day];
    }
}

@end
