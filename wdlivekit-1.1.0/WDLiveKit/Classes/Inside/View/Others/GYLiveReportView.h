//
//  GYLiveReportView.h
//  Woohoo
//
//  Created by 王雨乔 on 2020/9/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^GYLiveReportSubmitBlock)(NSString *content, NSArray *images);

@interface GYLiveReportView : UIView

@property (nonatomic, copy) GYLiveReportSubmitBlock submitBlock;

+ (GYLiveReportView *)reportView;

- (void)fb_showInView:(UIView *)inView;

- (void)fb_dismiss;

@end

NS_ASSUME_NONNULL_END
