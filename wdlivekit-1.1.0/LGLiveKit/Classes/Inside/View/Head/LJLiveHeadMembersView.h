//
//  LJLiveHeadMembersView.h
//  Woohoo
//
//  Created by M2-mini on 2021/8/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveHeadMembersView : UIView




+ (LJLiveHeadMembersView *)membersView;
@property (nonatomic, strong) LJLiveRoom *liveRoom;
@property (nonatomic, copy) LJLiveEventBlock eventBlock;
@end

NS_ASSUME_NONNULL_END
