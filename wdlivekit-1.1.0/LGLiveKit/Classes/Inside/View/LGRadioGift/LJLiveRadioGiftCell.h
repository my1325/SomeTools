//
//  LJRadioGiftView.h
//  wdLive
//
//  Created by Mimio on 2022/6/21.
//  Copyright © 2022 Mimio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJLiveRadioGiftModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LJLiveRadioGiftCellState) {
    LJLiveRadioGiftCellStateWait = 0,      // 等待
    LJLiveRadioGiftCellStateEnter,         // 进场
    LJLiveRadioGiftCellStateShow,          // 展示
    LJLiveRadioGiftCellStateExit,          // 退场
};

@interface LJLiveRadioGiftCell : UIView


@property (nonatomic, assign) LJLiveRadioGiftCellState state;
@property (nonatomic, strong) LJLiveRadioGiftModel *model;
@end

NS_ASSUME_NONNULL_END
