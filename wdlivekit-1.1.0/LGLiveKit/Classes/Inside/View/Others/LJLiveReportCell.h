//
//  LJLiveReportCell.h
//  Woohoo
//
//  Created by 王雨乔 on 2020/9/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveReportCell : UICollectionViewCell




@property (nonatomic, strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (nonatomic, copy) LJLiveVoidBlock deleteBlock, previewBlock;
@end

NS_ASSUME_NONNULL_END
