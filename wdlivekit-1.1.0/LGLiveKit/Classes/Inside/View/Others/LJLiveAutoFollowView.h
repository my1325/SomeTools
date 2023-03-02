//
//  LJLiveAutoFollowView.h
//  Woohoo
//
//  Created by M2-mini on 2021/8/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveAutoFollowView : UIView






- (void)lj_dismiss;
- (void)lj_showAvatar:(NSString *)avatar
             nickname:(NSString *)nickname
               follow:(BOOL)follow
               inView:(UIView *)inView;
+ (LJLiveAutoFollowView *)followView;
@property (nonatomic, copy) LJLiveVoidBlock avatarBlock, dimissBlock;
@property (nonatomic, copy) LJLiveBoolBlock followBlock;
@end

NS_ASSUME_NONNULL_END
