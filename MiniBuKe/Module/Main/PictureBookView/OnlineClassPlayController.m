//
//  OnlineClassPlayController.m
//  MiniBuKe
//
//  Created by chenheng on 2019/7/23.
//  Copyright © 2019 深圳偶家科技有限公司. All rights reserved.
//

#import "OnlineClassPlayController.h"
#import "CommonUsePackaging.h"
#import "ShareManager.h"
#import "WeChatManager.h"
#import "BKUploadingTipCtr.h"
#import "AFNetworkReachabilityManager.h"
@interface OnlineClassPlayController ()<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate,WKScriptMessageHandler>
{
    AFNetworkReachabilityManager * _manager;
}
@property(nonatomic, strong)WKWebView *webview;
@property(nonatomic,strong)UIProgressView*progress;
@end

@implementation OnlineClassPlayController

- (void)viewDidLoad {
    [super viewDidLoad];
 
     self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webview];
    self.webview.scrollView.bounces = NO;
    NSLog(@"self.url==>%@",self.url);
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    //监听UIWindow隐藏
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];
    
    // Do any additional setup after loading the view.
}
-(void)endFullScreen{
    NSLog(@"退出全屏");
     [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
 
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO ;
    [self.webview.configuration.userContentController addScriptMessageHandler:self name:JsAction];
    [self.webview.configuration.userContentController addScriptMessageHandler:self name:@"bmtj"];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
 
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self.webview.configuration.userContentController removeScriptMessageHandlerForName:JsAction];
    [self.webview.configuration.userContentController removeScriptMessageHandlerForName:@"bmtj"];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    //结束监听
    [_manager stopMonitoring];
}
-(BOOL)prefersStatusBarHidden
{
    return NO;
}
-(void)dealloc
{
    self.webview.UIDelegate = nil;
    self.webview.navigationDelegate = nil;
    self.webview.scrollView.delegate = nil;
    [self.webview removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webview removeObserver:self forKeyPath:@"title"];
}
#pragma mark 加载进度条
- (UIProgressView *)progress
{
    if (_progress == nil)
    {
        _progress = [[UIProgressView alloc]initWithFrame:CGRectMake(0, kNavbarH, SCREEN_WIDTH, 2)];
        _progress.tintColor = COLOR_STRING(@"#F6922D");
        _progress.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_progress];
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
        //        preferences.minimumFontSize = 16.0;
        configuration.preferences = preferences;
        _webview = [[WKWebView alloc]initWithFrame:CGRectMake(0, kNavbarH, SCREEN_WIDTH, SCREEN_HEIGHT-kNavbarH) configuration:configuration];
        _webview.UIDelegate = self;
        _webview.navigationDelegate = self;
        _webview.scrollView.delegate = self;
        _webview.backgroundColor = [UIColor whiteColor];
        _webview.scrollView.showsHorizontalScrollIndicator =NO;
        _webview.scrollView.showsVerticalScrollIndicator = NO;
        [_webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
        [_webview addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
//        _webview.mediaPlaybackRequiresUserAction = NO
//        _webview.allowsInlineMediaPlayback = YES
        
        
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
            if (self.titleSetting.length) {
                self.titleLabel.text= self.titleSetting;
            }else
            {
                self.titleLabel.text= self.webview.title;
            }
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




- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return nil;
    
}
-(void)close{
    
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - webDelegate
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    //    [MBProgressHUD showMessage:@"" toView:self.webview];
    NSLog(@"===didStartProvisionalNavigation=====");
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    //    [self.activityIndicator stopAnimating];
    NSLog(@"===内容开始返回=====");
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{//这里修改导航栏的标题，动态改变
    
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:^(id _Nullable ret, NSError * _Nullable error) {
    }];
    
  
    
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


#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
//    NSLog(@"message.name==>%@",message.name);
//    NSLog(@"message.body==>%@",message.body);
    
    if ([message.name isEqualToString:JsAction]) {
        NSString *messageStr = message.body;
        NSData *jsonData = [messageStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic ==>%@",dic[@"ID"]);
        if ([dic[@"ID"] isEqualToString:@"showShareComponent"]) {
            [[ShareManager singleton] getTemplate:[dic[@"data"]integerValue] WebView:self.webview];
        }
        if ([dic[@"ID"] isEqualToString:@"returnShareData"]) {
            [[ShareManager singleton] showShareTemplate:dic[@"data"]];
        }
        if ([dic[@"ID"] isEqualToString:@"pay"]) {
            [self pay_course:dic[@"data"][@"goodsId"]];
        }
        if ([dic[@"ID"] isEqualToString:@"toCourseDetailPage"]) {
            NSString * cid = dic[@"data"][@"courseId"];
            OnlineClassPlayController * vc = [[OnlineClassPlayController alloc]init];
            vc.url = [NSString stringWithFormat:@"%@/template/html/onlineCoursePage/onlineCoursePage.html?token=%@&courseId=%@",H5SERVER_URL,TokenEncode,cid];
            [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
        }
        if ([dic[@"ID"] isEqualToString:@"returnNetWorkStatus"]) {
            [self addObserverAFNListen];
        }
    }
    
    if ([message.name isEqualToString:@"bmtj"]) {
//        NSLog(@"message.body===>%@",message.body);
        if ([message.body isKindOfClass:[NSDictionary class]]) {
             [[BaiduMobStat defaultStat] didReceiveScriptMessage:message.name body:message.body];
        }
       
  
    }


}
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];

}

-(void)pay_course:(NSString*)courseId{
    if (![WXApi isWXAppInstalled]) {
        [CommonUsePackaging showSystemHint:@"您还没有安装微信!"];
        return;
    }
    if (!courseId || ![NSString stringWithFormat:@"%@",courseId].length) {
        [MBProgressHUD showError:@"no result"];
        return ;
    }
    [WeChatManager sharedManager].unfinishedResult = (NSString*)courseId;
    BKUploadingTipCtr *ctr = [[BKUploadingTipCtr alloc]initWithTitle:@"小布壳即将开启微信支付" andDes:@"" andleftBtnTitle:@"取消" andrightBtnTitle:@"确定" andIconName:@"wxpay_image"];
    ctr.view.frame = CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT);
    ctr.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    [ctr setUploadTipLeftBtnClick:^{
        
    }];
    [ctr setUploadTipRightBtnClick:^{
        NSDictionary * dic = @{@"activityId":@"",@"goodsId":courseId,@"openid":@"",@"orderType":@"3",@"payType":@"2",@"userDisId":@""};
        [MBProgressHUD showMessage:@"请等待" toView:self.view];
        [XBKNetWorkManager wxOrderWithDic:dic Finish:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            if (!error) {
                NSLog(@"responseObj==>%@",responseObj);
                [WeChatManager sharedManager].payContent = Pay_Course;
                [WeChatManager weiXinPayWithDic:(NSDictionary*)responseObj];
                [MBProgressHUD hideHUDForView:self.view];
                
            }
        }];
        
    }];
    [self presentViewController:ctr animated:NO completion:^{
        
    }];
}

-(void)addObserverAFNListen{
    
    //创建网络监听对象
    _manager = [AFNetworkReachabilityManager sharedManager];
    //开始监听
    [_manager startMonitoring];
    //监听改变
    FHWeakSelf;
    [_manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                [weakSelf.webview evaluateJavaScript:@"getNetworkStatus('none')" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                    
                }];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [weakSelf.webview evaluateJavaScript:@"getNetworkStatus('none')" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                    
                }];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [weakSelf.webview evaluateJavaScript:@"getNetworkStatus('WAN')" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                    
                }];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [weakSelf.webview evaluateJavaScript:@"getNetworkStatus('wifi')" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//                    NSLog(@"error:%@",error);
//                    NSLog(@"result:%@",result);
                }];
                break;
        }
    }];

    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
