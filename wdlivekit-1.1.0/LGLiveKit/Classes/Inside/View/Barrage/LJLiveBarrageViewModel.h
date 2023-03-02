//
//  LJLiveBarrageViewModel.h
//  Woohoo
//
//  Created by M2-mini on 2021/10/12.
//

#import "LJLiveBaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveBarrageViewModel : LJLiveBaseObject





/// 高度
/// 弹幕文案
/// 按钮大小
/// svip
/// 类型
- (instancetype)initWithBarrage:(LJLiveBarrage *)barrage;
@property (nonatomic, assign) BOOL isSvip, isVip;
@property (nonatomic, strong) LJLiveBarrage *barrage;
@property (nonatomic, strong) NSMutableAttributedString *barrageText;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, strong) UIColor *contentColor;
@property (nonatomic, assign) CGRect nameButtonRect;
@property (nonatomic, assign) LJLiveBarrageType barrageType;
@property (nonatomic, assign) CGSize nameButtonSize;
@end

NS_ASSUME_NONNULL_END
