//
//  LJLiveGiftBarrageViewModel.h
//  Woohoo
//
//  Created by M2-mini on 2021/9/14.
//

#import "LJLiveBaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveGiftBarrageViewModel : LJLiveBaseObject




@property (nonatomic, copy) LJLiveMessageReceiveBlock dismissBlock;
@property (nonatomic, strong) LJLiveBarrage *barrage;
@property (nonatomic, assign) NSInteger countdown;
@end

NS_ASSUME_NONNULL_END
