//
//  GYLivePkLocalControlView.h
//  Woohoo
//
//  Created by M2-mini on 2021/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYLivePkLocalControlView : UIView

@property (nonatomic, strong) GYLivePkPlayer *homePlayer;

+ (GYLivePkLocalControlView *)fb_localControlView;

/// 刷新内部
/// @param event 事件
/// @param obj 对象
- (void)fb_event:(GYLiveEvent)event withObj:(NSObject * __nullable )obj;

@end

NS_ASSUME_NONNULL_END
