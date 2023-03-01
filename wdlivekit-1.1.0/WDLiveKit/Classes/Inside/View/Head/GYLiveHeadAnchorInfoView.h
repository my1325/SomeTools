//
//  GYLiveHeadAnchorInfoView.h
//  Woohoo
//
//  Created by M2-mini on 2021/8/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYLiveHeadAnchorInfoView : UIView

@property (nonatomic, copy) GYLiveEventBlock eventBlock;

@property (nonatomic, strong) GYLiveRoom *liveRoom;

@property (nonatomic, assign) BOOL followed;

+ (GYLiveHeadAnchorInfoView *)anchorInfoView;

@end

NS_ASSUME_NONNULL_END
