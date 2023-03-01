//
//  GYLiveRankPopView.h
//  ActionSheetPicker-3.0
//
//  Created by Mimio on 2022/8/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYLiveRankPopView : UIView

@property (nonatomic, strong) NSMutableArray<GYLiveRoomMember *> *members;

@property (nonatomic, copy) GYLiveEventBlock eventBlock;

+ (GYLiveRankPopView *)rankView;

- (void)fb_reloadData;

- (void)fb_showInView:(UIView *)inView;

- (void)fb_dismiss;

@end

NS_ASSUME_NONNULL_END
