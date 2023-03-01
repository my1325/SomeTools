//
//  GYLiveBannerView.m
//  Woohoo
//
//  Created by M2-mini on 2021/12/24.
//  Copyright © 2020 王振明. All rights reserved.
//

#import "GYLiveBannerView.h"
#import "GYLiveAlertWebView.h"
#import "GYLiveCarouselView.h"
#import "GYLiveSideBannerView.h"

@interface GYLiveBannerView ()

@property (nonatomic, strong) GYLiveCarouselView *adScroll;

@end

@implementation GYLiveBannerView

#pragma mark - GYLiveMarqueeViewDelegate

- (void)bannerClick:(NSInteger)index
{
    GYLiveThinking(GYLiveThinkingEventTypeEvent, GYLiveThinkingEventClickBannerInLiveMultibeam, nil);
    /// 1:普通跳转 2：内购活动 3:申请主播 4:做积分墙任务的金币 5:老用户充值活动 6:新星榜 7:进入详情 8:三周年活动
    GYBannerInfo *bannerInfo = self.dataArray[index];
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

- (void)setDataArray:(NSArray *)dataArray
{
    self.backgroundColor = kGYColorFromRGBA(0x000000, 0.5);
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
    

    
    _dataArray = dataArray;
    NSMutableArray *marr = [@[] mutableCopy];
//    for (GYBannerInfo *banner in dataArray) {
//        [marr addObject:banner.imgAddr];
//    }
    for (int i = 0;i < (dataArray.count > 6 ? 6 : dataArray.count); i++) {
        GYBannerInfo *banner = dataArray[i];
        [marr addObject:banner.imgAddr];
    }
    
    self.adScroll.frame = CGRectMake(0, 0, 85, 97);
    self.adScroll.imageArray = marr;
    [self addSubview:self.adScroll];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 16, 3, 13, 13)];
    [closeBtn setBackgroundImage:kGYImageNamed(@"fb_live_close_icon") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    
    UILabel *moreLab = [[UILabel alloc] initWithFrame:CGRectMake(51, 85 + 4.5, 24, 10.5)];
    moreLab.font = kGYHurmeBoldFont(9);
    moreLab.textColor = kGYColorFromRGBA(0xFFFFFF, 0.5);
    moreLab.text = kGYLocalString(@"More");
    [self addSubview:moreLab];
    
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(moreLab.right + 3, 93, 3, 4)];
    arrow.image = kGYImageNamed(@"fb_live_banner_arrow");
    [self addSubview:arrow];
    
    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 85, 85, 20)];
    [moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:moreBtn];
    
}

-(void)closeBtnClick{
    [self removeFromSuperview];
}
    
-(void)moreBtnClick{
    
    GYLiveSideBannerView *view = [[GYLiveSideBannerView alloc] init];
    [view fb_showInView:self.superview.superview.superview];
}

- (void)setIsLive:(BOOL)isLive
{
    _isLive = isLive;
    GYEvent(@"fb_clickBannerInLive", nil);
}

- (GYLiveCarouselView *)adScroll {
 
    if (!_adScroll) {
        _adScroll = [[GYLiveCarouselView alloc] init];
        _adScroll.placeholderImage = kGYImageNamed(@"fb_live_default_head");
        _adScroll.placeholderImage2 = kGYImageNamed(@"fb_live_default_head");
        _adScroll.changeMode = ChangeModeDefault;
        _adScroll.pagePosition = PositionHide;
        _adScroll.pagePosition =  PositionBottomLeft;
        
    
        kGYWeakSelf;
        _adScroll.imageClickBlock = ^(NSInteger index) {
            [weakSelf bannerClick:index];
        };
    }
    return _adScroll;
}

@end
