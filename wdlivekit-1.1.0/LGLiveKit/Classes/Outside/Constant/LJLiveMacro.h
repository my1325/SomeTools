//
//  LJLiveMacro.h
//  Woohoo
//
//  Created by HUANGCHENG on 2021/5/31.
//  Copyright © 2021 tt. All rights reserved.
//

#ifndef LJLiveMacro_h
#define LJLiveMacro_h

/// 打印调试
#ifdef DEBUG
#define LJLog(fmt, ...) NSLog((@"%s [Line %d] \n--------------- LJLog ------------------\n " fmt @"\n----------------------------------------\n"), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__);
#else
#define LJLog(...)
#endif

/// 弱引用
#define kLJWeakSelf __weak __typeof(&*self)weakSelf = self

/// 系统版本
#define kLJSystemVersion [UIDevice currentDevice].systemVersion.doubleValue

/// 当前屏幕尺寸宏定义
#define kLJScreenBounds [UIScreen mainScreen].bounds
#define kLJScreenWidth [UIScreen mainScreen].bounds.size.width
#define kLJScreenHeight [UIScreen mainScreen].bounds.size.height

/// 机型判断的宏定义
#define kLJIsIpxs (kLJScreenWidth >= 375.0f && kLJScreenHeight >= 812.0f)
#define kLJIsIpns ([[UIApplication sharedApplication] statusBarFrame].size.height <= 20)
#define kLJIsIphone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
                    CGSizeEqualToSize(CGSizeMake(640, 1136), \
                    [[UIScreen mainScreen] currentMode].size) : NO)

/// 常用Bar宏定义
#define kLJStatusBarHeight (kLJIsIpxs ? 44 : 20)
#define kLJTabBarHeight (kLJStatusBarHeight > 20 ? 83 : 49)
#define kLJNavBarHeight (kLJStatusBarHeight + 44)
#define kLJBottomSafeHeight (kLJIsIpxs ? 34 : 0)
#define kLJTabBarSafeAreaHeight 34
#define kLJNavBarSafeAreaHeight (kLJStatusBarHeight > 20 ? 24 : 0)
#define kLJNavContainerViewHeight 44

/// 屏幕适配（以6s尺寸为基准）
#define kLJWidthScale(floatValue) (floatValue * kLJScreenWidth/375)
#define kLJHeightScale(floatValue) (floatValue * kLJScreenHeight/667)

#define kLJIpxsHeightScale(floatValue) (kLJIsIpxs ? kLJHeightScale(floatValue) : floatValue)
#define kLJIpnsHeightScale(floatValue) (kLJIsIpns ? kLJHeightScale(floatValue) : floatValue)

#define kLJIpxsWidthScale(floatValue) (kLJIsIpxs ? kLJWidthScale(floatValue) : floatValue)
#define kLJIpnsWidthScale(floatValue) (kLJIsIpns ? kLJWidthScale(floatValue) : floatValue)

/// 根据十六进制设置颜色以及透明度
#define kLJColorFromRGBA(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0f green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:a]

/// 根据十六进制设置透明度为1的颜色
#define kLJHexColor(hexValue) kLJColorFromRGBA(hexValue, 1)

/// UserDefaults
#define kLJUserDefaults [NSUserDefaults standardUserDefaults]

/// 通知
#define kLJNTF [NSNotificationCenter defaultCenter]
#define kLJNTFAddObj(_name, _sel, _obj) [kLJNTF addObserver:self selector:_sel name:_name object:_obj]
#define kLJNTFAdd(_name, _sel) kLJNTFAddObj(_name, _sel, nil)
#define kLJNTFPost(_name, _obj) [kLJNTF postNotificationName:_name object:_obj]

/// 根据内容,字体,限制长度等计算多行文本的size
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define kLJTextSize_MutiLine(_text, _font, _maxSize) [_text length] > 0 ? [_text boundingRectWithSize:_maxSize options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:_font} context:nil].size : CGSizeZero;
#else
#define kLJTextSize_MutiLine(_text, _font, _maxSize) [_text length] > 0 ? [_text sizeWithFont:_font constrainedToSize:_maxSize lineBreakMode:NSLineBreakByWordWrapping] : CGSizeZero;
#endif


#pragma mark - 涉及Bundle

#define kLJLiveBundlePath [[NSBundle bundleForClass:[LJLiveManager class]].bundlePath stringByAppendingPathComponent:@"LGLiveKit.bundle"]
//
#define kLJLiveBundle ([NSBundle bundleWithPath:kLJLiveBundlePath] ?: [NSBundle mainBundle])
/// Xib
#define kLJLoadingXib(stringValue) [[kLJLiveBundle loadNibNamed:stringValue owner:nil options:nil] objectAtIndex:0]//[[[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"Frameworks/LGLiveKit.framework/%@",stringValue] owner:nil options:nil] objectAtIndex:0]
/// 多语言适配
#define kLJLocalString(_key) [_key lj_localized]
/// 图片加载简写 读取xcasset图片
#define kLJImageNamed(_imageName) [UIImage imageNamed:_imageName inBundle:kLJLiveBundle compatibleWithTraitCollection:nil]

#endif /* LJLiveMacro_h */
