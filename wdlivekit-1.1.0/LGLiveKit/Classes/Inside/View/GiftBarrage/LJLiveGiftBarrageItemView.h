//
//  LJLiveGiftBarrageItemView.h
//  Woohoo
//
//  Created by M2-mini on 2021/9/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveGiftBarrageItemView : UIView








/// 加载中
+ (LJLiveGiftBarrageItemView *)giftBarrageWithFrame:(CGRect)frame;
- (void)lj_loadingFromLeftWithDismissDelay:(NSTimeInterval)delay
                                completion:(LJLiveVoidBlock)completion;
- (void)lj_dismissToLeftWithCompletion:(LJLiveVoidBlock)completion;
- (void)lj_comboScaleAnimation;
@property (nonatomic, copy) LJLiveVoidBlock dismissBlock;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) LJLiveBarrage * __nullable gift;
@end

NS_ASSUME_NONNULL_END
