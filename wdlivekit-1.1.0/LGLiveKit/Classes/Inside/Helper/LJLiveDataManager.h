//
//  LJLiveDataManager.h
//  Woohoo
//
//  Created by M1-mini on 2022/3/24.
//

#import <Foundation/Foundation.h>
#import "LJLiveAccount.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LJLiveDataOperation) {
    LJLiveDataOperationNone,          // 啥事不干
    LJLiveDataOperationReplaceAdd,    // 替换or新增
    LJLiveDataOperationRemove,        // 移除
};

/// 直播间数据管理
@interface LJLiveDataManager : NSObject

/*-------------------------------------------------------------------
 房间数据
 */
///
@property (nonatomic, strong) LJLiveRoom *current;
///
@property (nonatomic, assign) NSInteger index;
///
@property (nonatomic, strong) NSMutableArray<LJLiveRoom *> * rooms;

/// 初始化数据
/// @param rooms rooms
/// @param index index
- (void)lj_initWithRooms:(NSArray *)rooms atIndex:(NSInteger)index;

/// 请求房间列表
/// @param success 成功
/// @param failure 失败
- (void)lj_reloadDataWithSuccess:(void(^) (NSArray<LJLiveRoom *> * _Nonnull rooms))success
                          failure:(LJLiveVoidBlock)failure;

/// 更新房间数组
/// @param room 房间信息
/// @param operationBlock 操作
/// @param completionBlock 完成操作
- (void)lj_updateWith:(LJLiveRoom *)room
        operationBlock:(LJLiveDataOperation (^)(NSInteger index, LJLiveRoom * _Nullable old))operationBlock
       completionBlock:(void (^)(NSInteger index, LJLiveRoom * _Nullable old))completionBlock;

@end

NS_ASSUME_NONNULL_END
