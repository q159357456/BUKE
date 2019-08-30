//
//  BKRecommendBookListCtr.m
//  MiniBuKe
//
//  Created by chenheng on 2019/1/22.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKRecommendBookListCtr.h"
#import "CommonUsePackaging.h"
#import "BKRecommendDetailsCtr.h"

#define URLH5RecommendSearch [NSString stringWithFormat:@"%@/template/html/recommendBook/bookList.html",H5SERVER_URL]
#define H5NoticFlag @"JsAction"

@interface BKRecommendBookListCtr ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>


@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *titleLabel;
@property(nonatomic,strong) WKWebView *webview;

@end

@implementation BKRecommendBookListCtr
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpTopBar];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webview];
    [self LoadWebView];
}

- (void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
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
    [self.topView addSubview:backBtn];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80,kStatusBarH,SCREEN_WIDTH-160,44)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    _titleLabel.textColor = COLOR_STRING(@"#2f2f2f");
    [self.topView addSubview: _titleLabel];
    
    UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(0, kNavbarH-0.5, SCREEN_WIDTH, 0.5)];
    sepView.backgroundColor = COLOR_STRING(@"#ededed");
    [self.topView addSubview:sepView];
}

- (void)LoadWebView{
    NSString *encodedString = [URLH5RecommendSearch stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:encodedString]]];
    [BKLoadAnimationView ShowHitOn:self.view Frame:self.webview.frame];
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
        [_webview.configuration.userContentController addScriptMessageHandler:self name:H5NoticFlag];
        [_webview.configuration.userContentController addScriptMessageHandler:self name:@"bmtj"];

    }
    return _webview;
}
- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    NSLog(@"%@",message.name);
    if ([message.name isEqualToString:H5NoticFlag]) {
        NSString *messageStr = message.body;
        NSData *jsonData = [messageStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        NSString *actionID = dic[@"ID"];
        NSDictionary *dataDic = dic[@"data"];
        if ([actionID isEqualToString:@"1011"]) {//跳转书单详情
            NSString *recommeId = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"recommendId"]];
            if (recommeId.length) {
                NSLog(@"书单详情-%@",recommeId);
                BKRecommendDetailsCtr *ctr = [[BKRecommendDetailsCtr alloc]init];
                ctr.recommeId = recommeId;
                [self.navigationController pushViewController:ctr animated:YES];
            }
        }
        
    }else if ([message.name isEqualToString:@"bmtj"]){
        [[BaiduMobStat defaultStat] didReceiveScriptMessage:message.name body:message.body];
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
    [self.webview.configuration.userContentController removeScriptMessageHandlerForName:@"bmtj"];

    self.webview.navigationDelegate = nil;
    self.webview.scrollView.delegate = nil;
    self.webview.UIDelegate = nil;
    self.webview = nil;
}


#pragma mark - netError
- (void)addNetError{
    BKNetWorkErrorBackView *backView = [BKNetWorkErrorBackView showOn:self.view WithFrame:self.webview.frame];
    kWeakSelf(weakSelf);
    [backView setTryAgainAction:^{
        [weakSelf reloadAgain];
    }];
}
-(void)reloadAgain{
    [self LoadWebView];
}

@end
