//
//  GYLivePkRemoteWaitingView.m
//  Woohoo
//
//  Created by M2-mini on 2021/11/26.
//

#import "GYLivePkRemoteWaitingView.h"

@interface GYLivePkRemoteWaitingView ()

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *waitingView;

@end

@implementation GYLivePkRemoteWaitingView

#pragma mark - Life Cycle

+ (GYLivePkRemoteWaitingView *)fb_waitingView
{

    GYLivePkRemoteWaitingView *view = kGYLoadingXib(@"GYLivePkRemoteWaitingView");
    
    view.frame = CGRectMake(0, 0, kGYScreenWidth/2, kGYLiveHelper.ui.pkHomeVideoRect.size.height);
    return view;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self fb_setupViews];
}

#pragma mark - Init

- (void)fb_setupViews
{
//    self.waitingView.contentMode = UIViewContentModeScaleAspectFit;
//    NSString *path = [kGYLiveBundle pathForResource:@"fb_live_pk_waiting" ofType:@"gif"];
//    self.waitingView.yy_imageURL = [NSURL fileURLWithPath:path];
}

@end
