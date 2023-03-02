//
//  LJLiveReportView.h
//  Woohoo
//
//  Created by 王雨乔 on 2020/9/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LJLiveReportSubmitBlock)(NSString *content, NSArray *images);

@interface LJLiveReportView : UIView

@property (nonatomic, copy) LJLiveReportSubmitBlock submitBlock;

+ (LJLiveReportView *)reportView;

- (void)lj_showInView:(UIView *)inView;

- (void)lj_dismiss;

@end

NS_ASSUME_NONNULL_END
