//
//  GYLiveControlView.h
//  Woohoo
//
//  Created by M2-mini on 2021/8/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYLiveControlView : UIView

@property (nonatomic, copy) GYLiveEventBlock eventBlock;

@property (nonatomic, strong) GYLiveRoom *liveRoom;

- (void)fb_openChatView;

- (void)fb_closeChatView;

@end

NS_ASSUME_NONNULL_END
