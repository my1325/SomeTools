//
//  GYLiveInside.h
//  Woohoo
//
//  Created by M1-mini on 2022/4/25.
//  Copyright © 2022 tt. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define GYTip(_text, _status, _delay) [GYLiveInside fb_tipWithText:_text status:_status delay:_delay];

#define GYTipSuccess(_text) GYTip(_text, 0, 2.5);

#define GYTipError(_text) GYTip(_text, 1, 2.5);

#define GYTipWarning(_text) GYTip(_text, 2, 2.5);

#define GYEvent(_eventName, _params) [GYLiveInside fb_other:_eventName params:_params];

#define GYFirbase(_type, _params) [GYLiveInside fb_firbase:_type params:_params];

#define GYLiveThinking(_type, _eventName, _params) [GYLiveInside fb_thinking:_type eventName:_eventName params:_params];


@interface GYLiveInside : NSObject

/*-------------------------------------------------------------------
 直播间所需外部数据（中转数据）
 */
/// 网络状态
@property (nonatomic, assign) NSInteger networkStatus, sseStatus;
///
@property (nonatomic, strong) NSString *session;
/// 账号信息
@property (nonatomic, strong) GYLiveAccount *account;
/// 账号配置
@property (nonatomic, strong) GYLiveAccountConfig *accountConfig;
/// 阿语适配
@property (nonatomic, assign) BOOL appRTL;
///
@property (nonatomic, strong) AgoraRtmKit *rtmKit;
///
@property (nonatomic, strong) NSString *localizableAbbr;

/*-------------------------------------------------------------------
 数数统计（中转数据）
 */
/// 关注
@property (nonatomic, strong) NSString *from;
/// 关注
@property (nonatomic, strong) NSString *fromDetail;
/// 进入直播间
@property (nonatomic, strong) NSString * _Nullable fromJoin;
///
@property (nonatomic, assign) BOOL joinFlag;

/*-------------------------------------------------------------------
 中转数据
 */
/// 金币更新
@property (nonatomic, copy) GYLiveIntegerBlock coinsUpdate;
/// 关注
@property (nonatomic, copy) void(^ followStatusUpdate) (NSInteger status, NSInteger targetAccountId);
/// 标签选中
@property (nonatomic, copy) void(^ uniqueTagDidSelected) (GYUniqueTag * __nullable uniqueTag);

#pragma mark - Methods

+ (void)fb_loading;

+ (void)fb_hideLoading;

+ (void)fb_reloadHomeList;

+ (void)fb_tipWithText:(NSString *)text status:(GYLiveTipStatus)status delay:(float)delay;

+ (void)fb_firbase:(GYLiveFirbaseEventType)type
             params:(NSDictionary * __nullable )params;

+ (void)fb_thinking:(GYLiveThinkingEventType)type
           eventName:(NSString *)eventName
              params:(NSDictionary * __nullable )params;

+ (void)fb_other:(NSString *)eventName
           params:(NSDictionary * __nullable )params;

@end

NS_ASSUME_NONNULL_END
