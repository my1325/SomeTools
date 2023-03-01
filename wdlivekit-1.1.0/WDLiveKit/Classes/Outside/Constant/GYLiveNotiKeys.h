//
//  GYLiveNotiKeys.h
//  Woohoo
//
//  Created by HUANGCHENG on 2021/6/1.
//  Copyright © 2021 tt. All rights reserved.
//

#ifndef GYLiveNotiKeys_h
#define GYLiveNotiKeys_h

#pragma mark - SSE

// 开放视频聊天室功能【用来动态调整首页标签顺序】
static NSString *kGYLiveFeatureOpened            = @"kGYLiveFeatureOpened";
// 关闭视频聊天室功能【用来动态调整首页标签顺序】
static NSString *kGYLiveFeatureClosed            = @"kGYLiveFeatureClosed";
// 老视频聊天室关闭
static NSString *kGYLiveOldClosed                = @"kGYLiveOldClosed";
// 新视频聊天室开启
static NSString *kGYLiveNewCreated               = @"kGYLiveNewCreated";
// 视频聊天室恢复
static NSString *kGYLiveResumed                  = @"kGYLiveResumed";
// 视频聊天室编辑
static NSString *kGYLiveEdited                   = @"kGYLiveEdited";
// 视频聊天室解散
static NSString *kGYLiveDestroyed                = @"kGYLiveDestroyed";
// 视频聊天室私聊开关改变
static NSString *kGYLivePrivateChatFlagChanged   = @"kGYLivePrivateChatFlagChanged";
// 视频聊天室主持人被带走
static NSString *kGYLiveHostIsTakenAway          = @"kGYLiveHostIsTakenAway";
// 视频聊天室主持人收到礼物
static NSString *kGYLiveHostReceivedGift         = @"kGYLiveHostReceivedGift";
// 被视频聊天室主持人踢出
static NSString *kGYLiveKickedOut                = @"kGYLiveKickedOut";
// 通知关注更新（已关注：1），携带数组：@[@(targetAccountId), @(1)]
static NSString *kGYLiveFollowStatusUpdate       = @"kGYLiveFollowStatusUpdate";

// 视频聊天室目标更新
static NSString *kGYLiveGoalUpdated              = @"kGYLiveGoalUpdated";
// 视频聊天室目标达成
static NSString *kGYLiveGoalDone                 = @"kGYLiveGoalDone";

//// 语音聊天室目标更新
//static NSString *kGYChatRoomGoalUpdated          = @"kGYChatRoomGoalUpdated";
//// 语音聊天室目标达成
//static NSString *kGYChatRoomGoalDone             = @"kGYChatRoomGoalDone";


#pragma mark - 盲盒

// 是否点击过盲盒
static NSString *kGYLiveLuckyBoxClicked = @"kGYLiveLuckyBoxClicked";

// 是否关闭过弹窗
static NSString *kGYLiveLuckyBoxCloseClicked = @"kGYLiveLuckyBoxCloseClicked";


#endif /* GYLiveNotiKeys_h */
