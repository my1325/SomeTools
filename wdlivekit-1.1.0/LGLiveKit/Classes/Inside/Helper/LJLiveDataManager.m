//
//  LJLiveDataManager.m
//  Woohoo
//
//  Created by M1-mini on 2022/3/24.
//

#import "LJLiveDataManager.h"

@interface LJLiveDataManager ()

@end

@implementation LJLiveDataManager




#pragma mark - Methods




/// @param operationBlock 操作
/// @param room 房间信息
//    _index = index;
//}
/// 更新房间数组
//- (void)setIndex:(NSInteger)index
//    self.current = self.rooms[index];
//{
/// @param completionBlock 完成操作
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (LJLiveRoom *)current
{
    return self.rooms[self.index];
}
- (void)lj_reloadDataWithSuccess:(void(^) (NSArray<LJLiveRoom *> * _Nonnull rooms))success
                          failure:(LJLiveVoidBlock)failure
{
    // 请求直播数据
    [LJLiveNetworkHelper lj_getLivesWithSuccess:^(NSArray<LJLiveRoom *> * _Nonnull rooms) {
        success(rooms);
        return;
    } failure:^{
        failure();
    }];
}
- (void)lj_initWithRooms:(NSArray *)rooms atIndex:(NSInteger)index
{
    self.rooms = [@[] mutableCopy];
    LJLog(@"live debug room: data init: %ld, index: %ld", rooms.count, index);

    for (LJLiveRoom *room in rooms) {
        [self lj_updateWith:room operationBlock:^LJLiveDataOperation(NSInteger index, LJLiveRoom * _Nullable old) {
            return LJLiveDataOperationReplaceAdd;
        } completionBlock:^(NSInteger index, LJLiveRoom * _Nullable old) {
        }];
    }
    self.index = index;
}
- (void)lj_updateWith:(LJLiveRoom *)room
        operationBlock:(LJLiveDataOperation (^)(NSInteger index, LJLiveRoom * _Nullable old))operationBlock
       completionBlock:(void (^)(NSInteger index, LJLiveRoom * _Nullable old))completionBlock
{
    NSInteger index = -1;
    LJLiveRoom *old = nil;
    for (int j = 0; j < self.rooms.count; j++) {
        LJLiveRoom *m = self.rooms[j];
        if (m.hostAccountId == room.hostAccountId) {
            index = j;
            old = m;
            break;
        }
        if (m.roomId == room.roomId) {
            index = j;
            old = m;
            break;
        }
        if ([m.agoraRoomId isEqualToString:room.agoraRoomId]) {
            index = j;
            old = m;
            break;
        }
    }
    LJLiveDataOperation type = operationBlock(index, old);
    // 是否执行操作
    switch (type) {
        case LJLiveDataOperationReplaceAdd:
        {
            index == -1 ? [self.rooms addObject:room] : [self.rooms replaceObjectAtIndex:index withObject:room];
        }
            break;
        case LJLiveDataOperationRemove:
        {
            if (index != -1) {
                NSInteger oldIndex = self.index;
                [self.rooms removeObjectAtIndex:index];
                if (oldIndex > index) {
                    self.index -= 1;
                }
            }
        }
            break;
        
        default:
            break;
    }
//    if (index == self.index) self.index = index;
    if (completionBlock) completionBlock(index, old);
}
@end
