//
//  GYLiveMatchingView.h
//  Woohoo
//
//  Created by M2-mini on 2021/9/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 匹配成功，倒计时
@interface GYLiveMatchingView : UIView

- (void)fb_matchingSuccessed:(UIView *)inView
                anchorAvatar:(NSString *)anchorAvatar
                  anchorName:(NSString *)anchorName
                  userAvatar:(NSString *)userAvatar
                    userName:(NSString *)userName
            withDelayDismiss:(GYLiveVoidBlock)dismissBlock;

- (void)fb_matchingCountdown:(UIView *)inView
                anchorAvatar:(NSString *)anchorAvatar
                  anchorName:(NSString *)anchorName
                  userAvatar:(NSString *)userAvatar
                    userName:(NSString *)userName
            withDelayDismiss:(GYLiveVoidBlock)dismissBlock;

@end

NS_ASSUME_NONNULL_END
