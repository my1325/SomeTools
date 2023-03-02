//
//  LJLiveGiftPrivateView.h
//  Woohoo
//
//  Created by M2-mini on 2021/8/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveGiftPrivateView : UIView

@property (nonatomic, copy) LJLiveVoidBlock leftAvatarBlock, rightAvatarBlock, dismissBlock;

@property (nonatomic, copy) LJLiveObjectBlock privateBlock;

@property (nonatomic, strong) LJLiveRoom *liveRoom;

+ (LJLiveGiftPrivateView *)privateView;

- (void)lj_showInView:(UIView *)inView;

- (void)lj_dismiss;

@end

NS_ASSUME_NONNULL_END
