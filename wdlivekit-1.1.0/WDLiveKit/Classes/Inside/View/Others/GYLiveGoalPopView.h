//
//  GYLiveGoalPopView.h
//  YKBong
//
//  Created by Mac on 2021/4/6.
//  Copyright © 2021 YKBong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYLiveGoalPopView : UIView

@property (nonatomic, copy) GYLiveVoidBlock sendGiftBlock;

- (void)updateUIWithModel:(GYLiveRoomGoal *)model;


@end

NS_ASSUME_NONNULL_END
