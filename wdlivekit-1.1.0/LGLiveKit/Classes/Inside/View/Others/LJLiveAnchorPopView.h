//
//  LJLiveAnchorPopView.h
//  ActionSheetPicker-3.0
//
//  Created by Mimio on 2022/8/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveAnchorPopView : UIView

@property (nonatomic, strong) LJLiveRoomAnchor *anchor;

@property (nonatomic, copy) LJLiveVoidBlock reportBlock, avatarBlock, messageBlock, blockBlock;

@property (nonatomic, copy) LJLiveBoolBlock followBlock;

@property (nonatomic, assign) BOOL followed;

+ (LJLiveAnchorPopView *)anchorView;

- (void)lj_showInView:(UIView *)inView;

- (void)lj_dismiss;

@end

NS_ASSUME_NONNULL_END
