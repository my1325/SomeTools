//
//  GYLiveUIHelper.m
//  Woohoo
//
//  Created by M2-mini on 2021/10/28.
//

#import "GYLiveUIHelper.h"
#import <WDLiveKit/WDLiveKit-Swift.h>
@implementation GYLiveUIHelper

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self fb_defaultConfigs];
    }
    return self;
}

- (void)fb_defaultConfigs
{
    // 默认
}

#pragma mark - Default Rect

- (CGRect)headRect
{
    return CGRectMake(0, kGYStatusBarHeight, kGYScreenWidth, 76);
}

- (CGRect)inputRect
{
    CGFloat y = kGYScreenHeight - kGYBottomSafeHeight - 9 - 50;
    return CGRectMake(0, y, kGYScreenWidth, 50);
}

- (CGRect)giftBarrageRect
{
    CGFloat y = kGYScreenHeight - kGYHeightScale(20) - (321 + kGYBottomSafeHeight) - (42*3 + 12);
    return CGRectMake(0, y, 250 + kGYWidthScale(15), 42*3 + 12);
}

- (CGRect)barrageRect
{
    CGFloat height = kGYHeightScale(160);
    CGFloat y = CGRectGetMinY(self.inputRect) - height;
    return CGRectMake(0, y, kGYScreenWidth, height);
}

- (CGRect)bannerRect
{
    CGFloat y = self.barrageRect.origin.y + self.barrageRect.size.height - 124/2 - 5 - (kGYLiveManager.inside.accountConfig.voiceChatRoomBannerInfoList.count >= 2?105:85);
    return CGRectMake(kGYScreenWidth - 12 - 85, y, 85, (kGYLiveManager.inside.accountConfig.voiceChatRoomBannerInfoList.count >= 2?105:85));
}

- (CGRect)homeVideoRect
{
    return kGYScreenBounds;
}
- (CGRect)roomGoalRect
{
    return CGRectMake(15, kGYStatusBarHeight + 76 - 18, kGYWidthScale(149), 28);
}

- (CGRect)roomGoalPopRect
{
    return CGRectMake(15, kGYStatusBarHeight + 76 - 18 + 30, 100, 200);
}

- (CGRect)bonusViewRect
{
    return CGRectMake(0, 0, kGYScreenWidth, kGYScreenHeight);
}


#pragma mark - PK Rect

- (CGRect)pkBannerRect
{
    CGFloat y = self.barrageRect.origin.y + self.barrageRect.size.height - 5 - 105;
    return CGRectMake(kGYScreenWidth - 12 - 85, y, 85, 105);
}

- (CGRect)pkGiftBarrageRect
{
    CGFloat y = CGRectGetMaxY(self.headRect) + CGRectGetMinY(self.pkProgressRect) - 30 - 45 - 10 - (42*3 + 12);
    return CGRectMake(0, y, 250, 42*3 + 12);
}

- (CGRect)pkBarrageRect
{
    CGFloat height = kGYHeightScale(140) + (kGYIsIpxs ? 20 : 0); //kGYHeightScale(140);
    CGFloat y = CGRectGetMinY(self.inputRect) - height;
    return CGRectMake(0, y, kGYScreenWidth, height);
}

- (CGRect)pkControlRect
{
    CGFloat y = CGRectGetMaxY(self.headRect) + kGYHeightScale(10);
    CGFloat height = CGRectGetMinY(self.pkBarrageRect) - y - kGYHeightScale(4);
    return CGRectMake(0, y, kGYScreenWidth, height);
}

- (CGRect)pkAvatarsRect
{
    CGFloat y = self.pkControlRect.size.height - 35;
    return CGRectMake(0, y, kGYScreenWidth, 35);
}

- (CGRect)pkProgressRect
{
    CGFloat y = CGRectGetMinY(self.pkAvatarsRect) - 16;
    return CGRectMake(0, y, kGYScreenWidth, 16);
}

- (CGRect)pkPromptRect
{
    CGFloat y = CGRectGetMinY(self.pkProgressRect) - 28;
    return CGRectMake(0, y, kGYScreenWidth, 28);
}

- (CGRect)pkHomeVideoRect
{
    CGFloat y = CGRectGetMinY(self.pkControlRect);
    CGFloat width = kGYScreenWidth/2;
    CGFloat height = CGRectGetMinY(self.pkProgressRect);
    return CGRectMake(0, y, width, height);
}

- (CGRect)pkAwayVideoRect
{
    CGFloat y = CGRectGetMinY(self.pkControlRect);
    CGFloat width = kGYScreenWidth/2;
    CGFloat height = CGRectGetMinY(self.pkProgressRect);
    return CGRectMake(kGYScreenWidth/2, y, width, height);
}

- (CGRect)turnPlateBtnRect
{
    return CGRectMake(kGYScreenWidth - 70, 76 + kGYStatusBarHeight + 15, 60, 60);
}

- (CGRect)openBonusBtnRect
{
    return CGRectMake(kGYScreenWidth - 70, 76 + kGYStatusBarHeight + 15 + 75, 60, 60);
}


#pragma mark - Class Methods

/// close/notNow弹窗
/// @param inView inview
/// @param close 等待
/// @param notNow 更多
+ (void)fb_closeOrNot:(UIView *)inView withClose:(GYLiveVoidBlock)close notNow:(GYLiveVoidBlock)notNow
{
    GYLiveWaitMoreAlertView *wait = [GYLiveWaitMoreAlertView closeViewWithClose:close notNow:notNow];
    wait.contentLabel.text = kGYLocalString(@"Do you want to end or minimize this live show ?");
    [wait.waitButton setTitle:kGYLocalString(@"Wait") forState:UIControlStateNormal];
    [wait.moreButton setTitle:kGYLocalString(@"More anchors") forState:UIControlStateNormal];
    [inView addSubview:wait];
    [wait fb_open];
}

/// 配对成功弹窗
/// @param inView inview
/// @param dismissBlock 倒计时3s消失
+ (void)fb_matchingSuccessedByUser:(GYLiveRoomMember *)user
                            inView:(UIView *)inView
                  withDelayDismiss:(GYLiveVoidBlock)dismissBlock
{
    GYLiveMatchingView *matching = [[GYLiveMatchingView alloc] initWithFrame:kGYScreenBounds];
    [matching fb_matchingSuccessed:inView
                      anchorAvatar:kGYLiveHelper.data.current.hostAvatar
                        anchorName:kGYLiveHelper.data.current.hostName
                        userAvatar:user.avatar
                          userName:user.nickName
                  withDelayDismiss:dismissBlock];
}

/// 配对成功+倒计时弹窗
/// @param inView inview
/// @param dismissBlock 倒计时3s消失
+ (void)fb_matchingSuccessedAndCountdownByMyselfInView:(UIView *)inView
                                      withDelayDismiss:(GYLiveVoidBlock)dismissBlock
{
    GYLiveMatchingView *matching = [[GYLiveMatchingView alloc] initWithFrame:kGYScreenBounds];
    [matching fb_matchingCountdown:inView
                      anchorAvatar:kGYLiveHelper.data.current.hostAvatar
                        anchorName:kGYLiveHelper.data.current.hostName
                        userAvatar:kGYLiveManager.inside.account.avatar
                          userName:kGYLiveManager.inside.account.nickName
                  withDelayDismiss:dismissBlock];
}

/// wait/more弹窗
/// @param inView inview
/// @param waitBlock 等待
/// @param moreBlock 更多
+ (void)fb_waitOrMore:(UIView *)inView withWait:(GYLiveVoidBlock)waitBlock more:(GYLiveVoidBlock)moreBlock
{
    GYLiveWaitMoreAlertView *wait = [GYLiveWaitMoreAlertView waitMoreViewWithWait:waitBlock more:moreBlock];
    [inView addSubview:wait];
    [wait fb_open];
}

+ (void)fb_waitOrMoreDismiss:(UIView *)inView
{
    for (UIView *view in inView.subviews) {
        if ([view isKindOfClass:[GYLiveWaitMoreAlertView class]]) {
            [(GYLiveWaitMoreAlertView *)view fb_dismiss];
            break;
        }
    }
}

/// 20/min 提醒
/// @param inView inview
/// @param event 事件
+ (void)fb_generalRemind:(UIView *)inView
                  callFee:(NSInteger)callFee
                    event:(GYLiveVoidBlock)event
             spaceDismiss:(GYLiveVoidBlock __nullable )spaceDismiss
{
    GYLiveGeneralAlertView *alert = [GYLiveGeneralAlertView remindAlertView];
    alert.eventBlock = event;
    alert.spaceDismissBlock = spaceDismiss;
    alert.content = [NSString stringWithFormat:kGYLocalString(@"Free for the first 5 minutes, %ld coins /minute after it."), callFee];
    alert.iconImage = kGYImageNamed(@"fb_live_remind_icon");
    [inView addSubview:alert];
    [alert fb_open];
}

/// offline 更多
/// @param inView inview
/// @param event 事件
+ (void)fb_generalMore:(UIView *)inView
                 event:(GYLiveVoidBlock)event
          spaceDismiss:(GYLiveVoidBlock __nullable )spaceDismiss
{
    GYLiveGeneralAlertView *alert = [GYLiveGeneralAlertView moreAlertView];
    alert.eventBlock = event;
    alert.spaceDismissBlock = spaceDismiss;
    alert.content = kGYLocalString(@"The anchor is offline, take a look at other anchors");
    alert.iconImage = kGYImageNamed(@"fb_live_permission_icon");
    [inView addSubview:alert];
    [alert fb_open];
}

/// 自动关注弹窗
/// @param avatar 头像
/// @param nickname 昵称
/// @param followed 是否关注
/// @param inView view
/// @param avatarBlock 头像
/// @param followBlock 关注
/// @param dismissBlock 消失
+ (void)fb_autoFollowingWithAvatar:(NSString *)avatar
                          nickname:(NSString *)nickname
                          followed:(BOOL)followed
                            inView:(UIView *)inView
                       avatarBlock:(GYLiveVoidBlock)avatarBlock
                       followBlock:(GYLiveBoolBlock)followBlock
                      dismissBlock:(GYLiveVoidBlock)dismissBlock
{
    GYLiveAutoFollowView *view = [GYLiveAutoFollowView followView];
    view.followBlock = followBlock;
    view.dimissBlock = dismissBlock;
    view.avatarBlock = avatarBlock;
    [view fb_showAvatar:avatar nickname:nickname follow:followed inView:inView];
}

/// 主播信息弹窗
/// @param anchor 主播
/// @param inView view
/// @param report 拉黑
/// @param avatar avatar
/// @param message message
/// @param follow follow
+ (void)fb_anchorDataWithAnchor:(GYLiveRoomAnchor *)anchor
                         inView:(UIView *)inView
                         report:(GYLiveVoidBlock)report
                          block:(GYLiveVoidBlock)block
                         avatar:(GYLiveVoidBlock)avatar
                        message:(GYLiveVoidBlock)message
                         follow:(GYLiveBoolBlock)follow
{
    GYLiveAnchorPopView *view = [GYLiveAnchorPopView anchorView];
    view.reportBlock = report;
    view.blockBlock = block;
    view.avatarBlock = avatar;
    view.messageBlock = message;
    view.followBlock = follow;
    view.anchor = anchor;
    [view fb_showInView:inView];
}

/// 用户信息弹窗
/// @param user user
/// @param inView view
/// @param report report
/// @param avatar avatar
+ (void)fb_userDataWithUser:(GYLiveRoomUser *)user
                     inView:(UIView *)inView
                     report:(GYLiveVoidBlock)report
                      block:(GYLiveVoidBlock)block
                     avatar:(GYLiveVoidBlock)avatar
{
    GYLiveAudiencePopView *view = [GYLiveAudiencePopView audienceView];
    view.reportBlock = report;
    view.avatarBlock = avatar;
    view.blockBlock = block;
    view.user = user;
    [view fb_showInView:inView];
}

/// 举报
/// @param inView inview
/// @param submit submit
+ (void)fb_reportInView:(UIView *)inView
                 submit:(GYLiveReportSubmitBlock)submit
{
    GYLiveReportView *view = [GYLiveReportView reportView];
    view.submitBlock = submit;
    [view fb_showInView:inView];
    // 清理combo动画
    kGYLiveHelper.comboing = -1;
    [GYLiveComboViewManager.shared fb_removeCurrentViewFromSuperView];
    UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
}


@end
