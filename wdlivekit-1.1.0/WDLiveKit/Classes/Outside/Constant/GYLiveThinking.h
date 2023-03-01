//
//  GYLiveThinking.h
//  Woohoo
//
//  Created by M1-mini on 2022/4/25.
//  Copyright © 2022 tt. All rights reserved.
//

#ifndef GYLiveThinking_h
#define GYLiveThinking_h

#pragma mark - Event Names

/// 通用事件名
//static NSString * const GYLiveThinkingEventClickPurchase    = @"click_purchase";
//static NSString * const GYLiveThinkingEventPurchaseSuccess  = @"purchase_success";
static NSString * const GYLiveThinkingEventClickGift        = @"click_gift";
static NSString * const GYLiveThinkingEventSendGiftSuccess  = @"send_gift_success";
//static NSString * const GYLiveThinkingEventStartCallSuccess = @"start_call_success";
//static NSString * const GYLiveThinkingEventEndCallSuccess   = @"end_call_success";
static NSString * const GYLiveThinkingEventFollowSuccess    = @"follow_success";
/// 普通事件名
//static NSString * const GYLiveThinkingEventEnterHomePage               = @"enter_home_page";
//static NSString * const GYLiveThinkingEventEnterHostDetailPage         = @"enter_host_detail_page";
//static NSString * const GYLiveThinkingEventClickMessageFromDetail      = @"click_message_from_detail";
//static NSString * const GYLiveThinkingEventClickGiftsButtonInCall      = @"click_gifts_button_in_call";
//static NSString * const GYLiveThinkingEventClickRechargeButtonInCall   = @"click_recharge_button_in_call";
//static NSString * const GYLiveThinkingEventSendMessageSuccessInCall    = @"send_message_success_in_call";
//static NSString * const GYLiveThinkingEventCallEndClickLike        = @"call_end_click_like";
//static NSString * const GYLiveThinkingEventCallEndClickDislike     = @"call_end_click_dislike";
//static NSString * const GYLiveThinkingEventSearchContent           = @"search_content";
//static NSString * const GYLiveThinkingEventAcceptStartHuntingCall  = @"accept_start_hunting_call";
//static NSString * const GYLiveThinkingEventRefusedStartHuntingCall = @"refused_start_hunting_call";
//static NSString * const GYLiveThinkingEventNoRechargeFromHuntingCallEnd = @"no_recharge_from_hunting_call_end";
//static NSString * const GYLiveThinkingEventClickDiscountRechargeButtonInHuntingCall = @"click_discount_recharge_button_in_hunting_call";
//static NSString * const GYLiveThinkingEventRechargeSuccessWithin1minInHuntingCall  = @"recharge_success_within_1min_in_hunting_call";
//static NSString * const GYLiveThinkingEventRechargeSuccessWithin2minInHuntingCall  = @"recharge_success_within_2min_in_hunting_call";
//static NSString * const GYLiveThinkingEventEnterMultibeam      = @"enter_multibeam";
//static NSString * const GYLiveThinkingEventClickGiftSendAllInMultibeam     = @"click_gift_send_all_in_multibeam";
//static NSString * const GYLiveThinkingEventClickGiftsButtonInMultibeam     = @"click_gifts_button_in_multibeam";
//static NSString * const GYLiveThinkingEventClickPrivateButtonInMultibeam   = @"click_private_button_in_multibeam";
//static NSString * const GYLiveThinkingEventPrivateSuccessInMultibeam   = @"private_success_in_multibeam";
//static NSString * const GYLiveThinkingEventClickBossButtonInMultibeam  = @"click_boss_button_in_multibeam";
//static NSString * const GYLiveThinkingEventTimeForBossInMultibeam      = @"time_for_boss_in_multibeam";
//static NSString * const GYLiveThinkingEventClickCloseButtonInMultibeam = @"click_close_button_in_multibeam";
//static NSString * const GYLiveThinkingEventTimeForOneMultibeam         = @"time_for_one_multibeam";
//static NSString * const GYLiveThinkingEventCloseMultibeamByMinimize    = @"close_multibeam_by_minimize";
//static NSString * const GYLiveThinkingEventReturnMultibeamFromMinimize = @"return_multibeam_from_minimize";
static NSString * const GYLiveThinkingEventClickBannerInLiveMultibeam  = @"click_banner_in_live_multibeam";
//static NSString * const GYLiveThinkingEventEnterAppByNotification  = @"enter_app_by_notification";
static NSString * const GYLiveThinkingEventEnterLive               = @"enter_live";
static NSString * const GYLiveThinkingEventClickAutoSayHiInLive    = @"click_auto_say_hi_in_live";
static NSString * const GYLiveThinkingEventClickAutoFollowInLive   = @"click_auto_follow_in_live";
static NSString * const GYLiveThinkingEventClickAutoSendGiftInLive = @"click_auto_send_gift_in_live";
static NSString * const GYLiveThinkingEventTimeForOneLive          = @"time_for_one_live";
static NSString * const GYLiveThinkingEventClickHostAvatarInLive   = @"click_host_avatar_in_live";
static NSString * const GYLiveThinkingEventClickAudienceListInLive = @"click_audience_list_in_live";
static NSString * const GYLiveThinkingEventClickGiftsButtonInLive  = @"click_gifts_button_in_live";
static NSString * const GYLiveThinkingEventClickCloseButtonInLive  = @"click_close_button_in_live";
static NSString * const GYLiveThinkingEventCloseLiveByMinimize     = @"close_live_by_minimize";
static NSString * const GYLiveThinkingEventReturnLiveByMinimize    = @"return_live_by_minimize";
static NSString * const GYLiveThinkingEventClickRechargeButtonInLive   = @"click_recharge_button_in_live";
static NSString * const GYLiveThinkingEventSendBarrageInLive           = @"send_barrage_in_live";
static NSString * const GYLiveThinkingEventClickPrivateButtonInLive    = @"click_private_button_in_live";
static NSString * const GYLiveThinkingEventPrivateSuccessInLive    = @"private_success_in_live";
static NSString * const GYLiveThinkingEventSendGiftsWithin1minInPk = @"send_gifts_within_1min_in_pk";
static NSString * const GYLiveThinkingEventSendGiftsWithin2minInPk = @"send_gifts_within_2min_in_pk";
static NSString * const GYLiveThinkingEventSendGiftsWithin3minInPk = @"send_gifts_within_3min_in_pk";
static NSString * const GYLiveThinkingEventSendGiftsWithin4minInPk = @"send_gifts_within_4min_in_pk";
static NSString * const GYLiveThinkingEventSendGiftsWithin5minInPk = @"send_gifts_within_5min_in_pk";
static NSString * const GYLiveThinkingEventSendGiftsLast15secInPk  = @"send_gifts_last_15sec_in_pk";
static NSString * const GYLiveThinkingEventClickGiftRankInPk   = @"click_gift_rank_in_pk";
static NSString * const GYLiveThinkingEventTimeForOnePk        = @"time_for_one_pk";
static NSString * const GYLiveThinkingEventFirstRechargeWindowAppear       = @"first_recharge_window_appear";
static NSString * const GYLiveThinkingEventClickRechargeWindow        = @"click_recharge_window";


//static NSString * const GYLiveThinkingEventEnterMessagePage    = @"enter_message_page";
//static NSString * const GYLiveThinkingEventEnterConversationPage    = @"enter_conversation_page";
//static NSString * const GYLiveThinkingEventSendMessage         = @"send_message";
//static NSString * const GYLiveThinkingEventEnterVideoshowPage      = @"enter_videoshow_page";
//static NSString * const GYLiveThinkingEventEnterVideoshowScrollPage    = @"enter_videoshow_scroll_page";
//static NSString * const GYLiveThinkingEventEnterLeaderboardPage    = @"enter_leaderboard_page";
//static NSString * const GYLiveThinkingEventEnterLeaderboardIntimacy    = @"enter_leaderboard_intimacy";
//static NSString * const GYLiveThinkingEventEnterDetailFromHottest      = @"enter_detail_from_hottest";
//static NSString * const GYLiveThinkingEventClickFollowFromLeaderboard  = @"click_follow_from_leaderboard";
//static NSString * const GYLiveThinkingEventEnterMyCenterPage   = @"enter_my_center_page";
//static NSString * const GYLiveThinkingEventEnterRechargePage   = @"enter_recharge_page";
//static NSString * const GYLiveThinkingEventEnterSvipPage       = @"enter_svip_page";
//static NSString * const GYLiveThinkingEventEnterConsumptionRecord  = @"enter_consumption_record_page";
//static NSString * const GYLiveThinkingEventClickSignupInMyCenter   = @"click_signup_in_my_center";
//static NSString * const GYLiveThinkingEventEnterEditProfilePage  = @"enter_edit_profile_page";
//static NSString * const GYLiveThinkingEventClickRechargeButtonInNoCoinsWindow = @"click_recharge_button_in_no_coins_window";
//static NSString * const GYLiveThinkingEventClickLoginButton    = @"click_login_button";
//static NSString * const GYLiveThinkingEventLoginSuccess        = @"login_success";
//static NSString * const GYLiveThinkingEventClickImNewButton    = @"click_im_new_button";
//static NSString * const GYLiveThinkingEventEnterByTourist      = @"enter_by_tourist";
//static NSString * const GYLiveThinkingEventLoadingOpenAds      = @"loading_open_ads";
//static NSString * const GYLiveThinkingEventEnterWebByOpenAds   = @"enter_web_by_open_ads";
static NSString * const GYLiveThinkingEventSseLost             = @"sse_lost";

#pragma mark - Keys

//static NSString * const GYLiveThinkingKeyAppName       = @"app_name";
//static NSString * const GYLiveThinkingKeyAppChannel    = @"app_channel";
//static NSString * const GYLiveThinkingKeyServerVersion = @"server_version";
//static NSString * const GYLiveThinkingKeyEmail         = @"email";
static NSString * const GYLiveThinkingKeyAccountId     = @"account_id";
//static NSString * const GYLiveThinkingKeyNickname      = @"nickname";
//static NSString * const GYLiveThinkingKeyGender        = @"gender";
//static NSString * const GYLiveThinkingKeyAge           = @"age";
//static NSString * const GYLiveThinkingKeyTotalRevenue  = @"total_revenue";

//static NSString * const GYLiveThinkingKeyProductId         = @"product_id";
//static NSString * const GYLiveThinkingKeyRevenue           = @"revenue";
//static NSString * const GYLiveThinkingKeyOriRevenue        = @"ori_revenue";
//static NSString * const GYLiveThinkingKeyIsSvipItem        = @"is_svip_item";
//static NSString * const GYLiveThinkingKeyIsDiscountItem    = @"is_discount_item";
static NSString * const GYLiveThinkingKeyFrom              = @"from";

static NSString * const GYLiveThinkingKeyGiftId        = @"gift_id";
static NSString * const GYLiveThinkingKeyGiftName      = @"gift_name";
static NSString * const GYLiveThinkingKeyGiftCoins     = @"gift_coins";
static NSString * const GYLiveThinkingKeyIsLuckyBox    = @"is_luckybox";
static NSString * const GYLiveThinkingKeyIsFast        = @"is_fast";

//static NSString * const GYLiveThinkingKeyHungUpReason  = @"hung_up_reason";
static NSString * const GYLiveThinkingKeyFromDetail    = @"from_detail";

//static NSString * const GYLiveThinkingKeyContent   = @"content";
static NSString * const GYLiveThinkingKeyRoomId    = @"room_id";
//static NSString * const GYLiveThinkingKeyAnchorId  = @"anchor_id";

static NSString * const GYLiveThinkingKeyCoins         = @"coins";
//static NSString * const GYLiveThinkingKeyTime          = @"time";
//static NSString * const GYLiveThinkingKeyRoomType      = @"room_type";
//static NSString * const GYLiveThinkingKeyHostId        = @"host_id";
//static NSString * const GYLiveThinkingKeyHostDisplayId = @"host_display_id";

#pragma mark - Values

/// 内购渠道：live，private，hunting，multi-beam，recharge，svip，横幅广播
static NSString * const GYLiveThinkingValueLive         = @"live";
//static NSString * const GYLiveThinkingValuePrivate      = @"private";
//static NSString * const GYLiveThinkingValueHunting      = @"hunting";
//static NSString * const GYLiveThinkingValueMultibeam    = @"multi-beam";
//static NSString * const GYLiveThinkingValueRecharge     = @"recharge";
//static NSString * const GYLiveThinkingValueSvip         = @"svip";
static NSString * const GYLiveThinkingValueBroadcast    = @"broadcast";

/// 礼物渠道：live，private，hunting，multi-beam，match(Dama)
//static NSString * const GYLiveThinkingValueMatch        = @"match";

/// 通话渠道：live，multi-beam，detail，call-list，conversation，video-show，search，hunting, hunting-over,  host-list, following-list，match(Dama)
//static NSString * const GYLiveThinkingValueDetail          = @"detail";
//static NSString * const GYLiveThinkingValueCallList        = @"call-list";
//static NSString * const GYLiveThinkingValueConversation    = @"conversation";
//static NSString * const GYLiveThinkingValueVideoShow       = @"video-show";
//static NSString * const GYLiveThinkingValueSearch          = @"search";
//static NSString * const GYLiveThinkingValueHuntingOver     = @"hunting-over";
//static NSString * const GYLiveThinkingValueHostList        = @"host-list";
//static NSString * const GYLiveThinkingValueFollowingList   = @"following-list";

/// 挂断原因：user，anchor，no-coins，user-network，anchor-network，server-error
//static NSString * const GYLiveThinkingReasonUser           = @"user";
//static NSString * const GYLiveThinkingReasonAnchor         = @"anchor";
//static NSString * const GYLiveThinkingReasonNoCoins        = @"no-coins";
//static NSString * const GYLiveThinkingReasonUserNetwork    = @"user-network";
//static NSString * const GYLiveThinkingReasonAnchorNetwork  = @"anchor-network";
//static NSString * const GYLiveThinkingReasonServerError    = @"server-error";

/// 关注渠道：live，multi-beam，detail，rank，video-show，search，followers-list，match(Dama)
//static NSString * const GYLiveThinkingValueRank            = @"rank";
//static NSString * const GYLiveThinkingValueFollowersList   = @"followers-list";

/// 关注具体位置描述：live：head，auto-message，auto-follow-window，anchor-info-window
static NSString * const GYLiveThinkingValueDetailHead                = @"head";
static NSString * const GYLiveThinkingValueDetailAutoMessage         = @"auto-message";
static NSString * const GYLiveThinkingValueDetailAutoFollowWindow    = @"auto-follow-window";
static NSString * const GYLiveThinkingValueDetailAnchorInfoWindow    = @"anchor-info-window";

/// 其他
//static NSString * const GYLiveThinkingValueNotification    = @"notification";
//static NSString * const GYLiveThinkingValueHomeList        = @"home-list";
//static NSString * const GYLiveThinkingValueHomeDiscount099 = @"home-discount-0.99";
//static NSString * const GYLiveThinkingValueHomeDiscount499 = @"home-discount-4.99";
//static NSString * const GYLiveThinkingValueCallEnd         = @"call-end";

#endif /* GYLiveThinking_h */
