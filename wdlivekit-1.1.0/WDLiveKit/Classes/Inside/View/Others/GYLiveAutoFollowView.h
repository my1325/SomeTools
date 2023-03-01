//
//  GYLiveAutoFollowView.h
//  Woohoo
//
//  Created by M2-mini on 2021/8/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYLiveAutoFollowView : UIView

@property (nonatomic, copy) GYLiveBoolBlock followBlock;

@property (nonatomic, copy) GYLiveVoidBlock avatarBlock, dimissBlock;

+ (GYLiveAutoFollowView *)followView;

- (void)fb_showAvatar:(NSString *)avatar
             nickname:(NSString *)nickname
               follow:(BOOL)follow
               inView:(UIView *)inView;

- (void)fb_dismiss;

@end

NS_ASSUME_NONNULL_END
