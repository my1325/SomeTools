//
//  LJLiveEnum.h
//  Woohoo
//
//  Created by M1-mini on 2022/4/27.
//  Copyright © 2022 tt. All rights reserved.
//

#ifndef LJLiveEnum_h
#define LJLiveEnum_h

// 直播间角色
typedef NS_ENUM(NSUInteger, LJLiveUserType) {
    LJLiveUserTypeAnchor = 0,   // 主播
    LJLiveUserTypeUser,     // 用户
};

/// 角色
typedef NS_ENUM(NSUInteger, LJLiveRoleType) {
    LJLiveRoleTypeUser = 1,   // 用户
    LJLiveRoleTypeAnchor,     // 主播
};

/// 特权
typedef NS_ENUM(NSInteger, LJLivePrivilege) {
    LJLivePrivilegeHeaderFrame = 1,
    LJLivePrivilegePrimaryTreasureCase = 2,
    LJLivePrivilegeFreeMessage = 3,
    LJLivePrivilegeInRoom = 4,
    LJLivePrivilegeSeniorTreasureCase = 5,
    LJLivePrivilegeInvisible = 6,
    LJLivePrivilegeSupermeHeaderFrame = 7    // 至尊头像框
};

/// 接口请求类型
typedef NS_ENUM(NSUInteger, LJLiveRequestMethod) {
    LJLiveRequestMethodGet = 0,
    LJLiveRequestMethodPost,
};

/// 弹窗样式
typedef NS_ENUM(NSUInteger, LJLiveTipStatus) {
    LJLiveTipStatusSuccess = 0,
    LJLiveTipStatusError,
    LJLiveTipStatusWarning,
};

/// Firbase统计类型
typedef NS_ENUM(NSUInteger, LJLiveFirbaseEventType) {
    LJLiveFirbaseEventTypeSpendCurrency,   // params携带：way，value
};

/// 数数统计类型
typedef NS_ENUM(NSUInteger, LJLiveThinkingEventType) {
    LJLiveThinkingEventTypeEvent,
    LJLiveThinkingEventTypeTimeEvent,
};

/// Live直播间弹幕类型
typedef NS_ENUM(NSUInteger, LJLiveBarrageType) {
    LJLiveBarrageTypeHint = 1,          // 系统提示
    LJLiveBarrageTypeJoinLive = 2,      // 加入直播间
    LJLiveBarrageTypeTextMessage = 3,   // 文本消息
    LJLiveBarrageTypeGift = 4,          // 礼物
    LJLiveBarrageTypeBeMute = 5,        // 被禁言
    LJLiveBarrageTypeCancelMute = 6,    // 被取消禁言
    LJLiveBarrageTypeLiveRoomInfo = 7,  // 房间信息
    LJLiveBarrageTypeTakeAnchor = 8,    // 带走主播
    LJLiveBarrageTypePKMatchSuccessed = 9,  // PK匹配成功
    LJLiveBarrageTypePKEnded = 10,          // PK结束
    LJLiveBarrageTypePKPointUpdated = 11,   // PK分数更新
    LJLiveBarrageTypePKTimeUp = 12,         // PK时间到 携带pkwinner
    LJLiveBarrageTypePKOnceMore = 13,       // PK再来一次
    LJLiveBarrageTypePKRunAway = 14,        // PK逃跑
    LJLiveBarrageTypePKPrivateFlagChange = 15,     // 私聊按钮开关
    LJLiveBarrageTypeMembersInfo = 16,             // 刷新观众信息
    LJLiveBarrageTypeOppsiteVideo = 17,        // 通知对面视频开关
    LJLiveBarrageTypeTurntableInfo = 18,       // 通知更新转盘信息以及转盘结果
    LJLiveBarrageTypeMutedMembers = 19,        // 禁言列表
};

/// Live直播间操作
typedef NS_ENUM(NSUInteger, LJLiveEvent) {
    
    LJLiveEventMinimize,        // 最小化房间
    LJLiveEventClose,           // 关闭房间
    LJLiveEventMembers,         // 打开排行
    LJLiveEventGifts,           // 打开礼物列表
    LJLiveEventFastGift,        // 点击快速礼物
    LJLiveEventPersonalData,    // 头像
    LJLiveEventWallet,          // 打开钱包
    LJLiveEventFollow,          // 关注（1：关注，0：未关注）
    LJLiveEventSendBarrage,     // 发送弹幕
    LJLiveEventPrivateChat,     // 私聊带走
    LJLiveEventSendGift,        // 点击送礼物（携带LJGiftConfig）
    //
    LJLiveEventRoomLeave,             // 清理/重置UI
    LJLiveEventReceivedBarrage,         // 收到弹幕
    LJLiveEventUpdateRoomInfo,          // 更新房间信息
    LJLiveEventUpdatePrivateChat,       // 更新私聊按钮状态
    // PK
    LJLiveEventPKReceiveVideo,          // PK幕布更新（仅刷新布局）
    LJLiveEventPKReceiveMatchSuccessed, // PK配对成功，携带pkdata
    LJLiveEventPKReceivePointUpdate,    // PK比方更新，携带pointupdateMsg
    LJLiveEventPKReceiveTimeUp,         // PK倒计时结束，携带pkwinner
    LJLiveEventPKReceiveReady,          // 再次PK，准备，携带accountid
    LJLiveEventPKEnded,                 // 结束PK，恢复UI布局等
    LJLiveEventPKRunAway,               // 结束PK，恢复UI布局，逃跑提示等
    LJLiveEventPKOpenHomeRank,               // 点击主场排行
    LJLiveEventPKOpenAwayRank,               // 点击客场排行
    LJLiveEventPKOpenAwayRoom,               // 点击跳到客场房间
    LJLiveEventPKReceiveAudioMuted,          // PK音频开关
    LJLiveEventPKReceiveVideoMuted,          // PK视频开关
    
    LJLiveGoalUpdate,                  // 目标更新
    LJLiveEventHideOpposite,           // 隐藏
    LJLiveEventTurnPlateUpdate,        // 转盘信息更新
    
    LJLiveEventReport,                  // 举报
    LJLiveEventOpenMenu,                // 打开菜单
    LJLiveEventRechargeSuccess,         // 充值成功
};

typedef NS_ENUM(NSUInteger, LJLiveJoinFrom) {
    LJLiveJoinFromNone = 0,         // 默认
    LJLiveJoinFromBroadcast = 1,    // 横幅
};

// 通用Block
typedef void(^LJLiveIntegerBlock) (NSInteger intValue);
typedef void(^LJLiveObjectBlock) (id __nullable object);
typedef void(^LJLiveVoidBlock) (void);
typedef void(^LJLiveBoolBlock) (BOOL boolValue);
typedef void(^LJLiveTextBlock) (NSString * __nullable stringValue);
typedef void(^LJLiveArrayBlock) (NSArray * __nullable arrayValue);
typedef void(^LJLiveResponseBlock) (__kindof id _Nullable responseObj);

// 直播间事件回调
typedef void(^LJLiveEventBlock)(LJLiveEvent event, id _Nullable object);

#endif /* LJLiveEnum_h */
