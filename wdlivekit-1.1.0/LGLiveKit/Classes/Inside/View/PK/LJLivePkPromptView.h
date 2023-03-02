//
//  LJLivePkPromptView.h
//  Woohoo
//
//  Created by M2-mini on 2021/11/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLivePkPromptView : UIView



/// @param event 事件
/// 刷新内部
/// @param obj 对象
- (void)lj_event:(LJLiveEvent)event withObj:(NSObject * __nullable )obj;
+ (LJLivePkPromptView *)lj_promptView;
@end

NS_ASSUME_NONNULL_END
