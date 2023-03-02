//
//  LJLivePkAvatarsView.m
//  Woohoo
//
//  Created by M2-mini on 2021/11/17.
//

#import "LJLivePkAvatarsView.h"

@interface LJLivePkAvatarsView ()




@property (weak, nonatomic) IBOutlet UIImageView *local_no3_iv;
@property (weak, nonatomic) IBOutlet UIImageView *local_no2_iv;
@property (weak, nonatomic) IBOutlet UIImageView *remote_no1_iv;
@property (nonatomic, strong) NSArray *localIVs, *remoteIVs;
@property (weak, nonatomic) IBOutlet UIImageView *remote_no2_iv;
@property (weak, nonatomic) IBOutlet UIImageView *remote_no3_iv;
@property (weak, nonatomic) IBOutlet UIImageView *local_no1_iv;
@end

@implementation LJLivePkAvatarsView

#pragma mark - Life Cycle

+ (LJLivePkAvatarsView *)lj_avatarsView
{
    LJLivePkAvatarsView *view = kLJLoadingXib(@"LJLivePkAvatarsView");
    return view;
}


#pragma mark - Init



#pragma mark - Events



#pragma mark - Public Methods


#pragma mark - Methods


#pragma mark - Setter



- (void)lj_setupViews
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
- (void)lj_setupDataSource
{
    self.localIVs = @[self.local_no1_iv, self.local_no2_iv, self.local_no3_iv];
    self.remoteIVs = @[self.remote_no1_iv, self.remote_no2_iv, self.remote_no3_iv];
}
- (void)lj_event:(LJLiveEvent)event withObj:(NSObject * __nullable )obj
{
    // 开始PK
    if (event == LJLiveEventPKReceiveMatchSuccessed) {
        // 置空
        [self lj_cleanAvatars];
    }
    
    // 收到PK数据，刷新UI显示
    if (event == LJLiveEventPKReceivePointUpdate) {
        // 刷新头像
        LJLivePkPointUpdatedMsg *msg = (LJLivePkPointUpdatedMsg *)obj;
        self.localAvatars = msg.homePoint.topFanAvatars;
        self.remoteAvatars = msg.awayPoint.topFanAvatars;
    }
}
- (void)setRemoteAvatars:(NSArray *)remoteAvatars
{
    _remoteAvatars = remoteAvatars;
    
    for (int i = 0; i < remoteAvatars.count; i++) {
        UIImageView *iv = self.remoteIVs[i];
        NSString *imageUrl = remoteAvatars[i];
        [iv sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:kLJLiveManager.config.avatar];
    }
}
- (IBAction)localAvatarsClick:(UIButton *)sender
{
    if (self.eventBlock) self.eventBlock(LJLiveEventPKOpenHomeRank, nil);
}
- (IBAction)remoteAvatarsClick:(UIButton *)sender
{
    if (self.eventBlock) self.eventBlock(LJLiveEventPKOpenAwayRank, nil);
}
- (void)lj_cleanAvatars
{
    for (UIImageView *iv in self.localIVs) {
        [iv setImage:kLJImageNamed(@"lj_live_pk_rank_red_head")];
    }
    for (UIImageView *iv in self.remoteIVs) {
        [iv setImage:kLJImageNamed(@"lj_live_pk_rank_blue_head")];
    }
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self lj_setupDataSource];
    [self lj_setupViews];
}
- (void)setLocalAvatars:(NSArray *)localAvatars
{
    _localAvatars = localAvatars;
    
    for (int i = 0; i < localAvatars.count; i++) {
        UIImageView *iv = self.localIVs[i];
        NSString *imageUrl = localAvatars[i];
        [iv sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:kLJLiveManager.config.avatar];
    }
}
@end
