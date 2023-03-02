//
//  LJLiveRoomGoal.h
//  YKBong
//
//  Created by Mac on 2021/4/6.
//  Copyright © 2021 YKBong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveRoomGoal : LJLiveBaseObject




/** 房间号 */
@property (nonatomic, copy) NSString *goalDesc;
@property (nonatomic, strong) NSNumber *roomId;
@property (nonatomic, strong) NSNumber *goalIncome;
@property (nonatomic, strong) NSNumber *currentIncome;
@end

NS_ASSUME_NONNULL_END
