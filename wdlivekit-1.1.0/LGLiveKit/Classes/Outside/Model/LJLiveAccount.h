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

@property (nonatomic, assign) NSInteger accountId;

@property (nonatomic, strong) NSString *displayAccountId;
/// 金币数
@property (nonatomic, assign) NSInteger coins;

@property (nonatomic, strong) NSString *avatar;

@property (nonatomic, strong) NSString *nickName;

@property (nonatomic, assign) BOOL isSVip, isVip;
/// 充值总额
@property (nonatomic, assign) float rechargeAmount;
/// 特效数组
@property (nonatomic, strong) NSArray<NSNumber *> *privileges;
/// ab分组
@property (nonatomic, assign) NSInteger abTestFlag;
/// svip
@property (nonatomic, strong) LJSvipInfo *svipInfo;

#pragma mark - 自定义参数

/// 是否绿色账号
@property (nonatomic, assign) BOOL isGreen;

@end

@interface LJSvipInfo : LJLiveBaseObject

/// 到期时间字符串
@property (nonatomic, strong) NSString *expirationDate;
/// 是否是svip
@property (nonatomic, assign) BOOL isSVip;
/// 是否开通svip
@property (nonatomic, assign) BOOL isSVipPurchased;

@end

@interface LJLiveAccountConfig : LJLiveBaseObject

@property (nonatomic, strong) NSString *uniqueTagUrl;
/// Banner信息集合
@property (nonatomic, strong) NSArray<LJBannerInfo *> *bannerInfoList;
/// 语聊房直播间Banner信息集合 *******
@property (nonatomic, strong) NSArray<LJBannerInfo *> *voiceChatRoomBannerInfoList;
/// 一对多直播配置
@property (nonatomic, strong) LJLiveConfig *liveConfig;

@property (nonatomic, strong) LJUniqueTag * __nullable defaultEventLabel;
/// 三方支付开启条件， true 开  false 没开
@property (nonatomic, assign) BOOL webPayCondition;
/// 统计充值金额是否超过10
@property (nonatomic, assign) float totalPayOver10;
/// 语聊房礼物配置 *******
//@property (nonatomic, strong) NSArray<LJLiveGift *> *voiceChatRoomGiftConfigs;
/// 支付平台方式
@property (nonatomic, strong) NSArray *rechargeTList;
/// 支付配置
@property (nonatomic, strong) NSArray<LJPayConfig *> *payConfigs;
///// 内购项
//@property (nonatomic, strong) NSArray<LJIapConfig *> *iapConfigs;
///// paypal 内购项
//@property (nonatomic, strong) NSArray<LJIapConfig *> *ppConfigs;
///// 信用卡购买项目
//@property (nonatomic, strong) NSArray<LJIapConfig *> *ccConfigs;

@end

@interface LJBannerInfo : LJLiveBaseObject
/// 图片地址
@property (nonatomic, strong) NSString *imgAddr;
/// 跳转地址
@property (nonatomic, strong) NSString *redirectAddr;
/// 1:普通跳转 2：内购活动 3:申请主播 4:做积分墙任务的金币 5:老用户充值活动 6:新星榜 7:进入详情 8:三周年活动
@property (nonatomic, assign) NSInteger type;
/// 【当type=5时有用】用户最近一次充值的方式（1:苹果内购 2:paypal 3:google play 4:信用卡）
@property (nonatomic, assign) NSInteger latestRechargeT;
/// 【当type=5时有用】推荐的购买项Id
@property (nonatomic, strong) NSString *recommendedProductId;
/// 【当type=5时有用】通过banner充值的总次数
@property (nonatomic, assign) NSInteger totalRechargeCount;
///  主播id
@property (nonatomic, strong) NSString *extraData;

@end

/// 活动弹幕标签
@interface LJUniqueTag : LJLiveBaseObject

@property (nonatomic, strong) NSString *imageUrl;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *desc;

@property (nonatomic, assign) NSInteger expirationTime;

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, assign) NSInteger imageHeight;

@property (nonatomic, assign) NSInteger imageWidth;

/// 自定义参数 过期时间戳 - 当前时间戳
@property (nonatomic, assign) NSInteger timeInterval;

- (NSString *)lj_activityUrl;

@end

@interface LJLiveConfig : LJLiveBaseObject
/// 开关
@property (nonatomic, assign) BOOL isVideoChatRoomOn;

@property (nonatomic, strong) NSString *videoChatRoomTheme;

@property (nonatomic, strong) NSString *videoChatRoomThemeDesc;

@property (nonatomic, strong) NSString *videoChatRoomThemeImage;

@property (nonatomic, strong) NSString *videoChatRoomBriefIntro;
/// 礼物配置
@property (nonatomic, strong) NSArray<LJLiveGift *> *giftConfigs;
/// 被替换掉的礼物配置 兼容老版本
@property (nonatomic, strong) NSArray<LJLiveGift *> *videoChatRoomReplacedGiftConfigs;
/// pk进度条
@property (nonatomic, strong) NSString *pkScoreFlagUrl;
/// 转盘开关
@property (nonatomic,assign) BOOL isTurntableFeatureOn;

@end

#pragma mark - PayConfig

@interface LJPayConfig : NSObject

/// 类型
@property (nonatomic, assign) LJRechargeType type;
/// 标题
@property (nonatomic, strong) NSString *title;
/// 图片
@property (nonatomic, strong) NSString *iconUrl;
/// 角标
@property (nonatomic, strong) NSString *leftIconUrl;
/// 后缀（p/c，p/sp）
@property (nonatomic, strong) NSString *payUrlSuffix;
/// 系数（除10000）
@property (nonatomic, assign) NSInteger coefficient;
/// 购买项
@property (nonatomic, strong) NSArray<LJIapConfig *> *products;

@end


#pragma mark - IapConfig
@interface LJIapConfig : NSObject

/// 产品Id
@property (nonatomic, strong) NSString *productId;
/// 美元价格
@property (nonatomic, assign) float priceUSD;
/// 美元价格
@property (nonatomic, assign) float oriPriceUSD;
/// 基础数量
@property (nonatomic, assign) NSInteger baseCount;
/// 赠送数量
@property (nonatomic, assign) NSInteger extraCount;
/// 产品类型（1：一般消耗商品 2：折扣商品 3：续订商品 5:弹窗商品）
@property (nonatomic, assign) NSInteger productType;
/// 是否已经购买，用于判断折扣商品只能买一次。
@property (nonatomic, strong) NSNumber *isBought;
/// Banner入口购买时的赠送数量
@property (nonatomic, assign) NSInteger bannerExtraCount;
/// 类型
//@property (nonatomic, assign) LJRechargeType type;

@end


NS_ASSUME_NONNULL_END
