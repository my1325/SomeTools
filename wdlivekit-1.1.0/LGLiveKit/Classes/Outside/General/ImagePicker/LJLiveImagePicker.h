//
//  LJLiveImagePicker.h
//  Woohoo
//
//  Created by M2-mini on 2021/5/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LJLiveImageBlock)(UIImage * __nullable image);

@interface LJLiveImagePicker : UIViewController

+ (void)tyb_photoLibraryWithSender:(UIViewController *)vc
                         allowEdit:(BOOL)allowEdit
                        completion:(LJLiveImageBlock)completion;

+ (void)lj_cameraWithSender:(UIViewController *)vc
                   allowEdit:(BOOL)allowEdit
                  completion:(LJLiveImageBlock)completion;

@end

NS_ASSUME_NONNULL_END
