//
//  LJLiveReportView.m
//  Woohoo
//
//  Created by 王雨乔 on 2020/9/13.
//

#import "LJLiveReportView.h"
#import "LJLiveReportCell.h"
#import "LJLiveImagePicker.h"

static NSString *const kLJCellID = @"LJLiveReportViewCellID";

@interface LJLiveReportView () <UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

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

@implementation LJLiveReportView

#pragma mark - Life Cycle

+ (LJLiveReportView *)reportView
{
    LJLiveReportView *view = kLJLoadingXib(@"LJLiveReportView");
    view.frame = kLJScreenBounds;
    return view;
}


#pragma mark - Init



#pragma mark - Event



#pragma mark - UITextViewDelegate





#pragma mark - UICollectionViewDelegate




#pragma mark - Methods



#pragma mark - Getter


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LJLiveReportCell *report = [collectionView dequeueReusableCellWithReuseIdentifier:kLJCellID forIndexPath:indexPath];
    kLJWeakSelf;
    if (indexPath.row == self.photos.count) {
        // 新增
        report.image = kLJImageNamed(@"lj_live_report_add_icon");
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
            [LJLiveImagePicker tyb_photoLibraryWithSender:[LJLiveMethods lj_currentViewController] allowEdit:NO completion:^(UIImage * _Nullable image) {
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
- (void)lj_dismiss
{
    [UIView animateWithDuration:0.15 animations:^{
        self.contentView.y = kLJScreenHeight;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}
- (void)submitButtonClick:(UIButton *)sender
{
    if (self.textView.text.length == 0) {
        LJTipError(kLJLocalString(@"Content cannot be empty."));
        return;
    }
    if (self.submitBlock) {
        self.submitBlock(self.textView.text, self.photos);
        [self lj_dismiss];
    }
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self lj_setupDataSource];
    [self lj_setupViews];
}
- (void)textViewDidChange:(UITextView *)textView
{
    self.textNumLabel.text = [NSString stringWithFormat:@"%ld/300", textView.text.length];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.maskButton.enabled = NO;
    return YES;
}
- (void)lj_showInView:(UIView *)inView
{
    [inView addSubview:self];
    self.contentView.y = kLJScreenHeight;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.y = kLJScreenHeight - (432 + kLJBottomSafeHeight);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    } completion:^(BOOL finished) {
    }];
}
- (void)lj_setupDataSource
{
    self.photos = [@[] mutableCopy];
}
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(89, 92);
        layout.sectionInset = UIEdgeInsetsMake(0, kLJWidthScale(15), 0, kLJWidthScale(15));
        layout.minimumInteritemSpacing = 0.01;
        layout.minimumLineSpacing = 0.01;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 211+5, kLJScreenWidth, 92) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.showsHorizontalScrollIndicator = YES;
        [_collectionView registerNib:[UINib nibWithNibName:@"LJLiveReportCell" bundle:kLJLiveBundle] forCellWithReuseIdentifier:kLJCellID];
    }
    return _collectionView;
}
- (IBAction)maskButtonClick:(UIButton *)sender
{
    [self lj_dismiss];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    self.maskButton.enabled = YES;
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *content = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (content.length > 300) {
        return NO;
    }
    return YES;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count > 3 ? self.photos.count : self.photos.count + 1;
}
- (void)lj_setupViews
{
    self.contentViewHeight.constant = 12 + 432 + kLJBottomSafeHeight;
    self.submitButtonLeft.constant = kLJWidthScale(24);
    self.titleLabelLeft.constant = kLJWidthScale(15);
    //
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 12;
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 6;
    //
    UIImage *image = [UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
        graColor.fromColor = kLJHexColor(0xFF32A1);
        graColor.toColor = kLJHexColor(0xFC5F7C);
        graColor.type = QQGradualChangeTypeLeftToRight;
    } size:CGSizeMake(kLJScreenWidth - kLJWidthScale(24)*2, 60) cornerRadius:QQRadiusMakeSame(30)];
    [self.submitButton setBackgroundImage:image forState:UIControlStateNormal];
    //
    self. textView.delegate = self;
    [self.submitButton addTarget:self action:@selector(submitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //
    [self.contentView addSubview:self.collectionView];
    
    //
    self.desTagLabel.text = kLJLocalString(@"Please describe the report in detail");
    self.uploadTagLabel.text = kLJLocalString(@"Upload image (maximum of 4)");
    [self.submitButton setTitle:kLJLocalString(@"Submit") forState:UIControlStateNormal];
}
@end
