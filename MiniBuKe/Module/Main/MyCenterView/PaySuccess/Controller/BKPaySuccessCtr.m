//
//  BKPaySuccessCtr.m
//  MiniBuKe
//
//  Created by chenheng on 2018/12/6.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKPaySuccessCtr.h"
#import <WebKit/WebKit.h>
#import "ShareContentView.h"
#import "CenterSevice.h"

@interface BKPaySuccessCtr ()<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate>
@property(nonatomic, strong)WKWebView *webview;
@property(nonatomic, strong)UIProgressView*progress;
@property(nonatomic, strong) UIView *bottomView;
@property(nonatomic, strong)ShareContentView *shareContentView;
@end

@implementation BKPaySuccessCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self addBottomView];
    
    [self.view addSubview:self.webview];
    if (self.url.length == 0) {
        self.url = [NSString stringWithFormat:@"%@/template/html/yyh5/buySucceed/index.html",SERVER_URL];
    }
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}
- (void)addBottomView{
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-92, SCREEN_WIDTH, 92)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    UIButton *backHomebtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-140*2)/3.0, 0, 140, 44)];
    backHomebtn.backgroundColor = COLOR_STRING(@"#FEA449");
    [backHomebtn setTitle:@"返回首页" forState:UIControlStateNormal];
    [backHomebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backHomebtn.titleLabel.font = [UIFont systemFontOfSize:16.f weight:UIFontWeightMedium];
    backHomebtn.layer.cornerRadius = 22.f;
    backHomebtn.clipsToBounds = YES;
    [backHomebtn addTarget:self action:@selector(backHomeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:backHomebtn];
    
    UIButton *sharebtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(backHomebtn.frame)+(SCREEN_WIDTH-140*2)/3.0, 0, 140, 44)];
    sharebtn.backgroundColor = COLOR_STRING(@"#FEA449");
    [sharebtn setTitle:@"分享" forState:UIControlStateNormal];
    [sharebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sharebtn.titleLabel.font = [UIFont systemFontOfSize:16.f weight:UIFontWeightMedium];
    sharebtn.layer.cornerRadius = 22.f;
    sharebtn.clipsToBounds = YES;
    [sharebtn addTarget:self action:@selector(sharebtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:sharebtn];
}
-(ShareContentView *)shareContentView
{
    if (!_shareContentView) {
        
        _shareContentView = [[ShareContentView alloc]init];
    }
    return _shareContentView;
}
#pragma mark - btn action
-(void)backButtonClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)sharebtnAction{
//    [MobClick event:EVENT_Custom_110];
    if (self.shareContentView.imageurl.length==0) {
        [self getShareImage];
    }
    [self.shareContentView show];
}
-(void)getShareImage{
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    [CenterSevice user_invitation_share:^(id responsed, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        NSDictionary *dic= (NSDictionary*)responsed;
        //        NSLog(@"分享的图片%@",dic);
        if (!error) {
            self.shareContentView.imageurl = dic[@"data"][@"picUrl"];
        }else
        {
            
        }
    }];
    
}
- (void)backHomeAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark 移除观察者
- (void)dealloc
{
    [self.webview removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webview removeObserver:self forKeyPath:@"title"];
    if (self.webview) {
        self.webview.scrollView.delegate = nil;
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return nil;
}

#pragma mark - lazy
-(WKWebView *)webview
{
    if (!_webview) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        configuration.preferences = preferences;
        _webview = [[WKWebView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(self.topView.frame)-CGRectGetHeight(self.bottomView.frame)-20) configuration:configuration];
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
    NSLog(@"didFinishNavigation");
    
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"===页面加载失败=====");
}
// 接收到服务器跳转请求之后再执行
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"===接收到服务器跳转请求之后再执行=====");
}
#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{

}

@end
