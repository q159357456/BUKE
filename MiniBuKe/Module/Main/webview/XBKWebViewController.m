//
//  XBKWebViewController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/20.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "XBKWebViewController.h"
#import "ASIFormDataRequest.h"

#define bottomView_height 0

@interface XBKWebViewController ()<UIWebViewDelegate>

@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIView *middleView;
@property(nonatomic,strong) UIView *bottomView;

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic,strong) NSString *urlStr;

@end

@implementation XBKWebViewController

-(instancetype)init:(NSString *) urlStr {
    if (self = [super init]) {
        self.urlStr = urlStr;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    [self testUploadFile];
}

-(void) testUploadFile
{
//    NSString *uploadPath = [[NSBundle mainBundle] pathForResource:@"9ff977fed42b3de4aca40356be942ad9" ofType:@"spx"];
//    NSURL *url = [[NSURL alloc]initWithString:KURLHead_2];
//    
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//    
//    [request
//     setFile:uploadPath forKey:@"audio"];   //uploadPath：上传路径； audio:上传参数名，一定要跟接口给出的参数名一样；
//    
//    [requestsetDelegate:self];
//    
//    [requeststartAsynchronous];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideBarStyle];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self showBarStyle];
}

- (void)showBarStyle {
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)hideBarStyle {
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)initView{
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 73)];
    [_topView setBackgroundColor:COLOR_STRING(@"#FFFFFF")];
    [self.view addSubview:_topView];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - bottomView_height, self.view.frame.size.width, bottomView_height)];
    //[_bottomView setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:_bottomView];
    
    _middleView = [[UIView alloc] initWithFrame:CGRectMake(0, _topView.frame.origin.y + _topView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _topView.frame.size.height - _bottomView.frame.size.height)];
    [_middleView setBackgroundColor:COLOR_STRING(@"#FFFFFF")];
    //    [_middleView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:_middleView];
    
    
    NSLog(@" %f == %f",self.view.frame.size.height,self.view.frame.size.width);
    
    [self createTopViewChild];
    //[self createBottomViewChild];
    [self createMiddleViewChild];
    
    
}

-(void) createMiddleViewChild
{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, _topView.frame.origin.y + _topView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _topView.frame.size.height - _bottomView.frame.size.height)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    self.webView.delegate = self;
    [self.view addSubview: self.webView];
    [self.webView loadRequest:request];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    UIWebView *web = webView;
    
    //获取所有的html
    
    NSString *allHtml = @"document.documentElement.innerHTML";
    
    //获取网页title
    
    NSString *htmlTitle = @"document.title";
    
    //获取网页的一个值
    
    NSString *htmlNum = @"document.getElementById('title').innerText";
    
    //获取到得网页内容
    
    NSString *allHtmlInfo = [web stringByEvaluatingJavaScriptFromString:allHtml];
    
    NSString *titleHtmlInfo = [web stringByEvaluatingJavaScriptFromString:htmlTitle];
    
    NSString *numHtmlInfo = [web stringByEvaluatingJavaScriptFromString:htmlNum];
    
    self.titleLabel.text = titleHtmlInfo;
    
//    NSLog(@"webview => %@ => %@ => %@",allHtmlInfo,titleHtmlInfo,numHtmlInfo);
    
}

-(void) createTopViewChild {
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 40, 40)];
    //[_moveButton setBackgroundColor:[UIColor whiteColor]];
    
    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateSelected];
    //[_moveButton setTitle:@"故事" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:MY_FONT(18)];
    [backButton setAdjustsImageWhenHighlighted:NO];
    //[_moveButton setTitleColor:COLOR_STRING(@"#FFD1C7") forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:backButton];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,25,self.view.frame.size.width,48)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"";
    self.titleLabel.font = MY_FONT(19);
    self.titleLabel.textColor = COLOR_STRING(@"#2f2f2f");
    [_topView addSubview: self.titleLabel];
}

-(IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
