//
//  GYLiveAlertWebView.m
//  Woohoo
//
//  Created by M2-mini on 2021/12/25.
//  Copyright © 2020 王振明. All rights reserved.
//

#import "GYLiveAlertWebView.h"
#import <WDLiveKit/WDLiveKit-Swift.h>
@interface GYLiveAlertWebView ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation GYLiveAlertWebView

+ (GYLiveAlertWebView *)activityPopView
{
    GYLiveAlertWebView *view = kGYLoadingXib(@"GYLiveAlertWebView");
    view.frame = kGYScreenBounds;
    return view;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self fb_initViews];
}

- (void)fb_initViews
{
    [self.mainView insertSubview:self.webView belowSubview:self.backBtn];
    [self bringSubviewToFront:self.backBtn];
    [self addSubview:self.progressView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.mainView);
    }];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.backBtn setImage:[kGYImageNamed(@"fb_live_view_back") fb_flipedByRTL] forState:UIControlStateNormal];
}

- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    self.mainView.transform = CGAffineTransformMakeTranslation(0, kScreenWidth);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:12 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.mainView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
    // 清理combo动画
    kGYLiveHelper.comboing = -1;
    [GYLiveComboViewManager.shared fb_removeCurrentViewFromSuperView];
    UIApplication.sharedApplication.delegate.window.userInteractionEnabled = YES;
}

- (void)dismiss
{
    [UIView animateWithDuration:0.2 animations:^{
        self.mainView.transform = CGAffineTransformMakeTranslation(0, kScreenWidth);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)setReloadURL:(NSString *)reloadURL
{
    _reloadURL = reloadURL;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:reloadURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.webView loadRequest:request];
}

- (IBAction)bz_backAction:(id)sender
{
    [self dismiss];
    
    [GYLiveNetworkHelper fb_getUserInfoWithAccountId:kGYLiveManager.inside.account.accountId success:^(GYLiveAccount * _Nonnull a) {
        kGYLiveManager.inside.account = a;
    } failure:^{
    }];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler
{
    // 在发送请求之前，决定是否跳转
    NSURL *url = navigationAction.request.URL;
    if ([url.absoluteString rangeOfString:@"protocol://app?"].location != NSNotFound) {
        if ([url.absoluteString containsString:@"code=detail"]) {
            NSDictionary *dic = url.absoluteString.fb_parameterAddressURL;
            GYLiveAccount *a = [[GYLiveAccount alloc] init];
            a.accountId = [dic[@"data"] integerValue];
            NSInteger type = [dic[@"type"] integerValue];
            [kGYLiveManager.delegate fb_jumpDetailWithRoleType:type == 0 ? GYLiveRoleTypeAnchor : GYLiveRoleTypeUser account:a];
        }
        if ([url.absoluteString containsString:@"code=decreaseCoins"]) {
            NSDictionary *dic = url.absoluteString.fb_parameterAddressURL;
            NSString *data = dic[@"data"];
            kGYLiveManager.inside.account.coins -= data.integerValue;
            kGYLiveManager.inside.coinsUpdate(kGYLiveManager.inside.account.coins);
            // Firbase精细化打点
            GYFirbase(GYLiveFirbaseEventTypeSpendCurrency, (@{@"way": @"activity"}));
        }
        if ([url.absoluteString containsString:@"code=refreshCoins"]) {
            NSDictionary *dic = url.absoluteString.fb_parameterAddressURL;
            NSString *data = dic[@"data"];
            kGYLiveManager.inside.account.coins = data.integerValue;
            kGYLiveManager.inside.coinsUpdate(data.integerValue);
        }
        if ([url.absoluteString containsString:@"code=toRecharge"]) {
            [kGYLiveManager.delegate fb_jumpToRecharge];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    } else if ([url.absoluteString containsString:@"code=toast"]) {
        NSDictionary *dic = url.absoluteString.fb_parameterAddressURL;
        NSString *msg = dic[@"data"];
        GYTipWarning(msg);
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        BOOL loadFinish = _webView.estimatedProgress == 1.0;
        self.progressView.hidden = loadFinish;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = !loadFinish;
        [self.progressView setProgress:self.webView.estimatedProgress];
    }
}

#pragma mark - getter

- (WKWebView *)webView
{
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        _webView.backgroundColor = [UIColor blackColor];
        _webView.opaque = NO;
        _webView.navigationDelegate = self;
    }
    return _webView;
}

- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, kGYScreenHeight - 2, kGYScreenWidth, 1.5)];
        _progressView.trackTintColor = kGYHexColor(0x252529);
        _progressView.progressTintColor = kGYHexColor(0xFF6152);
    }
    return _progressView;
}

@end
