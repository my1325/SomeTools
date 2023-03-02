//
//  LJLiveMarkView.h
//  Woohoo
//
//  Created by M2-mini on 2021/9/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveMarkView : UIView




+ (CGFloat)lj_widthForContent:(NSAttributedString *)content
                       height:(CGFloat)height;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) NSAttributedString *content;
@end

NS_ASSUME_NONNULL_END
