//
//  GYLiveUIHelper.h
//  Woohoo
//
//  Created by M2-mini on 2021/10/28.
//

#import "GYLiveBaseObject.h"
#import "GYLiveMatchingView.h"
#import "GYLiveWaitMoreAlertView.h"
#import "GYLiveGeneralAlertView.h"
#import "GYLiveAutoFollowView.h"
#import "GYLiveAnchorPopView.h"
#import "GYLiveAudiencePopView.h"
#import "GYLiveReportView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYLiveUIHelper : GYLiveBaseObject

/// 顶部主播信息视图
@property (nonatomic, assign) CGRect headRect;
/// 活动信息图
@property (nonatomic, assign) CGRect bannerRect, pkBannerRect;
/// 目标视图
@property (nonatomic, assign) CGRect roomGoalRect, roomGoalPopRect;
/// 底部视图
@property (nonatomic, assign) CGRect inputRect;
/// 折扣视图
@property (nonatomic, assign) CGRect bonusViewRect;
/// 礼物弹幕
@property (nonatomic, assign) CGRect giftBarrageRect, pkGiftBarrageRect;
/// 弹幕区
@property (nonatomic, assign) CGRect barrageRect, pkBarrageRect;

/// 主播的视频幕布
@property (nonatomic, assign) CGRect homeVideoRect, pkHomeVideoRect;
/// PK选手的视频幕布
@property (nonatomic, assign) CGRect pkAwayVideoRect;
/// pk容器
@property (nonatomic, assign) CGRect pkControlRect;
/// pk头像
@property (nonatomic, assign) CGRect pkAvatarsRect;
/// pk进度条
@property (nonatomic, assign) CGRect pkProgressRect;
/// pk指示器
@property (nonatomic, assign) CGRect pkPromptRect;
/// 转盘按钮
@property (nonatomic, assign) CGRect turnPlateBtnRect;
/// 折扣按钮
@property (nonatomic, assign) CGRect openBonusBtnRect;
#pragma mark - Class Methods

/// 配对成功弹窗
/// @param inView inview
/// @param dismissBlock 倒计时3s消失
+ (void)fb_matchingSuccessedByUser:(GYLiveRoomMember *)user
                            inView:(UIView *)inView
                  withDelayDismiss:(GYLiveVoidBlock)dismissBlock;

/// 配对成功+倒计时弹窗
/// @param inView inview
/// @param dismissBlock 倒计时3s消失
+ (void)fb_matchingSuccessedAndCountdownByMyselfInView:(UIView *)inView
                                      withDelayDismiss:(GYLiveVoidBlock)dismissBlock;

/// close/notNow弹窗
/// @param inView inview
/// @param close 等待
/// @param notNow 更多
+ (void)fb_closeOrNot:(UIView *)inView withClose:(GYLiveVoidBlock)close notNow:(GYLiveVoidBlock)notNow;

/// wait/more弹窗
/// @param inView inview
/// @param waitBlock 等待
/// @param moreBlock 更多
+ (void)fb_waitOrMore:(UIView *)inView
             withWait:(GYLiveVoidBlock)waitBlock
                 more:(GYLiveVoidBlock)moreBlock;

/// 20/min 提醒
/// @param inView inview
/// @param event 事件
+ (void)fb_generalRemind:(UIView *)inView
                  callFee:(NSInteger)callFee
                    event:(GYLiveVoidBlock)event
             spaceDismiss:(GYLiveVoidBlock __nullable )spaceDismiss;

/// offline 更多
/// @param inView inview
/// @param event 事件
/// @param spaceDismiss 空白消失
+ (void)fb_generalMore:(UIView *)inView
                 event:(GYLiveVoidBlock)event
          spaceDismiss:(GYLiveVoidBlock __nullable )spaceDismiss;

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
                      dismissBlock:(GYLiveVoidBlock)dismissBlock;

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
                         follow:(GYLiveBoolBlock)follow;

/// 用户信息弹窗
/// @param user user
/// @param inView view
/// @param report report
/// @param avatar avatar
+ (void)fb_userDataWithUser:(GYLiveRoomUser *)user
                     inView:(UIView *)inView
                     report:(GYLiveVoidBlock)report
                      block:(GYLiveVoidBlock)block
                     avatar:(GYLiveVoidBlock)avatar;

/// 举报
/// @param inView inview
/// @param submit submit
+ (void)fb_reportInView:(UIView *)inView
                 submit:(GYLiveReportSubmitBlock)submit;

+ (void)fb_waitOrMoreDismiss:(UIView *)inView;

@end

NS_ASSUME_NONNULL_END
