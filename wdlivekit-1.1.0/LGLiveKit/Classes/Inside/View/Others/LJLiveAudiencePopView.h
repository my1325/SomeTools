//
//  LJLiveAudiencePopView.h
//  ActionSheetPicker-3.0
//
//  Created by Mimio on 2022/8/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveAudiencePopView : UIView

@property (nonatomic, strong) LJLiveRoomUser *user;

@property (nonatomic, copy) LJLiveVoidBlock avatarBlock, reportBlock, blockBlock;

@property (nonatomic, copy) LJLiveBoolBlock followBlock;

@property (nonatomic, assign) BOOL followed;

+ (LJLiveAudiencePopView *)audienceView;

- (void)lj_showInView:(UIView *)inView;

- (void)lj_dismiss;

@end

NS_ASSUME_NONNULL_END
