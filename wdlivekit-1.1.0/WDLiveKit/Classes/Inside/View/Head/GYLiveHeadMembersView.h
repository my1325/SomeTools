//
//  GYLiveHeadMembersView.h
//  Woohoo
//
//  Created by M2-mini on 2021/8/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYLiveHeadMembersView : UIView

@property (nonatomic, copy) GYLiveEventBlock eventBlock;

@property (nonatomic, strong) GYLiveRoom *liveRoom;

+ (GYLiveHeadMembersView *)membersView;

@end

NS_ASSUME_NONNULL_END
