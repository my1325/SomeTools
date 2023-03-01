//
//  GYLiveAnchorPopView.h
//  ActionSheetPicker-3.0
//
//  Created by Mimio on 2022/8/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYLiveAnchorPopView : UIView

@property (nonatomic, strong) GYLiveRoomAnchor *anchor;

@property (nonatomic, copy) GYLiveVoidBlock reportBlock, avatarBlock, messageBlock, blockBlock;

@property (nonatomic, copy) GYLiveBoolBlock followBlock;

@property (nonatomic, assign) BOOL followed;

+ (GYLiveAnchorPopView *)anchorView;

- (void)fb_showInView:(UIView *)inView;

- (void)fb_dismiss;

@end

NS_ASSUME_NONNULL_END
