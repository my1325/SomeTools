//
//  LJLivePageMenu.h
//  LJLivePageMenu
//
//  Created by 乐升平 on 17/10/26. https://github.com/SPStore/SPPageMenu
//  Copyright © 2017年 iDress. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LJLivePageMenuTrackerStyle) {
    LJLivePageMenuTrackerStyleLine = 0,                  // 下划线,默认与item等宽
    LJLivePageMenuTrackerStyleLineLongerThanItem,        // 下划线,比item要长(长度为item的宽+间距)
    LJLivePageMenuTrackerStyleLineAttachment,            // 下划线“依恋”样式，此样式下默认宽度为字体的pointSize，你可以通过trackerWidth自定义宽度
    LJLivePageMenuTrackerStyleRoundedRect,               // 圆角矩形
    LJLivePageMenuTrackerStyleRect,                      // 矩形
    LJLivePageMenuTrackerStyleTextZoom NS_ENUM_DEPRECATED_IOS(6_0, 6_0, "该枚举值已经被废弃，请用“selectedItemZoomScale”属性代替"), // 缩放(该枚举已经被废弃,用属性代替的目的是让其余样式可与缩放样式配套使用。如果你同时设置了该枚举和selectedItemZoomScale属性，selectedItemZoomScale优先级高于LJLivePageMenuTrackerStyleTextZoom
    LJLivePageMenuTrackerStyleNothing                    // 什么样式都没有
};

typedef NS_ENUM(NSInteger, LJLivePageMenuPermutationWay) {
    LJLivePageMenuPermutationWayScrollAdaptContent = 0,  // 自适应内容,可以左右滑动
    LJLivePageMenuPermutationWayNotScrollEqualWidths,    // 等宽排列,不可以滑动,整个内容被控制在pageMenu的范围之内,等宽是根据pageMenu的总宽度对每个按钮均分
    LJLivePageMenuPermutationWayNotScrollAdaptContent    // 自适应内容,不可以滑动,整个内容被控制在pageMenu的范围之内,这种排列方式下,自动计算item之间的间距,itemPadding属性无效
};

typedef NS_ENUM(NSInteger, LJLivePageMenuTrackerFollowingMode) {
    LJLivePageMenuTrackerFollowingModeAlways = 0,   // 外界scrollView拖动时，跟踪器时刻跟随外界scrollView移动
    LJLivePageMenuTrackerFollowingModeEnd,     // 外界scrollVie拖动结束后，跟踪器才开始移动
    LJLivePageMenuTrackerFollowingModeHalf     // 外界scrollView拖动到一半时，跟踪器开始移动
};

typedef NS_ENUM(NSInteger, LJLiveItemImagePosition) {
    LJLiveItemImagePositionDefault,   // 默认图片在左侧
    LJLiveItemImagePositionLeft,      // 图片在文字左侧
    LJLiveItemImagePositionRight,     // 图片在文字右侧
    LJLiveItemImagePositionTop,       // 图片在文字上侧
    LJLiveItemImagePositionBottom     // 图片在文字下侧
};

@class LJLivePageMenu,LJLivePageMenuButtonItem;

@protocol LJLivePageMenuDelegate <NSObject>

// 若以下2个代理方法同时实现了，只会走第2个代理方法（第2个代理方法包含了第1个代理方法的功能）
- (void)pageMenu:(LJLivePageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;
@optional// 右侧的功能按钮被点击的代理方法
- (void)pageMenu:(LJLivePageMenu *)pageMenu functionButtonClicked:(UIButton *)functionButton;
- (void)pageMenu:(LJLivePageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index;

@required@end


@interface LJLivePageMenuScrollView : UIScrollView
@end

@interface LJLivePageMenu : UIView





#if TARGET_INTERFACE_BUILDER
@property (nonatomic, readonly) IBInspectable NSInteger trackerStyle; // 该枚举属性支持storyBoard/xib,方便在storyBoard/xib中创建时直接设置
#else
@property (nonatomic, readonly) LJLivePageMenuTrackerStyle trackerStyle;
#endif
















// 默认NO;关闭跟踪器的跟随效果,在外界传了scrollView进来或者调用了moveTrackerFollowScrollView的情况下,如果为YES，则当外界滑动scrollView时，跟踪器不会时刻跟随,只有滑动结束才会跟随;  3.4.0版本开始被废弃，但是依然能使用,使用后相当于设置了LJLivePageMenuTrackerFollowingModeEnd枚举值
// 设置指定item的四周内边距,3.0版本的时候不小心多写了一个for,3.4.0版本已纠正
/* 1.让跟踪器时刻跟随外界scrollView滑动,实现了让跟踪器的宽度逐渐适应item宽度的功能;
   2.这个方法用于外界的scrollViewDidScroll代理方法中，如
 
    - (void)scrollViewDidScroll:(UIScrollView *)scrollView {
        [self.pageMenu moveTrackerFollowScrollView:scrollView];
    }
 
    3.如果外界设置了LJPageMenu的属性"bridgeScrollView"，那么外界就可以不用在scrollViewDidScroll方法中调用这个方法来实现跟踪器时刻跟随外界scrollView的效果,内部会自动处理; 外界对LJPageMenu的属性"bridgeScrollView"赋值是实现此效果的最简便的操作
 */
// 如果移除的正是当前选中的item(当前选中的item下标不为0),删除之后,选中的item会切换为上一个item
// 为functionButton配置相关属性，如设置字体、文字颜色等；在此,attributes中,只有NSFontAttributeName、NSForegroundColorAttributeName、NSBackgroundColorAttributeName有效
// 插入item,插入和删除操作时,如果itemIndex超过了了items的个数,则不做任何操作
// 跟踪器
/// 阿语翻转
// 下面的方法均有升级，其中ratio参数已失效
// 外界添加控制器view的srollView，pageMenu会监听该scrollView的滚动状况，让跟踪器时刻跟随此scrollView滑动；所谓的滚动状况，是指手指拖拽滚动，非手指拖拽不算
// -------------- 以下方法和属性被废弃，不再建议使用 --------------
/**
 *  传递数据
 *
 *  @param items    数组 (数组元素可以是NSString、UIImage类型、LJPageMenuButtonItem类型，其中LJPageMenuButtonItem相当于一个模型，可以同时设置图片和文字)
 *  @param selectedItemIndex  默认选中item的下标
 */
// 创建pagMenu
+ (instancetype)pageMenuWithFrame:(CGRect)frame trackerStyle:(LJLivePageMenuTrackerStyle)trackerStyle;
- (instancetype)initWithFrame:(CGRect)frame trackerStyle:(LJLivePageMenuTrackerStyle)trackerStyle;
- (void)setTitle:(nonnull NSString *)title forItemAtIndex:(NSUInteger)itemIndex; // 设置指定item的标题,设置后，仅会有文字
- (nullable NSString *)titleForItemAtIndex:(NSUInteger)itemIndex; // 获取指定item的标题

- (void)setImage:(nonnull UIImage *)image forItemAtIndex:(NSUInteger)itemIndex; // 设置指定item的图片,设置后，仅会有图片
- (nullable UIImage *)imageForItemAtIndex:(NSUInteger)itemIndex; // 获取指定item的图片

- (void)setItem:(LJLivePageMenuButtonItem *)item forItemAtIndex:(NSUInteger)itemIndex; // 同时为指定item设置标题和图片
- (nullable LJLivePageMenuButtonItem *)itemAtIndex:(NSUInteger)itemIndex; // 获取指定item

- (void)setContent:(id)content forItemAtIndex:(NSUInteger)itemIndex; // 设置指定item的内容，content可以是NSString、UIImage或LJPageMenuButtonItem类型
- (id)contentForItemAtIndex:(NSUInteger)itemIndex; // 获取指定item的内容，该方法返回值可能是NSString、UIImage或LJPageMenuButtonItem类型

- (void)setWidth:(CGFloat)width forItemAtIndex:(NSUInteger)itemIndex; // 设置指定item的宽度(如果width为0,item会根据内容自动计算width)
- (CGFloat)widthForItemAtIndex:(NSUInteger)itemIndex; // 获取指定item的宽度

- (void)setCustomSpacing:(CGFloat)spacing afterItemAtIndex:(NSUInteger)itemIndex; // 设置指定item后面的自定义间距
- (CGFloat)customSpacingAfterItemAtIndex:(NSUInteger)itemIndex; // 获取指定item后面的自定义间距

- (void)setEnabled:(BOOL)enaled forItemAtIndex:(NSUInteger)itemIndex; // 设置指定item的enabled状态
- (BOOL)enabledForItemAtIndex:(NSUInteger)itemIndex; // 获取指定item的enabled状态

- (void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets forItemAtIndex:(NSUInteger)itemIndex; // 设置指定item的四周内边距
- (UIEdgeInsets)contentEdgeInsetsForItemAtIndex:(NSUInteger)itemIndex; // 获取指定item的四周内边距

// 设置背景图片，barMetrics只有为UIBarMetricsDefault时才生效，如果外界传进来的backgroundImage调用过-resizableImageWithCapInsets:且参数capInsets不为UIEdgeInsetsZero，则直接用backgroundImage作为背景图; 否则内部会自动调用-resizableImageWithCapInsets:进行拉伸
- (void)setBackgroundImage:(nullable UIImage *)backgroundImage barMetrics:(UIBarMetrics)barMetrics;
- (void)setFunctionButtonTitle:(nullable NSString *)title image:(nullable UIImage *)image imagePosition:(LJLiveItemImagePosition)imagePosition imageRatio:(CGFloat)ratio forState:(UIControlState)state NS_DEPRECATED_IOS(6_0, 6_0, "Use - setFunctionButtonWithItem:forState:");
- (void)setTitle:(nullable NSString *)title image:(nullable UIImage *)image imagePosition:(LJLiveItemImagePosition)imagePosition imageRatio:(CGFloat)ratio forItemIndex:(NSUInteger)itemIndex NS_DEPRECATED_IOS(6_0, 6_0, "Use -setItem: forItemIndex:");
- (void)setItems:(nullable NSArray *)items selectedItemIndex:(NSInteger)selectedItemIndex;
- (void)setItem:(LJLivePageMenuButtonItem *)item forItemIndex:(NSUInteger)itemIndex NS_DEPRECATED_IOS(6_0, 6_0, "Use -setItem:forItemAtIndex:");
- (id)objectForItemAtIndex:(NSUInteger)itemIndex NS_DEPRECATED_IOS(6_0, 6_0, "Use -contentForItemAtIndex:");
- (void)setFunctionButtonTitleTextAttributes:(nullable NSDictionary *)attributes forState:(UIControlState)state;
- (void)setContent:(id)content forItemIndex:(NSUInteger)itemIndex NS_DEPRECATED_IOS(6_0, 6_0, "Use -setContent:forItemAtIndex:");
- (void)setTitle:(nullable NSString *)title image:(nullable UIImage *)image imagePosition:(LJLiveItemImagePosition)imagePosition imageRatio:(CGFloat)ratio imageTitleSpace:(CGFloat)imageTitleSpace forItemIndex:(NSUInteger)itemIndex NS_DEPRECATED_IOS(6_0, 6_0, "Use -setItem: forItemIndex:");
- (void)setFunctionButtonWithItem:(LJLivePageMenuButtonItem *)item forState:(UIControlState)state NS_DEPRECATED_IOS(6_0, 6_0, "Use -setFunctionButtonContent:forState:");
- (void)removeAllItems;
- (nullable UIImage *)backgroundImageForBarMetrics:(UIBarMetrics)barMetrics; // 获取背景图片

- (CGRect)titleRectRelativeToPageMenuForItemAtIndex:(NSUInteger)itemIndex;  // 文字相对pageMenu位置和大小
- (CGRect)imageRectRelativeToPageMenuForItemAtIndex:(NSUInteger)itemIndex;  // 图片相对pageMenu位置和大小
- (CGRect)buttonRectRelativeToPageMenuForItemAtIndex:(NSUInteger)itemIndex; // 按钮相对pageMenu位置和大小

- (void)addComponentViewInScrollView:(UIView *)componentView; // 在内置的scrollView上添加一个view

// 设置功能按钮的内容，content可以是NSString、UIImage或LJPageMenuButtonItem类型
- (void)setFunctionButtonContent:(id)content forState:(UIControlState)state;
- (void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets forForItemAtIndex:(NSUInteger)itemIndex NS_DEPRECATED_IOS(6_0, 6_0, "Use -setContentEdgeInsets:forItemAtIndex:");
- (void)insertItemWithTitle:(nonnull NSString *)title atIndex:(NSUInteger)itemIndex animated:(BOOL)animated;
- (void)moveTrackerFollowScrollView:(UIScrollView *)scrollView;
- (void)setTrackerHeight:(CGFloat)trackerHeight cornerRadius:(CGFloat)cornerRadius; // 设置跟踪器的高度和圆角半径，矩形和圆角矩形样式下半径参数无效。其余样式下：默认的高度为3，圆角半径为高度的一半。
@property (nonatomic, assign) LJLivePageMenuTrackerFollowingMode trackerFollowingMode; // 跟踪器的跟踪模式

// 分割线
@property (nonatomic, readonly) UIImageView *dividingLine; // 分割线,你可以拿到该对象设置一些自己想要的属性，如颜色、图片等，如果想要隐藏分割线，拿到该对象直接设置hidden为YES或设置alpha<0.01即可(eg：pageMenu.dividingLine.hidden = YES)
@property (nonatomic) CGFloat dividingLineHeight; // 分割线的高度

@property (nonatomic, assign) UIEdgeInsets contentInset; // 内容的四周内边距(内容不包括分割线)，默认UIEdgeInsetsZero

// 选中的item缩放系数，默认为1，为1代表不缩放，[0,1)之间缩小，(1,+∞)之间放大，(-1,0)之间"倒立"缩小，(-∞,-1)之间"倒立"放大，为-1"倒立不缩放",如果依然使用了废弃的LJLivePageMenuTrackerStyleTextZoom样式，则缩放系数默认为1.3
@property (nonatomic) CGFloat selectedItemZoomScale;
- (void)removeItemAtIndex:(NSUInteger)itemIndex animated:(BOOL)animated;
- (void)insertItemWithImage:(nonnull UIImage *)image atIndex:(NSUInteger)itemIndex animated:(BOOL)animated;
- (void)insertItem:(nonnull LJLivePageMenuButtonItem *)item atIndex:(NSUInteger)itemIndex animated:(BOOL)animated;
- (void)setFunctionButtonTitle:(nullable NSString *)title image:(nullable UIImage *)image imagePosition:(LJLiveItemImagePosition)imagePosition imageRatio:(CGFloat)ratio imageTitleSpace:(CGFloat)imageTitleSpace forState:(UIControlState)state NS_DEPRECATED_IOS(6_0, 6_0, "Use - setFunctionButtonWithItem:forState:");
@property (nonatomic, strong) UIScrollView *bridgeScrollView;
@property (nonatomic, assign) BOOL needTextColorGradients; // 是否需要文字渐变,默认为YES
@property (nonatomic, strong)          UIFont  *itemTitleFont;  // 设置所有item标题字体，不区分选中的item和未选中的item
@property(nonatomic) BOOL alwaysBounceHorizontal; // 水平方向上，当内容没有充满scrollView时，滑动scrollView是否有反弹效果，默认NO
@property (nonatomic, assign) CGFloat spacing; // item之间的间距
@property (nonatomic, assign)  CGFloat itemPadding NS_DEPRECATED_IOS(6_0, 6_0, "Use spacing instead");;
@property (nonnull, nonatomic, strong) UIFont  *unSelectedItemTitleFont;  // 未选中的item字体
@property (nonatomic, readonly) UIImageView *tracker; // 跟踪器,它是一个UIImageView类型，你可以拿到该对象去设置一些自己想要的属性,例如颜色,图片等
@property (nonatomic, strong)          UIColor *selectedItemTitleColor;   // 选中的item标题颜色
@property (nonatomic, assign) LJLivePageMenuPermutationWay permutationWay; // 排列方式
@property(nonatomic,readonly) NSUInteger numberOfItems; // items的总个数
@property (nonatomic, weak) LJLivePageMenuScrollView *itemScrollView;
@property (nonatomic, assign)  CGFloat trackerWidth; // 跟踪器的宽度
@property (nonatomic, strong)          UIColor *unSelectedItemTitleColor; // 未选中的item标题颜色
@property (nonatomic, assign) BOOL flipButtonsByRTL;
@property (nonatomic, weak) id<LJLivePageMenuDelegate> delegate;
@property (nonatomic, assign) CGFloat funtionButtonshadowOpacity; // 功能按钮左侧的阴影透明度,如果设置小于等于0，则没有阴影
@property (nonnull, nonatomic, strong) UIFont  *selectedItemTitleFont;    // 选中的item字体
@property (nonatomic, assign) BOOL closeTrackerFollowingMode NS_DEPRECATED_IOS(6_0, 6_0,"Use trackerFollowingMode instead");
@property(nonatomic) BOOL bounces; // 边界反弹效果，默认YES
@property (nonatomic, assign) BOOL showFuntionButton; // 是否显示功能按钮(功能按钮显示在最右侧),默认为NO
@property (nonatomic) NSInteger selectedItemIndex; // 选中的item下标，改变其值可以用于切换选中的item
@end


// 这个类相当于模型,主要用于同时为某个按钮设置图片和文字时使用
@interface LJLivePageMenuButtonItem : NSObject



// 图片的位置
// 快速创建同时含有标题和图片的item，默认图片在左边，文字在右边
// 图片与标题之间的间距,默认0.0
// 快速创建同时含有标题和图片的item，imagePositiona参数为图片位置
+ (instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image imagePosition:(LJLiveItemImagePosition)imagePosition;
+ (instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) UIImage *image;
@property (nonatomic, assign) LJLiveItemImagePosition imagePosition;
@property (nonatomic, assign) CGFloat imageTitleSpace;
@end

NS_ASSUME_NONNULL_END



