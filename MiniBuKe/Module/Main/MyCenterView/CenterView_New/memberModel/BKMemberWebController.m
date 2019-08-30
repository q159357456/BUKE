//
//  BKMemberWebController.m
//  MiniBuKe
//
//  Created by chenheng on 2019/5/24.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKMemberWebController.h"
#import "CommonUsePackaging.h"
#import "WeChatManager.h"
#import "BKUploadingTipCtr.h"
#import "PayResultController.h"
@interface BKMemberWebController ()<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate,WKScriptMessageHandler>
@property (nonatomic,assign) BOOL loadComplete;
@property (nonatomic,assign) BOOL isAppera;
@end

@implementation BKMemberWebController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.isAppera = YES;
    [_webview.configuration.userContentController addScriptMessageHandler:self name:JsAction];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.isAppera = NO;
    [_webview.configuration.userContentController removeScriptMessageHandlerForName:JsAction];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSString * params = [NSString stringWithFormat:@"isMemberActive=%ld&memberTime=%@&endTime=%@&nickName=%@&memberImg=%@&imageUrl=%@",(long)self.memberInfo.isMemberActive,self.memberInfo.memberTime?self.memberInfo.memberTime:@"",self.memberInfo.endTime?self.memberInfo.endTime:@"",self.memberInfo.nickName?self.memberInfo.nickName:@"取个名字",self.memberInfo.memberImg?self.memberInfo.memberImg:@"",self.memberInfo.imageUrl?self.memberInfo.imageUrl:@""];
    
    NSString * encodeStr = [params stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLUserAllowedCharacterSet]];

    self.url = self.url.length ? self.url : [NSString stringWithFormat:@"%@?%@",MemberToBuy,encodeStr];
    NSLog(@"self.url==>%@",self.url);
    [self.view addSubview:self.webview];
    [self setUpTopBar];
    [self LoadWebView];

   
    // Do any additional setup after loading the view.
}
- (void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setUpTopBar{
    self.topView = [[UIView alloc]init];
    _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH,kNavbarH);
    _topView.backgroundColor = [UIColor whiteColor];
     [self.view addSubview:_topView];

   
    UIImageView * bkimag = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"member_title_bg_image"]];
    bkimag.frame = CGRectMake(0, 0, _topView.frame.size.width, _topView.frame.size.height);
    [self.topView addSubview:bkimag];
    
    self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, kStatusBarH, 40, 40)];
    [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_backBtn setImage:[UIImage imageNamed:@"BookSelection_back_white_begin_icon"]
              forState:UIControlStateNormal];
    [_backBtn setImage:[UIImage imageNamed:@"BookSelection_back_white_begin_icon"]
              forState:UIControlStateSelected];
    [self.topView addSubview:_backBtn];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80,kStatusBarH,SCREEN_WIDTH-160,44)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.topView addSubview: _titleLabel];
    
    self.titleLabel.text = @"会员中心";
    
  

    
}

- (void)LoadWebView{
    if (self.url) {
        [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
        
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
        if (!self.memberInfo.isMemberActive)
        {
            _webview = [[WKWebView alloc]initWithFrame:CGRectMake(0, -kStatusBarH, SCREEN_WIDTH, SCREEN_HEIGHT+kStatusBarH-SCALE(80)) configuration:configuration];
        }else
        {
            _webview = [[WKWebView alloc]initWithFrame:CGRectMake(0, -kStatusBarH, SCREEN_WIDTH, SCREEN_HEIGHT+kStatusBarH) configuration:configuration];
        }
        _webview.UIDelegate = self;
        _webview.navigationDelegate = self;
        _webview.backgroundColor = COLOR_STRING(@"#ededed");
        _webview.scrollView.delegate = self;
        _webview.scrollView.showsHorizontalScrollIndicator =NO;
        _webview.scrollView.showsVerticalScrollIndicator = NO;
        
//        [_webview addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return _webview;
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
    if (!self.memberInfo.isMemberActive) {
        [self addBottomBtn];
    }
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"withError==>%@",error);
    [BKLoadAnimationView HiddenFrom:self.view];
    [self addNetError];
}

- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    NSString *messageStr = message.body;
    NSData *jsonData = [messageStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSString *actionID = dic[@"ID"];
    if ([actionID isEqualToString:@"vipPay"]) {
        if (dic[@"data"][@"goodsId"]) {
            [self payWithGoodsID:dic[@"data"][@"goodsId"]];
        }
        
    }
//    vipPay
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];

}
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    //网页title
//    if ([keyPath isEqualToString:@"title"])
//    {
//        if (object == self.webview)
//        {
//            self.titleLabel.text = self.webview.title;
//        }
//        else
//        {
//            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//        }
//    }
//    else
//    {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
//    [self.webview removeObserver:self forKeyPath:@"title"];
    self.webview.navigationDelegate = nil;
    self.webview.scrollView.delegate = nil;
    self.webview.UIDelegate = nil;
//    self.webview = nil;
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

-(void)addBottomBtn{
    UIView * view  = [[UIView alloc]init];
    view.backgroundColor = COLOR_STRING(@"#F7F9FB");
    [self.view addSubview:view];
    UIImageView * imagev = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"member_bottom_bg_image"]];
    [view addSubview:imagev];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setTitle:@"即将开通，敬请期待" forState:UIControlStateNormal];
    [btn setTitle:@"购买" forState:UIControlStateNormal];
    [view addSubview:btn];
    btn.backgroundColor = COLOR_STRING(@"#FEA449");
//    btn.backgroundColor = [UIColor redColor];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(SCALE(80));
    }];
    [imagev mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.right.bottom.top.mas_equalTo(view);
    }];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.mas_equalTo(view);
        make.size.mas_equalTo(CGSizeMake(SCALE(300), SCALE(47)));
    
    }];
    btn.layer.cornerRadius = SCALE(22);
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(toBuy:) forControlEvents:UIControlEventTouchUpInside];
  
}
-(void)toBuy:(UIButton*)btn{
 
    FHWeakSelf;
    [self.webview evaluateJavaScript:@"getGoodsId()" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (!result) {
            [MBProgressHUD showError:@"no result"];
            return ;
        }
        [weakSelf payWithGoodsID:(NSString*)result];
        
    }];
}
-(void)payWithGoodsID:(NSString*)goodid{
    if (![WXApi isWXAppInstalled]) {
        [CommonUsePackaging showSystemHint:@"您还没有安装微信!"];
        return;
    }
    [WeChatManager sharedManager].unfinishedResult = goodid;
    BKUploadingTipCtr *ctr = [[BKUploadingTipCtr alloc]initWithTitle:@"小布壳即将开启微信支付" andDes:@"" andleftBtnTitle:@"取消" andrightBtnTitle:@"确定" andIconName:@"wxpay_image"];
    ctr.view.frame = CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT);
    ctr.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    [ctr setUploadTipLeftBtnClick:^{
        
    }];
    [ctr setUploadTipRightBtnClick:^{
        NSDictionary * dic = @{@"activityId":@"",@"goodsId":goodid,@"openid":@"",@"orderType":@"4",@"payType":@"2",@"userDisId":@""};
        [MBProgressHUD showMessage:@"请等待" toView:self.view];
        [XBKNetWorkManager wxOrderWithDic:dic Finish:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            if (!error) {
                NSLog(@"responseObj==>%@",responseObj);
                [WeChatManager sharedManager].payContent = Pay_Member;
                [WeChatManager weiXinPayWithDic:(NSDictionary*)responseObj];
                [MBProgressHUD hideHUDForView:self.view];
            }
        }];
        
    }];
    [self presentViewController:ctr animated:NO completion:nil];
    
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
