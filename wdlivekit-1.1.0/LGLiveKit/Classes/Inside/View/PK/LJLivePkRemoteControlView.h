//
//  LJLivePkRemoteControlView.h
//  Woohoo
//
//  Created by M2-mini on 2021/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLivePkRemoteControlView : UIView

@property (nonatomic, copy) LJLiveEventBlock eventBlock;

@property (nonatomic, strong) LJLivePkPlayer *remotePlayer;

@property (nonatomic, assign) BOOL isMuted;

+ (LJLivePkRemoteControlView *)lj_remoteControlView;

/// 刷新内部
/// @param event 事件
/// @param obj 对象
- (void)lj_event:(LJLiveEvent)event withObj:(NSObject * __nullable )obj;

@end

NS_ASSUME_NONNULL_END
