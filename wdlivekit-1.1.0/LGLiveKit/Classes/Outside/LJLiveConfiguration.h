//
//  LJLiveConfiguration.h
//  Woohoo
//
//  Created by M1-mini on 2022/4/27.
//  Copyright © 2022 tt. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LJLiveChannel) {
    LJLiveChannelDefault = 0,
    LJLiveChannelDama = 151,
};

@interface LJLiveConfiguration : NSObject


/// 加载网页时，控制测试服额外传参dev，正式服不影响，Default NO
/// >=13.2禁止视频画面截屏录屏，Default YES
/// 阿语适配，是否开启UI翻转，Default YES
/// 默认简介，Default @“”
/// 渠道号：如有特殊定制，传各自的channel
/// 默认头像
/// 应用内是否支持私聊功能，Default YES
@property (nonatomic, strong) NSString *mood;
@property (nonatomic, assign) BOOL flipRTLEnable;
@property (nonatomic, assign) BOOL screenshotHideEnable;
@property (nonatomic, strong) UIImage *avatar;
@property (nonatomic, assign) BOOL privateEnable;
@property (nonatomic, assign) LJLiveChannel channel;
@property (nonatomic, assign) BOOL isTestServer;
@end

NS_ASSUME_NONNULL_END
