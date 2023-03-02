//
//  LJLiveImagePicker.m
//  Woohoo
//
//  Created by M2-mini on 2021/5/12.
//

#import "LJLiveImagePicker.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface LJLiveImagePicker () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, copy) LJLiveImageBlock imagesBlock;

@end

@implementation LJLiveImagePicker

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.clearColor;
}

- (void)photoLibraryWithAllowEdit:(BOOL)allowEdit
                       completion:(LJLiveImageBlock)completion
{
    self.imagesBlock = completion;
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // 编辑模式, 但是编辑框是正方形的
    imagePicker.allowsEditing = allowEdit;
    // 设置可用的媒体类型、默认只包含kUTTypeImage
    imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    imagePicker.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)cameraWithAllowEdit:(BOOL)allowEdit
                 completion:(LJLiveImageBlock)completion
{
    self.imagesBlock = completion;
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    // 编辑模式, 但是编辑框是正方形的
    imagePicker.allowsEditing = allowEdit;
    // 设置可用的媒体类型、默认只包含kUTTypeImage
    imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    imagePicker.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

+ (void)tyb_photoLibraryWithSender:(UIViewController *)vc
                         allowEdit:(BOOL)allowEdit
                        completion:(LJLiveImageBlock)completion
{
    [LJLiveAuth lj_requestPhotoAlbumAuthSuccess:^{
        LJLiveImagePicker *selector = [[LJLiveImagePicker alloc] init];
        [vc addChildViewController:selector];
        [selector photoLibraryWithAllowEdit:allowEdit completion:completion];
    } failure:^{
    }];
}

+ (void)lj_cameraWithSender:(UIViewController *)vc
                   allowEdit:(BOOL)allowEdit
                  completion:(LJLiveImageBlock)completion
{
    [LJLiveAuth lj_requestCameraAuthSuccess:^{
        
        LJLiveImagePicker *selector = [[LJLiveImagePicker alloc] init];
        [vc addChildViewController:selector];
        [selector cameraWithAllowEdit:allowEdit completion:completion];
    
    } failure:^{
    }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    // 获取用户拍摄的是照片还是视频
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    // 图片
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        // 图片
        UIImage *image = picker.allowsEditing ? info[UIImagePickerControllerEditedImage] : info[UIImagePickerControllerOriginalImage];
        // 保存图片到相册中
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        if (self.imagesBlock) self.imagesBlock([UIImage imageWithData:imageData]);
    }
    // 视频
    if ([mediaType isEqualToString:(NSString *)kUTTypeVideo]) {
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self removeFromParentViewController];
}

// 取消图片选择调用此方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self removeFromParentViewController];
}

@end
