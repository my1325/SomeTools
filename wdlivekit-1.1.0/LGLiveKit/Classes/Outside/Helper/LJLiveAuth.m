//
//  LJLiveAuth.m
//  Woohoo
//
//  Created by M2-mini on 2021/3/16.
//

#import "LJLiveAuth.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <Photos/Photos.h>
//#import <PhotosUI/PhotosUI.h>

@implementation LJLiveAuth

#pragma mark - 请求相册权限

+ (void)lj_requestPhotoAlbumAuthSuccess:(LJLiveVoidBlock __nullable)success
                                 failure:(LJLiveVoidBlock __nullable)failure
{
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
        dispatch_async(dispatch_get_main_queue(), ^{

            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:kLJLocalString(@"Please allow the access of your photo album in the \"Settings - Privacy - Photo Album\" option") preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *okAction = [UIAlertAction actionWithTitle:kLJLocalString(@"Settings") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) { }];
              }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kLJLocalString(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) { }];

            [alertController addAction:okAction];
            [alertController addAction:cancelAction];
            [[LJLiveMethods lj_currentViewController] presentViewController:alertController animated:YES completion:^{}];

            if (failure) failure();
        });
    } else if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusAuthorized) {
                    if (success) success();
                } else {
                    if (failure) failure();
                }
            });
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) success();
        });
    }
}

#pragma mark - 请求相机权限

+ (void)lj_requestCameraAuthSuccess:(LJLiveVoidBlock __nullable)success
                             failure:(LJLiveVoidBlock __nullable)faiulre
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    if (success) success();
                } else {
                    if (faiulre) faiulre();
                }
            });
        }];
    } else if (authStatus == AVAuthorizationStatusAuthorized) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) success();
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:kLJLocalString(@"Please allow the access of your camera in the \"Settings - Privacy - Cameras\"") preferredStyle:UIAlertControllerStyleAlert];

            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:kLJLocalString(@"Settings") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) { }];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kLJLocalString(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) { }];
            [alertController addAction:okAction];
            [alertController addAction:cancelAction];
            [[LJLiveMethods lj_currentViewController] presentViewController:alertController animated:YES completion:^{}];
        });
        if (faiulre) faiulre();
    }
}

#pragma mark - 请求麦克风权限

+ (void)lj_requestMicrophoneAuth:(LJLiveVoidBlock __nullable)success
                          failure:(LJLiveVoidBlock __nullable)failure
{
    AVAudioSession *sharedSession = [AVAudioSession sharedInstance];
    AVAudioSessionRecordPermission permission = [sharedSession recordPermission];
    if (permission == AVAudioSessionRecordPermissionUndetermined) {
        [sharedSession requestRecordPermission:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    if (success) success();
                } else {
                    if (failure) failure();
                }
            });
        }];
    } else if (permission == AVAudioSessionRecordPermissionGranted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) success();
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:kLJLocalString(@"Please allow the access of your Mircophone in the \"Settings - Privacy - Mircophone\" option") preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *okAction = [UIAlertAction actionWithTitle:kLJLocalString(@"Settings") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) { }];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kLJLocalString(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
            [alertController addAction:okAction];
            [alertController addAction:cancelAction];
            [[LJLiveMethods lj_currentViewController] presentViewController:alertController animated:YES completion:^{}];
        });
        if (failure) failure();
    }
}

                    // 拒绝
                    // 允许
        // 未被询问
                    // 允许
        // 明确拒绝
        // 明确允许
        // 添加 AlertAction 事件回调（三种类型：默认，取消，警告）
        // 未做出选择
        // 明确允许
        // 获取访问相机权限时，弹窗的点击事件获取
        // 请求
        // 明确允许
            // 明确拒绝或不确定因素控制
                    // 拒绝
@end
