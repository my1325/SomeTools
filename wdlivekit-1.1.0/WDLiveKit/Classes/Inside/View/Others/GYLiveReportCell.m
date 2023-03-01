//
//  GYLiveReportCell.m
//  Woohoo
//
//  Created by 王雨乔 on 2020/9/13.
//

#import "GYLiveReportCell.h"

@interface GYLiveReportCell ()

@property (weak, nonatomic) IBOutlet UIButton *imageButton;

@end

@implementation GYLiveReportCell

#pragma mark - Life Cycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self fb_setupViews];
}

#pragma mark - Init

- (void)fb_setupViews
{
    self.imageButton.layer.masksToBounds = YES;
    self.imageButton.layer.cornerRadius = 6;
    //
    self.imageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.imageButton addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Events

- (IBAction)closeButtonClick:(UIButton *)sender
{
    if (self.deleteBlock) self.deleteBlock();
}

- (void)imageClick:(UIButton *)sender
{
    if (self.previewBlock) self.previewBlock();
}

#pragma mark - Setter

- (void)setImage:(UIImage *)image
{
    _image = image;
    [self.imageButton setImage:image forState:UIControlStateNormal];
}

@end
