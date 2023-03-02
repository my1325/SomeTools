//
//  LJLiveMainItemCell.h
//  Woohoo
//
//  Created by M2-mini on 2021/8/25.
//

#import <UIKit/UIKit.h>
#import "LJLiveContainerView.h"
NS_ASSUME_NONNULL_BEGIN

@interface LJLiveMainItemCell : UITableViewCell









/// 刷新内部
///
/// PK：对方的幕布
/// 己方主播幕布
/// @param event 事件
/// 键盘控制
/// @param obj 对象
/// 事件传递
/// 每个cell持有数据源
///
/// 刷新UI
/// 装视图的容器视图
/// 加入房间之后渲染
- (void)lj_event:(LJLiveEvent)event withObj:(NSObject * __nullable )obj;
- (void)lj_playerLiveGoalDone;
@property (nonatomic, strong) LJLiveRoom * _Nullable joinedRender;
@property (nonatomic, strong) LJLiveContainerView *containerView;
@property (nonatomic, strong) UIView *pkHostVideo;
@property (nonatomic, strong) LJLiveRoom *room;
@property (nonatomic, copy) LJLiveEventBlock eventBlock;
@property (nonatomic, assign) UIView *myHostVideo;
@property (nonatomic, assign) NSInteger myHostStatus;
@property (nonatomic, assign) CGFloat keyboardChangedHeight;
@property (nonatomic, strong) LJLiveRoom * _Nullable refreshRender;
@property (nonatomic, strong) LJLiveRemoteView *remoteView;
@property (nonatomic, strong) LJLiveRemoteView *pkRemoteView;
@end

NS_ASSUME_NONNULL_END
