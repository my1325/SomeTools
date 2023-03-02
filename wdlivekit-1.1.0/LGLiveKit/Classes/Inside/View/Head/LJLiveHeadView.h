//
//  LJLiveHeadView.h
//  Woohoo
//
//  Created by M2-mini on 2021/8/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveHeadView : UIView




/// @param obj 对象
/// @param event 事件
/// 刷新内部
- (void)lj_event:(LJLiveEvent)event withObj:(NSObject * __nullable )obj;
@property (nonatomic, copy) LJLiveEventBlock eventBlock;
@property (nonatomic, strong) LJLiveRoom *liveRoom;
@end

NS_ASSUME_NONNULL_END
