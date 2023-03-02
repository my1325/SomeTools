//
//  LJLivePkRankView.h
//  Woohoo
//
//  Created by M2-mini on 2021/11/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLivePkRankView : UIView






/// 主场
- (void)lj_pkRankOpenInView:(UIView *)inView;
- (void)lj_dismiss;
+ (LJLivePkRankView *)lj_pkRankView;
@property (nonatomic, strong) NSArray<LJLivePkTopFan *> *fans;
@property (nonatomic, assign) BOOL isHome;
@property (nonatomic, copy) LJLiveEventBlock eventBlock;
@end

NS_ASSUME_NONNULL_END
