//
//  LJLiveManager.h
//  Woohoo
//
//  Created by M1-mini on 2022/4/24.
//  Copyright © 2022 tt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJLiveHeader.h"
#import "LJLiveConfiguration.h"
#import "LJLiveInside.h"
//#import "LJLiveRadioGift.h"

NS_ASSUME_NONNULL_BEGIN

#define kLJLiveManager [LJLiveManager sharedManager]
@protocol LJLiveManagerDataSource <NSObject>
- (NSString *)lj_localizableAbbr;
/// 当前多语言本地化简写（支持：en，ar，tr）
/// 弹幕敏感词屏蔽：返回过滤后的文案


- (NSString *)lj_sensitiveReplaceByText:(NSString *)text;
/// @param text 原文案

@optional/// 网络状态
/// 绑定RTM代理
- (nullable AgoraRtcEngineKit *)lj_rtcKit;

/// @param delegate 对象

@required/// SSE状态
///获取rtc
- (NSString *)lj_session;
/// session


- (id)lj_account;
- (id)lj_accountConfig;
/// 账号配置：字典，或者对象



- (NSInteger)lj_sseStatus;

/// 账号：字典，或者对象
- (AgoraRtmKit *)lj_bindingRTMDelegate:(id _Nullable)delegate;
- (NSInteger)lj_networkStatus;

@end

@protocol LJLiveManagerDelegate <NSObject>
- (void)lj_showLoading;
- (void)lj_thinking:(LJLiveThinkingEventType)type eventName:(NSString *)eventName params:(NSDictionary * __nullable )params;

/// @param params 参数
- (void)lj_event:(NSString *)eventName params:(NSDictionary * __nullable )params;

/// 数数统计
/// 横幅广播点击
/// @param type 类型
/// 普通事件统计


/// 通知外部刷新首页直播数据

/// 点击4.99优惠项
/// 点击0.99优惠项
/// @param hostAccountId id
- (void)lj_click499DisCountItem;
/// @param eventName 名
/// @param roomId roomid
- (void)lj_broadcastWithType:(int)type
               hostAccountId:(NSInteger)hostAccountId
                      roomId:(NSInteger)roomId
                 agoraRoomId:(NSString *)agoraRoomId;

- (void)lj_firbase:(LJLiveFirbaseEventType)type params:(NSDictionary * __nullable )params;
/// @param params 参数
/// @param type 类型

- (void)lj_click099DisCountItem;
- (void)lj_reloadHomeList;
/// Firbase精细化打点


/// @param eventName 名
@optional/// 加载svip购买页
/// @param agoraRoomId id


- (void)lj_hideLoading;
- (void)lj_toDisplaySvipRechargePage;
/// @param type 类型 //1 ChatRoom 2 Live 3 UGC
/// @param params 参数
/// @param success 成功

/// 跳转详情
/// @param roleType 角色
- (void)lj_insideCoinsUpdateWith:(NSInteger)leftDiamond;
/// @param query 参数

- (void)lj_requestWay:(LJLiveRequestMethod)requestWay
            requestApi:(NSString *)api
                 query:(NSDictionary * __nullable )query
                  body:(id __nullable )body
               success:(void(^) (id responseObj))success
               failure:(void(^) (NSString * __nullable error))failure;
/// 跳转回话
/// @param uniqueTag 标签
/// 跳转内购页

/// @param status 是否关注（0：未关注，1：已关注）
- (void)lj_jumpConversationWithRoleType:(LJLiveRoleType)roleType account:(LJLiveAccount *)account;

/// @param failure 失败
/// @param account 角色信息

/// @param api 接口
@required/// 内部关注某人，通知外部
- (void)lj_tipWithText:(NSString *)text status:(LJLiveTipStatus)status delay:(float)delay;
/// @param delay 延迟消失
- (void)lj_jumpToPrivate:(LJLivePrivate *)privateChat;
/// 跳转私聊通话


/// @param body 参数

/// 内部消费金币，通知外部
/// @param success 成功

/// @param requestWay 方式
/// @param roleType 角色
- (void)lj_uploadImage:(UIImage *)image
                success:(void(^) (NSString *imageURL))success
                failure:(LJLiveVoidBlock)failure;
/// @param image 图片


- (void)lj_jumpDetailWithRoleType:(LJLiveRoleType)roleType account:(LJLiveAccount *)account;
/// 弹窗
- (void)lj_insideFollowStatusUpdateWithStatus:(NSInteger)status targetAccountId:(NSInteger)targetAccountId;
/// 内部设置标签，通知外部
- (void)lj_buyViewOpenAt:(UIView *)atView;
/// 上传图片
/// @param atView 父视图


/// @param failure 失败
/// @param account 角色信息
/// @param targetAccountId ID
- (void)lj_insideDidSelectedUniqueTag:(LJUniqueTag * __nullable )uniqueTag;
/// @param text 文案
/// @param privateChat 信息
/// @param leftDiamond 更新
/// 请求
/// 充值成功统计外部自己实现
/// @param status 样式
- (void)lj_jumpToRecharge;
@end

#pragma mark - LJLiveManager

@interface LJLiveManager : NSObject






#pragma mark - 对外接口








#pragma mark - 数据传递（外部通知直播模块）




/// 最小化
/// 关闭房间
/// @param targetAccountId ID
/// @param from 渠道
/// 初始化直播模块
/// @param delegate 代理
/// 外部选中标签，通知直播间
/// 当前房间数据
/// 加入房间（由于需要统计进入渠道，外部自己实现事件统计）
/// 在一个直播间中
/// @param status 是否关注（0：未关注，1：已关注）
/// 最小化房间
/// 声网ID
/// 通过ID加入房间（画面出现相对较慢）（由于需要统计进入渠道，外部自己实现事件统计）
/// @param uniqueTag 标签
///
/// 外传内（数据）
/// @param agoraAppId 声网ID
/// @param index 在rooms中的下标
/// @param eventData SSEResponse
/// 配置文件
/*-------------------------------------------------------------------
 配置
 */
/*-------------------------------------------------------------------
 */
/// @param operation 操作（推出liveVc）
/// @param from 渠道
/// @param configuration 配置
/// @param operation 操作（推出vc）
/// 外部关注某人，通知直播间
/// @param rooms 字典数组或者对象数组（内部会调用MJ转换，单个room至少含有hostAccountId及agoraRoomId）
/// @param leftDiamond 最新余额
/*-------------------------------------------------------------------
 直播间状态参数
 */
/// @param dataSource 代理
/// 声网引擎
/// 接收sse推送
/// 在直播模块中
/// @param hostAccountId ID
/// 退出直播模块
/// 外部金币更新，通知直播间
- (void)lj_outsideDidSelectedUniqueTag:(LJUniqueTag *)uniqueTag;
- (void)lj_outsideFollowStatus:(NSInteger)status targetAccountId:(NSInteger)targetAccountId;
- (void)lj_sseEventData:(NSDictionary *)eventData;
- (void)lj_joinRoomByHostAccountId:(NSInteger)hostAccountId
                              from:(LJLiveJoinFrom)from
                         operation:(void(^) (UIViewController *vc))operation;
- (void)lj_outsideCoinsUpdate:(NSInteger)leftDiamond;
- (void)lj_joinRoomWith:(NSArray *)rooms
                atIndex:(NSInteger)index
                   from:(LJLiveJoinFrom)from
              operation:(void(^) (UIViewController *vc))operation;
- (void)lj_logout;
- (void)lj_minimize;
- (void)lj_close;
- (void)lj_initWithAgoraAppId:(NSString *)agoraAppId
                 configuration:(LJLiveConfiguration * __nullable )configuration
                    dataSource:(id<LJLiveManagerDataSource>)dataSource
                      delegate:(id<LJLiveManagerDelegate>)delegate;
+ (LJLiveManager *)sharedManager;
@property (nonatomic, strong) NSString *agoraAppId;
@property (nonatomic, readonly) BOOL inARoom;
@property (nonatomic, strong) LJLiveInside *inside;
@property (nonatomic, readonly) BOOL inModule;
@property (nonatomic, readonly) LJLiveRoom * __nullable room;
@property (nonatomic, weak) id<LJLiveManagerDelegate> delegate;
@property (nonatomic, strong) AgoraRtcEngineKit * __nullable agoraKit;
@property (nonatomic, strong) LJLiveConfiguration *config;
@property (nonatomic, weak) id<LJLiveManagerDataSource> dataSource;
@property (nonatomic, readonly) BOOL isMinimize;
@end

NS_ASSUME_NONNULL_END
