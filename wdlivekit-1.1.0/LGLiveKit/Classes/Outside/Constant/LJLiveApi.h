//
//  LJLiveApi.h
//  Woohoo
//
//  Created by HUANGCHENG on 2021/6/1.
//  Copyright © 2021 tt. All rights reserved.
//

#ifndef LJLiveApi_h
#define LJLiveApi_h


/// 活动标签列表
#define kLJLiveApi_Account_GetEventLabelList    @"/api/Account/GetEventLabelList"
/// 设置标签
#define kLJLiveApi_Account_SetDefaultEventLabel @"/api/Account/SetDefaultEventLabel"
/// 设置标签顺序
#define kLJLiveApi_Account_SetEventLabelSequence @"/api/Account/SetEventLabelSequence"
/// 获取用户信息
#define kLJLiveApi_Account_GetUserInfo          @"/api/Account/GetUserInfo"
/// 根据主播信息
#define kLJLiveApi_Account_getAnchorInfo        @"/api/Account/GetAnchorInfo"

/// 关注
#define kLJLiveApi_Account_Follow               @"/api/Account/Follow"
/// 取消关注
#define kLJLiveApi_Account_CancelFollow         @"/api/Account/CancelFollow"

/// 拉黑
#define kLJLiveApi_Account_Block                @"/api/Account/Block"
/// 取消拉黑
#define kLJLiveApi_Account_CancelBlock                @"/api/Account/CancelBlock"
/// 举报
#define kLJLiveApi_Account_Report               @"/api/Account/Report"


/// 加入房间【用户/主播】
#define kLJLiveApi_Room_JoinRoom                        @"/api/VideoChatRoom/JoinRoom"
/// 加入房间【用户/主播】
#define kLJLiveApi_Room_JoinRoomByHostId                @"/api/VideoChatRoom/JoinRoomByHostId"
/// 离开房间【用户/主播】
#define kLJLiveApi_Room_LeaveRoom                       @"/api/VideoChatRoom/LeaveRoom"

/// 用户送礼【用户】
#define kLJLiveApi_Room_UserSendGift                    @"/api/VideoChatRoom/UserSendGift"
/// 用户带走主播【用户】
#define kLJLiveApi_Room_UserTakeHost                    @"/api/VideoChatRoom/UserTakeHost"

/// 获取关注主播列表【用户】
#define kLJLiveApi_Room_GetFollowingAnchorList          @"/api/VideoChatRoom/GetFollowingAnchorList"
/// 获取视频聊天室列表【用户/主播】
#define kLJLiveApi_Room_GetRoomList                     @"/api/VideoChatRoom/GetRoomList"
/// 获取房间信息【用户/主播】
#define kLJLiveApi_Room_GetRoomInfo                     @"/api/VideoChatRoom/GetRoomInfo"
/// 获取视频聊天室主播信息【用户/主播】
#define kLJLiveApi_Room_GetVideoChatRoomAnchorInfo      @"/api/VideoChatRoom/GetVideoChatRoomAnchorInfo"
/// 获取视频聊天室用户信息【用户/主播】
#define kLJLiveApi_Room_GetVideoChatRoomUserInfo        @"/api/VideoChatRoom/GetVideoChatRoomUserInfo"
/// 获取PK房间Top Fans
#define kLJLiveApi_Room_GetVideoChatRoomPKTopFanList    @"/api/VideoChatRoom/GetVideoChatRoomPKTopFanList"
/// 获取多人聊天室列表【用户/主播】
#define kLJLiveApi_Room_GetMultiplayerChatRoomList      @"/api/VideoChatRoom/GetMultiplayerChatRoomList"
/// 获取多人聊天室关注主播列表【用户】
#define kLJLiveApi_Room_GetMultiplayerChatRoomFollowingAnchorList   @"/api/VideoChatRoom/GetMultiplayerChatRoomFollowingAnchorList"
/// 获取房间禁言列表
#define kLJLiveApi_Room_GetMutedMembers         @"/api/VideoChatRoom/GetMutedMembers"

/// 礼物阅读标签
#define kLJLiveApi_Room_SetGiftViewed           @"/api/VideoChatRoom/SetGiftViewed"

/// 发送文字消息【用户/主播】
#define kLJLiveApi_Room_SendTextMsg          @"/api/VideoChatRoom/SendTextMsg"


#pragma mark - UGC

/// 加入房间 /api/UgcVideoChatRoom/JoinRoomByHostId
/// 离开房间 /api/UgcVideoChatRoom/LeaveRoom
/// 送礼 /api/UgcVideoChatRoom/UserSendGift
/// 获取直播间列表 /api/UgcVideoChatRoom/GetRoomList
/// 获取直播间信息 /api/UgcVideoChatRoom/GetRoomInfo
/// 获取直播间用户信息 /api/UgcVideoChatRoom/GetVideoChatRoomUserInfo
/// 用户举报主播 /api/UgcVideoChatRoom/ReportRoom

/// 加入房间【用户/主播】
#define kLJLiveApi_UgcRoom_JoinRoomByHostId                @"/api/UgcVideoChatRoom/JoinRoomByHostId"
/// 离开房间【用户/主播】
#define kLJLiveApi_UgcRoom_LeaveRoom                       @"/api/UgcVideoChatRoom/LeaveRoom"
/// 用户送礼【用户】
#define kLJLiveApi_UgcRoom_UserSendGift                    @"/api/UgcVideoChatRoom/UserSendGift"
/// 获取视频聊天室列表【用户/主播】
#define kLJLiveApi_UgcRoom_GetRoomList                     @"/api/UgcVideoChatRoom/GetRoomList"
/// 获取房间信息【用户/主播】
#define kLJLiveApi_UgcRoom_GetRoomInfo                     @"/api/UgcVideoChatRoom/GetRoomInfo"
/// 获取视频聊天室用户信息【用户/主播】
#define kLJLiveApi_UgcRoom_GetVideoChatRoomUserInfo        @"/api/UgcVideoChatRoom/GetVideoChatRoomUserInfo"
/// 举报
#define kLJLiveApi_UgcRoom_ReportRoom                   @"/api/UgcVideoChatRoom/ReportRoom"
/// 获取被禁言成员列表【主播】
#define kLJLiveApi_UgcRoom_GetMutedMembers              @"/api/UgcVideoChatRoom/GetMutedMembers"

#endif /* LJLiveApi_h */
