//
//  GYLiveGiftBarrageView.h
//  Woohoo
//
//  Created by M2-mini on 2021/8/27.
//

#import <UIKit/UIKit.h>
#import "GYLiveGiftBarrageViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYLiveGiftBarrageView : UIView

@property (nonatomic, strong) GYLiveGiftBarrageViewModel *giftvm;

/// 刷新内部
/// @param event 事件
/// @param obj 对象
- (void)fb_event:(GYLiveEvent)event withObj:(NSObject * __nullable )obj;

@end

NS_ASSUME_NONNULL_END
