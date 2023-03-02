//
//  LJLiveAnchorPopView.h
//  ActionSheetPicker-3.0
//
//  Created by Mimio on 2022/8/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveAnchorPopView : UIView








+ (LJLiveAnchorPopView *)anchorView;
- (void)lj_dismiss;
- (void)lj_showInView:(UIView *)inView;
@property (nonatomic, copy) LJLiveBoolBlock followBlock;
@property (nonatomic, copy) LJLiveVoidBlock reportBlock, avatarBlock, messageBlock, blockBlock;
@property (nonatomic, strong) LJLiveRoomAnchor *anchor;
@property (nonatomic, assign) BOOL followed;
@end

NS_ASSUME_NONNULL_END
