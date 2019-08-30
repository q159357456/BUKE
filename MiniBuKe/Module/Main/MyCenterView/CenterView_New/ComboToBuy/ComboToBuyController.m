//
//  ComboToBuyController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/29.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "ComboToBuyController.h"
#import "BottomBuyView.h"
#import "ToPayViewController.h"
#import "ShareContentView.h"
#import "CenterSevice.h"
#import "BabyInfoAddController.h"
#import "ShareURLView.h"
#import "CommonUsePackaging.h"
#import "ShareChooseView.h"
@interface ComboToBuyController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property(nonatomic,strong)BottomBuyView *bottomBuyView;
@property(nonatomic,strong)ShareContentView *shareContentView;
@property(nonatomic,strong)ShareURLView * shareURLView;

@end

@implementation ComboToBuyController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.webview.configuration.userContentController addScriptMessageHandler:self name:@"toPay"];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.webview.configuration.userContentController removeScriptMessageHandlerForName:@"toPay"];
   
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webview.configuration.userContentController addScriptMessageHandler:self name:@"toPay"];
    [self.topView addSubview:self.rightBtn];
    [self.view addSubview:self.webview];
    if (self.HaveBotom) {
       [self.view addSubview:self.bottomBuyView];
        self.titleLabel.text = @"『100+1』绘本套餐";
        if (!self.goodsModel) {
            [self getGoodsInfo];
        }
        
    }else
    {
        [self.webview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.topView.mas_bottom);
            make.bottom.mas_equalTo(self.view.mas_bottom);
            make.left.mas_equalTo(self.view.mas_left);
            make.right.mas_equalTo(self.view.mas_right);
        }];
        self.titleLabel.text = @"邀请返现领取双重大礼";
    }
//    NSLog(@"self.url===>%@",self.url);
    // Do any additional setup after loading the view.
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
        if (!self.HaveBotom) {
            
            _webview = [[WKWebView alloc]initWithFrame:CGRectZero configuration:configuration];
      
        }else
        {
            
            _webview = [[WKWebView alloc]initWithFrame:CGRectMake(0, kNavbarH, SCREEN_WIDTH, SCREEN_HEIGHT-kNavbarH - 60) configuration:configuration];
        }
      
        _webview.UIDelegate = self;
        _webview.navigationDelegate = self;
//        _webview.scrollView.delegate = self;
        _webview.backgroundColor = [UIColor whiteColor];
        _webview.scrollView.showsHorizontalScrollIndicator =NO;
        _webview.scrollView.showsVerticalScrollIndicator = NO;
//        [_webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
        [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
        
    }
    return _webview;
}
-(ShareContentView *)shareContentView
{
    if (!_shareContentView) {
        
        _shareContentView = [[ShareContentView alloc]init];
    }
    return _shareContentView;
}
-(ShareURLView *)shareURLView
{
    if (!_shareURLView) {
        _shareURLView = [[ShareURLView alloc]init];
    }
    return _shareURLView;
}
-(UIButton *)rightBtn
{
    if (!_rightBtn) {
         UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -55, kStatusBarH==44?32:18 , 40, 40)];
        [btn setImage:[UIImage imageNamed:@"shrar_icon"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn = btn;
    }
    return _rightBtn;
}
-(BottomBuyView *)bottomBuyView
{
    if (!_bottomBuyView) {
        _bottomBuyView = [[BottomBuyView alloc]init];
        [_bottomBuyView.btn addTarget:self action:@selector(topay:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBuyView;
}

#pragma mark - 获得商品信息
-(void)getGoodsInfo{
    [MBProgressHUD showMessage:@"" toView:self.view];
    [CenterSevice pay_goods:@"1" AndFinish:^(id responsed, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        NSDictionary *dic = (NSDictionary*)responsed;
//        NSLog(@"responsed:%@",responsed);
//        NSLog(@"error:%@",error);
        if ([dic[@"code"] intValue] != 1) {
            [MBProgressHUD showError:dic[@"msg"]];
            return ;
        }
        if (!error) {
            self.goodsModel = [GoodsModel getGoodsInfo:dic[@"data"]];
            if (self.goodsModel.disCountDTOS.count>0) {
                DisCount *dis = self.goodsModel.disCountDTOS[0];
                CGFloat discount = [dis.price floatValue];
                CGFloat shifu = self.goodsModel.goodsPrice.floatValue - discount;
                self.bottomBuyView.label1.text = [NSString stringWithFormat:@"实付:￥%.02f",shifu];
                self.bottomBuyView.label2.text = [NSString stringWithFormat:@"￥%@",self.goodsModel.goodsPrice];
                  self.bottomBuyView.lineView.hidden=NO;
                [self.bottomBuyView reSizeLineWith];
                
            }else
            {
                self.bottomBuyView.label1.text = [NSString stringWithFormat:@"实付:￥%@",self.goodsModel.goodsPrice];
                self.bottomBuyView.label2.text = [NSString stringWithFormat:@"￥%@",self.goodsModel.goodsPrice];
                self.bottomBuyView.lineView.hidden=YES;
                [self.bottomBuyView reSizeLineWith];
            }
          
           
        }
    }];
}


#pragma mark - 分享的图片
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
#pragma mark - action
-(void)topay:(UIButton*)btn{
//    [MobClick event:EVENT_Custom_103];
    BabyInfoAddController *vc = [[BabyInfoAddController alloc]init];
    vc.isPayMode = YES;
    [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
    
}
-(void)share:(UIButton*)btn{
    [ShareChooseView shareChooseCallBack:^(NSInteger index) {
        NSLog(@"%ld",index);
    }];
    return;
//    [MobClick event:EVENT_Custom_102];
   
//    if ([self.url isEqualToString:ComboLongPic]) {
        if (self.shareContentView.imageurl.length==0) {
            [self getShareImage];
        }
        [self.shareContentView show];
//    }else
//    {
//        [self.shareURLView show];
//    }
    
    
    
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

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    
    if ([message.name isEqualToString:@"toPay"]) {
    
//            BabyInfoAddController *vc = [[BabyInfoAddController alloc]init];
//            vc.isPayMode = YES;
//            [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
        ComboToBuyController *vc = [[ComboToBuyController alloc]init];
        vc.url = ComboLongPic;
        vc.HaveBotom = YES;
        [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
//        [MobClick event:EVENT_Custom_100];
        
    }
}
@end
