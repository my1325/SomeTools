//
//  LJLiveBarrageView.h
//  Woohoo
//
//  Created by M2-mini on 2021/8/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveBarrageView : UIView

@property (nonatomic, copy) LJLiveEventBlock eventBlock;

@property (nonatomic, strong) LJLiveRoom *liveRoom;

/// 刷新内部
/// @param event 事件
/// @param obj 对象
- (void)lj_event:(LJLiveEvent)event withObj:(NSObject * __nullable )obj;

@end

NS_ASSUME_NONNULL_END
