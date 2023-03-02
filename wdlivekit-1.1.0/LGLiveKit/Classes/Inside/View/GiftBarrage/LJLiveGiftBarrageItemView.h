//
//  LJLiveGiftBarrageItemView.h
//  Woohoo
//
//  Created by M2-mini on 2021/9/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveGiftBarrageItemView : UIView

@property (nonatomic, strong) LJLiveBarrage * __nullable gift;

@property (nonatomic, copy) LJLiveVoidBlock dismissBlock;

/// 加载中
@property (nonatomic, assign) BOOL isLoading;

+ (LJLiveGiftBarrageItemView *)giftBarrageWithFrame:(CGRect)frame;

- (void)lj_loadingFromLeftWithDismissDelay:(NSTimeInterval)delay
                                completion:(LJLiveVoidBlock)completion;

- (void)lj_dismissToLeftWithCompletion:(LJLiveVoidBlock)completion;

- (void)lj_comboScaleAnimation;

@end

NS_ASSUME_NONNULL_END
