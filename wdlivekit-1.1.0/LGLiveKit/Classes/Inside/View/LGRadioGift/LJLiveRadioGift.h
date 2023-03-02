//
//  LJRadioGIftView.h
//  wdLive
//
//  Created by Mimio on 2022/6/21.
//  Copyright © 2022 Mimio. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LJRadioGiftRoomType) {
    LJRadioGiftRoomTypeChatRoom = 1 ,
    LJRadioGiftRoomTypeLive = 2,
    LJRadioGiftRoomTypeUGC = 3,
};

typedef NS_ENUM(NSInteger, LJRadioGiftSupportRoomType) {
    LJRadioGiftSupportRoomTypeChatRoom = 1 << 1,
    LJRadioGiftSupportRoomTypeLive = 1 << 2,
    LJRadioGiftSupportRoomTypeUGC = 1 << 3,
};

@protocol LJRadioGiftDelegate <NSObject>
- (void)lj_clickRadioGiftWithRoomType:(LJRadioGiftRoomType)roomType andRoomId:(NSInteger)roomId andAgoraRoomId:(NSString *)agoraRoomId andHostAccountId:(NSInteger)hostAccountId;
@optional
/// 数数统计
- (void)lj_thinkingEventName:(NSString *)eventName;
@end

@interface LJLiveRadioGift : UIView
@property (nonatomic, weak) id<LJRadioGiftDelegate> delegate;
//public 是否显示
@property (nonatomic, assign) BOOL enable;
//private
@property (nonatomic, strong) UIView *radioGiftView;
@property (nonatomic, assign) LJRadioGiftSupportRoomType supportRoomType;
@property (nonatomic, copy  ) NSString *boldFontName;

+ (LJLiveRadioGift *)shared;

- (void)lj_initRadioGiftViewInView:(UIView *)view boldFontName:(NSString *)boldFontName;
- (void)lj_receiveRtmRespone:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
