//
//  GYLiveGiftBarrageViewModel.h
//  Woohoo
//
//  Created by M2-mini on 2021/9/14.
//

#import "GYLiveBaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYLiveGiftBarrageViewModel : GYLiveBaseObject

@property (nonatomic, strong) GYLiveBarrage *barrage;

@property (nonatomic, assign) NSInteger countdown;

@property (nonatomic, copy) GYLiveMessageReceiveBlock dismissBlock;

@end

NS_ASSUME_NONNULL_END
