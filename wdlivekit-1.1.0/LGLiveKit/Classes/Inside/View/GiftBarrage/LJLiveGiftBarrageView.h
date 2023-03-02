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



/// 刷新内部
/// @param obj 对象
/// @param event 事件
- (void)lj_event:(LJLiveEvent)event withObj:(NSObject * __nullable )obj;
@property (nonatomic, strong) LJLiveGiftBarrageViewModel *giftvm;
@end

NS_ASSUME_NONNULL_END
