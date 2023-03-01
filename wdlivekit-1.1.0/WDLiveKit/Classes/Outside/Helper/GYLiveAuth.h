//
//  GYLiveAuth.h
//  Woohoo
//
//  Created by M2-mini on 2021/3/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 权限请求
@interface GYLiveAuth : NSObject

/// 相册权限
/// @param success 成功
/// @param failure 失败
+ (void)fb_requestPhotoAlbumAuthSuccess:(GYLiveVoidBlock __nullable)success
                                 failure:(GYLiveVoidBlock __nullable)failure;

/// 相机权限
/// @param success 成功
/// @param faiulre 失败
+ (void)fb_requestCameraAuthSuccess:(GYLiveVoidBlock __nullable)success
                             failure:(GYLiveVoidBlock __nullable)faiulre;

/// 麦克风权限
/// @param success 成功
/// @param failure 失败
+ (void)fb_requestMicrophoneAuth:(GYLiveVoidBlock __nullable)success
                          failure:(GYLiveVoidBlock __nullable)failure;

@end

NS_ASSUME_NONNULL_END
