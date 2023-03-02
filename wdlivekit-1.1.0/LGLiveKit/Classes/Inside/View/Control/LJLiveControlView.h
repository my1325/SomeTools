//
//  LJLiveControlView.h
//  Woohoo
//
//  Created by M2-mini on 2021/8/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveControlView : UIView





- (void)lj_closeChatView;
- (void)lj_openChatView;
@property (nonatomic, copy) LJLiveEventBlock eventBlock;
@property (nonatomic, strong) LJLiveRoom *liveRoom;
@end

NS_ASSUME_NONNULL_END
