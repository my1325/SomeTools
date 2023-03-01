//
//  GYLiveUniqueTagView.h
//  Woohoo
//
//  Created by Mac on 2021/4/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYLiveUniqueTagView : UIView

@property (nonatomic, copy) GYLiveObjectBlock selectTagBlcok;

+ (GYLiveUniqueTagView *)tagView;

- (void)showInView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
