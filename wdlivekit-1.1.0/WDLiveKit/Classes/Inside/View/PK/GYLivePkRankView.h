//
//  GYLivePkRankView.h
//  Woohoo
//
//  Created by M2-mini on 2021/11/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYLivePkRankView : UIView

@property (nonatomic, copy) GYLiveEventBlock eventBlock;
/// 主场
@property (nonatomic, assign) BOOL isHome;

@property (nonatomic, strong) NSArray<GYLivePkTopFan *> *fans;

+ (GYLivePkRankView *)fb_pkRankView;

- (void)fb_pkRankOpenInView:(UIView *)inView;

- (void)fb_dismiss;

@end

NS_ASSUME_NONNULL_END
