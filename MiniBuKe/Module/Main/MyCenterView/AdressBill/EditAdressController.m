//
//  EditAdressController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/12/3.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "EditAdressController.h"
#import "CenterSevice.h"
#import "BKLoginCodeTip.h"
#import "BKCommonShowTipCtr.h"
#import "CommonUsePackaging.h"
@interface EditAdressController ()
@property(nonatomic,strong)UIProgressView*progress;
@property(nonatomic,strong)NSDictionary *startDic;
@end

@implementation EditAdressController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.webview.configuration.userContentController addScriptMessageHandler:self name:@"done"];
    [_webview.configuration.userContentController addScriptMessageHandler:self name:@"showShareComponent"];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.webview.configuration.userContentController removeScriptMessageHandlerForName:@"done"];
       [self.webview.configuration.userContentController removeScriptMessageHandlerForName:@"showShareComponent"];
}
-(void)dealloc
{
    self.webview.UIDelegate = nil;
    self.webview.navigationDelegate = nil;
    self.webview.scrollView.delegate = nil;
    [self.webview removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webview removeObserver:self forKeyPath:@"title"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webview];
    
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    
    // Do any additional setup after loading the view.
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
        _webview = [[WKWebView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(self.topView.frame)) configuration:configuration];
        _webview.UIDelegate = self;
        _webview.navigationDelegate = self;
        _webview.scrollView.delegate = self;
         _webview.backgroundColor = [UIColor whiteColor];
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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.webview evaluateJavaScript:@"save()"
                       completionHandler:^(id _Nullable ret, NSError * _Nullable error) {
//                           [MBProgressHUD hideHUDForView:self.webview];
                           self.startDic = (NSDictionary*)ret;
                          
                           
        }];
    });
   
    
    
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
    NSLog(@"message.name==>%@",message.name);
    NSLog(@"message.body==>%@",message.body);
    if ([message.name isEqualToString:@"done"]) {
        NSDictionary *dic = (NSDictionary*)message.body;
        NSLog(@"dic--%@",dic);
        if (dic) {
            [self post_pay_addressAdressData:dic];
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

#pragma mark 保存编辑地址
-(void)post_pay_addressAdressData:(NSDictionary*)params
{
    NSMutableDictionary*dic = [NSMutableDictionary dictionaryWithDictionary:params];
    [dic removeObjectForKey:@"orderNo"];
    [MBProgressHUD showMessage:@""];
    [CenterSevice post_pay_addressAdressData:dic CompletionHandler:^(id responsed, NSError *error) {
        [MBProgressHUD hideHUD];
//        NSDictionary *dic = (NSDictionary*)responsed;
        if (!error)
        {
//            NSLog(@"responsed===>%@",responsed);
            if (self.getAdessData) {
                self.getAdessData();
            }
            
            [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"编辑成功" and:APP_DELEGATE.window];
      
            [self.navigationController popViewControllerAnimated:YES];
           
        }else
        {
            
        }
    }];
}

-(void)backButtonClick
{
    [self.webview evaluateJavaScript:@"save()"
                   completionHandler:^(id _Nullable ret, NSError * _Nullable error) {
                       
                       NSDictionary *endDic = (NSDictionary*)ret;
                       NSLog(@"startDic:%@",self.startDic);
                       NSLog(@"endDic:%@",endDic);
                       if ([self.startDic isEqualToDictionary:endDic]||(self.startDic==nil&&endDic==nil)) {
                           [self.navigationController popViewControllerAnimated:YES];
                           return ;
                       }
                       BKCommonShowTipCtr *ctr = [[BKCommonShowTipCtr alloc]init];
                       [ctr showWithTitle:@"" andsubTitle:@"是否保存本次编辑结果?" andLeftBtntitel:@"保存" andRightBtnTitle:@"取消" andIsTap:NO AndLeftBtnAction:^{
                           if ([self jsugeAdressInfoWith:ret]) {
                               
                               [self post_pay_addressAdressData:(NSDictionary*)ret];
                           }
                           
                       } AndRightBtnAction:^{
                           [self.navigationController popViewControllerAnimated:YES];
                       }];
                       [ctr startShowTipWithController:self];
                       
                       
        }];
 

}
//判断是否编辑过
//-(void)
//判读填写信息是否符合要求
-(BOOL)jsugeAdressInfoWith:(id)info{
    NSDictionary *dic = (NSDictionary*)info;
    NSString *addressContext = dic[@"addressContext"];
    NSString *provinceAndCity = dic[@"provinceAndCity"];
    NSString *userName = dic[@"userName"];
    NSString *userPhone = dic[@"userPhone"];
    
    if (!addressContext.length) {
        [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"没有填写详细地址" and:self.view];
        return NO;
    }
    
    if (!provinceAndCity.length) {
        [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"没有填写行政区划" and:self.view];
        return NO;
    }
    
    if (!userName.length) {
       [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"没有填写姓名" and:self.view];
        return NO;
    }
    
    if (![self IsPhoneNumber:userPhone]) {
        [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"请填写正确手机号" and:self.view];
        return NO;
    }
    
    
    return YES;
    
}

-(BOOL)IsPhoneNumber:(NSString *)number
{
    NSString *phoneRegex1=@"^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$";
    NSPredicate *phoneTest1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex1];
    return  [phoneTest1 evaluateWithObject:number];
}
@end
