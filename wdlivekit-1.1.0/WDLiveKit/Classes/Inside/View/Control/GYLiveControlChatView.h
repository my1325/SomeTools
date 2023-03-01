//
//  GYLiveControlChatView.h
//  Woohoo
//
//  Created by M2-mini on 2021/8/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYLiveControlChatView : UIView

@property (nonatomic, copy) GYLiveEventBlock eventBlock;
///
@property (nonatomic, assign) CGFloat orginWidth;

- (void)fb_openClose:(BOOL)openClose animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
