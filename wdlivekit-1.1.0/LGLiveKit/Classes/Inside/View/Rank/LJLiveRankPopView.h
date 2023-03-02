//
//  LJLiveRankPopView.h
//  ActionSheetPicker-3.0
//
//  Created by Mimio on 2022/8/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveRankPopView : UIView







+ (LJLiveRankPopView *)rankView;
- (void)lj_dismiss;
- (void)lj_showInView:(UIView *)inView;
- (void)lj_reloadData;
@property (nonatomic, strong) NSMutableArray<LJLiveRoomMember *> *members;
@property (nonatomic, copy) LJLiveEventBlock eventBlock;
@end

NS_ASSUME_NONNULL_END
