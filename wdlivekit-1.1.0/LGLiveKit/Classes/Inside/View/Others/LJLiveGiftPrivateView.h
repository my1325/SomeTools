//
//  LJLiveGiftPrivateView.h
//  Woohoo
//
//  Created by M2-mini on 2021/8/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveGiftPrivateView : UIView







- (void)lj_dismiss;
+ (LJLiveGiftPrivateView *)privateView;
- (void)lj_showInView:(UIView *)inView;
@property (nonatomic, copy) LJLiveVoidBlock leftAvatarBlock, rightAvatarBlock, dismissBlock;
@property (nonatomic, strong) LJLiveRoom *liveRoom;
@property (nonatomic, copy) LJLiveObjectBlock privateBlock;
@end

NS_ASSUME_NONNULL_END
