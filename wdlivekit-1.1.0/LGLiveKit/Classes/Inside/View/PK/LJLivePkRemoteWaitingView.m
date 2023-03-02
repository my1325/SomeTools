//
//  LJLivePkRemoteWaitingView.m
//  Woohoo
//
//  Created by M2-mini on 2021/11/26.
//

#import "LJLivePkRemoteWaitingView.h"

@interface LJLivePkRemoteWaitingView ()


@property (weak, nonatomic) IBOutlet YYAnimatedImageView *waitingView;
@end

@implementation LJLivePkRemoteWaitingView

#pragma mark - Life Cycle

+ (LJLivePkRemoteWaitingView *)lj_waitingView
{

    LJLivePkRemoteWaitingView *view = kLJLoadingXib(@"LJLivePkRemoteWaitingView");
    
    view.frame = CGRectMake(0, 0, kLJScreenWidth/2, kLJLiveHelper.ui.pkHomeVideoRect.size.height);
    return view;
}


#pragma mark - Init


- (void)lj_setupViews
{
//    self.waitingView.contentMode = UIViewContentModeScaleAspectFit;
//    NSString *path = [kLJLiveBundle pathForResource:@"lj_live_pk_waiting" ofType:@"gif"];
//    self.waitingView.yy_imageURL = [NSURL fileURLWithPath:path];
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self lj_setupViews];
}
@end
