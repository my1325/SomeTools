//
//  GYLiveSideBannerView.m
//  WDLiveKit
//
//  Created by Mimio on 2022/9/22.
//

#import "GYLiveSideBannerView.h"
#import "GYLiveAlertWebView.h"

@interface GYLiveSideBannerView()
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) UIView *bgView;
@end

@implementation GYLiveSideBannerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 0, kGYScreenWidth, kGYScreenHeight);
        [self fb_creatUI];
    }
    return self;
}

- (void)fb_showInView:(UIView *)inView{

    for (UIView *subview in inView.subviews) {
        if ([subview isKindOfClass:[self class]]) {
            return;
        }
    }
    [inView addSubview:self];
    
    UIView *subScroll = (UIView *)(self.superview);
    UIView *cell = (UIView *)subScroll.superview;
    UIScrollView *scroll = (UIScrollView *)cell.superview;
    scroll.scrollEnabled = NO;
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgView.x = kGYLiveManager.inside.appRTL?0:kGYScreenWidth - 100;
        
    } completion:^(BOOL finished) {}];
}
- (void)fb_dismiss{
    UIView *subScroll = (UIView *)(self.superview);
    UIView *cell = (UIView *)subScroll.superview;
    UIScrollView *scroll = (UIScrollView *)cell.superview;
    scroll.scrollEnabled = YES;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.bgView.x = kGYLiveManager.inside.appRTL?-100:kGYScreenWidth;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

#pragma mark - UI
-(void)fb_creatUI{
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:self.bounds];
    [self addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(fb_dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(kGYLiveManager.inside.appRTL?-kGYScreenWidth:kGYScreenWidth , 0, 100 , kGYScreenHeight)];
    _bgView.backgroundColor = kGYColorFromRGBA(0x000000, 0.7);
    [self addSubview:_bgView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, kGYStatusBarHeight + 7, 100, 18)];
    titleLab.text = kGYLocalString(@"More Events");
    titleLab.textColor = UIColor.whiteColor;
    titleLab.font = kGYHurmeBoldFont(12);
    titleLab.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:titleLab];

    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kGYStatusBarHeight + 31, 100, kGYScreenHeight - kGYStatusBarHeight - 31)];
    _scroll.contentSize = CGSizeMake(100, 12 + 95*kGYLiveManager.inside.accountConfig.voiceChatRoomBannerInfoList.count);
    [_bgView addSubview:_scroll];
    
    NSArray *bannerArr = kGYLiveManager.inside.accountConfig.voiceChatRoomBannerInfoList;
    for (int i = 0;i < bannerArr.count; i++) {
        GYBannerInfo *banner = [GYBannerInfo mj_objectWithKeyValues:bannerArr[i]];
        UIButton *imageBtn = [[UIButton alloc] initWithFrame:CGRectMake(7.5, 6 + 95*i, 85, 97)];
        imageBtn.tag = 100 + i;
        [imageBtn sd_setBackgroundImageWithURL:banner.imgAddr.mj_url forState:UIControlStateNormal];
        [_scroll addSubview:imageBtn];
        [imageBtn addTarget:self action:@selector(fb_itemClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)fb_itemClick:(UIButton *)imageBtn
{
    NSInteger index = imageBtn.tag - 100;
    NSArray *bannerArr = kGYLiveManager.inside.accountConfig.voiceChatRoomBannerInfoList;
    
    GYLiveThinking(GYLiveThinkingEventTypeEvent, GYLiveThinkingEventClickBannerInLiveMultibeam, nil);
    /// 1:普通跳转 2：内购活动 3:申请主播 4:做积分墙任务的金币 5:老用户充值活动 6:新星榜 7:进入详情 8:三周年活动
    GYBannerInfo *bannerInfo = bannerArr[index];
    switch (bannerInfo.type) {
        case 1:
        {
            /// 普通跳转（打开网页）
            GYLiveAlertWebView *view = [GYLiveAlertWebView activityPopView];
            view.reloadURL = bannerInfo.redirectAddr;
            [view showInView:[GYLiveMethods fb_currentViewController].view];
        }
            break;
        case 6:
        {
            /// 新星榜
            NSMutableDictionary *dic = [@{
                @"session": kGYLiveManager.inside.session,
                @"type": @(1).stringValue
            } mutableCopy];
            
#ifdef DEBUG
            if (kGYLiveManager.config.isTestServer) [dic setValue:@"develop" forKey:@"env"];
#endif
            
            NSString *str = [bannerInfo.redirectAddr fb_addressURLAppendingByArg:dic];
             /// 普通跳转（打开网页）
            GYLiveAlertWebView *view = [GYLiveAlertWebView activityPopView];
            view.reloadURL = str;
            [view showInView:[GYLiveMethods fb_currentViewController].view];
        }
            break;
        case 7:
        {
            /// 进入详情
            GYLiveAccount *a = [[GYLiveAccount alloc] init];
            a.accountId = bannerInfo.extraData.integerValue;
            [kGYLiveManager.delegate fb_jumpDetailWithRoleType:GYLiveRoleTypeAnchor account:a];
        }
            break;
        case 8:
        {
            /// 三周年活动
            NSMutableDictionary *dic = [@{
                @"session": kGYLiveManager.inside.session,
                @"type": @(1).stringValue,
                @"display":kGYLiveManager.inside.account.displayAccountId
            } mutableCopy];
            
#ifdef DEBUG
            if (kGYLiveManager.config.isTestServer) [dic setValue:@"develop" forKey:@"env"];
#endif
            
            NSString *absoluteStr = bannerInfo.redirectAddr;
            NSString *tempUrl = [absoluteStr fb_addressURLAppendingByArg:dic];
             /// 普通跳转（打开网页）
            GYLiveAlertWebView *view = [GYLiveAlertWebView activityPopView];
            view.reloadURL = tempUrl;
            [view showInView:[GYLiveMethods fb_currentViewController].view];
        }
            break;
            
        default:
            break;
    }
}

@end
