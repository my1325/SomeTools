//
//  LJLivePkRemoteControlView.h
//  Woohoo
//
//  Created by M2-mini on 2021/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLivePkRemoteControlView : UIView






/// 刷新内部
/// @param obj 对象
/// @param event 事件
+ (LJLivePkRemoteControlView *)lj_remoteControlView;
- (void)lj_event:(LJLiveEvent)event withObj:(NSObject * __nullable )obj;
@property (nonatomic, assign) BOOL isMuted;
@property (nonatomic, strong) LJLivePkPlayer *remotePlayer;
@property (nonatomic, copy) LJLiveEventBlock eventBlock;
@end

NS_ASSUME_NONNULL_END
