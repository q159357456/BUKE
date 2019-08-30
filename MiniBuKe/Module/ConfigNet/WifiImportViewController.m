//
//  WifiImportViewController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/9.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "WifiImportViewController.h"
#import "UITextField+Border.h"
#import "QRCodeViewController.h"
#import "BKUtils.h"
#import "MBProgressHUD+XBK.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@interface WifiImportViewController ()<UITextFieldDelegate>

@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIView *middleView;

@property(nonatomic,strong) UITextField *wifiInput;
@property(nonatomic,strong) UITextField *pwdInput;

@end

@implementation WifiImportViewController {
    UITapGestureRecognizer *singleTap;
}

//+(void) pushViewController
//{
//    WifiImportViewController *mWifiImportViewController = [[WifiImportViewController alloc] init];
//    mWifiImportViewController.isConfigNet = YES;
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mWifiImportViewController];
//    [APP_DELEGATE.navigationController presentModalViewController:navigationController animated:YES];
//    [APP_DELEGATE.navigationController pushViewController:mWifiImportViewController animated:YES];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor: [UIColor whiteColor]];
    
    [self initView];
}

- (void)initView{
    _topView = [[UIView alloc] init];
    [_topView setBackgroundColor:COLOR_STRING(@"#FFFFFF")];
    [self.view addSubview:_topView];
    
    _middleView = [[UIView alloc] init];
    [_middleView setBackgroundColor:COLOR_STRING(@"#FFFFFF")];
    [self.view addSubview:_middleView];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, kNavbarH));
        make.top.equalTo(self.view);
    }];
    
    [_middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self createTopViewChild];
    [self createMiddleViewChild];
}

-(void)createMiddleViewChild {
    CGFloat y = 56.f;
    if (self.view.frame.size.width < 375.f) {
        y = 40.f;
    }
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(19, y, self.view.frame.size.width - 19*2, 20.f);
    label1.textColor = COLOR_STRING(@"#666666");
    label1.textAlignment = NSTextAlignmentLeft;
    label1.text = @"请输入机器人要连接的Wifi网络";
    label1.font = MY_FONT(15.f);
    [_middleView addSubview: label1];
    
    //获取当前所连接的wifi名称
    NSString *currentSSID = [self getCurrentSSID];
    NSLog(@"currentSSID === %@",currentSSID);
    
    UIView *wifiBottomView = [[UIView alloc]initWithFrame:CGRectMake(19, CGRectGetMaxY(label1.frame)+15.f, self.view.frame.size.width-19*2, 50)];
    wifiBottomView.backgroundColor = COLOR_STRING(@"#ffffff");
    wifiBottomView.layer.cornerRadius = 25.f;
    wifiBottomView.layer.masksToBounds = YES;
    wifiBottomView.layer.borderColor = COLOR_STRING(@"#eaeaea").CGColor;
    wifiBottomView.layer.borderWidth = 1.f;
    [_middleView addSubview:wifiBottomView];
    
    UIView *wifiBottomView1 = [[UIView alloc]initWithFrame:CGRectMake(19, CGRectGetMaxY(wifiBottomView.frame)+15.f, self.view.frame.size.width-19*2, 50)];
    wifiBottomView1.backgroundColor = COLOR_STRING(@"#ffffff");
    wifiBottomView1.layer.cornerRadius = 25.f;
    wifiBottomView1.layer.masksToBounds = YES;
    wifiBottomView1.layer.borderColor = COLOR_STRING(@"#eaeaea").CGColor;
    wifiBottomView1.layer.borderWidth = 1.f;
    [_middleView addSubview:wifiBottomView1];
    
    _wifiInput = [[UITextField alloc] initWithFrame:CGRectMake(16, 0, CGRectGetWidth(wifiBottomView.frame) - 16*2, 50)];
    [_wifiInput setPlaceholder:@"请输入wifi账号"];
    [_wifiInput setFont:[UIFont systemFontOfSize:16.f]];
    _wifiInput.tintColor = COLOR_STRING(@"#FA9A3A");
    _wifiInput.delegate = self;
    [wifiBottomView addSubview: _wifiInput];
    
    if (currentSSID.length > 0) {
        _wifiInput.text = currentSSID;
    }
    _pwdInput = [[UITextField alloc]  initWithFrame:CGRectMake(16, 0, CGRectGetWidth(wifiBottomView1.frame) - 16*2, 50)];
    [_pwdInput setPlaceholder:@"请输入wifi密码"];
    [_pwdInput setFont:[UIFont systemFontOfSize:16.f]];
    _pwdInput.tintColor = COLOR_STRING(@"#FA9A3A");
    _pwdInput.delegate = self;
    [wifiBottomView1 addSubview: _pwdInput];

    UIButton *downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    downButton.frame = CGRectMake(19, CGRectGetMaxY(wifiBottomView1.frame)+15.f, self.view.frame.size.width-19*2, 50);
    [downButton setBackgroundColor:COLOR_STRING(@"#FEA449")];
    [downButton setTitle:@"下一步" forState:UIControlStateNormal];
    [downButton.titleLabel setFont:[UIFont systemFontOfSize:16.f weight:UIFontWeightMedium]];
    [downButton setTitleColor:COLOR_STRING(@"#FFFFFF") forState:UIControlStateNormal];
    downButton.layer.cornerRadius = 25.f;
    downButton.layer.masksToBounds = YES;
    [downButton addTarget:self action:@selector(downButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_middleView addSubview:downButton];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, downButton.frame.origin.y + downButton.frame.size.height + 20, SCREEN_WIDTH, 20)];
    tipLabel.textColor = COLOR_STRING(@"#999999");
    tipLabel.font = MY_FONT(12);
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = @"机器人暂不支持5GHz频段wifi";
    [_middleView addSubview:tipLabel];
    
    UIImageView *image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"newConfig_net_flag"];
    image.frame = CGRectMake(SCREEN_WIDTH*0.5-28-79, -3, 28, 28);
    [tipLabel addSubview:image];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self setUpForDismissKeyboard];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self closeKeyboard];
    return YES;
}

-(void)closeKeyboard{
    [self.view removeGestureRecognizer:singleTap];
    [_pwdInput resignFirstResponder];//收起键盘
    [_wifiInput resignFirstResponder];//收起键盘
}

- (void)setUpForDismissKeyboard {
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
}

-(void)fingerTapped:(id)sender{
    [self closeKeyboard];
}

-(IBAction)downButtonClick:(id)sender{
    NSString *wifiInputStr = _wifiInput.text;
    NSString *wifiPassStr = _pwdInput.text;
    if(![wifiInputStr isEqual:@""]){
        QRCodeViewController *mQRCodeViewController = [[QRCodeViewController alloc] init];
        mQRCodeViewController.wifiAccount = wifiInputStr;
        mQRCodeViewController.wifiPassword = wifiPassStr;
        mQRCodeViewController.isConfigNet = self.isConfigNet;
        mQRCodeViewController.robotType = self.robotType;
        mQRCodeViewController.configMold = WifiConfigNet;
        [self.navigationController pushViewController:mQRCodeViewController animated:YES];
    } else {
//        [MBProgressHUD showText:@"Wifi账号或密码不能为空"];
        [_wifiInput resignFirstResponder];
        [_pwdInput resignFirstResponder];
        [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"Wifi账号不能为空" and:self.view];
    }
}

-(void)createTopViewChild{
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, kStatusBarH, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateSelected];
    [backButton.titleLabel setFont:MY_FONT(18)];
    [backButton setAdjustsImageWhenHighlighted:NO];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40,kStatusBarH,self.view.frame.size.width-80,40)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"配置网络";
    titleLabel.font = [UIFont systemFontOfSize:18.f weight:UIFontWeightMedium];
    titleLabel.textColor = COLOR_STRING(@"#2f2f2f");
    [_topView addSubview: titleLabel];
}

-(IBAction)backButtonClick:(id)sender
{
    [self closeKeyboard];
    
//    if (self.isConfigNet) {
//        [APP_DELEGATE.navigationController dismissModalViewControllerAnimated:YES];
//    } else {
        [self.navigationController popViewControllerAnimated:YES];
//    }
}

-(NSString *)getCurrentSSID
{
    NSString *wifiName = nil;
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    if (!wifiInterfaces) {
        return nil;
    }
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            CFRelease(dictRef);
        }
    }
    CFRelease(wifiInterfaces);
    return wifiName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideBarStyle];
}

- (void)hideBarStyle {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
    self.navigationController.navigationBar.hidden = NO;

    //[self showBarStyle];
}

- (void)dealloc{
    self.wifiInput.delegate = nil;
    self.pwdInput.delegate = nil;
}

@end
