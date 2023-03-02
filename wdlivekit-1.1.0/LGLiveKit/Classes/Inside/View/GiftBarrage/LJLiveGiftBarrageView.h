//
//  LJLiveGiftBarrageView.h
//  Woohoo
//
//  Created by M2-mini on 2021/8/27.
//

#import <UIKit/UIKit.h>
#import "LJLiveGiftBarrageViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveGiftBarrageView : UIView

@property (nonatomic, strong) LJLiveGiftBarrageViewModel *giftvm;

/// 刷新内部
/// @param event 事件
/// @param obj 对象
- (void)lj_event:(LJLiveEvent)event withObj:(NSObject * __nullable )obj;

@end

NS_ASSUME_NONNULL_END
