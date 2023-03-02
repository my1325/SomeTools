//
//  LJLivePkControlView.h
//  Woohoo
//
//  Created by M2-mini on 2021/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLivePkControlView : UIView



/// @param event 事件
/// 刷新内部
/// @param obj 对象
- (void)lj_event:(LJLiveEvent)event withObj:(NSObject * __nullable )obj;
@property (nonatomic, copy) LJLiveEventBlock eventBlock;
@end

NS_ASSUME_NONNULL_END
