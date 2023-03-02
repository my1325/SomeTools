//
//  LJLiveHeadAnchorInfoView.h
//  Woohoo
//
//  Created by M2-mini on 2021/8/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveHeadAnchorInfoView : UIView

@property (nonatomic, copy) LJLiveEventBlock eventBlock;

@property (nonatomic, strong) LJLiveRoom *liveRoom;

@property (nonatomic, assign) BOOL followed;

+ (LJLiveHeadAnchorInfoView *)anchorInfoView;

@end

NS_ASSUME_NONNULL_END
