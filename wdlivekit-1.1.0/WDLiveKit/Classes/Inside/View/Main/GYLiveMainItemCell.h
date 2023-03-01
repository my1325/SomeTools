//
//  GYLiveMainItemCell.h
//  Woohoo
//
//  Created by M2-mini on 2021/8/25.
//

#import <UIKit/UIKit.h>
#import "GYLiveContainerView.h"
NS_ASSUME_NONNULL_BEGIN

@interface GYLiveMainItemCell : UITableViewCell

/// 键盘控制
@property (nonatomic, assign) CGFloat keyboardChangedHeight;
/// 事件传递
@property (nonatomic, copy) GYLiveEventBlock eventBlock;
/// 己方主播幕布
@property (nonatomic, strong) GYLiveRemoteView *remoteView;
/// PK：对方的幕布
@property (nonatomic, strong) GYLiveRemoteView *pkRemoteView;


@property (nonatomic, strong) UIView *pkHostVideo;
///
@property (nonatomic, assign) NSInteger myHostStatus;
///
@property (nonatomic, assign) UIView *myHostVideo;

/// 装视图的容器视图
@property (nonatomic, strong) GYLiveContainerView *containerView;

/// 每个cell持有数据源
@property (nonatomic, strong) GYLiveRoom *room;
/// 加入房间之后渲染
@property (nonatomic, strong) GYLiveRoom * _Nullable joinedRender;
/// 刷新UI
@property (nonatomic, strong) GYLiveRoom * _Nullable refreshRender;


/// 刷新内部
/// @param event 事件
/// @param obj 对象
- (void)fb_event:(GYLiveEvent)event withObj:(NSObject * __nullable )obj;

- (void)fb_playerLiveGoalDone;

@end

NS_ASSUME_NONNULL_END
