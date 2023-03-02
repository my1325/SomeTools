//
//  LJLiveUIHelper.h
//  Woohoo
//
//  Created by M2-mini on 2021/10/28.
//

#import "LJLiveBaseObject.h"
#import "LJLiveMatchingView.h"
#import "LJLiveWaitMoreAlertView.h"
#import "LJLiveGeneralAlertView.h"
#import "LJLiveAutoFollowView.h"
#import "LJLiveAnchorPopView.h"
#import "LJLiveAudiencePopView.h"
#import "LJLiveReportView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveUIHelper : LJLiveBaseObject

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
+ (void)lj_matchingSuccessedByUser:(LJLiveRoomMember *)user
                            inView:(UIView *)inView
                  withDelayDismiss:(LJLiveVoidBlock)dismissBlock;

/// 配对成功+倒计时弹窗
/// @param inView inview
/// @param dismissBlock 倒计时3s消失
+ (void)lj_matchingSuccessedAndCountdownByMyselfInView:(UIView *)inView
                                      withDelayDismiss:(LJLiveVoidBlock)dismissBlock;

/// close/notNow弹窗
/// @param inView inview
/// @param close 等待
/// @param notNow 更多
+ (void)lj_closeOrNot:(UIView *)inView withClose:(LJLiveVoidBlock)close notNow:(LJLiveVoidBlock)notNow;

/// wait/more弹窗
/// @param inView inview
/// @param waitBlock 等待
/// @param moreBlock 更多
+ (void)lj_waitOrMore:(UIView *)inView
             withWait:(LJLiveVoidBlock)waitBlock
                 more:(LJLiveVoidBlock)moreBlock;

/// 20/min 提醒
/// @param inView inview
/// @param event 事件
+ (void)lj_generalRemind:(UIView *)inView
                  callFee:(NSInteger)callFee
                    event:(LJLiveVoidBlock)event
             spaceDismiss:(LJLiveVoidBlock __nullable )spaceDismiss;

/// offline 更多
/// @param inView inview
/// @param event 事件
/// @param spaceDismiss 空白消失
+ (void)lj_generalMore:(UIView *)inView
                 event:(LJLiveVoidBlock)event
          spaceDismiss:(LJLiveVoidBlock __nullable )spaceDismiss;

/// 自动关注弹窗
/// @param avatar 头像
/// @param nickname 昵称
/// @param followed 是否关注
/// @param inView view
/// @param avatarBlock 头像
/// @param followBlock 关注
/// @param dismissBlock 消失
+ (void)lj_autoFollowingWithAvatar:(NSString *)avatar
                          nickname:(NSString *)nickname
                          followed:(BOOL)followed
                            inView:(UIView *)inView
                       avatarBlock:(LJLiveVoidBlock)avatarBlock
                       followBlock:(LJLiveBoolBlock)followBlock
                      dismissBlock:(LJLiveVoidBlock)dismissBlock;

/// 主播信息弹窗
/// @param anchor 主播
/// @param inView view
/// @param report 拉黑
/// @param avatar avatar
/// @param message message
/// @param follow follow
+ (void)lj_anchorDataWithAnchor:(LJLiveRoomAnchor *)anchor
                         inView:(UIView *)inView
                         report:(LJLiveVoidBlock)report
                          block:(LJLiveVoidBlock)block
                         avatar:(LJLiveVoidBlock)avatar
                        message:(LJLiveVoidBlock)message
                         follow:(LJLiveBoolBlock)follow;

/// 用户信息弹窗
/// @param user user
/// @param inView view
/// @param report report
/// @param avatar avatar
+ (void)lj_userDataWithUser:(LJLiveRoomUser *)user
                     inView:(UIView *)inView
                     report:(LJLiveVoidBlock)report
                      block:(LJLiveVoidBlock)block
                     avatar:(LJLiveVoidBlock)avatar;

/// 举报
/// @param inView inview
/// @param submit submit
+ (void)lj_reportInView:(UIView *)inView
                 submit:(LJLiveReportSubmitBlock)submit;

+ (void)lj_waitOrMoreDismiss:(UIView *)inView;

@end

NS_ASSUME_NONNULL_END
