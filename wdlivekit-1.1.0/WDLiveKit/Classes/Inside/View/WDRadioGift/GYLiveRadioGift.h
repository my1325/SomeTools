//
//  GYRadioGIftView.h
//  wdLive
//
//  Created by Mimio on 2022/6/21.
//  Copyright © 2022 Mimio. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GYRadioGiftRoomType) {
    GYRadioGiftRoomTypeChatRoom = 1 ,
    GYRadioGiftRoomTypeLive = 2,
    GYRadioGiftRoomTypeUGC = 3,
};

typedef NS_ENUM(NSInteger, GYRadioGiftSupportRoomType) {
    GYRadioGiftSupportRoomTypeChatRoom = 1 << 1,
    GYRadioGiftSupportRoomTypeLive = 1 << 2,
    GYRadioGiftSupportRoomTypeUGC = 1 << 3,
};

@protocol GYRadioGiftDelegate <NSObject>
- (void)fb_clickRadioGiftWithRoomType:(GYRadioGiftRoomType)roomType andRoomId:(NSInteger)roomId andAgoraRoomId:(NSString *)agoraRoomId andHostAccountId:(NSInteger)hostAccountId;
@optional
/// 数数统计
- (void)fb_thinkingEventName:(NSString *)eventName;
@end

@interface GYLiveRadioGift : UIView
@property (nonatomic, weak) id<GYRadioGiftDelegate> delegate;
//public 是否显示
@property (nonatomic, assign) BOOL enable;
//private
@property (nonatomic, strong) UIView *radioGiftView;
@property (nonatomic, assign) GYRadioGiftSupportRoomType supportRoomType;
@property (nonatomic, copy  ) NSString *boldFontName;

+ (GYLiveRadioGift *)shared;

- (void)fb_initRadioGiftViewInView:(UIView *)view boldFontName:(NSString *)boldFontName;
- (void)fb_receiveRtmRespone:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
