//
//  GYLiveGift.h
//  Woohoo
//
//  Created by M1-mini on 2022/4/24.
//  Copyright © 2022 tt. All rights reserved.
//

#import "GYLiveBaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYLiveGift : GYLiveBaseObject

/// 礼物ID
@property (nonatomic, assign) NSInteger giftId;
/// 礼物name
@property (nonatomic, strong) NSString *giftName;
/// 价格
@property (nonatomic, assign) NSInteger giftPrice;
/// 原价
@property (nonatomic, assign) NSInteger giftOriPrice;
/// 礼物图标
@property (nonatomic, strong) NSString *iconUrl;
/// svg文件地址
@property (nonatomic, strong) NSString *svgUrl;
/// 是否是盲盒
@property (nonatomic, assign) BOOL isBlindBox;
///
@property (nonatomic, strong) NSString *comboIconUrl;
///
@property (nonatomic, assign) CGFloat comboSize;

@end

NS_ASSUME_NONNULL_END
