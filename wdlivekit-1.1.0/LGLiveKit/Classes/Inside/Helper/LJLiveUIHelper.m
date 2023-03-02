//
//  LJLiveUIHelper.m
//  Woohoo
//
//  Created by M2-mini on 2021/10/28.
//

#import "LJLiveUIHelper.h"
#import <LGLiveKit/LGLiveKit-Swift.h>
@implementation LJLiveUIHelper

#pragma mark - Init



#pragma mark - Default Rect










#pragma mark - PK Rect













#pragma mark - Class Methods

+ (void)lj_closeOrNot:(UIView *)inView withClose:(LJLiveVoidBlock)close notNow:(LJLiveVoidBlock)notNow
{
    LJLiveWaitMoreAlertView *wait = [LJLiveWaitMoreAlertView closeViewWithClose:close notNow:notNow];
    wait.contentLabel.text = kLJLocalString(@"Do you want to end or minimize this live show ?");
    [wait.waitButton setTitle:kLJLocalString(@"Wait") forState:UIControlStateNormal];
    [wait.moreButton setTitle:kLJLocalString(@"More anchors") forState:UIControlStateNormal];
    [inView addSubview:wait];
    [wait lj_open];
}

+ (void)lj_matchingSuccessedByUser:(LJLiveRoomMember *)user
                            inView:(UIView *)inView
                  withDelayDismiss:(LJLiveVoidBlock)dismissBlock
{
    LJLiveMatchingView *matching = [[LJLiveMatchingView alloc] initWithFrame:kLJScreenBounds];
    [matching lj_matchingSuccessed:inView
                      anchorAvatar:kLJLiveHelper.data.current.hostAvatar
                        anchorName:kLJLiveHelper.data.current.hostName
                        userAvatar:user.avatar
                          userName:user.nickName
                  withDelayDismiss:dismissBlock];
}

+ (void)lj_matchingSuccessedAndCountdownByMyselfInView:(UIView *)inView
                                      withDelayDismiss:(LJLiveVoidBlock)dismissBlock
{
    LJLiveMatchingView *matching = [[LJLiveMatchingView alloc] initWithFrame:kLJScreenBounds];
    [matching lj_matchingCountdown:inView
                      anchorAvatar:kLJLiveHelper.data.current.hostAvatar
                        anchorName:kLJLiveHelper.data.current.hostName
                        userAvatar:kLJLiveManager.inside.account.avatar
                          userName:kLJLiveManager.inside.account.nickName
                  withDelayDismiss:dismissBlock];
}

+ (void)lj_waitOrMore:(UIView *)inView withWait:(LJLiveVoidBlock)waitBlock more:(LJLiveVoidBlock)moreBlock
{
    LJLiveWaitMoreAlertView *wait = [LJLiveWaitMoreAlertView waitMoreViewWithWait:waitBlock more:moreBlock];
    [inView addSubview:wait];
    [wait lj_open];
}

+ (void)lj_waitOrMoreDismiss:(UIView *)inView
{
    for (UIView *view in inView.subviews) {
        if ([view isKindOfClass:[LJLiveWaitMoreAlertView class]]) {
            [(LJLiveWaitMoreAlertView *)view lj_dismiss];
            break;
        }
    }
}

+ (void)lj_generalRemind:(UIView *)inView
                  callFee:(NSInteger)callFee
                    event:(LJLiveVoidBlock)event
             spaceDismiss:(LJLiveVoidBlock __nullable )spaceDismiss
{
    LJLiveGeneralAlertView *alert = [LJLiveGeneralAlertView remindAlertView];
    alert.eventBlock = event;
    alert.spaceDismissBlock = spaceDismiss;
    alert.content = [NSString stringWithFormat:kLJLocalString(@"Free for the first 5 minutes, %ld coins /minute after it."), callFee];
    alert.iconImage = kLJImageNamed(@"lj_live_remind_icon");
    [inView addSubview:alert];
    [alert lj_open];
}

+ (void)lj_generalMore:(UIView *)inView
                 event:(LJLiveVoidBlock)event
          spaceDismiss:(LJLiveVoidBlock __nullable )spaceDismiss
{
    LJLiveGeneralAlertView *alert = [LJLiveGeneralAlertView moreAlertView];
    alert.eventBlock = event;
    alert.spaceDismissBlock = spaceDismiss;
    alert.content = kLJLocalString(@"The anchor is offline, take a look at other anchors");
    alert.iconImage = kLJImageNamed(@"lj_live_permission_icon");
    [inView addSubview:alert];
    [alert lj_open];
}

+ (void)lj_autoFollowingWithAvatar:(NSString *)avatar
                          nickname:(NSString *)nickname
                          followed:(BOOL)followed
                            inView:(UIView *)inView
                       avatarBlock:(LJLiveVoidBlock)avatarBlock
                       followBlock:(LJLiveBoolBlock)followBlock
                      dismissBlock:(LJLiveVoidBlock)dismissBlock
{
    LJLiveAutoFollowView *view = [LJLiveAutoFollowView followView];
    view.followBlock = followBlock;
    view.dimissBlock = dismissBlock;
    view.avatarBlock = avatarBlock;
    [view lj_showAvatar:avatar nickname:nickname follow:followed inView:inView];
}

+ (void)lj_anchorDataWithAnchor:(LJLiveRoomAnchor *)anchor
                         inView:(UIView *)inView
                         report:(LJLiveVoidBlock)report
                          block:(LJLiveVoidBlock)block
                         avatar:(LJLiveVoidBlock)avatar
                        message:(LJLiveVoidBlock)message
                         follow:(LJLiveBoolBlock)follow
{
    LJLiveAnchorPopView *view = [LJLiveAnchorPopView anchorView];
    view.reportBlock = report;
    view.blockBlock = block;
    view.avatarBlock = avatar;
    view.messageBlock = message;
    view.followBlock = follow;
    view.anchor = anchor;
    [view lj_showInView:inView];
}

+ (void)lj_userDataWithUser:(LJLiveRoomUser *)user
                     inView:(UIView *)inView
                     report:(LJLiveVoidBlock)report
                      block:(LJLiveVoidBlock)block
                     avatar:(LJLiveVoidBlock)avatar
{
    LJLiveAudiencePopView *view = [LJLiveAudiencePopView audienceView];
    view.reportBlock = report;
    view.avatarBlock = avatar;
    view.blockBlock = block;
    view.user = user;
    [view lj_showInView:inView];
}

+ (void)lj_reportInView:(UIView *)inView
                 submit:(LJLiveReportSubmitBlock)submit
{
    LJLiveReportView *view = [LJLiveReportView reportView];
    view.submitBlock = submit;
    [view lj_showInView:inView];
    kLJLiveHelper.comboing = -1;
    [LJLiveComboViewManager.shared lj_removeCurrentViewFromSuperView];
    UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
}


/// 配对成功+倒计时弹窗
/// @param followBlock 关注
/// @param report 拉黑
/// @param user user
/// @param inView inview
/// @param event 事件
/// @param inView inview
    // 清理combo动画
/// close/notNow弹窗
/// 自动关注弹窗
/// @param nickname 昵称
/// 举报
/// offline 更多
/// @param dismissBlock 倒计时3s消失
/// @param report report
/// @param inView inview
/// wait/more弹窗
/// @param moreBlock 更多
/// @param inView inview
/// @param waitBlock 等待
/// @param avatarBlock 头像
/// @param submit submit
/// @param event 事件
/// @param notNow 更多
/// @param inView view
/// @param close 等待
/// @param inView view
/// @param follow follow
/// 配对成功弹窗
/// @param dismissBlock 倒计时3s消失
/// 用户信息弹窗
/// @param inView view
/// @param dismissBlock 消失
/// @param followed 是否关注
/// 主播信息弹窗
/// @param inView inview
/// @param avatar avatar
/// @param anchor 主播
/// @param message message
/// @param inView inview
/// @param avatar avatar
/// @param avatar 头像
/// 20/min 提醒
/// @param inView inview
- (CGRect)pkHomeVideoRect
{
    CGFloat y = CGRectGetMinY(self.pkControlRect);
    CGFloat width = kLJScreenWidth/2;
    CGFloat height = CGRectGetMinY(self.pkProgressRect);
    return CGRectMake(0, y, width, height);
}
- (CGRect)roomGoalRect
{
    return CGRectMake(15, kLJStatusBarHeight + 76 - 18, kLJWidthScale(149), 28);
}
- (CGRect)bonusViewRect
{
    return CGRectMake(0, 0, kLJScreenWidth, kLJScreenHeight);
}
- (CGRect)pkGiftBarrageRect
{
    CGFloat y = CGRectGetMaxY(self.headRect) + CGRectGetMinY(self.pkProgressRect) - 30 - 45 - 10 - (42*3 + 12);
    return CGRectMake(0, y, 250, 42*3 + 12);
}
- (CGRect)headRect
{
    return CGRectMake(0, kLJStatusBarHeight, kLJScreenWidth, 76);
}
- (CGRect)pkControlRect
{
    CGFloat y = CGRectGetMaxY(self.headRect) + kLJHeightScale(10);
    CGFloat height = CGRectGetMinY(self.pkBarrageRect) - y - kLJHeightScale(4);
    return CGRectMake(0, y, kLJScreenWidth, height);
}
- (CGRect)roomGoalPopRect
{
    return CGRectMake(15, kLJStatusBarHeight + 76 - 18 + 30, 100, 200);
}
- (CGRect)pkPromptRect
{
    CGFloat y = CGRectGetMinY(self.pkProgressRect) - 28;
    return CGRectMake(0, y, kLJScreenWidth, 28);
}
- (CGRect)turnPlateBtnRect
{
    return CGRectMake(kLJScreenWidth - 70, 76 + kLJStatusBarHeight + 15, 60, 60);
}
- (CGRect)barrageRect
{
    CGFloat height = kLJHeightScale(160);
    CGFloat y = CGRectGetMinY(self.inputRect) - height;
    return CGRectMake(0, y, kLJScreenWidth, height);
}
- (CGRect)openBonusBtnRect
{
    return CGRectMake(kLJScreenWidth - 70, 76 + kLJStatusBarHeight + 15 + 75, 60, 60);
}
- (CGRect)pkBarrageRect
{
    CGFloat height = kLJHeightScale(140) + (kLJIsIpxs ? 20 : 0); //kLJHeightScale(140);
    CGFloat y = CGRectGetMinY(self.inputRect) - height;
    return CGRectMake(0, y, kLJScreenWidth, height);
}
- (CGRect)pkBannerRect
{
    CGFloat y = self.barrageRect.origin.y + self.barrageRect.size.height - 5 - 105;
    return CGRectMake(kLJScreenWidth - 12 - 85, y, 85, 105);
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self lj_defaultConfigs];
    }
    return self;
}
- (CGRect)inputRect
{
    CGFloat y = kLJScreenHeight - kLJBottomSafeHeight - 9 - 50;
    return CGRectMake(0, y, kLJScreenWidth, 50);
}
- (CGRect)giftBarrageRect
{
    CGFloat y = kLJScreenHeight - kLJHeightScale(20) - (321 + kLJBottomSafeHeight) - (42*3 + 12);
    return CGRectMake(0, y, 250 + kLJWidthScale(15), 42*3 + 12);
}
- (CGRect)homeVideoRect
{
    return kLJScreenBounds;
}
- (CGRect)pkAvatarsRect
{
    CGFloat y = self.pkControlRect.size.height - 35;
    return CGRectMake(0, y, kLJScreenWidth, 35);
}
- (CGRect)pkProgressRect
{
    CGFloat y = CGRectGetMinY(self.pkAvatarsRect) - 16;
    return CGRectMake(0, y, kLJScreenWidth, 16);
}
- (void)lj_defaultConfigs
{
    // 默认
}
- (CGRect)pkAwayVideoRect
{
    CGFloat y = CGRectGetMinY(self.pkControlRect);
    CGFloat width = kLJScreenWidth/2;
    CGFloat height = CGRectGetMinY(self.pkProgressRect);
    return CGRectMake(kLJScreenWidth/2, y, width, height);
}
- (CGRect)bannerRect
{
    CGFloat y = self.barrageRect.origin.y + self.barrageRect.size.height - 124/2 - 5 - (kLJLiveManager.inside.accountConfig.voiceChatRoomBannerInfoList.count >= 2?105:85);
    return CGRectMake(kLJScreenWidth - 12 - 85, y, 85, (kLJLiveManager.inside.accountConfig.voiceChatRoomBannerInfoList.count >= 2?105:85));
}
@end
