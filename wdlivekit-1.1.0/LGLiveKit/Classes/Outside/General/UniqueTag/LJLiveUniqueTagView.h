//
//  LJLiveUniqueTagView.h
//  Woohoo
//
//  Created by Mac on 2021/4/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveUniqueTagView : UIView




+ (LJLiveUniqueTagView *)tagView;
- (void)showInView:(UIView *)view;
@property (nonatomic, copy) LJLiveObjectBlock selectTagBlcok;
@end

NS_ASSUME_NONNULL_END
