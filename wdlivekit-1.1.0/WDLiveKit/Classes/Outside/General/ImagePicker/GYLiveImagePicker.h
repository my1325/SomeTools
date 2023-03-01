//
//  GYLiveImagePicker.h
//  Woohoo
//
//  Created by M2-mini on 2021/5/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^GYLiveImageBlock)(UIImage * __nullable image);

@interface GYLiveImagePicker : UIViewController

+ (void)tyb_photoLibraryWithSender:(UIViewController *)vc
                         allowEdit:(BOOL)allowEdit
                        completion:(GYLiveImageBlock)completion;

+ (void)fb_cameraWithSender:(UIViewController *)vc
                   allowEdit:(BOOL)allowEdit
                  completion:(GYLiveImageBlock)completion;

@end

NS_ASSUME_NONNULL_END
