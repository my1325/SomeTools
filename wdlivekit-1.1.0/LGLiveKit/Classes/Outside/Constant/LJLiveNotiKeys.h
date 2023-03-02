//
//  LJLiveNotiKeys.h
//  Woohoo
//
//  Created by HUANGCHENG on 2021/6/1.
//  Copyright © 2021 tt. All rights reserved.
//

#ifndef LJLiveNotiKeys_h
#define LJLiveNotiKeys_h

#pragma mark - SSE

// 开放视频聊天室功能【用来动态调整首页标签顺序】
static NSString *kLJLiveFeatureOpened            = @"kLJLiveFeatureOpened";
// 关闭视频聊天室功能【用来动态调整首页标签顺序】
static NSString *kLJLiveFeatureClosed            = @"kLJLiveFeatureClosed";
// 老视频聊天室关闭
static NSString *kLJLiveOldClosed                = @"kLJLiveOldClosed";
// 新视频聊天室开启
static NSString *kLJLiveNewCreated               = @"kLJLiveNewCreated";
// 视频聊天室恢复
static NSString *kLJLiveResumed                  = @"kLJLiveResumed";
// 视频聊天室编辑
static NSString *kLJLiveEdited                   = @"kLJLiveEdited";
// 视频聊天室解散
static NSString *kLJLiveDestroyed                = @"kLJLiveDestroyed";
// 视频聊天室私聊开关改变
static NSString *kLJLivePrivateChatFlagChanged   = @"kLJLivePrivateChatFlagChanged";
// 视频聊天室主持人被带走
static NSString *kLJLiveHostIsTakenAway          = @"kLJLiveHostIsTakenAway";
// 视频聊天室主持人收到礼物
static NSString *kLJLiveHostReceivedGift         = @"kLJLiveHostReceivedGift";
// 被视频聊天室主持人踢出
static NSString *kLJLiveKickedOut                = @"kLJLiveKickedOut";
// 通知关注更新（已关注：1），携带数组：@[@(targetAccountId), @(1)]
static NSString *kLJLiveFollowStatusUpdate       = @"kLJLiveFollowStatusUpdate";

// 视频聊天室目标更新
static NSString *kLJLiveGoalUpdated              = @"kLJLiveGoalUpdated";
// 视频聊天室目标达成
static NSString *kLJLiveGoalDone                 = @"kLJLiveGoalDone";

//// 语音聊天室目标更新
//static NSString *kLJChatRoomGoalUpdated          = @"kLJChatRoomGoalUpdated";
//// 语音聊天室目标达成
//static NSString *kLJChatRoomGoalDone             = @"kLJChatRoomGoalDone";


#pragma mark - 盲盒

// 是否点击过盲盒
static NSString *kLJLiveLuckyBoxClicked = @"kLJLiveLuckyBoxClicked";

// 是否关闭过弹窗
static NSString *kLJLiveLuckyBoxCloseClicked = @"kLJLiveLuckyBoxCloseClicked";


#endif /* LJLiveNotiKeys_h */
