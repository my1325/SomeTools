//
//  LJLiveThinking.h
//  Woohoo
//
//  Created by M1-mini on 2022/4/25.
//  Copyright © 2022 tt. All rights reserved.
//

#ifndef LJLiveThinking_h
#define LJLiveThinking_h

#pragma mark - Event Names

/// 通用事件名
//static NSString * const LJLiveThinkingEventClickPurchase    = @"click_purchase";
//static NSString * const LJLiveThinkingEventPurchaseSuccess  = @"purchase_success";
static NSString * const LJLiveThinkingEventClickGift        = @"click_gift";
static NSString * const LJLiveThinkingEventSendGiftSuccess  = @"send_gift_success";
//static NSString * const LJLiveThinkingEventStartCallSuccess = @"start_call_success";
//static NSString * const LJLiveThinkingEventEndCallSuccess   = @"end_call_success";
static NSString * const LJLiveThinkingEventFollowSuccess    = @"follow_success";
/// 普通事件名
//static NSString * const LJLiveThinkingEventEnterHomePage               = @"enter_home_page";
//static NSString * const LJLiveThinkingEventEnterHostDetailPage         = @"enter_host_detail_page";
//static NSString * const LJLiveThinkingEventClickMessageFromDetail      = @"click_message_from_detail";
//static NSString * const LJLiveThinkingEventClickGiftsButtonInCall      = @"click_gifts_button_in_call";
//static NSString * const LJLiveThinkingEventClickRechargeButtonInCall   = @"click_recharge_button_in_call";
//static NSString * const LJLiveThinkingEventSendMessageSuccessInCall    = @"send_message_success_in_call";
//static NSString * const LJLiveThinkingEventCallEndClickLike        = @"call_end_click_like";
//static NSString * const LJLiveThinkingEventCallEndClickDislike     = @"call_end_click_dislike";
//static NSString * const LJLiveThinkingEventSearchContent           = @"search_content";
//static NSString * const LJLiveThinkingEventAcceptStartHuntingCall  = @"accept_start_hunting_call";
//static NSString * const LJLiveThinkingEventRefusedStartHuntingCall = @"refused_start_hunting_call";
//static NSString * const LJLiveThinkingEventNoRechargeFromHuntingCallEnd = @"no_recharge_from_hunting_call_end";
//static NSString * const LJLiveThinkingEventClickDiscountRechargeButtonInHuntingCall = @"click_discount_recharge_button_in_hunting_call";
//static NSString * const LJLiveThinkingEventRechargeSuccessWithin1minInHuntingCall  = @"recharge_success_within_1min_in_hunting_call";
//static NSString * const LJLiveThinkingEventRechargeSuccessWithin2minInHuntingCall  = @"recharge_success_within_2min_in_hunting_call";
//static NSString * const LJLiveThinkingEventEnterMultibeam      = @"enter_multibeam";
//static NSString * const LJLiveThinkingEventClickGiftSendAllInMultibeam     = @"click_gift_send_all_in_multibeam";
//static NSString * const LJLiveThinkingEventClickGiftsButtonInMultibeam     = @"click_gifts_button_in_multibeam";
//static NSString * const LJLiveThinkingEventClickPrivateButtonInMultibeam   = @"click_private_button_in_multibeam";
//static NSString * const LJLiveThinkingEventPrivateSuccessInMultibeam   = @"private_success_in_multibeam";
//static NSString * const LJLiveThinkingEventClickBossButtonInMultibeam  = @"click_boss_button_in_multibeam";
//static NSString * const LJLiveThinkingEventTimeForBossInMultibeam      = @"time_for_boss_in_multibeam";
//static NSString * const LJLiveThinkingEventClickCloseButtonInMultibeam = @"click_close_button_in_multibeam";
//static NSString * const LJLiveThinkingEventTimeForOneMultibeam         = @"time_for_one_multibeam";
//static NSString * const LJLiveThinkingEventCloseMultibeamByMinimize    = @"close_multibeam_by_minimize";
//static NSString * const LJLiveThinkingEventReturnMultibeamFromMinimize = @"return_multibeam_from_minimize";
static NSString * const LJLiveThinkingEventClickBannerInLiveMultibeam  = @"click_banner_in_live_multibeam";
//static NSString * const LJLiveThinkingEventEnterAppByNotification  = @"enter_app_by_notification";
static NSString * const LJLiveThinkingEventEnterLive               = @"enter_live";
static NSString * const LJLiveThinkingEventClickAutoSayHiInLive    = @"click_auto_say_hi_in_live";
static NSString * const LJLiveThinkingEventClickAutoFollowInLive   = @"click_auto_follow_in_live";
static NSString * const LJLiveThinkingEventClickAutoSendGiftInLive = @"click_auto_send_gift_in_live";
static NSString * const LJLiveThinkingEventTimeForOneLive          = @"time_for_one_live";
static NSString * const LJLiveThinkingEventClickHostAvatarInLive   = @"click_host_avatar_in_live";
static NSString * const LJLiveThinkingEventClickAudienceListInLive = @"click_audience_list_in_live";
static NSString * const LJLiveThinkingEventClickGiftsButtonInLive  = @"click_gifts_button_in_live";
static NSString * const LJLiveThinkingEventClickCloseButtonInLive  = @"click_close_button_in_live";
static NSString * const LJLiveThinkingEventCloseLiveByMinimize     = @"close_live_by_minimize";
static NSString * const LJLiveThinkingEventReturnLiveByMinimize    = @"return_live_by_minimize";
static NSString * const LJLiveThinkingEventClickRechargeButtonInLive   = @"click_recharge_button_in_live";
static NSString * const LJLiveThinkingEventSendBarrageInLive           = @"send_barrage_in_live";
static NSString * const LJLiveThinkingEventClickPrivateButtonInLive    = @"click_private_button_in_live";
static NSString * const LJLiveThinkingEventPrivateSuccessInLive    = @"private_success_in_live";
static NSString * const LJLiveThinkingEventSendGiftsWithin1minInPk = @"send_gifts_within_1min_in_pk";
static NSString * const LJLiveThinkingEventSendGiftsWithin2minInPk = @"send_gifts_within_2min_in_pk";
static NSString * const LJLiveThinkingEventSendGiftsWithin3minInPk = @"send_gifts_within_3min_in_pk";
static NSString * const LJLiveThinkingEventSendGiftsWithin4minInPk = @"send_gifts_within_4min_in_pk";
static NSString * const LJLiveThinkingEventSendGiftsWithin5minInPk = @"send_gifts_within_5min_in_pk";
static NSString * const LJLiveThinkingEventSendGiftsLast15secInPk  = @"send_gifts_last_15sec_in_pk";
static NSString * const LJLiveThinkingEventClickGiftRankInPk   = @"click_gift_rank_in_pk";
static NSString * const LJLiveThinkingEventTimeForOnePk        = @"time_for_one_pk";
static NSString * const LJLiveThinkingEventFirstRechargeWindowAppear       = @"first_recharge_window_appear";
static NSString * const LJLiveThinkingEventClickRechargeWindow        = @"click_recharge_window";


//static NSString * const LJLiveThinkingEventEnterMessagePage    = @"enter_message_page";
//static NSString * const LJLiveThinkingEventEnterConversationPage    = @"enter_conversation_page";
//static NSString * const LJLiveThinkingEventSendMessage         = @"send_message";
//static NSString * const LJLiveThinkingEventEnterVideoshowPage      = @"enter_videoshow_page";
//static NSString * const LJLiveThinkingEventEnterVideoshowScrollPage    = @"enter_videoshow_scroll_page";
//static NSString * const LJLiveThinkingEventEnterLeaderboardPage    = @"enter_leaderboard_page";
//static NSString * const LJLiveThinkingEventEnterLeaderboardIntimacy    = @"enter_leaderboard_intimacy";
//static NSString * const LJLiveThinkingEventEnterDetailFromHottest      = @"enter_detail_from_hottest";
//static NSString * const LJLiveThinkingEventClickFollowFromLeaderboard  = @"click_follow_from_leaderboard";
//static NSString * const LJLiveThinkingEventEnterMyCenterPage   = @"enter_my_center_page";
//static NSString * const LJLiveThinkingEventEnterRechargePage   = @"enter_recharge_page";
//static NSString * const LJLiveThinkingEventEnterSvipPage       = @"enter_svip_page";
//static NSString * const LJLiveThinkingEventEnterConsumptionRecord  = @"enter_consumption_record_page";
//static NSString * const LJLiveThinkingEventClickSignupInMyCenter   = @"click_signup_in_my_center";
//static NSString * const LJLiveThinkingEventEnterEditProfilePage  = @"enter_edit_profile_page";
//static NSString * const LJLiveThinkingEventClickRechargeButtonInNoCoinsWindow = @"click_recharge_button_in_no_coins_window";
//static NSString * const LJLiveThinkingEventClickLoginButton    = @"click_login_button";
//static NSString * const LJLiveThinkingEventLoginSuccess        = @"login_success";
//static NSString * const LJLiveThinkingEventClickImNewButton    = @"click_im_new_button";
//static NSString * const LJLiveThinkingEventEnterByTourist      = @"enter_by_tourist";
//static NSString * const LJLiveThinkingEventLoadingOpenAds      = @"loading_open_ads";
//static NSString * const LJLiveThinkingEventEnterWebByOpenAds   = @"enter_web_by_open_ads";
static NSString * const LJLiveThinkingEventSseLost             = @"sse_lost";

#pragma mark - Keys

//static NSString * const LJLiveThinkingKeyAppName       = @"app_name";
//static NSString * const LJLiveThinkingKeyAppChannel    = @"app_channel";
//static NSString * const LJLiveThinkingKeyServerVersion = @"server_version";
//static NSString * const LJLiveThinkingKeyEmail         = @"email";
static NSString * const LJLiveThinkingKeyAccountId     = @"account_id";
//static NSString * const LJLiveThinkingKeyNickname      = @"nickname";
//static NSString * const LJLiveThinkingKeyGender        = @"gender";
//static NSString * const LJLiveThinkingKeyAge           = @"age";
//static NSString * const LJLiveThinkingKeyTotalRevenue  = @"total_revenue";

//static NSString * const LJLiveThinkingKeyProductId         = @"product_id";
//static NSString * const LJLiveThinkingKeyRevenue           = @"revenue";
//static NSString * const LJLiveThinkingKeyOriRevenue        = @"ori_revenue";
//static NSString * const LJLiveThinkingKeyIsSvipItem        = @"is_svip_item";
//static NSString * const LJLiveThinkingKeyIsDiscountItem    = @"is_discount_item";
static NSString * const LJLiveThinkingKeyFrom              = @"from";

static NSString * const LJLiveThinkingKeyGiftId        = @"gift_id";
static NSString * const LJLiveThinkingKeyGiftName      = @"gift_name";
static NSString * const LJLiveThinkingKeyGiftCoins     = @"gift_coins";
static NSString * const LJLiveThinkingKeyIsLuckyBox    = @"is_luckybox";
static NSString * const LJLiveThinkingKeyIsFast        = @"is_fast";

//static NSString * const LJLiveThinkingKeyHungUpReason  = @"hung_up_reason";
static NSString * const LJLiveThinkingKeyFromDetail    = @"from_detail";

//static NSString * const LJLiveThinkingKeyContent   = @"content";
static NSString * const LJLiveThinkingKeyRoomId    = @"room_id";
//static NSString * const LJLiveThinkingKeyAnchorId  = @"anchor_id";

static NSString * const LJLiveThinkingKeyCoins         = @"coins";
//static NSString * const LJLiveThinkingKeyTime          = @"time";
//static NSString * const LJLiveThinkingKeyRoomType      = @"room_type";
//static NSString * const LJLiveThinkingKeyHostId        = @"host_id";
//static NSString * const LJLiveThinkingKeyHostDisplayId = @"host_display_id";

#pragma mark - Values

/// 内购渠道：live，private，hunting，multi-beam，recharge，svip，横幅广播
static NSString * const LJLiveThinkingValueLive         = @"live";
//static NSString * const LJLiveThinkingValuePrivate      = @"private";
//static NSString * const LJLiveThinkingValueHunting      = @"hunting";
//static NSString * const LJLiveThinkingValueMultibeam    = @"multi-beam";
//static NSString * const LJLiveThinkingValueRecharge     = @"recharge";
//static NSString * const LJLiveThinkingValueSvip         = @"svip";
static NSString * const LJLiveThinkingValueBroadcast    = @"broadcast";

/// 礼物渠道：live，private，hunting，multi-beam，match(Dama)
//static NSString * const LJLiveThinkingValueMatch        = @"match";

/// 通话渠道：live，multi-beam，detail，call-list，conversation，video-show，search，hunting, hunting-over,  host-list, following-list，match(Dama)
//static NSString * const LJLiveThinkingValueDetail          = @"detail";
//static NSString * const LJLiveThinkingValueCallList        = @"call-list";
//static NSString * const LJLiveThinkingValueConversation    = @"conversation";
//static NSString * const LJLiveThinkingValueVideoShow       = @"video-show";
//static NSString * const LJLiveThinkingValueSearch          = @"search";
//static NSString * const LJLiveThinkingValueHuntingOver     = @"hunting-over";
//static NSString * const LJLiveThinkingValueHostList        = @"host-list";
//static NSString * const LJLiveThinkingValueFollowingList   = @"following-list";

/// 挂断原因：user，anchor，no-coins，user-network，anchor-network，server-error
//static NSString * const LJLiveThinkingReasonUser           = @"user";
//static NSString * const LJLiveThinkingReasonAnchor         = @"anchor";
//static NSString * const LJLiveThinkingReasonNoCoins        = @"no-coins";
//static NSString * const LJLiveThinkingReasonUserNetwork    = @"user-network";
//static NSString * const LJLiveThinkingReasonAnchorNetwork  = @"anchor-network";
//static NSString * const LJLiveThinkingReasonServerError    = @"server-error";

/// 关注渠道：live，multi-beam，detail，rank，video-show，search，followers-list，match(Dama)
//static NSString * const LJLiveThinkingValueRank            = @"rank";
//static NSString * const LJLiveThinkingValueFollowersList   = @"followers-list";

/// 关注具体位置描述：live：head，auto-message，auto-follow-window，anchor-info-window
static NSString * const LJLiveThinkingValueDetailHead                = @"head";
static NSString * const LJLiveThinkingValueDetailAutoMessage         = @"auto-message";
static NSString * const LJLiveThinkingValueDetailAutoFollowWindow    = @"auto-follow-window";
static NSString * const LJLiveThinkingValueDetailAnchorInfoWindow    = @"anchor-info-window";

/// 其他
//static NSString * const LJLiveThinkingValueNotification    = @"notification";
//static NSString * const LJLiveThinkingValueHomeList        = @"home-list";
//static NSString * const LJLiveThinkingValueHomeDiscount099 = @"home-discount-0.99";
//static NSString * const LJLiveThinkingValueHomeDiscount499 = @"home-discount-4.99";
//static NSString * const LJLiveThinkingValueCallEnd         = @"call-end";

#endif /* LJLiveThinking_h */
