//
//  LJLiveMatchingView.h
//  Woohoo
//
//  Created by M2-mini on 2021/9/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 匹配成功，倒计时
@interface LJLiveMatchingView : UIView



- (void)lj_matchingCountdown:(UIView *)inView
                anchorAvatar:(NSString *)anchorAvatar
                  anchorName:(NSString *)anchorName
                  userAvatar:(NSString *)userAvatar
                    userName:(NSString *)userName
            withDelayDismiss:(LJLiveVoidBlock)dismissBlock;
- (void)lj_matchingSuccessed:(UIView *)inView
                anchorAvatar:(NSString *)anchorAvatar
                  anchorName:(NSString *)anchorName
                  userAvatar:(NSString *)userAvatar
                    userName:(NSString *)userName
            withDelayDismiss:(LJLiveVoidBlock)dismissBlock;
@end

NS_ASSUME_NONNULL_END
