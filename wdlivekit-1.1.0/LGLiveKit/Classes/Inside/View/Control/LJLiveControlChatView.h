//
//  LJLiveControlChatView.h
//  Woohoo
//
//  Created by M2-mini on 2021/8/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveControlChatView : UIView



///
- (void)lj_openClose:(BOOL)openClose animated:(BOOL)animated;
@property (nonatomic, copy) LJLiveEventBlock eventBlock;
@property (nonatomic, assign) CGFloat orginWidth;
@end

NS_ASSUME_NONNULL_END
