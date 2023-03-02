//
//  LJLiveGift.h
//  Woohoo
//
//  Created by M1-mini on 2022/4/24.
//  Copyright © 2022 tt. All rights reserved.
//

#import "LJLiveBaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveGift : LJLiveBaseObject


/// 原价
/// svg文件地址
/// 礼物name
/// 礼物图标
/// 价格
///
///
/// 礼物ID
/// 是否是盲盒
@property (nonatomic, strong) NSString *giftName;
@property (nonatomic, strong) NSString *iconUrl;
@property (nonatomic, strong) NSString *comboIconUrl;
@property (nonatomic, assign) CGFloat comboSize;
@property (nonatomic, assign) BOOL isBlindBox;
@property (nonatomic, assign) NSInteger giftId;
@property (nonatomic, strong) NSString *svgUrl;
@property (nonatomic, assign) NSInteger giftOriPrice;
@property (nonatomic, assign) NSInteger giftPrice;
@end

NS_ASSUME_NONNULL_END
