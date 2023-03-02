//
//  LJLiveHeadAnchorInfoView.h
//  Woohoo
//
//  Created by M2-mini on 2021/8/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveHeadAnchorInfoView : UIView





+ (LJLiveHeadAnchorInfoView *)anchorInfoView;
@property (nonatomic, strong) LJLiveRoom *liveRoom;
@property (nonatomic, assign) BOOL followed;
@property (nonatomic, copy) LJLiveEventBlock eventBlock;
@end

NS_ASSUME_NONNULL_END
