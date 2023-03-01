//
//  GYLiveAudiencePopView.h
//  ActionSheetPicker-3.0
//
//  Created by Mimio on 2022/8/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYLiveAudiencePopView : UIView

@property (nonatomic, strong) GYLiveRoomUser *user;

@property (nonatomic, copy) GYLiveVoidBlock avatarBlock, reportBlock, blockBlock;

@property (nonatomic, copy) GYLiveBoolBlock followBlock;

@property (nonatomic, assign) BOOL followed;

+ (GYLiveAudiencePopView *)audienceView;

- (void)fb_showInView:(UIView *)inView;

- (void)fb_dismiss;

@end

NS_ASSUME_NONNULL_END
