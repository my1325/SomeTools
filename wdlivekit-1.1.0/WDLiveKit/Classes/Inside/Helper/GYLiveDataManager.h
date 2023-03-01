//
//  GYLiveDataManager.h
//  Woohoo
//
//  Created by M1-mini on 2022/3/24.
//

#import <Foundation/Foundation.h>
#import "GYLiveAccount.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GYLiveDataOperation) {
    GYLiveDataOperationNone,          // 啥事不干
    GYLiveDataOperationReplaceAdd,    // 替换or新增
    GYLiveDataOperationRemove,        // 移除
};

/// 直播间数据管理
@interface GYLiveDataManager : NSObject

/*-------------------------------------------------------------------
 房间数据
 */
///
@property (nonatomic, strong) GYLiveRoom *current;
///
@property (nonatomic, assign) NSInteger index;
///
@property (nonatomic, strong) NSMutableArray<GYLiveRoom *> * rooms;

/// 初始化数据
/// @param rooms rooms
/// @param index index
- (void)fb_initWithRooms:(NSArray *)rooms atIndex:(NSInteger)index;

/// 请求房间列表
/// @param success 成功
/// @param failure 失败
- (void)fb_reloadDataWithSuccess:(void(^) (NSArray<GYLiveRoom *> * _Nonnull rooms))success
                          failure:(GYLiveVoidBlock)failure;

/// 更新房间数组
/// @param room 房间信息
/// @param operationBlock 操作
/// @param completionBlock 完成操作
- (void)fb_updateWith:(GYLiveRoom *)room
        operationBlock:(GYLiveDataOperation (^)(NSInteger index, GYLiveRoom * _Nullable old))operationBlock
       completionBlock:(void (^)(NSInteger index, GYLiveRoom * _Nullable old))completionBlock;

@end

NS_ASSUME_NONNULL_END
