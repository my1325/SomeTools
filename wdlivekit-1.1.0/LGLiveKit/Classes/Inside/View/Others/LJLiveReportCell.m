//
//  LJLiveReportCell.m
//  Woohoo
//
//  Created by 王雨乔 on 2020/9/13.
//

#import "LJLiveReportCell.h"

@interface LJLiveReportCell ()


@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@end

@implementation LJLiveReportCell

#pragma mark - Life Cycle


#pragma mark - Init


#pragma mark - Events



#pragma mark - Setter


- (void)lj_setupViews
{
    self.imageButton.layer.masksToBounds = YES;
    self.imageButton.layer.cornerRadius = 6;
    //
    self.imageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.imageButton addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self lj_setupViews];
}
- (IBAction)closeButtonClick:(UIButton *)sender
{
    if (self.deleteBlock) self.deleteBlock();
}
- (void)imageClick:(UIButton *)sender
{
    if (self.previewBlock) self.previewBlock();
}
- (void)setImage:(UIImage *)image
{
    _image = image;
    [self.imageButton setImage:image forState:UIControlStateNormal];
}
@end
