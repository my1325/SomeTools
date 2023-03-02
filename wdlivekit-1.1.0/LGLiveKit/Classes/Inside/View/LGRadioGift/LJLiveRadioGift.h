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
- (void)lj_thinkingEventName:(NSString *)eventName;
@optional/// 数数统计
- (void)lj_clickRadioGiftWithRoomType:(LJRadioGiftRoomType)roomType andRoomId:(NSInteger)roomId andAgoraRoomId:(NSString *)agoraRoomId andHostAccountId:(NSInteger)hostAccountId;
@required@end

@interface LJLiveRadioGift : UIView


//private
//public 是否显示
- (void)lj_receiveRtmRespone:(NSDictionary *)dic;
- (void)lj_initRadioGiftViewInView:(UIView *)view boldFontName:(NSString *)boldFontName;
+ (LJLiveRadioGift *)shared;
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, assign) LJRadioGiftSupportRoomType supportRoomType;
@property (nonatomic, strong) UIView *radioGiftView;
@property (nonatomic, weak) id<LJRadioGiftDelegate> delegate;
@property (nonatomic, copy  ) NSString *boldFontName;
@end

NS_ASSUME_NONNULL_END
