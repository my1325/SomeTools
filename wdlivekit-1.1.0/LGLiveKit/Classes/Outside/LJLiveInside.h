//
//  LJLiveInside.h
//  Woohoo
//
//  Created by M1-mini on 2022/4/25.
//  Copyright © 2022 tt. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define LJTip(_text, _status, _delay) [LJLiveInside lj_tipWithText:_text status:_status delay:_delay];

#define LJTipSuccess(_text) LJTip(_text, 0, 2.5);

#define LJTipError(_text) LJTip(_text, 1, 2.5);

#define LJTipWarning(_text) LJTip(_text, 2, 2.5);

#define LJEvent(_eventName, _params) [LJLiveInside lj_other:_eventName params:_params];

#define LJFirbase(_type, _params) [LJLiveInside lj_firbase:_type params:_params];

#define LJLiveThinking(_type, _eventName, _params) [LJLiveInside lj_thinking:_type eventName:_eventName params:_params];


@interface LJLiveInside : NSObject




#pragma mark - Methods








/// 账号信息
/*-------------------------------------------------------------------
 数数统计（中转数据）
 */
/// 阿语适配
/// 账号配置
///
/// 关注
/// 关注
///
/// 关注
///
/// 金币更新
/*-------------------------------------------------------------------
 直播间所需外部数据（中转数据）
 */
/// 进入直播间
/// 标签选中
/*-------------------------------------------------------------------
 中转数据
 */
///
/// 网络状态
+ (void)lj_hideLoading;
+ (void)lj_tipWithText:(NSString *)text status:(LJLiveTipStatus)status delay:(float)delay;
+ (void)lj_loading;
+ (void)lj_reloadHomeList;
+ (void)lj_thinking:(LJLiveThinkingEventType)type
           eventName:(NSString *)eventName
              params:(NSDictionary * __nullable )params;
+ (void)lj_other:(NSString *)eventName
           params:(NSDictionary * __nullable )params;
+ (void)lj_firbase:(LJLiveFirbaseEventType)type
             params:(NSDictionary * __nullable )params;
@property (nonatomic, assign) NSInteger networkStatus, sseStatus;
@property (nonatomic, strong) NSString * _Nullable fromJoin;
@property (nonatomic, assign) BOOL appRTL;
@property (nonatomic, copy) void(^ followStatusUpdate) (NSInteger status, NSInteger targetAccountId);
@property (nonatomic, strong) NSString *session;
@property (nonatomic, strong) LJLiveAccount *account;
@property (nonatomic, copy) LJLiveIntegerBlock coinsUpdate;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, copy) void(^ uniqueTagDidSelected) (LJUniqueTag * __nullable uniqueTag);
@property (nonatomic, strong) LJLiveAccountConfig *accountConfig;
@property (nonatomic, assign) BOOL joinFlag;
@property (nonatomic, strong) NSString *localizableAbbr;
@property (nonatomic, strong) AgoraRtmKit *rtmKit;
@property (nonatomic, strong) NSString *fromDetail;
@end

NS_ASSUME_NONNULL_END
