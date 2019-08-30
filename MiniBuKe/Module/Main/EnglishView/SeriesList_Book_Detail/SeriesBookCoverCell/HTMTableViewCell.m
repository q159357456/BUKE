//
//  HTMTableViewCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/9/19.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "HTMTableViewCell.h"
#import "English_Header.h"
#import "BKLoadAnimationView.h"
@interface HTMTableViewCell()<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,WKScriptMessageHandler>
{
    BOOL alreadyResize;
    CGFloat web_height;
    NSInteger selcIndex;
}

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end
@implementation HTMTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}


-(void)dealloc
{
      [self.webview.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
    [self.webview.configuration.userContentController removeScriptMessageHandlerForName:@"clickBook"];
    self.webview.scrollView.delegate = nil;
}
//取消监听contentsize
- (void)removeContentSizeObserver{
    [self.webview.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
    self.webview.scrollView.delegate = nil;
    
}
-(WKWebView *)webview
{
    if (!_webview) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        configuration.preferences = preferences;
        _webview = [[WKWebView alloc]initWithFrame:CGRectZero configuration:configuration];
        _webview.UIDelegate = self;
         _webview.navigationDelegate = self;
        _webview.backgroundColor = [UIColor whiteColor];
        _webview.scrollView.scrollEnabled =NO;
        _webview.scrollView.delegate = self;
        _webview.scrollView.showsHorizontalScrollIndicator =NO;
        _webview.scrollView.showsVerticalScrollIndicator = NO;
        [_webview.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        kWeakSelf(weakSelf);
        [_webview.configuration.userContentController addScriptMessageHandler:weakSelf name:@"clickBook"];
    }
    return _webview;
}
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    
    if (object == self.webview.scrollView && [keyPath isEqual:@"contentSize"]) {
        UIScrollView *scrollView = self.webview.scrollView;
        if (web_height != self.webview.scrollView.contentSize.height) {
            [self eventName:HTML_WebView_Height_Event Params:[NSNumber numberWithFloat:scrollView.contentSize.height]];
            web_height = self.webview.scrollView.contentSize.height;
            if (![self.subviews containsObject:self.webview]) {
                [self addSubview:self.webview];
                
                [self.webview mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
                }];
            }

        }

    }
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 30  ,100, 60, 60)];
//        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//        [self addSubview:self.activityIndicator];
        
    }
    return self;
    
}
-(void)setIntroduction:(NSString *)introduction
{
    if (self.isScanningTo)
    {
        _introduction = introduction;
    }else
    {
        _introduction = [NSString stringWithFormat:@"%@&token=%@",introduction,TokenEncode];
    }
    web_height = 0;
    if (self.isGuide) {
        
        if (self.html_State == Guide_State)
        {
            [self.webview removeFromSuperview];
            [self removeContentSizeObserver];
            self.webview = nil;
            selcIndex = 0;
           
            [BKLoadAnimationView ShowHitOn:self Frame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
            [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.introduction]]];
        }else
        {
            [self.webview removeFromSuperview];
            [self removeContentSizeObserver];
            self.webview = nil;
            selcIndex = 1;
            [BKLoadAnimationView ShowHitOn:self Frame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
            [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.introduction]]];
        }
    }else
    {

        
        //先取消监听再置nil
        [self.webview removeFromSuperview];
        [self removeContentSizeObserver];
        self.webview = nil;
        alreadyResize = NO;
        [BKLoadAnimationView ShowHitOn:self Frame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
        [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.introduction]]];
    }
    
}
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
    [BKLoadAnimationView HiddenFrom:self];
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
    
    
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
    NSLog(@"===页面加载失败=====");
    [BKLoadAnimationView HiddenFrom:self];

}
// 接收到服务器跳转请求之后再执行
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}


- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [APP_DELEGATE.navigationController presentViewController:alertController animated:YES completion:nil];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setIsGuide:(BOOL)isGuide
{
    _isGuide = isGuide;
    if (isGuide) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:(@selector(panScro:))];
        pan.delegate = self;
        [self addGestureRecognizer:pan];
    }
    
}
#pragma mark - scroDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    NSInteger index = scrollView.contentOffset.x/SCREEN_WIDTH;
    if (selcIndex == index) {
        
        return;
    }
    selcIndex = index;
}

-(void)panScro:(UIPanGestureRecognizer*)pan{

    if (pan.state == UIGestureRecognizerStateEnded) {
        [self commitTranslation:[pan translationInView:pan.view]];
    }

}
- (void)commitTranslation:(CGPoint)translation
{
    if (fabs(translation.x) < 20) {
        
        return;
    }
    if (translation.x>0) {
        //向右
        if (fabs(translation.y) <20) {
            if (selcIndex == 0) {
                return;
            }
           
            selcIndex = 0;
            if (self.delegate && [self.delegate respondsToSelector:@selector(scroDidend:)]) {
                [self.delegate scroDidend:0];
            }
           
        }
        
    }else
    {
        //向左
        if (fabs(translation.y) <20) {
            if (selcIndex == 1) {
                return;
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(scroDidend:)]) {
                [self.delegate scroDidend:1];
                
            }
        }
        
    }
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{

    if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]])
    {
        return YES;
    }else
    {
        return NO;
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return nil;
    
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    
    if ([message.name isEqualToString:@"clickBook"]) {
//        NSDictionary *dic = (NSDictionary*)message.body;
        NSLog(@"message.body--%@",message.body);
        [self eventName:HTML_WebView_Intens_Event Params:message.body];
      
    }
}

@end
