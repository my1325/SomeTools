//
//  GYLivePkAvatarsView.m
//  Woohoo
//
//  Created by M2-mini on 2021/11/17.
//

#import "GYLivePkAvatarsView.h"

@interface GYLivePkAvatarsView ()

@property (weak, nonatomic) IBOutlet UIImageView *local_no3_iv;
@property (weak, nonatomic) IBOutlet UIImageView *local_no2_iv;
@property (weak, nonatomic) IBOutlet UIImageView *local_no1_iv;

@property (weak, nonatomic) IBOutlet UIImageView *remote_no1_iv;
@property (weak, nonatomic) IBOutlet UIImageView *remote_no2_iv;
@property (weak, nonatomic) IBOutlet UIImageView *remote_no3_iv;

@property (nonatomic, strong) NSArray *localIVs, *remoteIVs;

@end

@implementation GYLivePkAvatarsView

#pragma mark - Life Cycle

+ (GYLivePkAvatarsView *)fb_avatarsView
{
    GYLivePkAvatarsView *view = kGYLoadingXib(@"GYLivePkAvatarsView");
    return view;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self fb_setupDataSource];
    [self fb_setupViews];
}

#pragma mark - Init

- (void)fb_setupDataSource
{
    self.localIVs = @[self.local_no1_iv, self.local_no2_iv, self.local_no3_iv];
    self.remoteIVs = @[self.remote_no1_iv, self.remote_no2_iv, self.remote_no3_iv];
}

- (void)fb_setupViews
{
    self.local_no1_iv.layer.masksToBounds = YES;
    self.local_no1_iv.layer.cornerRadius = 12;
    self.local_no2_iv.layer.masksToBounds = YES;
    self.local_no2_iv.layer.cornerRadius = 12;
    self.local_no3_iv.layer.masksToBounds = YES;
    self.local_no3_iv.layer.cornerRadius = 12;
    self.remote_no1_iv.layer.masksToBounds = YES;
    self.remote_no1_iv.layer.cornerRadius = 12;
    self.remote_no2_iv.layer.masksToBounds = YES;
    self.remote_no2_iv.layer.cornerRadius = 12;
    self.remote_no3_iv.layer.masksToBounds = YES;
    self.remote_no3_iv.layer.cornerRadius = 12;
    
    self.local_no1_iv.contentMode = UIViewContentModeScaleAspectFill;
    self.local_no2_iv.contentMode = UIViewContentModeScaleAspectFill;
    self.local_no3_iv.contentMode = UIViewContentModeScaleAspectFill;
    self.remote_no1_iv.contentMode = UIViewContentModeScaleAspectFill;
    self.remote_no2_iv.contentMode = UIViewContentModeScaleAspectFill;
    self.remote_no3_iv.contentMode = UIViewContentModeScaleAspectFill;
}

#pragma mark - Events

- (IBAction)localAvatarsClick:(UIButton *)sender
{
    if (self.eventBlock) self.eventBlock(GYLiveEventPKOpenHomeRank, nil);
}

- (IBAction)remoteAvatarsClick:(UIButton *)sender
{
    if (self.eventBlock) self.eventBlock(GYLiveEventPKOpenAwayRank, nil);
}

#pragma mark - Public Methods

- (void)fb_event:(GYLiveEvent)event withObj:(NSObject * __nullable )obj
{
    // 开始PK
    if (event == GYLiveEventPKReceiveMatchSuccessed) {
        // 置空
        [self fb_cleanAvatars];
    }
    
    // 收到PK数据，刷新UI显示
    if (event == GYLiveEventPKReceivePointUpdate) {
        // 刷新头像
        GYLivePkPointUpdatedMsg *msg = (GYLivePkPointUpdatedMsg *)obj;
        self.localAvatars = msg.homePoint.topFanAvatars;
        self.remoteAvatars = msg.awayPoint.topFanAvatars;
    }
}

#pragma mark - Methods

- (void)fb_cleanAvatars
{
    for (UIImageView *iv in self.localIVs) {
        [iv setImage:kGYImageNamed(@"fb_live_pk_rank_red_head")];
    }
    for (UIImageView *iv in self.remoteIVs) {
        [iv setImage:kGYImageNamed(@"fb_live_pk_rank_blue_head")];
    }
}

#pragma mark - Setter

- (void)setLocalAvatars:(NSArray *)localAvatars
{
    _localAvatars = localAvatars;
    
    for (int i = 0; i < localAvatars.count; i++) {
        UIImageView *iv = self.localIVs[i];
        NSString *imageUrl = localAvatars[i];
        [iv sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:kGYLiveManager.config.avatar];
    }
}

- (void)setRemoteAvatars:(NSArray *)remoteAvatars
{
    _remoteAvatars = remoteAvatars;
    
    for (int i = 0; i < remoteAvatars.count; i++) {
        UIImageView *iv = self.remoteIVs[i];
        NSString *imageUrl = remoteAvatars[i];
        [iv sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:kGYLiveManager.config.avatar];
    }
}

@end
