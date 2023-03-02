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





- (void)lj_dismiss;
- (void)lj_showInView:(UIView *)inView;
+ (LJLiveReportView *)reportView;
@property (nonatomic, copy) LJLiveReportSubmitBlock submitBlock;
@end

NS_ASSUME_NONNULL_END
