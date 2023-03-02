//
//  LJLiveAudiencePopView.h
//  ActionSheetPicker-3.0
//
//  Created by Mimio on 2022/8/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveAudiencePopView : UIView








- (void)lj_dismiss;
- (void)lj_showInView:(UIView *)inView;
+ (LJLiveAudiencePopView *)audienceView;
@property (nonatomic, strong) LJLiveRoomUser *user;
@property (nonatomic, copy) LJLiveVoidBlock avatarBlock, reportBlock, blockBlock;
@property (nonatomic, copy) LJLiveBoolBlock followBlock;
@property (nonatomic, assign) BOOL followed;
@end

NS_ASSUME_NONNULL_END
