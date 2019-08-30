//
//  BKBookReportH5Ctr.m
//  MiniBuKe
//
//  Created by chenheng on 2019/3/6.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKBookReportH5Ctr.h"
#import "CommonUsePackaging.h"
#import "IntensiveReadingController.h"
#import "ShareContentView.h"
#import "WeChatManager.h"
static NSString *H5ShareShow = @"share";
static NSString *H5SHareFuncName = @"clickShareBtn(1)";
//#define URLH5BookReport [NSString stringWithFormat:@"%@/template/html/readReport/readReport.html",H5SERVER_URL]
//https://dev-api.xiaobuke.com/template/html/readReport/readReport.html
#define H5NoticFlag @"JsAction"

@interface BKBookReportH5Ctr () <WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler,UIScrollViewDelegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *titleLabel;
@property(nonatomic,strong) WKWebView *webview;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *backBtn;
@property(nonatomic,strong) ShareContentView *shareContentView;
@property(nonatomic,copy) NSString *url;
@property (nonatomic,assign) BOOL loadComplete;
@property (nonatomic,assign) BOOL isAppera;

@end

@implementation BKBookReportH5Ctr

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    if (self.topView.alpha != 1) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    self.isAppera = YES;

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    if (self.topView.alpha != 1) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.isAppera = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.view.backgroundColor = COLOR_STRING(@"#ffffff");
    [self.view addSubview:self.webview];
    [self setUpTopBar];
    self.shareBtn.hidden = YES;
    [self LoadWebView];
}
-(NSString *)url
{
    if (!_url) {
        
        _url = @"";
    }
    return _url;
}
-(ShareContentView *)shareContentView
{
    if (!_shareContentView) {
        _shareContentView = [[ShareContentView alloc]init];
    }
    return _shareContentView;
}
- (void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpTopBar{
    self.topView = [[UIView alloc]init];
    _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH,kNavbarH);
    _topView.backgroundColor = [UIColor clearColor];
//    _topView.alpha = 0;
    [self.view addSubview:_topView];
    
    self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, kStatusBarH, 40, 40)];
    [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_backBtn setImage:[UIImage imageNamed:@"BookSelection_back_white_icon"]
              forState:UIControlStateNormal];
    [_backBtn setImage:[UIImage imageNamed:@"BookSelection_back_white_icon"]
              forState:UIControlStateSelected];
    [self.view addSubview:_backBtn];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80,kStatusBarH,SCREEN_WIDTH-160,44)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    _titleLabel.textColor = [UIColor whiteColor];
    [self.topView addSubview: _titleLabel];
//    self.titleLabel.hidden = YES;
    
    
    self.shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40-6, kStatusBarH, 40, 40)];
    
    [self.shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.shareBtn];
    
}

- (void)LoadWebView{
//    NSString *encodedString = [[NSString stringWithFormat:@"%@?token=%@&notShare=true",URLH5BookReport,APP_DELEGATE.mLoginResult.token] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
        self.url = ReadReportAdress;
        NSLog(@"self.url ===> %@",self.url);
        [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
        
        [BKLoadAnimationView ShowHitOn:self.view Frame:CGRectMake(0, kNavbarH, SCREEN_WIDTH, SCREEN_HEIGHT-kNavbarH)];
}

-(WKWebView *)webview
{
    if (!_webview) {
        [CommonUsePackaging deletWebCache];
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        configuration.preferences = preferences;
        
        _webview = [[WKWebView alloc]initWithFrame:CGRectMake(0, -kStatusBarH, SCREEN_WIDTH, SCREEN_HEIGHT+kStatusBarH) configuration:configuration];
        _webview.UIDelegate = self;
        _webview.navigationDelegate = self;
        _webview.backgroundColor = COLOR_STRING(@"#ffffff");
        _webview.scrollView.delegate = self;
        _webview.scrollView.showsHorizontalScrollIndicator =NO;
        _webview.scrollView.showsVerticalScrollIndicator = NO;
        _webview.scrollView.bounces = NO;
        [_webview addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        [_webview.configuration.userContentController addScriptMessageHandler:self name:H5NoticFlag];
    }
    return _webview;
}
- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    
    if ([message.name isEqualToString:H5NoticFlag]) {
        NSString *messageStr = message.body;
        NSData *jsonData = [messageStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        NSString *actionID = dic[@"ID"];
        NSDictionary *dataDic = dic[@"data"];
        if ([actionID isEqualToString:@"1012"]) {//跳转绘本
            NSString *bookid = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"bookID"]];
            if (bookid.length) {
                IntensiveReadingController *vc = [[IntensiveReadingController alloc]init];
                vc.bookid = bookid;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        else if ([actionID isEqualToString:@"1021"]){
            
            NSString *weekTab = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"weekTab"]];
            if (weekTab.integerValue == 2)
            {
                self.shareBtn.hidden = YES;
            }else
            {
                 self.shareBtn.hidden = NO;
            }
            NSLog(@"1021===>%@",dataDic);
        }
         else if ([actionID isEqualToString:H5ShareShow]){
             
             NSLog(@"H5ShareShow===>%@",dataDic);
             [MBProgressHUD hideHUDForView:self.view];
             [self.shareContentView show];
             self.shareContentView.imageurl = [NSString stringWithFormat:@"%@%@",@"http://",dataDic[@"data"][@"shareImage"]];
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
    
    self.loadComplete = YES;
    [self changeTopBarWithIsshow:NO];
    
    [BKLoadAnimationView HiddenFrom:self.view];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%@",error);
    [BKLoadAnimationView HiddenFrom:self.view];
    [self addNetError];
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
    
    [self.webview removeObserver:self forKeyPath:@"title"];
    [self.webview.configuration.userContentController removeScriptMessageHandlerForName:H5NoticFlag];
    
    self.webview.navigationDelegate = nil;
    self.webview.scrollView.delegate = nil;
    self.webview.UIDelegate = nil;
    self.webview = nil;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.loadComplete) {
        return;
    }
    if (scrollView.contentOffset.y > kNavbarH) {
        [self changeTopBarWithIsshow:YES];
    }else{
        [self changeTopBarWithIsshow:NO];
    }
}
- (void)changeTopBarWithIsshow:(BOOL)isshow{
    if (self.isAppera == NO) {
        return;
    }
    if (isshow ) {

        
            [UIView animateWithDuration:0.25 animations:^{
                
                self.topView.backgroundColor = [UIColor whiteColor];
                [self.backBtn setImage:[UIImage imageNamed:@"mate_back"]
                              forState:UIControlStateNormal];
                [self.backBtn setImage:[UIImage imageNamed:@"mate_back"]
                              forState:UIControlStateSelected];
                
                [self.shareBtn setImage:[UIImage imageNamed:@"BookSelection_share_icon"] forState:UIControlStateNormal];
                [self.shareBtn setImage:[UIImage imageNamed:@"BookSelection_share_icon"] forState:UIControlStateSelected];
                self.titleLabel.textColor = COLOR_STRING(@"#2f2f2f");
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
            }];

        
    }else{

        
            [UIView animateWithDuration:0.25 animations:^{
                
                [self.backBtn setImage:[UIImage imageNamed:@"BookSelection_back_white_icon"]
                              forState:UIControlStateNormal];
                [self.backBtn setImage:[UIImage imageNamed:@"BookSelection_back_white_icon"]
                              forState:UIControlStateSelected];
                [self.shareBtn setImage:[UIImage imageNamed:@"BookSelection_share_white_icon"] forState:UIControlStateNormal];
                [self.shareBtn setImage:[UIImage imageNamed:@"BookSelection_share_white_icon"] forState:UIControlStateSelected];
//                self.titleLabel.hidden = YES;
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
                
                self.topView.backgroundColor = [UIColor clearColor];
                self.titleLabel.textColor = [UIColor whiteColor];
                
            }];
        }

}
#pragma mark - shareBtn
- (void)shareBtnAction{
    if (![WXApi isWXAppInstalled]) {
        [CommonUsePackaging showSystemHint:@"您还没有安装微信!"];
        return;
    }
    [MBProgressHUD showMessage:@"" toView:self.view];
    [self.webview evaluateJavaScript:H5SHareFuncName completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
//        NSLog(@"result===>%@",result);
        
    }];
    
}

#pragma mark - netError
- (void)addNetError{
    BKNetWorkErrorBackView *backView = [BKNetWorkErrorBackView showOn:self.view WithFrame:CGRectMake(0, kNavbarH, SCREEN_WIDTH, SCREEN_HEIGHT-kNavbarH)];
    kWeakSelf(weakSelf);
    [backView setTryAgainAction:^{
        [weakSelf reloadAgain];
    }];
}
-(void)reloadAgain{
    [self LoadWebView];
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];

}

@end
