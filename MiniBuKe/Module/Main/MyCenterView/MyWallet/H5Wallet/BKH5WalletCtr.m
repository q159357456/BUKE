//
//  BKH5WalletCtr.m
//  MiniBuKe
//
//  Created by chenheng on 2018/12/21.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKH5WalletCtr.h"
#import "CommonUsePackaging.h"
#import "BKH5DrawDepositCtr.h"
#import "BKWithdrawDepositCtr.h"
#import "BKH5TiXianProgressCtr.h"
@interface BKH5WalletCtr ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) UIView *topView;
@property(nonatomic,strong)WKWebView *webview;
@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation BKH5WalletCtr
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
- (void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTopBar];
    // Do any additional setup after loading the view.
    [self.webview.configuration.userContentController addScriptMessageHandler:self name:@"clickCheckBtn"];
    [self.webview.configuration.userContentController addScriptMessageHandler:self name:@"clickCashBtn"];
    [self startLoad];
}

- (void)startLoad{
    NSString *encodedString = [self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:encodedString]]];
    [self.view addSubview:self.webview];

}

- (void)setUpTopBar{
    self.topView = [[UIView alloc]init];
    _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH,kNavbarH);
    _topView.backgroundColor = COLOR_STRING(@"#ffffff");
    [self.view addSubview:_topView];

    UIImageView *bgView = [[UIImageView alloc]initWithFrame:self.topView.frame];
    bgView.image = [UIImage imageNamed:@"wallet_top_bg"];
    [self.topView addSubview:bgView];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, kStatusBarH, 40, 40)];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"wallet_back_icon"]
             forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"wallet_back_icon"]
             forState:UIControlStateSelected];
    [self.topView addSubview:backBtn];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80,kStatusBarH,SCREEN_WIDTH-160,44)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
//    _titleLabel.text = @"我的钱包";
    _titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    _titleLabel.textColor = COLOR_STRING(@"#FFFFFF");
    [self.topView addSubview: _titleLabel];
}

-(WKWebView *)webview
{
    if (!_webview) {
        [CommonUsePackaging deletWebCache];
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        configuration.preferences = preferences;
        
        _webview = [[WKWebView alloc]initWithFrame:CGRectMake(0, kNavbarH, SCREEN_WIDTH, SCREEN_HEIGHT-kNavbarH) configuration:configuration];
        _webview.UIDelegate = self;
        _webview.navigationDelegate = self;
        _webview.backgroundColor = [UIColor whiteColor];
        _webview.scrollView.showsHorizontalScrollIndicator =NO;
        _webview.scrollView.showsVerticalScrollIndicator = NO;
        [_webview addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];

    }
    return _webview;
}
- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    if ([message.name isEqualToString:@"clickCheckBtn"]) {//查看提现明细
        if (message.body) {
            BKH5TiXianProgressCtr *vc = [[BKH5TiXianProgressCtr alloc]init];
            vc.url = [NSString stringWithFormat:@"%@?token=%@&transactionId=%@",H5DrawProgress,APP_DELEGATE.mLoginResult.token,message.body];
            [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
        }
    }else if ([message.name isEqualToString:@"clickCashBtn"]){//提现按钮
        if (message.body) {
            BKH5DrawDepositCtr *vc = [[BKH5DrawDepositCtr alloc]init];
            vc.url = [NSString stringWithFormat:@"%@?token=%@&money=%@&isBind=%d",H5WalletDraw,APP_DELEGATE.mLoginResult.token,message.body,APP_DELEGATE.mLoginResult.bindWx];
            [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
        }
    }
}
    
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"didFinishNavigation");
    
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%@",error);
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //网页title
    if ([keyPath isEqualToString:@"title"])
    {
        if (object == self.webview)
        {
            self.titleLabel.text = self.webview.title;
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.webview.configuration.userContentController removeScriptMessageHandlerForName:@"clickCheckBtn"];
    [self.webview.configuration.userContentController removeScriptMessageHandlerForName:@"clickCashBtn"];
    [self.webview removeObserver:self forKeyPath:@"title"];

    self.webview.navigationDelegate = nil;
    self.webview.scrollView.delegate = nil;
    self.webview.UIDelegate = nil;
    self.webview = nil;
}

//- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler();
//    }])];
//    [self presentViewController:alertController animated:YES completion:nil];
//
//}
@end
