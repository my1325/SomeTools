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


#pragma mark - Class Methods












/// @param dismissBlock 消失
/// @param followBlock 关注
/// 活动信息图
/// pk指示器
/// @param follow follow
/// @param inView view
/// @param spaceDismiss 空白消失
/// @param submit submit
/// 自动关注弹窗
/// 举报
/// 弹幕区
/// 顶部主播信息视图
/// @param avatar 头像
/// pk头像
/// @param inView view
/// 转盘按钮
/// 主播信息弹窗
/// PK选手的视频幕布
/// @param inView inview
/// @param dismissBlock 倒计时3s消失
/// @param inView inview
/// @param inView inview
/// @param report 拉黑
/// @param user user
/// @param avatar avatar
/// @param waitBlock 等待
/// @param avatar avatar
/// 折扣视图
/// @param event 事件
/// @param inView view
/// @param inView inview
/// @param inView inview
/// @param moreBlock 更多
/// @param close 等待
/// close/notNow弹窗
/// 配对成功弹窗
/// 目标视图
/// 用户信息弹窗
/// 底部视图
/// @param report report
/// @param event 事件
/// wait/more弹窗
/// 配对成功+倒计时弹窗
/// 折扣按钮
/// @param followed 是否关注
/// pk容器
/// 礼物弹幕
/// @param notNow 更多
/// @param avatarBlock 头像
/// pk进度条
/// @param message message
/// 主播的视频幕布
/// @param anchor 主播
/// offline 更多
/// @param inView inview
/// @param dismissBlock 倒计时3s消失
/// @param nickname 昵称
/// @param inView inview
/// 20/min 提醒
+ (void)lj_generalMore:(UIView *)inView
                 event:(LJLiveVoidBlock)event
          spaceDismiss:(LJLiveVoidBlock __nullable )spaceDismiss;
+ (void)lj_closeOrNot:(UIView *)inView withClose:(LJLiveVoidBlock)close notNow:(LJLiveVoidBlock)notNow;
+ (void)lj_waitOrMore:(UIView *)inView
             withWait:(LJLiveVoidBlock)waitBlock
                 more:(LJLiveVoidBlock)moreBlock;
+ (void)lj_userDataWithUser:(LJLiveRoomUser *)user
                     inView:(UIView *)inView
                     report:(LJLiveVoidBlock)report
                      block:(LJLiveVoidBlock)block
                     avatar:(LJLiveVoidBlock)avatar;
+ (void)lj_generalRemind:(UIView *)inView
                  callFee:(NSInteger)callFee
                    event:(LJLiveVoidBlock)event
             spaceDismiss:(LJLiveVoidBlock __nullable )spaceDismiss;
+ (void)lj_autoFollowingWithAvatar:(NSString *)avatar
                          nickname:(NSString *)nickname
                          followed:(BOOL)followed
                            inView:(UIView *)inView
                       avatarBlock:(LJLiveVoidBlock)avatarBlock
                       followBlock:(LJLiveBoolBlock)followBlock
                      dismissBlock:(LJLiveVoidBlock)dismissBlock;
+ (void)lj_waitOrMoreDismiss:(UIView *)inView;
+ (void)lj_reportInView:(UIView *)inView
                 submit:(LJLiveReportSubmitBlock)submit;
+ (void)lj_matchingSuccessedByUser:(LJLiveRoomMember *)user
                            inView:(UIView *)inView
                  withDelayDismiss:(LJLiveVoidBlock)dismissBlock;
+ (void)lj_matchingSuccessedAndCountdownByMyselfInView:(UIView *)inView
                                      withDelayDismiss:(LJLiveVoidBlock)dismissBlock;
+ (void)lj_anchorDataWithAnchor:(LJLiveRoomAnchor *)anchor
                         inView:(UIView *)inView
                         report:(LJLiveVoidBlock)report
                          block:(LJLiveVoidBlock)block
                         avatar:(LJLiveVoidBlock)avatar
                        message:(LJLiveVoidBlock)message
                         follow:(LJLiveBoolBlock)follow;
@property (nonatomic, assign) CGRect homeVideoRect, pkHomeVideoRect;
@property (nonatomic, assign) CGRect headRect;
@property (nonatomic, assign) CGRect inputRect;
@property (nonatomic, assign) CGRect roomGoalRect, roomGoalPopRect;
@property (nonatomic, assign) CGRect pkControlRect;
@property (nonatomic, assign) CGRect pkAwayVideoRect;
@property (nonatomic, assign) CGRect giftBarrageRect, pkGiftBarrageRect;
@property (nonatomic, assign) CGRect bonusViewRect;
@property (nonatomic, assign) CGRect barrageRect, pkBarrageRect;
@property (nonatomic, assign) CGRect pkAvatarsRect;
@property (nonatomic, assign) CGRect openBonusBtnRect;
@property (nonatomic, assign) CGRect bannerRect, pkBannerRect;
@property (nonatomic, assign) CGRect turnPlateBtnRect;
@property (nonatomic, assign) CGRect pkProgressRect;
@property (nonatomic, assign) CGRect pkPromptRect;
@end

NS_ASSUME_NONNULL_END
