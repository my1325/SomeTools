//
//  GYLiveBarrageAutoEventView.h
//  Woohoo
//
//  Created by M2-mini on 2021/9/4.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GYLiveBarrageAutoEventType) {
    GYLiveBarrageAutoEventTypeSayHi,        // say hi
    GYLiveBarrageAutoEventTypeSendGift,     // send gift
    GYLiveBarrageAutoEventTypeFollow,       // follow
};

NS_ASSUME_NONNULL_BEGIN

@interface GYLiveBarrageAutoEventView : UIView

@property (nonatomic, strong) NSString *avatarUrl;

@property (nonatomic, assign) GYLiveBarrageAutoEventType type;

@property (nonatomic, copy) GYLiveEventBlock eventBlock;

@end

NS_ASSUME_NONNULL_END
