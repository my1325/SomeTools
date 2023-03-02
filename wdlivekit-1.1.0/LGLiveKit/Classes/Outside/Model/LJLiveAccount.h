//
//  LJLiveAccount.h
//  Woohoo
//
//  Created by M1-mini on 2022/4/24.
//  Copyright © 2022 tt. All rights reserved.
//

#import "LJLiveBaseObject.h"
#import "LJLiveGift.h"

NS_ASSUME_NONNULL_BEGIN
/// 支付方式
typedef NS_ENUM(NSUInteger, LJRechargeType) {
    LJRechargeTypeSVIP = -5,
    LJRechargeTypeIAP = 1,          // 1：苹果内购
    LJRechargeTypePP  = 2,
    LJRechargeTypeCC = 8,

};


@class LJSvipInfo, LJBannerInfo, LJUniqueTag, LJLiveConfig, LJPayConfig, LJIapConfig;

@interface LJLiveAccount : LJLiveBaseObject






#pragma mark - 自定义参数


/// 特效数组
/// 充值总额
/// 金币数
/// ab分组
/// svip
/// 是否绿色账号
@property (nonatomic, assign) NSInteger coins;
@property (nonatomic, strong) NSArray<NSNumber *> *privileges;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, assign) NSInteger accountId;
@property (nonatomic, assign) float rechargeAmount;
@property (nonatomic, assign) NSInteger abTestFlag;
@property (nonatomic, strong) NSString *displayAccountId;
@property (nonatomic, assign) BOOL isGreen;
@property (nonatomic, strong) LJSvipInfo *svipInfo;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, assign) BOOL isSVip, isVip;
@end

@interface LJSvipInfo : LJLiveBaseObject


/// 到期时间字符串
/// 是否开通svip
/// 是否是svip
@property (nonatomic, strong) NSString *expirationDate;
@property (nonatomic, assign) BOOL isSVip;
@property (nonatomic, assign) BOOL isSVipPurchased;
@end

@interface LJLiveAccountConfig : LJLiveBaseObject



//@property (nonatomic, strong) NSArray<LJLiveGift *> *voiceChatRoomGiftConfigs;
///// paypal 内购项
/// 三方支付开启条件， true 开  false 没开
/// 语聊房礼物配置 *******
/// 支付平台方式
/// 一对多直播配置
//@property (nonatomic, strong) NSArray<LJIapConfig *> *ccConfigs;
///// 信用卡购买项目
/// 统计充值金额是否超过10
//@property (nonatomic, strong) NSArray<LJIapConfig *> *ppConfigs;
/// 支付配置
//@property (nonatomic, strong) NSArray<LJIapConfig *> *iapConfigs;
/// Banner信息集合
///// 内购项
/// 语聊房直播间Banner信息集合 *******
@property (nonatomic, assign) float totalPayOver10;
@property (nonatomic, assign) BOOL webPayCondition;
@property (nonatomic, strong) LJUniqueTag * __nullable defaultEventLabel;
@property (nonatomic, strong) LJLiveConfig *liveConfig;
@property (nonatomic, strong) NSArray<LJBannerInfo *> *voiceChatRoomBannerInfoList;
@property (nonatomic, strong) NSArray *rechargeTList;
@property (nonatomic, strong) NSArray<LJBannerInfo *> *bannerInfoList;
@property (nonatomic, strong) NSString *uniqueTagUrl;
@property (nonatomic, strong) NSArray<LJPayConfig *> *payConfigs;
@end

@interface LJBannerInfo : LJLiveBaseObject

/// 1:普通跳转 2：内购活动 3:申请主播 4:做积分墙任务的金币 5:老用户充值活动 6:新星榜 7:进入详情 8:三周年活动
/// 图片地址
/// 【当type=5时有用】用户最近一次充值的方式（1:苹果内购 2:paypal 3:google play 4:信用卡）
/// 跳转地址
///  主播id
/// 【当type=5时有用】推荐的购买项Id
/// 【当type=5时有用】通过banner充值的总次数
@property (nonatomic, assign) NSInteger latestRechargeT;
@property (nonatomic, strong) NSString *redirectAddr;
@property (nonatomic, strong) NSString *imgAddr;
@property (nonatomic, assign) NSInteger totalRechargeCount;
@property (nonatomic, strong) NSString *recommendedProductId;
@property (nonatomic, strong) NSString *extraData;
@property (nonatomic, assign) NSInteger type;
@end

/// 活动弹幕标签
@interface LJUniqueTag : LJLiveBaseObject










/// 自定义参数 过期时间戳 - 当前时间戳
- (NSString *)lj_activityUrl;
@property (nonatomic, assign) NSInteger expirationTime;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) NSInteger imageHeight;
@property (nonatomic, assign) NSInteger timeInterval;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, assign) NSInteger imageWidth;
@end

@interface LJLiveConfig : LJLiveBaseObject





/// pk进度条
/// 被替换掉的礼物配置 兼容老版本
/// 礼物配置
/// 转盘开关
/// 开关
@property (nonatomic, strong) NSString *videoChatRoomTheme;
@property (nonatomic, strong) NSArray<LJLiveGift *> *giftConfigs;
@property (nonatomic, strong) NSString *videoChatRoomThemeDesc;
@property (nonatomic, strong) NSArray<LJLiveGift *> *videoChatRoomReplacedGiftConfigs;
@property (nonatomic, strong) NSString *videoChatRoomBriefIntro;
@property (nonatomic, strong) NSString *videoChatRoomThemeImage;
@property (nonatomic, assign) BOOL isVideoChatRoomOn;
@property (nonatomic,assign) BOOL isTurntableFeatureOn;
@property (nonatomic, strong) NSString *pkScoreFlagUrl;
@end

#pragma mark - PayConfig

@interface LJPayConfig : NSObject


/// 类型
/// 系数（除10000）
/// 后缀（p/c，p/sp）
/// 购买项
/// 角标
/// 图片
/// 标题
@property (nonatomic, strong) NSString *payUrlSuffix;
@property (nonatomic, assign) LJRechargeType type;
@property (nonatomic, strong) NSString *iconUrl;
@property (nonatomic, strong) NSString *leftIconUrl;
@property (nonatomic, assign) NSInteger coefficient;
@property (nonatomic, strong) NSArray<LJIapConfig *> *products;
@property (nonatomic, strong) NSString *title;
@end


#pragma mark - IapConfig
@interface LJIapConfig : NSObject


/// 赠送数量
/// 类型
/// 产品Id
/// 美元价格
/// 美元价格
/// 产品类型（1：一般消耗商品 2：折扣商品 3：续订商品 5:弹窗商品）
/// Banner入口购买时的赠送数量
/// 是否已经购买，用于判断折扣商品只能买一次。
//@property (nonatomic, assign) LJRechargeType type;
/// 基础数量
@property (nonatomic, assign) NSInteger baseCount;
@property (nonatomic, assign) NSInteger productType;
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, assign) NSInteger bannerExtraCount;
@property (nonatomic, assign) float priceUSD;
@property (nonatomic, strong) NSNumber *isBought;
@property (nonatomic, assign) NSInteger extraCount;
@property (nonatomic, assign) float oriPriceUSD;
@end


NS_ASSUME_NONNULL_END
