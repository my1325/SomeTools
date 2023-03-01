//
//  GYLivePkRemoteControlView.h
//  Woohoo
//
//  Created by M2-mini on 2021/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYLivePkRemoteControlView : UIView

@property (nonatomic, copy) GYLiveEventBlock eventBlock;

@property (nonatomic, strong) GYLivePkPlayer *remotePlayer;

@property (nonatomic, assign) BOOL isMuted;

+ (GYLivePkRemoteControlView *)fb_remoteControlView;

/// 刷新内部
/// @param event 事件
/// @param obj 对象
- (void)fb_event:(GYLiveEvent)event withObj:(NSObject * __nullable )obj;

@end

NS_ASSUME_NONNULL_END
