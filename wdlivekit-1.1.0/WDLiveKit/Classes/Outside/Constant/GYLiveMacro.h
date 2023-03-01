//
//  GYLiveMacro.h
//  Woohoo
//
//  Created by HUANGCHENG on 2021/5/31.
//  Copyright © 2021 tt. All rights reserved.
//

#ifndef GYLiveMacro_h
#define GYLiveMacro_h

/// 打印调试
#ifdef DEBUG
#define GYLog(fmt, ...) NSLog((@"%s [Line %d] \n--------------- GYLog ------------------\n " fmt @"\n----------------------------------------\n"), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__);
#else
#define GYLog(...)
#endif

/// 弱引用
#define kGYWeakSelf __weak __typeof(&*self)weakSelf = self

/// 系统版本
#define kGYSystemVersion [UIDevice currentDevice].systemVersion.doubleValue

/// 当前屏幕尺寸宏定义
#define kGYScreenBounds [UIScreen mainScreen].bounds
#define kGYScreenWidth [UIScreen mainScreen].bounds.size.width
#define kGYScreenHeight [UIScreen mainScreen].bounds.size.height

/// 机型判断的宏定义
#define kGYIsIpxs (kGYScreenWidth >= 375.0f && kGYScreenHeight >= 812.0f)
#define kGYIsIpns ([[UIApplication sharedApplication] statusBarFrame].size.height <= 20)
#define kGYIsIphone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
                    CGSizeEqualToSize(CGSizeMake(640, 1136), \
                    [[UIScreen mainScreen] currentMode].size) : NO)

/// 常用Bar宏定义
#define kGYStatusBarHeight (kGYIsIpxs ? 44 : 20)
#define kGYTabBarHeight (kGYStatusBarHeight > 20 ? 83 : 49)
#define kGYNavBarHeight (kGYStatusBarHeight + 44)
#define kGYBottomSafeHeight (kGYIsIpxs ? 34 : 0)
#define kGYTabBarSafeAreaHeight 34
#define kGYNavBarSafeAreaHeight (kGYStatusBarHeight > 20 ? 24 : 0)
#define kGYNavContainerViewHeight 44

/// 屏幕适配（以6s尺寸为基准）
#define kGYWidthScale(floatValue) (floatValue * kGYScreenWidth/375)
#define kGYHeightScale(floatValue) (floatValue * kGYScreenHeight/667)

#define kGYIpxsHeightScale(floatValue) (kGYIsIpxs ? kGYHeightScale(floatValue) : floatValue)
#define kGYIpnsHeightScale(floatValue) (kGYIsIpns ? kGYHeightScale(floatValue) : floatValue)

#define kGYIpxsWidthScale(floatValue) (kGYIsIpxs ? kGYWidthScale(floatValue) : floatValue)
#define kGYIpnsWidthScale(floatValue) (kGYIsIpns ? kGYWidthScale(floatValue) : floatValue)

/// 根据十六进制设置颜色以及透明度
#define kGYColorFromRGBA(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0f green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:a]

/// 根据十六进制设置透明度为1的颜色
#define kGYHexColor(hexValue) kGYColorFromRGBA(hexValue, 1)

/// UserDefaults
#define kGYUserDefaults [NSUserDefaults standardUserDefaults]

/// 通知
#define kGYNTF [NSNotificationCenter defaultCenter]
#define kGYNTFAddObj(_name, _sel, _obj) [kGYNTF addObserver:self selector:_sel name:_name object:_obj]
#define kGYNTFAdd(_name, _sel) kGYNTFAddObj(_name, _sel, nil)
#define kGYNTFPost(_name, _obj) [kGYNTF postNotificationName:_name object:_obj]

/// 根据内容,字体,限制长度等计算多行文本的size
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define kGYTextSize_MutiLine(_text, _font, _maxSize) [_text length] > 0 ? [_text boundingRectWithSize:_maxSize options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:_font} context:nil].size : CGSizeZero;
#else
#define kGYTextSize_MutiLine(_text, _font, _maxSize) [_text length] > 0 ? [_text sizeWithFont:_font constrainedToSize:_maxSize lineBreakMode:NSLineBreakByWordWrapping] : CGSizeZero;
#endif


#pragma mark - 涉及Bundle

#define kGYLiveBundlePath [[NSBundle bundleForClass:[GYLiveManager class]].bundlePath stringByAppendingPathComponent:@"WDLiveKit.bundle"]
//
#define kGYLiveBundle ([NSBundle bundleWithPath:kGYLiveBundlePath] ?: [NSBundle mainBundle])
/// Xib
#define kGYLoadingXib(stringValue) [[kGYLiveBundle loadNibNamed:stringValue owner:nil options:nil] objectAtIndex:0]//[[[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"Frameworks/WDLiveKit.framework/%@",stringValue] owner:nil options:nil] objectAtIndex:0]
/// 多语言适配
#define kGYLocalString(_key) [_key fb_localized]
/// 图片加载简写 读取xcasset图片
#define kGYImageNamed(_imageName) [UIImage imageNamed:_imageName inBundle:kGYLiveBundle compatibleWithTraitCollection:nil]

#endif /* GYLiveMacro_h */
