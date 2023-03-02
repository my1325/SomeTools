//
//  LJLiveContainerView.h
//  Woohoo
//
//  Created by M2-mini on 2021/8/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveContainerView : UIView





/// @param obj 对象
/// 键盘控制
/// 刷新内部
/// @param event 事件
- (void)lj_event:(LJLiveEvent)event withObj:(NSObject * __nullable )obj;
@property (nonatomic, assign) CGFloat keyboardChangedHeight;
@property (nonatomic, copy) LJLiveEventBlock eventBlock;
@property (nonatomic, strong) LJLiveRoom *liveRoom;
@end

NS_ASSUME_NONNULL_END
