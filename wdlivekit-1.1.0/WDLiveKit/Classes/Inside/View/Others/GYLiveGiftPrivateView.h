//
//  GYLiveGiftPrivateView.h
//  Woohoo
//
//  Created by M2-mini on 2021/8/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYLiveGiftPrivateView : UIView

@property (nonatomic, copy) GYLiveVoidBlock leftAvatarBlock, rightAvatarBlock, dismissBlock;

@property (nonatomic, copy) GYLiveObjectBlock privateBlock;

@property (nonatomic, strong) GYLiveRoom *liveRoom;

+ (GYLiveGiftPrivateView *)privateView;

- (void)fb_showInView:(UIView *)inView;

- (void)fb_dismiss;

@end

NS_ASSUME_NONNULL_END
