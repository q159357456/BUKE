//
//  EmViewController.m
//  MiniBuKe
//
//  Created by chenheng on 2019/3/29.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "EmViewController.h"
#import "CommonUsePackaging.h"
@interface EmViewController ()<WKUIDelegate,WKNavigationDelegate>
@property(nonatomic, strong)WKWebView *webview;
@property(nonatomic,strong)UIButton *backBtn;
@end

@implementation EmViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
//    if (@available(iOS 11.0, *)) {
//        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
//    }else
//    {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
//    if (@available(iOS 11.0, *)) {
//        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAlways];
//    }else
//    {
//        self.automaticallyAdjustsScrollViewInsets = YES;
//    }
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webview];
    NSString  *temp = EmblemAddress;
    NSURL *url = [NSURL URLWithString:temp];
    [self.webview loadRequest:[NSURLRequest requestWithURL:url]];
    self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, kStatusBarH, 40, 40)];
    [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_backBtn setImage:[UIImage imageNamed:@"therefore_navibar_back "]
              forState:UIControlStateNormal];
    [self.view addSubview:_backBtn];
    
    
    // Do any additional setup after loading the view.
}
-(void)backBtnClick{
    [APP_DELEGATE.navigationController popViewControllerAnimated:YES];
}
-(WKWebView *)webview
{
    if (!_webview) {
//        [CommonUsePackaging deletWebCache];
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        configuration.preferences = preferences;
        _webview = [[WKWebView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height) configuration:configuration];
        _webview.UIDelegate = self;
        _webview.navigationDelegate = self;
        //        _webview.scrollView.delegate = self;
        _webview.backgroundColor = [UIColor whiteColor];
        _webview.scrollView.showsHorizontalScrollIndicator =NO;
        _webview.scrollView.showsVerticalScrollIndicator = NO;
        _webview.scrollView.bounces = NO;
    }
    return _webview;
}

#pragma mark - webDelegate
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    NSLog(@"===didStartProvisionalNavigation=====");
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
    NSLog(@"===内容开始返回=====");
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{//这里修改导航栏的标题，动态改变
    NSLog(@"加载完成");
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:^(id _Nullable ret, NSError * _Nullable error) {
    }];
//
    
    
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    //    [MBProgressHUD hideHUDForView:self.webview];
    NSLog(@"===页面加载失败=====");
    
    
}
// 接收到服务器跳转请求之后再执行
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"===接收到服务器跳转请求之后再执行=====");
}

-(void)dealloc
{
    NSLog(@"=====dealloc");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
