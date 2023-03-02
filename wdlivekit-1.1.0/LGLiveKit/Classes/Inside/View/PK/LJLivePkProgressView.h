//
//  LJLivePkProgressView.h
//  Woohoo
//
//  Created by M2-mini on 2021/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLivePkProgressView : UIView



/// 刷新内部
/// @param obj 对象
/// @param event 事件
- (void)lj_event:(LJLiveEvent)event withObj:(NSObject * __nullable )obj;
@property (nonatomic, assign) NSInteger homePoint, awayPoint;
@end

NS_ASSUME_NONNULL_END
