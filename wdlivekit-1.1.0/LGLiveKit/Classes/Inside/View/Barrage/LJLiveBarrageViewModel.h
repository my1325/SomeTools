//
//  LJLiveBarrageViewModel.h
//  Woohoo
//
//  Created by M2-mini on 2021/10/12.
//

#import "LJLiveBaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveBarrageViewModel : LJLiveBaseObject

@property (nonatomic, strong) LJLiveBarrage *barrage;
/// 弹幕文案
@property (nonatomic, strong) NSMutableAttributedString *barrageText;
/// 高度
@property (nonatomic, assign) CGSize contentSize;
/// svip
@property (nonatomic, assign) BOOL isSvip, isVip;
/// 类型
@property (nonatomic, assign) LJLiveBarrageType barrageType;
/// 按钮大小
@property (nonatomic, assign) CGSize nameButtonSize;

@property (nonatomic, assign) CGRect nameButtonRect;

@property (nonatomic, strong) UIColor *contentColor;

- (instancetype)initWithBarrage:(LJLiveBarrage *)barrage;

@end

NS_ASSUME_NONNULL_END
