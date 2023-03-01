//
//  GYLiveGiftBarrageItemView.h
//  Woohoo
//
//  Created by M2-mini on 2021/9/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYLiveGiftBarrageItemView : UIView

@property (nonatomic, strong) GYLiveBarrage * __nullable gift;

@property (nonatomic, copy) GYLiveVoidBlock dismissBlock;

/// 加载中
@property (nonatomic, assign) BOOL isLoading;

+ (GYLiveGiftBarrageItemView *)giftBarrageWithFrame:(CGRect)frame;

- (void)fb_loadingFromLeftWithDismissDelay:(NSTimeInterval)delay
                                completion:(GYLiveVoidBlock)completion;

- (void)fb_dismissToLeftWithCompletion:(GYLiveVoidBlock)completion;

- (void)fb_comboScaleAnimation;

@end

NS_ASSUME_NONNULL_END
