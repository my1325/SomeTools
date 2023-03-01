//
//  GYLiveReportView.m
//  Woohoo
//
//  Created by 王雨乔 on 2020/9/13.
//

#import "GYLiveReportView.h"
#import "GYLiveReportCell.h"
#import "GYLiveImagePicker.h"

static NSString *const kGYCellID = @"GYLiveReportViewCellID";

@interface GYLiveReportView () <UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *maskButton;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelLeft;

@property (weak, nonatomic) IBOutlet UILabel *textNumLabel;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *submitButtonLeft;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *desTagLabel;

@property (weak, nonatomic) IBOutlet UILabel *uploadTagLabel;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *photos;

@end

@implementation GYLiveReportView

#pragma mark - Life Cycle

+ (GYLiveReportView *)reportView
{
    GYLiveReportView *view = kGYLoadingXib(@"GYLiveReportView");
    view.frame = kGYScreenBounds;
    return view;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self fb_setupDataSource];
    [self fb_setupViews];
}

#pragma mark - Init

- (void)fb_setupDataSource
{
    self.photos = [@[] mutableCopy];
}

- (void)fb_setupViews
{
    self.contentViewHeight.constant = 12 + 432 + kGYBottomSafeHeight;
    self.submitButtonLeft.constant = kGYWidthScale(24);
    self.titleLabelLeft.constant = kGYWidthScale(15);
    //
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 12;
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 6;
    //
    UIImage *image = [UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
        graColor.fromColor = kGYHexColor(0xFF32A1);
        graColor.toColor = kGYHexColor(0xFC5F7C);
        graColor.type = QQGradualChangeTypeLeftToRight;
    } size:CGSizeMake(kGYScreenWidth - kGYWidthScale(24)*2, 60) cornerRadius:QQRadiusMakeSame(30)];
    [self.submitButton setBackgroundImage:image forState:UIControlStateNormal];
    //
    self. textView.delegate = self;
    [self.submitButton addTarget:self action:@selector(submitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //
    [self.contentView addSubview:self.collectionView];
    
    //
    self.desTagLabel.text = kGYLocalString(@"Please describe the report in detail");
    self.uploadTagLabel.text = kGYLocalString(@"Upload image (maximum of 4)");
    [self.submitButton setTitle:kGYLocalString(@"Submit") forState:UIControlStateNormal];
}

#pragma mark - Event

- (IBAction)maskButtonClick:(UIButton *)sender
{
    [self fb_dismiss];
}

- (void)submitButtonClick:(UIButton *)sender
{
    if (self.textView.text.length == 0) {
        GYTipError(kGYLocalString(@"Content cannot be empty."));
        return;
    }
    if (self.submitBlock) {
        self.submitBlock(self.textView.text, self.photos);
        [self fb_dismiss];
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.maskButton.enabled = NO;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    self.maskButton.enabled = YES;
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.textNumLabel.text = [NSString stringWithFormat:@"%ld/300", textView.text.length];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *content = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (content.length > 300) {
        return NO;
    }
    return YES;
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count > 3 ? self.photos.count : self.photos.count + 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GYLiveReportCell *report = [collectionView dequeueReusableCellWithReuseIdentifier:kGYCellID forIndexPath:indexPath];
    kGYWeakSelf;
    if (indexPath.row == self.photos.count) {
        // 新增
        report.image = kGYImageNamed(@"fb_live_report_add_icon");
        report.closeButton.hidden = YES;
    } else {
        report.image = self.photos[indexPath.row];
        report.closeButton.hidden = NO;
    }
    report.deleteBlock = ^{
        // 删除
        [weakSelf.photos removeObjectAtIndex:indexPath.row];
        [weakSelf.collectionView reloadData];
    };
    report.previewBlock = ^{
        if (indexPath.row == weakSelf.photos.count) {
            // 添加照片
            [GYLiveImagePicker tyb_photoLibraryWithSender:[GYLiveMethods fb_currentViewController] allowEdit:NO completion:^(UIImage * _Nullable image) {
                [weakSelf.photos addObject:image];
                [weakSelf.collectionView reloadData];
            }];
        } else {
            // 取消预览功能
//            NSMutableArray *marr = [@[] mutableCopy];
//            for (UIImage *image in weakSelf.photos) {
//                YBIBImageData *imageData = [[YBIBImageData alloc] init];
//                imageData.thumbImage = image;
//                [marr addObject:imageData];
//            }
//            if (marr.count > 0) {
//                YBImageBrowser *browser = [[YBImageBrowser alloc] init];
//                browser.dataSourceArray = marr;
//                browser.currentPage = indexPath.row;
//                browser.defaultToolViewHandler.topView.operationType = YBIBTopViewOperationTypeSave;
//                [browser show];
//            }
        }
    };
    return report;
}

#pragma mark - Methods

- (void)fb_showInView:(UIView *)inView
{
    [inView addSubview:self];
    self.contentView.y = kGYScreenHeight;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.y = kGYScreenHeight - (432 + kGYBottomSafeHeight);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    } completion:^(BOOL finished) {
    }];
}

- (void)fb_dismiss
{
    [UIView animateWithDuration:0.15 animations:^{
        self.contentView.y = kGYScreenHeight;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

#pragma mark - Getter

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(89, 92);
        layout.sectionInset = UIEdgeInsetsMake(0, kGYWidthScale(15), 0, kGYWidthScale(15));
        layout.minimumInteritemSpacing = 0.01;
        layout.minimumLineSpacing = 0.01;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 211+5, kGYScreenWidth, 92) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.showsHorizontalScrollIndicator = YES;
        [_collectionView registerNib:[UINib nibWithNibName:@"GYLiveReportCell" bundle:kGYLiveBundle] forCellWithReuseIdentifier:kGYCellID];
    }
    return _collectionView;
}

@end
