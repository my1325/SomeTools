//
//  LJLiveCarouselView.h
//
//  Created by 肖睿 on 16/3/17.
//  Copyright © 2016年 肖睿. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LJLiveCarouselView;

typedef void(^ClickBlock)(NSInteger index);

//pageControl的显示位置
typedef NS_ENUM(NSInteger, PageControlPosition) {
    PositionDefault,           //默认值 == PositionBottomCenter
    PositionHide,           //隐藏
    PositionTopCenter,      //中上
    PositionBottomLeft,     //左下
    PositionBottomCenter,   //中下
    PositionBottomRight     //右下
};

//gif播放方式
typedef NS_ENUM(NSInteger, GifPlayMode) {
    GifPlayModeAlways,          //始终播放
    GifPlayModeNever,           //从不播放
    GifPlayModePauseWhenScroll  //切换图片时不播放
};

//图片切换的方式
typedef NS_ENUM(NSInteger, ChangeMode) {
    ChangeModeDefault,  //轮播滚动
    ChangeModeFade      //淡入淡出
};



/**
 *  代理
 */
@protocol LJLiveCarouselViewDelegate <NSObject>
@optional- (void)carouselView:(LJLiveCarouselView *)carouselView clickImageAtIndex:(NSInteger)index;
@required
/**
 *  该方法用来处理图片的点击，会返回图片在数组中的索引
 *  代理与block二选一即可，若两者都实现，block的优先级高
 *
 *  @param carouselView 控件本身
 *  @param index        图片索引
 */

@end


/**
 *  C语言函数，创建本地gif图片
 *  本地gif图片请使用该函数创建，否则gif无动画效果
 *  @param imageName 图片名称
 */
UIImage *gifImageNamed(NSString *imageName);


/**
 *  说明：要想正常使用，图片数组imageArray必须设置
 *  控件的frame必须设置，xib\sb创建的可不设置
 *  其他属性都有默认值，可不设置
 */
@interface LJLiveCarouselView : UIView


#pragma mark 属性

























#pragma mark 方法












/**
 *  设置分页控件位置，默认为PositionBottomCenter
 *  只有一张图片时，pageControl隐藏
 */
/**
 *  轮播的图片数组，可以是本地图片（UIImage，不能是图片名称），也可以是网络路径
 *  支持网络gif图片，本地gif需做处理后传入
 */
/**
 *  设置分页控件指示器的颜色
 *  不设置则为系统默认
 *
 *  @param color        其他页码的颜色
 *  @param currentColor 当前页码的颜色
 */
/**
 *  描述文字的TextAlignment，默认为NSTextAlignmentCenter
 */
/**
 *  是否开启图片缓存，默认为YES
 */
/**
 *  每一页停留时间，默认为5s，最少1s
 *  当设置的值小于1s时，则为默认值
 */
/**
 *  设置图片的切换模式，默认为ChangeModeDefault
 */
/**
 *  开启定时器
 *  默认已开启，调用该方法会重新开启
 */
/**
 *  点击图片后要执行的操作，会返回图片在数组中的索引
 */
/**
 *  停止定时器
 *  停止后，如果手动滚动图片，定时器会重新开启
 */
/**
 *  占位图片，在设置图片数组之前设置
 *  不设置则为默认占位图
 */
/**
 *  图片描述的字符串数组，应与图片顺序对应
 *
 *  图片描述控件默认是隐藏的
 *  设置该属性，控件会显示
 *  设置为nil或空数组，控件会隐藏
 */
/**
 *  清除沙盒中的图片缓存
 */
/**
 *  修改图片描述控件的部分属性，不需要修改的传nil
 *
 *  @param color   字体颜色，默认为[UIColor whiteColor]
 *  @param font    字体，默认为[UIFont systemFontOfSize:13]
 *  @param bgColor 背景颜色，默认为[UIColor colorWithWhite:0 alpha:0.5]
 */
/**
 *  gif的播放方式，默认为GifPlayModeAlways
 *  淡入淡出模式下修改无效
 */
/**
 *  占位图片，在设置图片数组之前设置
 *  不设置则为默认占位图
 */
/**
 *  如果pagePosition无法满足需求，可通过该属性设置分页控件的偏移量
 *  在pagePosition的基础上进行偏移
 */
/**
 *  设置分页控件指示器的图片
 *  两个图片必须同时设置，否则设置无效
 *  不设置则为系统默认
 *
 *  @param image    其他页码的图片
 *  @param currentImage 当前页码的图片
 */
/**
 *  设置图片的内容模式，默认为UIViewContentModeScaleToFill
 */
/**
 *  代理，用来处理图片的点击
 */
- (void)setPageColor:(UIColor *)color andCurrentPageColor:(UIColor *)currentColor;
- (void)stopTimer;
- (void)startTimer;
- (void)setPageImage:(UIImage *)image andCurrentPageImage:(UIImage *)currentImage;
+ (void)clearDiskCache;
- (void)setDescribeTextColor:(UIColor *)color font:(UIFont *)font bgColor:(UIColor *)bgColor;
@property (nonatomic, assign) NSTimeInterval time;
@property (nonatomic, assign) GifPlayMode gifPlayMode;
@property (nonatomic, strong) NSArray *describeArray;
@property (nonatomic, assign) NSTextAlignment describeTextAlignment;
@property (nonatomic, assign) CGPoint pageOffset;
@property (nonatomic, assign) UIViewContentMode contentMode;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, weak) id<LJLiveCarouselViewDelegate> delegate;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, copy) ClickBlock imageClickBlock;
@property (nonatomic, strong) UIImage *placeholderImage2;
@property (nonatomic, assign) ChangeMode changeMode;
@property (nonatomic, assign) PageControlPosition pagePosition;
@property (nonatomic, assign) BOOL autoCache;
@end
