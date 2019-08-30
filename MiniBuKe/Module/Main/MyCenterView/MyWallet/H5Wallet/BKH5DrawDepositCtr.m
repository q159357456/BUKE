//
//  BKH5DrawDepositCtr.m
//  MiniBuKe
//
//  Created by chenheng on 2018/12/21.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKH5DrawDepositCtr.h"
#import "CommonUsePackaging.h"
#import "WeChatManager.h"
#import "BKH5TiXianProgressCtr.h"
@interface BKH5DrawDepositCtr ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property (nonatomic, strong) UIView *topView;
@property(nonatomic,strong)WKWebView *webview;
@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation BKH5DrawDepositCtr
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
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
    [self setUpTopBar];
    // Do any additional setup after loading the view.
    [self.webview.configuration.userContentController addScriptMessageHandler:self name:@"toBind"];
    [self.webview.configuration.userContentController addScriptMessageHandler:self name:@"toDraw"];
    [self.webview.configuration.userContentController addScriptMessageHandler:self name:@"backWX"];

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
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, kStatusBarH, 40, 40)];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"mate_back"]
             forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"mate_back"]
             forState:UIControlStateSelected];
    [_topView addSubview:backBtn];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80,kStatusBarH,SCREEN_WIDTH-160,44)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
//    _titleLabel.text = @"提现";
    _titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    _titleLabel.textColor = COLOR_STRING(@"#2f2f2f");
    [_topView addSubview: _titleLabel];
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
    if ([message.name isEqualToString:@"toBind"]) {
        //绑定跟新微信
        [self updateBindWeChart];
    }else if ([message.name isEqualToString:@"toDraw"]){
        //申请提现成功,跳转进度页
        BKH5TiXianProgressCtr *vc = [[BKH5TiXianProgressCtr alloc]init];
        vc.url = [NSString stringWithFormat:@"%@?token=%@&transactionId=%@",H5DrawProgress,APP_DELEGATE.mLoginResult.token,@"-1"];
        vc.progressDataJsonStr = message.body;
        [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
    }else if ([message.name isEqualToString:@"backWX"]){
        //更新微信头像昵称
        NSString *jsonString = message.body;
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        if (dic != nil) {
            APP_DELEGATE.mLoginResult.wxImageUrl = [dic objectForKey:@"wxImageUrl"];
            APP_DELEGATE.mLoginResult.wxNickName = [dic objectForKey:@"wxNickName"];
            APP_DELEGATE.mLoginResult.bindWx = YES;
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

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.webview.configuration.userContentController removeScriptMessageHandlerForName:@"toBind"];
    [self.webview.configuration.userContentController removeScriptMessageHandlerForName:@"toDraw"];
    [self.webview.configuration.userContentController removeScriptMessageHandlerForName:@"backWX"];
    [self.webview removeObserver:self forKeyPath:@"title"];

    self.webview.navigationDelegate = nil;
    self.webview.scrollView.delegate = nil;
    self.webview.UIDelegate = nil;
    self.webview = nil;
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
#pragma mark -
- (void)updateBindWeChart{
    if (APP_DELEGATE.isWXInstalled)
    {
        [WeChatManager sendAuthRequest];
        [WeChatManager sharedManager].delegate = self;
    }else
    {
        [CommonUsePackaging showSystemHint:@"您还未安装微信客户端，请先下载安装"];
    }
}
/**拉起微信成功回调code*/
-(void)wechatLoginWithCode:(NSString*)code{
    NSLog(@"%@",code);
    if (code.length) {
        NSDictionary *dic = @{
                              @"code":code
                              };
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        [self.webview evaluateJavaScript:[NSString stringWithFormat:@"reqTixian(%@)",jsonString] completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        }];
    }else{
        //授权失败提示
        [[[BKLoginCodeTip alloc]init] AddBindWeChartFailTip:self.view];
    }
}
/**拉起微信失败回调*/
-(void)wechatLoginError{
    //授权失败提示
    [[[BKLoginCodeTip alloc]init] AddBindWeChartFailTip:self.view];
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
