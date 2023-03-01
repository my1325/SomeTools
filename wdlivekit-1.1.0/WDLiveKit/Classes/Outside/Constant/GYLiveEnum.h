//
//  GYLiveEnum.h
//  Woohoo
//
//  Created by M1-mini on 2022/4/27.
//  Copyright © 2022 tt. All rights reserved.
//

#ifndef GYLiveEnum_h
#define GYLiveEnum_h

// 直播间角色
typedef NS_ENUM(NSUInteger, GYLiveUserType) {
    GYLiveUserTypeAnchor = 0,   // 主播
    GYLiveUserTypeUser,     // 用户
};

/// 角色
typedef NS_ENUM(NSUInteger, GYLiveRoleType) {
    GYLiveRoleTypeUser = 1,   // 用户
    GYLiveRoleTypeAnchor,     // 主播
};

/// 特权
typedef NS_ENUM(NSInteger, GYLivePrivilege) {
    GYLivePrivilegeHeaderFrame = 1,
    GYLivePrivilegePrimaryTreasureCase = 2,
    GYLivePrivilegeFreeMessage = 3,
    GYLivePrivilegeInRoom = 4,
    GYLivePrivilegeSeniorTreasureCase = 5,
    GYLivePrivilegeInvisible = 6,
    GYLivePrivilegeSupermeHeaderFrame = 7    // 至尊头像框
};

/// 接口请求类型
typedef NS_ENUM(NSUInteger, GYLiveRequestMethod) {
    GYLiveRequestMethodGet = 0,
    GYLiveRequestMethodPost,
};

/// 弹窗样式
typedef NS_ENUM(NSUInteger, GYLiveTipStatus) {
    GYLiveTipStatusSuccess = 0,
    GYLiveTipStatusError,
    GYLiveTipStatusWarning,
};

/// Firbase统计类型
typedef NS_ENUM(NSUInteger, GYLiveFirbaseEventType) {
    GYLiveFirbaseEventTypeSpendCurrency,   // params携带：way，value
};

/// 数数统计类型
typedef NS_ENUM(NSUInteger, GYLiveThinkingEventType) {
    GYLiveThinkingEventTypeEvent,
    GYLiveThinkingEventTypeTimeEvent,
};

/// Live直播间弹幕类型
typedef NS_ENUM(NSUInteger, GYLiveBarrageType) {
    GYLiveBarrageTypeHint = 1,          // 系统提示
    GYLiveBarrageTypeJoinLive = 2,      // 加入直播间
    GYLiveBarrageTypeTextMessage = 3,   // 文本消息
    GYLiveBarrageTypeGift = 4,          // 礼物
    GYLiveBarrageTypeBeMute = 5,        // 被禁言
    GYLiveBarrageTypeCancelMute = 6,    // 被取消禁言
    GYLiveBarrageTypeLiveRoomInfo = 7,  // 房间信息
    GYLiveBarrageTypeTakeAnchor = 8,    // 带走主播
    GYLiveBarrageTypePKMatchSuccessed = 9,  // PK匹配成功
    GYLiveBarrageTypePKEnded = 10,          // PK结束
    GYLiveBarrageTypePKPointUpdated = 11,   // PK分数更新
    GYLiveBarrageTypePKTimeUp = 12,         // PK时间到 携带pkwinner
    GYLiveBarrageTypePKOnceMore = 13,       // PK再来一次
    GYLiveBarrageTypePKRunAway = 14,        // PK逃跑
    GYLiveBarrageTypePKPrivateFlagChange = 15,     // 私聊按钮开关
    GYLiveBarrageTypeMembersInfo = 16,             // 刷新观众信息
    GYLiveBarrageTypeOppsiteVideo = 17,        // 通知对面视频开关
    GYLiveBarrageTypeTurntableInfo = 18,       // 通知更新转盘信息以及转盘结果
    GYLiveBarrageTypeMutedMembers = 19,        // 禁言列表
};

/// Live直播间操作
typedef NS_ENUM(NSUInteger, GYLiveEvent) {
    
    GYLiveEventMinimize,        // 最小化房间
    GYLiveEventClose,           // 关闭房间
    GYLiveEventMembers,         // 打开排行
    GYLiveEventGifts,           // 打开礼物列表
    GYLiveEventFastGift,        // 点击快速礼物
    GYLiveEventPersonalData,    // 头像
    GYLiveEventWallet,          // 打开钱包
    GYLiveEventFollow,          // 关注（1：关注，0：未关注）
    GYLiveEventSendBarrage,     // 发送弹幕
    GYLiveEventPrivateChat,     // 私聊带走
    GYLiveEventSendGift,        // 点击送礼物（携带GYGiftConfig）
    //
    GYLiveEventRoomLeave,             // 清理/重置UI
    GYLiveEventReceivedBarrage,         // 收到弹幕
    GYLiveEventUpdateRoomInfo,          // 更新房间信息
    GYLiveEventUpdatePrivateChat,       // 更新私聊按钮状态
    // PK
    GYLiveEventPKReceiveVideo,          // PK幕布更新（仅刷新布局）
    GYLiveEventPKReceiveMatchSuccessed, // PK配对成功，携带pkdata
    GYLiveEventPKReceivePointUpdate,    // PK比方更新，携带pointupdateMsg
    GYLiveEventPKReceiveTimeUp,         // PK倒计时结束，携带pkwinner
    GYLiveEventPKReceiveReady,          // 再次PK，准备，携带accountid
    GYLiveEventPKEnded,                 // 结束PK，恢复UI布局等
    GYLiveEventPKRunAway,               // 结束PK，恢复UI布局，逃跑提示等
    GYLiveEventPKOpenHomeRank,               // 点击主场排行
    GYLiveEventPKOpenAwayRank,               // 点击客场排行
    GYLiveEventPKOpenAwayRoom,               // 点击跳到客场房间
    GYLiveEventPKReceiveAudioMuted,          // PK音频开关
    GYLiveEventPKReceiveVideoMuted,          // PK视频开关
    
    GYLiveGoalUpdate,                  // 目标更新
    GYLiveEventHideOpposite,           // 隐藏
    GYLiveEventTurnPlateUpdate,        // 转盘信息更新
    
    GYLiveEventReport,                  // 举报
    GYLiveEventOpenMenu,                // 打开菜单
    GYLiveEventRechargeSuccess,         // 充值成功
};

typedef NS_ENUM(NSUInteger, GYLiveJoinFrom) {
    GYLiveJoinFromNone = 0,         // 默认
    GYLiveJoinFromBroadcast = 1,    // 横幅
};

// 通用Block
typedef void(^GYLiveIntegerBlock) (NSInteger intValue);
typedef void(^GYLiveObjectBlock) (id __nullable object);
typedef void(^GYLiveVoidBlock) (void);
typedef void(^GYLiveBoolBlock) (BOOL boolValue);
typedef void(^GYLiveTextBlock) (NSString * __nullable stringValue);
typedef void(^GYLiveArrayBlock) (NSArray * __nullable arrayValue);
typedef void(^GYLiveResponseBlock) (__kindof id _Nullable responseObj);

// 直播间事件回调
typedef void(^GYLiveEventBlock)(GYLiveEvent event, id _Nullable object);

#endif /* GYLiveEnum_h */
