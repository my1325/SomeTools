//
//  GYLiveGoalView.h
//  YKBong
//
//  Created by Mac on 2021/4/6.
//  Copyright © 2021 YKBong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYLiveGoalView : UIView

@property (nonatomic, assign) BOOL isOpen;

@property (nonatomic, copy) GYLiveBoolBlock openAction;

- (void)updateUIWithModel:(GYLiveRoomGoal *)model;

@end

NS_ASSUME_NONNULL_END
