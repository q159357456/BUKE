//
//  BKCustomWebViewCtr.m
//  MiniBuKe
//
//  Created by chenheng on 2019/1/2.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKCustomWebViewCtr.h"
#import "CommonUsePackaging.h"

@interface BKCustomWebViewCtr ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property (nonatomic,strong) UIView *topView;
@property(nonatomic,strong)WKWebView *webview;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic, strong) UIProgressView *progress;

@end

@implementation BKCustomWebViewCtr

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
- (void)backBtnClick{

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = COLOR_STRING(@"#f9f9f9");
    
    [self initTopBarView];
    
    [self startLoad];
    
}
- (void)initTopBarView{
    self.topView = [[UIView alloc]init];
    _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH,kNavbarH);
    _topView.backgroundColor = COLOR_STRING(@"#ffffff");
    [self.view addSubview:_topView];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80,kStatusBarH,SCREEN_WIDTH-160,44)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    _titleLabel.textColor = COLOR_STRING(@"#2f2f2f");
    [_topView addSubview: _titleLabel];
    
    self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, kStatusBarH, 40, 40)];
    [self.backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.backBtn setImage:[UIImage imageNamed:@"mate_back"]
                  forState:UIControlStateNormal];
    [self.backBtn setImage:[UIImage imageNamed:@"mate_back"]
                  forState:UIControlStateSelected];
    [_topView addSubview:self.backBtn];
}

- (void)startLoad{
    NSString *encodedString = [self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([encodedString hasPrefix:@"http"]) {
        [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:encodedString]]];
    }
    [self.view addSubview:self.webview];
}
- (UIProgressView *)progress
{
    if (_progress == nil)
    {
        _progress = [[UIProgressView alloc]initWithFrame:CGRectMake(0, kNavbarH-2, SCREEN_WIDTH, 2)];
        _progress.tintColor = COLOR_STRING(@"#6FD06C");
        _progress.backgroundColor = [UIColor whiteColor];
        [self.topView addSubview:_progress];
    }
    return _progress;
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
        [_webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return _webview;
}
- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    
}
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"===didStartProvisionalNavigation=====");
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
    //加载进度值
    if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        if (object == self.webview)
        {
            [self.progress setAlpha:1.0f];
            [self.progress setProgress:self.webview.estimatedProgress animated:YES];
            if(self.webview.estimatedProgress >= 1.0f)
            {
                [UIView animateWithDuration:0.5f
                                      delay:0.3f
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     [self.progress setAlpha:0.0f];
                                 }
                                 completion:^(BOOL finished) {
                                     [self.progress setProgress:0.0f animated:NO];
                                 }];
            }
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    //网页title
    else if ([keyPath isEqualToString:@"title"])
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
    
    [self.webview removeObserver:self forKeyPath:@"title"];
    [self.webview removeObserver:self forKeyPath:@"estimatedProgress"];
    
    self.webview.navigationDelegate = nil;
    self.webview.scrollView.delegate = nil;
    self.webview.UIDelegate = nil;
    self.webview = nil;
}

@end
