//
//  LJLiveGoalPopView.h
//  YKBong
//
//  Created by Mac on 2021/4/6.
//  Copyright © 2021 YKBong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveGoalPopView : UIView

@property (nonatomic, copy) LJLiveVoidBlock sendGiftBlock;

- (void)updateUIWithModel:(LJLiveRoomGoal *)model;


@end

NS_ASSUME_NONNULL_END
