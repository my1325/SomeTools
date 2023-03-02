//
//  DIMTurntableView.h
//  DIMOOY
//
//  Created by vkooy on 2018/5/21.
//  Copyright © 2017年. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LJDegress2Radians(degrees) ((M_PI * degrees) / 180)
//   - 1.25

@interface LJLiveTurntableGradientColorModel : NSObject


@property (strong,nonatomic) UIColor * endColor;
@property (strong,nonatomic) UIColor * startColor;
@end

@interface LJLiveTurntableViewModel : NSObject


//@property(assign,nonatomic) BOOL isAnimating;//是否是当前正在转的
@property (nonatomic, strong) NSString *remark;
@property(assign,nonatomic) int num;
@property (nonatomic, assign) int index;
@property (nonatomic, strong) NSString *imageName;
@property(assign,nonatomic) int displayIndex;
@end

@interface LJLiveTurntableView : UIView




// displayIndex 数组下标
- (void)turntableRotateToDisplayIndex:(NSInteger)displayIndex;
@property (strong,nonatomic) NSArray <LJLiveTurntableGradientColorModel *>* panBgGradientColors;//开发中，未完善
@property (strong,nonatomic) NSArray <UIColor *>* panBgColors;
@property(assign,nonatomic) CGFloat textPadding;
@property (assign,nonatomic) CGSize imageSize;
@property(copy,nonatomic) void(^lunckyAnimationDidStopBlock)(BOOL flag,LJLiveTurntableViewModel * item);
@property(assign,nonatomic)  CGFloat circleWidth;
@property (strong,nonatomic) UIColor* textFontColor;
@property (nonatomic, strong) NSArray<LJLiveTurntableViewModel *> *luckyItemArray;
@property (strong,nonatomic) UIImageView * bg;
@property (strong,nonatomic) NSDictionary *attributes;
@end
