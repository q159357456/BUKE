//
//  BKWKWebViewController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/15.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKWKWebViewController.h"
#import <WebKit/WebKit.h>
@interface BKWKWebViewController ()<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate>
@property(nonatomic, strong)WKWebView *webview;
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIProgressView*progress;
@property(nonatomic,strong)UILabel *titleLabel;
@end

@implementation BKWKWebViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
//    [self.webview.configuration.userContentController addScriptMessageHandler:self name:@"done"];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
//    [self.webview.configuration.userContentController removeScriptMessageHandlerForName:@"done"];

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topView];
    [self.topView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.webview];
    
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    
    // Do any additional setup after loading the view.
}
#pragma mark 加载进度条
- (UIProgressView *)progress
{
    if (_progress == nil)
    {
        _progress = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 2)];
        _progress.tintColor = COLOR_STRING(@"#6FD06C");
        _progress.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_progress];
    }
    return _progress;
}
-(UIView *)topView
{
    if (!_topView) {
        CGFloat statuHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        CGFloat navHeight = 44.f + statuHeight;
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, navHeight)];
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_topView.bounds.size.width/2 - 100,statuHeight==44?35:30, 200, 20)];
        
        UIButton *rightBtn= [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 55, statuHeight==44?25:18, 40, 40)];
        [rightBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:rightBtn];
    }
    return _topView;
}
-(WKWebView *)webview
{
    if (!_webview) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        preferences.minimumFontSize = 16.0;
        configuration.preferences = preferences;
        _webview = [[WKWebView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(self.topView.frame)) configuration:configuration];
        _webview.UIDelegate = self;
        _webview.navigationDelegate = self;
        _webview.backgroundColor = [UIColor whiteColor];
        _webview.scrollView.delegate = self;
        _webview.scrollView.showsHorizontalScrollIndicator =NO;
        _webview.scrollView.showsVerticalScrollIndicator = NO;
        [_webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
        [_webview addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        
    }
    return _webview;
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

#pragma mark 移除观察者
- (void)dealloc
{
    [self.webview removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webview removeObserver:self forKeyPath:@"title"];
}



- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return nil;
    
}
-(void)close{
    
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - webDelegate
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    NSLog(@"===didStartProvisionalNavigation=====");
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    //    [self.activityIndicator stopAnimating];
    NSLog(@"===内容开始返回=====");
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{//这里修改导航栏的标题，动态改变
    NSLog(@"didFinishNavigation");
    
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
    
//    [webView evaluateJavaScript:@"setTing()" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
//        //当然在这个setTing()返回的数据可以是个字典的数据形式。
//    }];
//

    
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
    NSLog(@"===页面加载失败=====");
    
    
}
// 接收到服务器跳转请求之后再执行
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
     NSLog(@"===接收到服务器跳转请求之后再执行=====");
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
