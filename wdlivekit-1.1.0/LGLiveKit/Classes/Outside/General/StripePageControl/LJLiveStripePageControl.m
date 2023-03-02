//
//  LJLiveStripePageControl.m
//  Woohoo
//
//  Created by M2-mini on 2021/7/22.
//

#import "LJLiveStripePageControl.h"

@interface LJLiveStripePageControl ()

@property (nonatomic, strong) UIView *tagView;

@property (nonatomic, strong) UIView *contentView;

@end

@implementation LJLiveStripePageControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self lj_setupViews];
    }
    return self;
}

#pragma mark - Init

- (void)lj_setupViews
{
    [self addSubview:self.contentView];
    [self addSubview:self.tagView];
}

#pragma mark - Getter

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
        _tagView.layer.masksToBounds = YES;
        _tagView.layer.cornerRadius = 1;
    }
    return _contentView;
}

- (UIView *)tagView
{
    if (!_tagView) {
        _tagView = [[UIView alloc] init];
        _tagView.backgroundColor = UIColor.whiteColor;
        _tagView.layer.masksToBounds = YES;
        _tagView.layer.cornerRadius = 1;
    }
    return _tagView;
}

#pragma mark - Setter

- (void)setNormalColor:(UIColor *)normalColor
{
    _normalColor = normalColor;
    self.contentView.backgroundColor = normalColor;
}

- (void)setCurrentTagColor:(UIColor *)currentTagColor
{
    _currentTagColor = currentTagColor;
    self.tagView.backgroundColor = currentTagColor;
}

- (void)setCurrentTagRadius:(CGFloat)currentTagRadius
{
    _currentTagRadius = currentTagRadius;
    self.tagView.layer.cornerRadius = currentTagRadius;
}

- (void)setNumbersOfPage:(NSInteger)numbersOfPage
{
    _numbersOfPage = numbersOfPage;
//    self.hidden = numbersOfPage <= 1;
    [self lj_updateConstraints];
}

- (void)setCurrentTagSize:(CGSize)currentTagSize
{
    _currentTagSize = currentTagSize;
    [self lj_updateConstraints];
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    
    CGFloat p = currentPage * self.currentTagSize.width;
    [UIView animateWithDuration:0.25 animations:^{
        self.tagView.x = CGRectGetMinX(self.contentView.frame) + p;
    }];
}

- (void)lj_updateConstraints
{
    if (CGSizeEqualToSize(CGSizeZero, self.currentTagSize) && self.numbersOfPage <= 0) {
        return;
    }
    self.contentView.frame = CGRectMake(0, 0, self.currentTagSize.width * self.numbersOfPage, self.currentTagSize.height);
    self.contentView.center = CGPointMake(self.size.width/2, self.size.height/2);
    self.tagView.frame = CGRectMake(CGRectGetMinX(self.contentView.frame), self.height/2 - self.currentTagSize.height/2, self.currentTagSize.width, self.currentTagSize.height);
}

@end
