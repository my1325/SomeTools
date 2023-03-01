//
//  GYLiveDataManager.m
//  Woohoo
//
//  Created by M1-mini on 2022/3/24.
//

#import "GYLiveDataManager.h"

@interface GYLiveDataManager ()

@end

@implementation GYLiveDataManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

//- (void)setIndex:(NSInteger)index
//{
//    _index = index;
//    self.current = self.rooms[index];
//}

- (GYLiveRoom *)current
{
    return self.rooms[self.index];
}

#pragma mark - Methods

- (void)fb_initWithRooms:(NSArray *)rooms atIndex:(NSInteger)index
{
    self.rooms = [@[] mutableCopy];
    GYLog(@"live debug room: data init: %ld, index: %ld", rooms.count, index);

    for (GYLiveRoom *room in rooms) {
        [self fb_updateWith:room operationBlock:^GYLiveDataOperation(NSInteger index, GYLiveRoom * _Nullable old) {
            return GYLiveDataOperationReplaceAdd;
        } completionBlock:^(NSInteger index, GYLiveRoom * _Nullable old) {
        }];
    }
    self.index = index;
}

- (void)fb_reloadDataWithSuccess:(void(^) (NSArray<GYLiveRoom *> * _Nonnull rooms))success
                          failure:(GYLiveVoidBlock)failure
{
    // 请求直播数据
    [GYLiveNetworkHelper fb_getLivesWithSuccess:^(NSArray<GYLiveRoom *> * _Nonnull rooms) {
        success(rooms);
        return;
    } failure:^{
        failure();
    }];
}

/// 更新房间数组
/// @param room 房间信息
/// @param operationBlock 操作
/// @param completionBlock 完成操作
- (void)fb_updateWith:(GYLiveRoom *)room
        operationBlock:(GYLiveDataOperation (^)(NSInteger index, GYLiveRoom * _Nullable old))operationBlock
       completionBlock:(void (^)(NSInteger index, GYLiveRoom * _Nullable old))completionBlock
{
    NSInteger index = -1;
    GYLiveRoom *old = nil;
    for (int j = 0; j < self.rooms.count; j++) {
        GYLiveRoom *m = self.rooms[j];
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
    GYLiveDataOperation type = operationBlock(index, old);
    // 是否执行操作
    switch (type) {
        case GYLiveDataOperationReplaceAdd:
        {
            index == -1 ? [self.rooms addObject:room] : [self.rooms replaceObjectAtIndex:index withObject:room];
        }
            break;
        case GYLiveDataOperationRemove:
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
