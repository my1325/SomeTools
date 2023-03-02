//
//  LJLiveBarrageAutoEventView.h
//  Woohoo
//
//  Created by M2-mini on 2021/9/4.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LJLiveBarrageAutoEventType) {
    LJLiveBarrageAutoEventTypeSayHi,        // say hi
    LJLiveBarrageAutoEventTypeSendGift,     // send gift
    LJLiveBarrageAutoEventTypeFollow,       // follow
};

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveBarrageAutoEventView : UIView

@property (nonatomic, strong) NSString *avatarUrl;

@property (nonatomic, assign) LJLiveBarrageAutoEventType type;

@property (nonatomic, copy) LJLiveEventBlock eventBlock;

@end

NS_ASSUME_NONNULL_END
