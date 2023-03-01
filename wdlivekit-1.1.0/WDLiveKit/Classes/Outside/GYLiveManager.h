//
//  GYLiveManager.h
//  Woohoo
//
//  Created by M1-mini on 2022/4/24.
//  Copyright © 2022 tt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYLiveHeader.h"
#import "GYLiveConfiguration.h"
#import "GYLiveInside.h"
//#import "GYLiveRadioGift.h"

NS_ASSUME_NONNULL_BEGIN

#define kGYLiveManager [GYLiveManager sharedManager]
@protocol GYLiveManagerDataSource <NSObject>

@required

///获取rtc
- (nullable AgoraRtcEngineKit *)fb_rtcKit;

/// 网络状态
- (NSInteger)fb_networkStatus;

/// SSE状态
- (NSInteger)fb_sseStatus;

/// session
- (NSString *)fb_session;

/// 账号：字典，或者对象
- (id)fb_account;

/// 账号配置：字典，或者对象
- (id)fb_accountConfig;

/// 绑定RTM代理
/// @param delegate 对象
- (AgoraRtmKit *)fb_bindingRTMDelegate:(id _Nullable)delegate;

@optional

/// 当前多语言本地化简写（支持：en，ar，tr）
- (NSString *)fb_localizableAbbr;

/// 弹幕敏感词屏蔽：返回过滤后的文案
/// @param text 原文案
- (NSString *)fb_sensitiveReplaceByText:(NSString *)text;

@end

@protocol GYLiveManagerDelegate <NSObject>

@required

/// 请求
/// @param requestWay 方式
/// @param api 接口
/// @param query 参数
/// @param body 参数
/// @param success 成功
/// @param failure 失败
- (void)fb_requestWay:(GYLiveRequestMethod)requestWay
            requestApi:(NSString *)api
                 query:(NSDictionary * __nullable )query
                  body:(id __nullable )body
               success:(void(^) (id responseObj))success
               failure:(void(^) (NSString * __nullable error))failure;

/// 跳转私聊通话
/// @param privateChat 信息
- (void)fb_jumpToPrivate:(GYLivePrivate *)privateChat;

/// 跳转详情
/// @param roleType 角色
/// @param account 角色信息
- (void)fb_jumpDetailWithRoleType:(GYLiveRoleType)roleType account:(GYLiveAccount *)account;

/// 跳转内购页
- (void)fb_jumpToRecharge;

/// 跳转回话
/// @param roleType 角色
/// @param account 角色信息
- (void)fb_jumpConversationWithRoleType:(GYLiveRoleType)roleType account:(GYLiveAccount *)account;

/// 上传图片
/// @param image 图片
/// @param success 成功
/// @param failure 失败
- (void)fb_uploadImage:(UIImage *)image
                success:(void(^) (NSString *imageURL))success
                failure:(GYLiveVoidBlock)failure;

/// 充值成功统计外部自己实现
/// @param atView 父视图
- (void)fb_buyViewOpenAt:(UIView *)atView;

/// 弹窗
/// @param text 文案
/// @param status 样式
/// @param delay 延迟消失
- (void)fb_tipWithText:(NSString *)text status:(GYLiveTipStatus)status delay:(float)delay;

/// 内部消费金币，通知外部
/// @param leftDiamond 更新
- (void)fb_insideCoinsUpdateWith:(NSInteger)leftDiamond;

/// 内部关注某人，通知外部
/// @param status 是否关注（0：未关注，1：已关注）
/// @param targetAccountId ID
- (void)fb_insideFollowStatusUpdateWithStatus:(NSInteger)status targetAccountId:(NSInteger)targetAccountId;

/// 内部设置标签，通知外部
/// @param uniqueTag 标签
- (void)fb_insideDidSelectedUniqueTag:(GYUniqueTag * __nullable )uniqueTag;

@optional

- (void)fb_showLoading;

- (void)fb_hideLoading;

/// Firbase精细化打点
/// @param type 类型
/// @param params 参数
- (void)fb_firbase:(GYLiveFirbaseEventType)type params:(NSDictionary * __nullable )params;

/// 数数统计
/// @param type 类型
/// @param eventName 名
/// @param params 参数
- (void)fb_thinking:(GYLiveThinkingEventType)type eventName:(NSString *)eventName params:(NSDictionary * __nullable )params;

/// 普通事件统计
/// @param eventName 名
/// @param params 参数
- (void)fb_event:(NSString *)eventName params:(NSDictionary * __nullable )params;

/// 通知外部刷新首页直播数据
- (void)fb_reloadHomeList;

/// 横幅广播点击
/// @param type 类型 //1 ChatRoom 2 Live 3 UGC
/// @param hostAccountId id
/// @param roomId roomid
/// @param agoraRoomId id
- (void)fb_broadcastWithType:(int)type
               hostAccountId:(NSInteger)hostAccountId
                      roomId:(NSInteger)roomId
                 agoraRoomId:(NSString *)agoraRoomId;

/// 加载svip购买页
- (void)fb_toDisplaySvipRechargePage;

/// 点击0.99优惠项
- (void)fb_click099DisCountItem;

/// 点击4.99优惠项
- (void)fb_click499DisCountItem;

@end

#pragma mark - GYLiveManager

@interface GYLiveManager : NSObject

/*-------------------------------------------------------------------
 配置
 */
/// 声网ID
@property (nonatomic, strong) NSString *agoraAppId;
/// 配置文件
@property (nonatomic, strong) GYLiveConfiguration *config;
/// 外传内（数据）
@property (nonatomic, strong) GYLiveInside *inside;
///
@property (nonatomic, weak) id<GYLiveManagerDataSource> dataSource;

@property (nonatomic, weak) id<GYLiveManagerDelegate> delegate;

/*-------------------------------------------------------------------
 直播间状态参数
 */
/// 在直播模块中
@property (nonatomic, readonly) BOOL inModule;
/// 在一个直播间中
@property (nonatomic, readonly) BOOL inARoom;
/// 最小化
@property (nonatomic, readonly) BOOL isMinimize;
/// 声网引擎
@property (nonatomic, strong) AgoraRtcEngineKit * __nullable agoraKit;
/// 当前房间数据
@property (nonatomic, readonly) GYLiveRoom * __nullable room;

/*-------------------------------------------------------------------
 */

+ (GYLiveManager *)sharedManager;

#pragma mark - 对外接口

/// 初始化直播模块
/// @param agoraAppId 声网ID
/// @param dataSource 代理
/// @param delegate 代理
/// @param configuration 配置
- (void)fb_initWithAgoraAppId:(NSString *)agoraAppId
                 configuration:(GYLiveConfiguration * __nullable )configuration
                    dataSource:(id<GYLiveManagerDataSource>)dataSource
                      delegate:(id<GYLiveManagerDelegate>)delegate;

/// 退出直播模块
- (void)fb_logout;

/// 通过ID加入房间（画面出现相对较慢）（由于需要统计进入渠道，外部自己实现事件统计）
/// @param hostAccountId ID
/// @param operation 操作（推出liveVc）
/// @param from 渠道
- (void)fb_joinRoomByHostAccountId:(NSInteger)hostAccountId
                              from:(GYLiveJoinFrom)from
                         operation:(void(^) (UIViewController *vc))operation;

/// 加入房间（由于需要统计进入渠道，外部自己实现事件统计）
/// @param rooms 字典数组或者对象数组（内部会调用MJ转换，单个room至少含有hostAccountId及agoraRoomId）
/// @param index 在rooms中的下标
/// @param operation 操作（推出vc）
/// @param from 渠道
- (void)fb_joinRoomWith:(NSArray *)rooms
                atIndex:(NSInteger)index
                   from:(GYLiveJoinFrom)from
              operation:(void(^) (UIViewController *vc))operation;

/// 最小化房间
- (void)fb_minimize;

/// 关闭房间
- (void)fb_close;

/// 接收sse推送
/// @param eventData SSEResponse
- (void)fb_sseEventData:(NSDictionary *)eventData;

#pragma mark - 数据传递（外部通知直播模块）

/// 外部金币更新，通知直播间
/// @param leftDiamond 最新余额
- (void)fb_outsideCoinsUpdate:(NSInteger)leftDiamond;

/// 外部关注某人，通知直播间
/// @param status 是否关注（0：未关注，1：已关注）
/// @param targetAccountId ID
- (void)fb_outsideFollowStatus:(NSInteger)status targetAccountId:(NSInteger)targetAccountId;

/// 外部选中标签，通知直播间
/// @param uniqueTag 标签
- (void)fb_outsideDidSelectedUniqueTag:(GYUniqueTag *)uniqueTag;

@end

NS_ASSUME_NONNULL_END
