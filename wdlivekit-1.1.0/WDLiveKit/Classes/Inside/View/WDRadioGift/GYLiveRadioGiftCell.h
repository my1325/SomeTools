//
//  GYRadioGiftView.h
//  wdLive
//
//  Created by Mimio on 2022/6/21.
//  Copyright © 2022 Mimio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYLiveRadioGiftModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GYLiveRadioGiftCellState) {
    GYLiveRadioGiftCellStateWait = 0,      // 等待
    GYLiveRadioGiftCellStateEnter,         // 进场
    GYLiveRadioGiftCellStateShow,          // 展示
    GYLiveRadioGiftCellStateExit,          // 退场
};

@interface GYLiveRadioGiftCell : UIView

@property (nonatomic, assign) GYLiveRadioGiftCellState state;
@property (nonatomic, strong) GYLiveRadioGiftModel *model;

@end

NS_ASSUME_NONNULL_END
