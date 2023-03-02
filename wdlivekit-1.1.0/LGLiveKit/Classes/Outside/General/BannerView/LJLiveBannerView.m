//
//  LJLiveBannerView.m
//  Woohoo
//
//  Created by M2-mini on 2021/12/24.
//  Copyright © 2020 王振明. All rights reserved.
//

#import "LJLiveBannerView.h"
#import "LJLiveAlertWebView.h"
#import "LJLiveCarouselView.h"
#import "LJLiveSideBannerView.h"

@interface LJLiveBannerView ()


@property (nonatomic, strong) LJLiveCarouselView *adScroll;
@end

@implementation LJLiveBannerView

#pragma mark - LJLiveMarqueeViewDelegate



    



- (LJLiveCarouselView *)adScroll {
 
    if (!_adScroll) {
        _adScroll = [[LJLiveCarouselView alloc] init];
        _adScroll.placeholderImage = kLJImageNamed(@"lj_live_default_head");
        _adScroll.placeholderImage2 = kLJImageNamed(@"lj_live_default_head");
        _adScroll.changeMode = ChangeModeDefault;
        _adScroll.pagePosition = PositionHide;
        _adScroll.pagePosition =  PositionBottomLeft;
        
    
        kLJWeakSelf;
        _adScroll.imageClickBlock = ^(NSInteger index) {
            [weakSelf bannerClick:index];
        };
    }
    return _adScroll;
}
- (void)setDataArray:(NSArray *)dataArray
{
    self.backgroundColor = kLJColorFromRGBA(0x000000, 0.5);
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
    

    
    _dataArray = dataArray;
    NSMutableArray *marr = [@[] mutableCopy];
//    for (LJBannerInfo *banner in dataArray) {
//        [marr addObject:banner.imgAddr];
//    }
    for (int i = 0;i < (dataArray.count > 6 ? 6 : dataArray.count); i++) {
        LJBannerInfo *banner = dataArray[i];
        [marr addObject:banner.imgAddr];
    }
    
    self.adScroll.frame = CGRectMake(0, 0, 85, 97);
    self.adScroll.imageArray = marr;
    [self addSubview:self.adScroll];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 16, 3, 13, 13)];
    [closeBtn setBackgroundImage:kLJImageNamed(@"lj_live_close_icon") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    
    UILabel *moreLab = [[UILabel alloc] initWithFrame:CGRectMake(51, 85 + 4.5, 24, 10.5)];
    moreLab.font = kLJHurmeBoldFont(9);
    moreLab.textColor = kLJColorFromRGBA(0xFFFFFF, 0.5);
    moreLab.text = kLJLocalString(@"More");
    [self addSubview:moreLab];
    
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(moreLab.right + 3, 93, 3, 4)];
    arrow.image = kLJImageNamed(@"lj_live_banner_arrow");
    [self addSubview:arrow];
    
    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 85, 85, 20)];
    [moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:moreBtn];
    
}
- (void)bannerClick:(NSInteger)index
{
    LJLiveThinking(LJLiveThinkingEventTypeEvent, LJLiveThinkingEventClickBannerInLiveMultibeam, nil);
    /// 1:普通跳转 2：内购活动 3:申请主播 4:做积分墙任务的金币 5:老用户充值活动 6:新星榜 7:进入详情 8:三周年活动
    LJBannerInfo *bannerInfo = self.dataArray[index];
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
- (void)setIsLive:(BOOL)isLive
{
    _isLive = isLive;
    LJEvent(@"lj_clickBannerInLive", nil);
}
-(void)closeBtnClick{
    [self removeFromSuperview];
}
-(void)moreBtnClick{
    
    LJLiveSideBannerView *view = [[LJLiveSideBannerView alloc] init];
    [view lj_showInView:self.superview.superview.superview];
}
@end
