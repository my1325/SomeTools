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





/// @param index 下标
/// @param hostAccountId 主播ID
/// 通过房间信息进入
/// 清理内部定时器及UI
/// @param rooms 房间数组
/// 通过ID进入房间
- (void)lj_reloadMyCoins;
- (void)lj_clean;
- (instancetype)initWithHostAccountId:(NSInteger)hostAccountId;
- (instancetype)initWithRooms:(NSArray<LJLiveRoom *> *)rooms atIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
