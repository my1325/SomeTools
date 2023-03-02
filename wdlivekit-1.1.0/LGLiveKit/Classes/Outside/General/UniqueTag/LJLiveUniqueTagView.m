//
//  LJLiveUniqueTagView.m
//  Woohoo
//
//  Created by Mac on 2021/4/13.
//

#import "LJLiveUniqueTagView.h"
#import "LJLiveUniqueTagCell.h"

@interface LJLiveUniqueTagView () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@property (weak, nonatomic) IBOutlet UILabel *titleTagLabel;

@property (weak, nonatomic) IBOutlet UILabel *desTagLabel;

@property (weak, nonatomic) IBOutlet UIImageView *emptyView;

@end

@implementation LJLiveUniqueTagView

+ (LJLiveUniqueTagView *)tagView
{
    LJLiveUniqueTagView *view = kLJLoadingXib(@"LJLiveUniqueTagView");
    view.frame = kLJScreenBounds;
    return view;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self lj_setupViews];
    [self lj_bindData];
}

- (void)lj_setupViews
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, kScreenWidth, kLJHeightScale(257)) byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.mainView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.mainView.layer.mask = maskLayer;
    self.mainView.transform = CGAffineTransformMakeTranslation(0, kScreenWidth);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"LJLiveUniqueTagCell" bundle:kLJLiveBundle] forCellReuseIdentifier:@"LJLiveUniqueTagCell"];
    
    self.mainView.transform = CGAffineTransformMakeTranslation(0, kLJHeightScale(257));
    //
    self.titleTagLabel.text = kLJLocalString(@"Choose your unique event medal");
    self.desTagLabel.text = kLJLocalString(@"Please click your favorite medal as your particular comment effect for Multibeam/Livestream below.");
}

- (void)lj_bindData
{
    kLJWeakSelf;
    [LJLiveNetworkHelper lj_getEventLabelListSuccess:^(__kindof id  _Nullable responseObj) {
        self.dataArray = [LJUniqueTag mj_objectArrayWithKeyValuesArray:responseObj];
        weakSelf.emptyView.hidden = self.dataArray.count != 0;
        LJUniqueTag *defaultLabel = kLJLiveManager.inside.accountConfig.defaultEventLabel;
        if (defaultLabel.title.length > 0) {
            for (LJUniqueTag *model in self.dataArray) {
                if ([model.title isEqualToString:defaultLabel.title]) {
                    model.selected = YES;
                }
            }
        }
        [self.tableView reloadData];
    } failure:^{
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LJLiveUniqueTagCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LJLiveUniqueTagCell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LJUniqueTag *selectModel = self.dataArray[indexPath.row];
    for (LJUniqueTag *model in self.dataArray) {
        if ([model.title isEqualToString:selectModel.title]) {
            model.selected = !model.selected;
            selectModel = model;
        }else {
            model.selected = NO;
        }
    }
    [self.tableView reloadData];
    
    if (selectModel.selected) {
        if (self.selectTagBlcok) {
            self.selectTagBlcok(selectModel);
        }
        [LJLiveNetworkHelper lj_setEventLabelWithTitle:selectModel.title success:^(__kindof id  _Nonnull responseObj) {
        } failure:^{
        }];
    } else {
        if (self.selectTagBlcok) {
            self.selectTagBlcok(selectModel);
        }
        [LJLiveNetworkHelper lj_setEventLabelWithTitle:@"" success:^(__kindof id  _Nonnull responseObj) {
        } failure:^{
        }];
    }
}

- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:12 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.mainView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.2 animations:^{
        self.mainView.transform = CGAffineTransformMakeTranslation(0, kLJHeightScale(257));
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)lj_hide:(id)sender {
    [self dismiss];
}

@end
