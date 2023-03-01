//
//  GYLiveMedalListView.h
//  ActionSheetPicker-3.0
//
//  Created by Mimio on 2022/8/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYLiveMedalListView : UIView

@property (nonatomic, strong) GYLiveRoomAnchor *anchor;

- (void)fb_showInView:(UIView *)inView withAccountId:(NSInteger)accountId;

- (void)fb_dismiss;

@end

NS_ASSUME_NONNULL_END
