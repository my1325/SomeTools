//
//  LJLiveRankPopView.h
//  ActionSheetPicker-3.0
//
//  Created by Mimio on 2022/8/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveRankPopView : UIView

@property (nonatomic, strong) NSMutableArray<LJLiveRoomMember *> *members;

@property (nonatomic, copy) LJLiveEventBlock eventBlock;

+ (LJLiveRankPopView *)rankView;

- (void)lj_reloadData;

- (void)lj_showInView:(UIView *)inView;

- (void)lj_dismiss;

@end

NS_ASSUME_NONNULL_END
