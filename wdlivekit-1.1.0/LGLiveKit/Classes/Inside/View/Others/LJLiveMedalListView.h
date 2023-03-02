//
//  LJLiveMedalListView.h
//  ActionSheetPicker-3.0
//
//  Created by Mimio on 2022/8/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveMedalListView : UIView

@property (nonatomic, strong) LJLiveRoomAnchor *anchor;

- (void)lj_showInView:(UIView *)inView withAccountId:(NSInteger)accountId;

- (void)lj_dismiss;

@end

NS_ASSUME_NONNULL_END
