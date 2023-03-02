//
//  LJLiveAuth.h
//  Woohoo
//
//  Created by M2-mini on 2021/3/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 权限请求
@interface LJLiveAuth : NSObject




/// 麦克风权限
/// @param success 成功
/// @param success 成功
/// 相册权限
/// @param faiulre 失败
/// @param failure 失败
/// @param failure 失败
/// @param success 成功
/// 相机权限
+ (void)lj_requestPhotoAlbumAuthSuccess:(LJLiveVoidBlock __nullable)success
                                 failure:(LJLiveVoidBlock __nullable)failure;
+ (void)lj_requestCameraAuthSuccess:(LJLiveVoidBlock __nullable)success
                             failure:(LJLiveVoidBlock __nullable)faiulre;
+ (void)lj_requestMicrophoneAuth:(LJLiveVoidBlock __nullable)success
                          failure:(LJLiveVoidBlock __nullable)failure;
@end

NS_ASSUME_NONNULL_END
