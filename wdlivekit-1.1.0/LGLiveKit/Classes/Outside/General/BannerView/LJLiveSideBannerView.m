//
//  LJLiveSideBannerView.m
//  LGLiveKit
//
//  Created by Mimio on 2022/9/22.
//

#import "LJLiveSideBannerView.h"
#import "LJLiveAlertWebView.h"

@interface LJLiveSideBannerView()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIScrollView *scroll;
@end

@implementation LJLiveSideBannerView



#pragma mark - UI


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 0, kLJScreenWidth, kLJScreenHeight);
        [self lj_creatUI];
    }
    return self;
}
- (void)lj_showInView:(UIView *)inView{

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
        self.bgView.x = kLJLiveManager.inside.appRTL?0:kLJScreenWidth - 100;
        
    } completion:^(BOOL finished) {}];
}
-(void)lj_creatUI{
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:self.bounds];
    [self addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(lj_dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(kLJLiveManager.inside.appRTL?-kLJScreenWidth:kLJScreenWidth , 0, 100 , kLJScreenHeight)];
    _bgView.backgroundColor = kLJColorFromRGBA(0x000000, 0.7);
    [self addSubview:_bgView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, kLJStatusBarHeight + 7, 100, 18)];
    titleLab.text = kLJLocalString(@"More Events");
    titleLab.textColor = UIColor.whiteColor;
    titleLab.font = kLJHurmeBoldFont(12);
    titleLab.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:titleLab];

    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kLJStatusBarHeight + 31, 100, kLJScreenHeight - kLJStatusBarHeight - 31)];
    _scroll.contentSize = CGSizeMake(100, 12 + 95*kLJLiveManager.inside.accountConfig.voiceChatRoomBannerInfoList.count);
    [_bgView addSubview:_scroll];
    
    NSArray *bannerArr = kLJLiveManager.inside.accountConfig.voiceChatRoomBannerInfoList;
    for (int i = 0;i < bannerArr.count; i++) {
        LJBannerInfo *banner = [LJBannerInfo mj_objectWithKeyValues:bannerArr[i]];
        UIButton *imageBtn = [[UIButton alloc] initWithFrame:CGRectMake(7.5, 6 + 95*i, 85, 97)];
        imageBtn.tag = 100 + i;
        [imageBtn sd_setBackgroundImageWithURL:banner.imgAddr.mj_url forState:UIControlStateNormal];
        [_scroll addSubview:imageBtn];
        [imageBtn addTarget:self action:@selector(lj_itemClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)lj_itemClick:(UIButton *)imageBtn
{
    NSInteger index = imageBtn.tag - 100;
    NSArray *bannerArr = kLJLiveManager.inside.accountConfig.voiceChatRoomBannerInfoList;
    
    LJLiveThinking(LJLiveThinkingEventTypeEvent, LJLiveThinkingEventClickBannerInLiveMultibeam, nil);
    /// 1:普通跳转 2：内购活动 3:申请主播 4:做积分墙任务的金币 5:老用户充值活动 6:新星榜 7:进入详情 8:三周年活动
    LJBannerInfo *bannerInfo = bannerArr[index];
    switch (bannerInfo.type) {
        case 1:
        {
            /// 普通跳转（打开网页）
            LJLiveAlertWebView *view = [LJLiveAlertWebView activityPopView];
            view.reloadURL = bannerInfo.redirectAddr;
            [view showInView:[LJLiveMethods lj_currentViewController].view];
        }
            break;
        case 6:
        {
            /// 新星榜
            NSMutableDictionary *dic = [@{
                @"session": kLJLiveManager.inside.session,
                @"type": @(1).stringValue
            } mutableCopy];
            
#ifdef DEBUG
            if (kLJLiveManager.config.isTestServer) [dic setValue:@"develop" forKey:@"env"];
#endif
            
            NSString *str = [bannerInfo.redirectAddr lj_addressURLAppendingByArg:dic];
             /// 普通跳转（打开网页）
            LJLiveAlertWebView *view = [LJLiveAlertWebView activityPopView];
            view.reloadURL = str;
            [view showInView:[LJLiveMethods lj_currentViewController].view];
        }
            break;
        case 7:
        {
            /// 进入详情
            LJLiveAccount *a = [[LJLiveAccount alloc] init];
            a.accountId = bannerInfo.extraData.integerValue;
            [kLJLiveManager.delegate lj_jumpDetailWithRoleType:LJLiveRoleTypeAnchor account:a];
        }
            break;
        case 8:
        {
            /// 三周年活动
            NSMutableDictionary *dic = [@{
                @"session": kLJLiveManager.inside.session,
                @"type": @(1).stringValue,
                @"display":kLJLiveManager.inside.account.displayAccountId
            } mutableCopy];
            
#ifdef DEBUG
            if (kLJLiveManager.config.isTestServer) [dic setValue:@"develop" forKey:@"env"];
#endif
            
            NSString *absoluteStr = bannerInfo.redirectAddr;
            NSString *tempUrl = [absoluteStr lj_addressURLAppendingByArg:dic];
             /// 普通跳转（打开网页）
            LJLiveAlertWebView *view = [LJLiveAlertWebView activityPopView];
            view.reloadURL = tempUrl;
            [view showInView:[LJLiveMethods lj_currentViewController].view];
        }
            break;
            
        default:
            break;
    }
}
- (void)lj_dismiss{
    UIView *subScroll = (UIView *)(self.superview);
    UIView *cell = (UIView *)subScroll.superview;
    UIScrollView *scroll = (UIScrollView *)cell.superview;
    scroll.scrollEnabled = YES;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.bgView.x = kLJLiveManager.inside.appRTL?-100:kLJScreenWidth;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}
@end
