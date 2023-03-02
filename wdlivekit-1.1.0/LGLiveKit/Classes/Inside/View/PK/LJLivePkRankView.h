//
//  LJLivePkRankView.h
//  Woohoo
//
//  Created by M2-mini on 2021/11/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLivePkRankView : UIView

@property (nonatomic, copy) LJLiveEventBlock eventBlock;
/// 主场
@property (nonatomic, assign) BOOL isHome;

@property (nonatomic, strong) NSArray<LJLivePkTopFan *> *fans;

+ (LJLivePkRankView *)lj_pkRankView;

- (void)lj_pkRankOpenInView:(UIView *)inView;

- (void)lj_dismiss;

@end

NS_ASSUME_NONNULL_END
