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
@property (nonatomic, assign) BOOL isTestServer;
/// 默认头像
@property (nonatomic, strong) UIImage *avatar;
/// 默认简介，Default @“”
@property (nonatomic, strong) NSString *mood;
/// 应用内是否支持私聊功能，Default YES
@property (nonatomic, assign) BOOL privateEnable;
/// 阿语适配，是否开启UI翻转，Default YES
@property (nonatomic, assign) BOOL flipRTLEnable;
/// >=13.2禁止视频画面截屏录屏，Default YES
@property (nonatomic, assign) BOOL screenshotHideEnable;
/// 渠道号：如有特殊定制，传各自的channel
@property (nonatomic, assign) LJLiveChannel channel;

@end

NS_ASSUME_NONNULL_END
