//
//  BKRecommendDetailsCtr.m
//  MiniBuKe
//
//  Created by chenheng on 2019/1/23.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKRecommendDetailsCtr.h"
#import "CommonUsePackaging.h"
#import "IntensiveReadingController.h"
#import "ShareURLView.h"
#import "AFNetworking.h"
#define URLH5RecommendDetail [NSString stringWithFormat:@"%@/template/html/recommendBook/bookItem.html",H5SERVER_URL]
#define H5NoticFlag @"JsAction"

@interface BKRecommendDetailsCtr ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler,UIScrollViewDelegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *titleLabel;
@property(nonatomic,strong) WKWebView *webview;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *backBtn;
@property(nonatomic,strong)ShareURLView *shareURLView;
@property(nonatomic,copy)NSString *url;
@property (nonatomic,assign) BOOL loadComplete;
@property (nonatomic,assign) BOOL isAppera;

@end

@implementation BKRecommendDetailsCtr
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
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webview];
    [self setUpTopBar];
    
    [self LoadWebView];
    
}
-(NSString *)url
{
    if (!_url) {
        
        _url = @"";
    }
    return _url;
}
-(ShareURLView *)shareURLView
{
    if (!_shareURLView) {
        _shareURLView = [[ShareURLView alloc]init];
    }
    return _shareURLView;
}
- (void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpTopBar{
    self.topView = [[UIView alloc]init];
    _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH,kNavbarH);
    _topView.backgroundColor = COLOR_STRING(@"#ffffff");
    _topView.alpha = 0;
    [self.view addSubview:_topView];
    
    self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, kStatusBarH, 40, 40)];
    [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_backBtn setImage:[UIImage imageNamed:@"BookSelection_back_white_begin_icon"]
             forState:UIControlStateNormal];
    [_backBtn setImage:[UIImage imageNamed:@"BookSelection_back_white_begin_icon"]
             forState:UIControlStateSelected];
    [self.view addSubview:_backBtn];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80,kStatusBarH,SCREEN_WIDTH-160,44)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    _titleLabel.textColor = COLOR_STRING(@"#2f2f2f");
    [self.topView addSubview: _titleLabel];
    self.titleLabel.hidden = YES;

    
    self.shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40-6, kStatusBarH, 40, 40)];
//    [self.shareBtn setImage:[UIImage imageNamed:@"BookSelection_share_white_icon"] forState:UIControlStateNormal];
//    [self.shareBtn setImage:[UIImage imageNamed:@"BookSelection_share_white_icon"] forState:UIControlStateSelected];

    [self.shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.shareBtn];
    
}

- (void)LoadWebView{
    if (self.recommeId.length) {
        NSString *encodedString = [[NSString stringWithFormat:@"%@?recommendId=%@",URLH5RecommendDetail,self.recommeId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.url = encodedString;
        [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:encodedString]]];
        
        [BKLoadAnimationView ShowHitOn:self.view Frame:CGRectMake(0, kNavbarH, SCREEN_WIDTH, SCREEN_HEIGHT-kNavbarH)];
    }
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
        _webview.backgroundColor = COLOR_STRING(@"#ededed");
        _webview.scrollView.delegate = self;
        _webview.scrollView.showsHorizontalScrollIndicator =NO;
        _webview.scrollView.showsVerticalScrollIndicator = NO;
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
        if ([actionID isEqualToString:@"1012"]) {//跳转绘本预览
            NSString *bookid = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"bookID"]];
            if (bookid.length) {
                IntensiveReadingController *vc = [[IntensiveReadingController alloc]init];
                vc.bookid = bookid;
                [self.navigationController pushViewController:vc animated:YES];
            }
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
    
    [self.backBtn setImage:[UIImage imageNamed:@"BookSelection_back_white_icon"]
                  forState:UIControlStateNormal];
    [self.backBtn setImage:[UIImage imageNamed:@"BookSelection_back_white_icon"]
                  forState:UIControlStateSelected];
    [self.shareBtn setImage:[UIImage imageNamed:@"BookSelection_share_white_icon"] forState:UIControlStateNormal];

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
    if ( scrollView.contentOffset.y > kNavbarH) {
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
        if (self.titleLabel.hidden == YES) {
            
            [UIView animateWithDuration:0.25 animations:^{
                
                self.topView.alpha = 1;
                [self.backBtn setImage:[UIImage imageNamed:@"mate_back"]
                              forState:UIControlStateNormal];
                [self.backBtn setImage:[UIImage imageNamed:@"mate_back"]
                              forState:UIControlStateSelected];
                
                [self.shareBtn setImage:[UIImage imageNamed:@"BookSelection_share_icon"] forState:UIControlStateNormal];
                [self.shareBtn setImage:[UIImage imageNamed:@"BookSelection_share_icon"] forState:UIControlStateSelected];
                self.titleLabel.hidden = NO;
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
            }];
        }
        
    }else{
        if (self.titleLabel.hidden == NO) {
            
            [UIView animateWithDuration:0.25 animations:^{
                
                [self.backBtn setImage:[UIImage imageNamed:@"BookSelection_back_white_icon"]
                              forState:UIControlStateNormal];
                [self.backBtn setImage:[UIImage imageNamed:@"BookSelection_back_white_icon"]
                              forState:UIControlStateSelected];
                [self.shareBtn setImage:[UIImage imageNamed:@"BookSelection_share_white_icon"] forState:UIControlStateNormal];
                [self.shareBtn setImage:[UIImage imageNamed:@"BookSelection_share_white_icon"] forState:UIControlStateSelected];
                self.titleLabel.hidden = YES;
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
                
                self.topView.alpha = 0;
            }];
        }
    }
}
#pragma mark - shareBtn

- (void)shareBtnAction{

    [MBProgressHUD showMessage:@""];
    [[BaiduMobStat defaultStat] logEvent:@"c_share150" eventLabel:@"推荐书单页面"];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *path = [NSString stringWithFormat:@"%@%@",NewLoginSERVER_URL,@"/user/share"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%@",self.recommeId] forKey:@"templateId"];
    [params setObject:@6 forKey:@"templateType"];;
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:path parameters:params error:nil];
    request.timeoutInterval = 10.f;
    [request setValue:APP_DELEGATE.mLoginResult.token forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [MBProgressHUD hideHUD];
        NSDictionary *dic = (NSDictionary*)responseObject;
        if ([dic[@"code"] intValue] == 1) {
            ShareModel *model = [ShareModel getShareModelWithDic:dic[@"data"]];
            model.templateType = @"6";
            model.templateID = self.recommeId;
            self.shareURLView.model  = model;
            [self.shareURLView show];
        }else
        {
            [MBProgressHUD showError:dic[@"msg"]];
        }
        
    }];
    [task resume];
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
@end
