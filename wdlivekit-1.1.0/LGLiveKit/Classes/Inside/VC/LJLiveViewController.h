//
//  LJLiveViewController.h
//  Woohoo
//
//  Created by M2-mini on 2021/8/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 内部自动请求最新房间列表，提供滑动支持
@interface LJLiveViewController : UIViewController

/// 通过ID进入房间
/// @param hostAccountId 主播ID
- (instancetype)initWithHostAccountId:(NSInteger)hostAccountId;

/// 通过房间信息进入
/// @param rooms 房间数组
/// @param index 下标
- (instancetype)initWithRooms:(NSArray<LJLiveRoom *> *)rooms atIndex:(NSInteger)index;

/// 清理内部定时器及UI
- (void)lj_clean;

- (void)lj_reloadMyCoins;

@end

NS_ASSUME_NONNULL_END
