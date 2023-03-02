//
//  LJLiveAutoFollowView.h
//  Woohoo
//
//  Created by M2-mini on 2021/8/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveAutoFollowView : UIView

@property (nonatomic, copy) LJLiveBoolBlock followBlock;

@property (nonatomic, copy) LJLiveVoidBlock avatarBlock, dimissBlock;

+ (LJLiveAutoFollowView *)followView;

- (void)lj_showAvatar:(NSString *)avatar
             nickname:(NSString *)nickname
               follow:(BOOL)follow
               inView:(UIView *)inView;

- (void)lj_dismiss;

@end

NS_ASSUME_NONNULL_END
