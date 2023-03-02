//
//  LJLivePkLocalControlView.h
//  Woohoo
//
//  Created by M2-mini on 2021/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLivePkLocalControlView : UIView




/// @param obj 对象
/// 刷新内部
/// @param event 事件
+ (LJLivePkLocalControlView *)lj_localControlView;
- (void)lj_event:(LJLiveEvent)event withObj:(NSObject * __nullable )obj;
@property (nonatomic, strong) LJLivePkPlayer *homePlayer;
@end

NS_ASSUME_NONNULL_END
