//
//  BKNewLoginController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/22.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKNewLoginController.h"
#import "BKLoginCodeInputView.h"
#import "BKLoginPhoneInputView.h"
#import "XBKWebViewController.h"
#import "BKNewBindPhoneController.h"
#import "BKNewPhoneSelectAreaCtr.h"
#import "BKLoginCodeTip.h"
#import "BKNewLoginRequestManage.h"
#import "WeChatManager.h"
#import "HomeViewController.h"

@interface BKNewLoginController ()<WeChatManagerDelegate>

@property(nonatomic, strong) BKLoginCodeInputView *codeInputView;
@property(nonatomic, strong) BKLoginPhoneInputView *phoneInputView;
@property(nonatomic, strong) UIImageView *iconView;

@property(nonatomic, strong) UIButton *loginBtn;
@property(nonatomic, strong) UILabel *loginTipLabe;
@property(nonatomic, strong) UIButton *agreementBtn;

@property(nonatomic, strong) UIButton *weChartloginBtn;
@property(nonatomic, strong) UILabel *weChartLabe;

@property(nonatomic, copy) NSString *phoneStr;
@property(nonatomic, copy) NSString *codeStr;
@property(nonatomic, copy) NSString *areaNumberStr;

@property(nonatomic, assign) BOOL isEnableLogin;
@end

@implementation BKNewLoginController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self addNotification];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self removeNotification];
    [self closeKeyboard];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    self.areaNumberStr = @"86";
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
    [self.view addGestureRecognizer:singleTap];
}

- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardwillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChangeBegin:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground)name:UIApplicationWillEnterForegroundNotification object:nil];
}
- (void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}
- (void)applicationWillEnterForeground{
    [self closeKeyboard];
}
- (void)dealloc{
    [self removeNotification];
}

- (void)setUI{
    __weak typeof(self) weakSelf = self;
    self.view.backgroundColor = COLOR_STRING(@"#FFFFFF");
    
    self.codeInputView = [[BKLoginCodeInputView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-50.f, 50.f)];
    _codeInputView.tag = 99;
    [_codeInputView setSendCodeBtnClick:^{
        //发送验证码
        [weakSelf sendMessCode];
    }];
    [self.view addSubview:_codeInputView];
    
    self.phoneInputView = [[BKLoginPhoneInputView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-50.f, 50.f)];
    _phoneInputView.tag = 66;
    [_phoneInputView setAreaSelectBlock:^{
        //选择区号地区
        [weakSelf selectAreaAction];
    }];
     [self.view addSubview:_phoneInputView];
    
    self.iconView = [[UIImageView alloc]init];
    self.iconView.image = [UIImage imageNamed:@"login_toplogon_icon"];
    [self.view addSubview:_iconView];
    
    self.loginBtn = [[UIButton alloc]init];
    _loginBtn.backgroundColor = COLOR_STRING(@"#d7d7d7");
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:COLOR_STRING(@"#FFFFFF") forState:UIControlStateNormal];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:16.f weight:UIFontWeightMedium];
    _loginBtn.layer.cornerRadius = 25.f;
    _loginBtn.clipsToBounds = YES;
    [_loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    
    self.weChartLabe = [[UILabel alloc]init];
    self.weChartLabe.text = @"使用微信账号登录";
    self.weChartLabe.textColor = COLOR_STRING(@"#999999");
    _weChartLabe.font = [UIFont systemFontOfSize:13.f];
    [self.view addSubview:_weChartLabe];
    
    self.weChartloginBtn = [[UIButton alloc]init];
    [_weChartloginBtn setImage:[UIImage imageNamed:@"login_wechart_lighticon"] forState:UIControlStateNormal];
    [_weChartloginBtn setImage:[UIImage imageNamed:@"login_wechart_lighticon"] forState:UIControlStateSelected];
    [_weChartloginBtn addTarget:self action:@selector(weChartloginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_weChartloginBtn];
    if (APP_DELEGATE.isWXInstalled)
    {
        self.weChartloginBtn.hidden = NO;
        self.weChartLabe.hidden = NO;
    }else
    {
        self.weChartloginBtn.hidden = YES;
        self.weChartLabe.hidden =YES;
    }

    self.loginTipLabe = [[UILabel alloc]init];
    self.loginTipLabe.text = @"登录即代表您同意";
    self.loginTipLabe.textColor = COLOR_STRING(@"#999999");
    _loginTipLabe.font = [UIFont systemFontOfSize:12.f];
    _loginTipLabe.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_loginTipLabe];
    
    self.agreementBtn = [[UIButton alloc]init];
    [_agreementBtn setTitle:@"《偶家科技用户协议》" forState:UIControlStateNormal];
    [_agreementBtn setTitleColor:COLOR_STRING(@"#FA9A3A") forState:UIControlStateNormal];
    [_agreementBtn addTarget:self action:@selector(agreementBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _agreementBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [self.view addSubview:_agreementBtn];
    
    [self addConstraints];
}

- (void)addConstraints{
    [self.codeInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(25.f);
        make.right.mas_equalTo(self.view.mas_right).offset(-25.f);
        make.height.mas_equalTo(50.f);
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(22);
    }];
    [self.phoneInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.codeInputView.mas_left);
        make.right.mas_equalTo(self.codeInputView.mas_right);
        make.height.mas_equalTo(50.f);
        make.bottom.mas_equalTo(self.codeInputView.mas_top).offset(-15.f);
    }];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.codeInputView.mas_left);
        make.right.mas_equalTo(self.codeInputView.mas_right);
        make.height.mas_equalTo(50.f);
        make.top.mas_equalTo(self.codeInputView.mas_bottom).offset(15.f);
    }];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(94);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.phoneInputView.mas_top).offset(-34);
    }];
    [self.weChartLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-46.f);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    [self.weChartloginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(44);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.weChartLabe.mas_top).offset(-15);
    }];
    [self.loginTipLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH*0.5);
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.loginBtn.mas_bottom).offset(15);
    }];
    [self.agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.loginTipLabe.mas_right);
        make.centerY.mas_equalTo(self.loginTipLabe.mas_centerY);
        make.width.mas_equalTo(123);
        make.height.mas_equalTo(15);
    }];
}

- (void)closeKeyboard{
    [self.phoneInputView cancelFirstResponder];
    [self.codeInputView cancelFirstResponder];
}
#pragma mark - changeBtnUI
- (void)changeLoginBtnUIWithIsEnable:(BOOL)isEnabel{
    if (isEnabel) {
        [_loginBtn setBackgroundColor:COLOR_STRING(@"#FEA449")];
    }else{
        [_loginBtn setBackgroundColor:COLOR_STRING(@"#d7d7d7")];
    }
    self.isEnableLogin = isEnabel;
}
- (void)changeSendCodeBtnUIWithEnable:(BOOL)isEnabel{
    [_codeInputView changeSendCodeBtnUIWithEnabel:isEnabel];
}
#pragma mark - BtnClick Action
/**跳转用户协议*/
- (void)agreementBtnClick{
    [self closeKeyboard];
    XBKWebViewController *mXBKWebViewController = [[XBKWebViewController alloc] init: USER_REGISTER_AGREEMENT_URL];
    [APP_DELEGATE.navigationController pushViewController:mXBKWebViewController animated:YES];
}
/**跳转微信登录*/
- (void)weChartloginBtnClick{
    [self closeKeyboard];

    [WeChatManager sendAuthRequest];
    [WeChatManager sharedManager].delegate = self;
}
/**手机登录*/
- (void)loginBtnClick{
    if (!_isEnableLogin) return;
    if (self.phoneStr.length && self.codeStr.length) {
        [self closeKeyboard];
        
        if (![BKUtils checkPhoneNumberIsValidity:_phoneStr withAreaPhone:[_phoneInputView GetThePhoneAreaNUmber]]) {
            [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"登录失败,请检查手机号" and:self.view];

        }else{
            if(_codeStr.length){
                [MBProgressHUD showMessage:@""];
                [BKNewLoginRequestManage requestLoginWithPhone:self.phoneStr WithCode:self.codeStr WithUnionId:@"" AndFinish:^(id  _Nonnull responsed, NSError * _Nonnull error) {
                    [MBProgressHUD hideHUD];
                    if(error == nil){
                        if([[responsed objectForKey:@"code"] integerValue]==1){
                            //登录成功
                            [self LoginSuccessWithDictionary:[responsed objectForKey:@"data"]];
                            [[BaiduMobStat defaultStat] logEvent:@"e_login100" eventLabel:@"手机账号登录"];
                            
                        }else if ([[responsed objectForKey:@"code"] integerValue] == 11006){
                            //11006验证码错误失效
                            [[[BKLoginCodeTip alloc]init] AddCodeIsErrorTip:self.view];
                        }
                        else{
                            NSString *str =[responsed objectForKey:@"msg"];
                            if (str.length) {
                                [[[BKLoginCodeTip alloc]init] AddTextShowTip:str and:self.view];

                            }else{
                                [[[BKLoginCodeTip alloc]init] AddLoginRequestErrorTip:self.view];
                            }
                        }
                    }else{
                        [[[BKLoginCodeTip alloc]init] AddLoginNetErrorTip:self.view];
                    }
                }];
            }else{
                [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"请输入验证码" and:self.view];

            }
        }
    }
}
/**手机地区选择*/
- (void)selectAreaAction{
    kWeakSelf(weakself);
    [self closeKeyboard];

    BKNewPhoneSelectAreaCtr *ctr = [[BKNewPhoneSelectAreaCtr alloc]init];
    [ctr setSelectAreaPhoneCompletion:^(NSString * _Nonnull areaStr) {
        [weakself changeThePhoneAreaNumber:areaStr];
    }];
    [APP_DELEGATE.navigationController pushViewController:ctr animated:YES];
}
/**发送短信验证码*/
- (void)sendMessCode{
    if (![BKUtils checkPhoneNumberIsValidity:self.phoneStr withAreaPhone:[self.phoneInputView GetThePhoneAreaNUmber]]) {
        [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"发送失败,请检查手机号" and:self.view];

    }else{
        [MBProgressHUD showMessage:@""];
        NSString *phoneStr = nil;
        if ([_areaNumberStr isEqualToString:@"86"]) {
            phoneStr = _phoneStr;
        }else{
            phoneStr = [NSString stringWithFormat:@"%@%@",_areaNumberStr,_phoneStr];
        }
        [BKNewLoginRequestManage resquestSendVerificationCodeWithPhoneNumber:phoneStr AndFinish:^(id  _Nonnull responsed, NSError * _Nonnull error) {
            [MBProgressHUD hideHUD];
            if (error == nil) {
                if([[responsed objectForKey:@"success"] boolValue]){
                    //验证码发送成功
                    [self.codeInputView beginStartCountDown];
                    [[[BKLoginCodeTip alloc]init] AddCodeSendOkTip:self.view];
                }
                else{
                    NSString *str =[responsed objectForKey:@"message"];
                    if (str.length) {
                        [[[BKLoginCodeTip alloc]init] AddTextShowTip:str and:self.view];

                    }else{
                        [[[BKLoginCodeTip alloc]init] AddLoginRequestErrorTip:self.view];
                    }
                }
            }else{
                [[[BKLoginCodeTip alloc]init] AddLoginNetErrorTip:self.view];
            }
        }];
    }
}
/**改变区号显示*/
- (void)changeThePhoneAreaNumber:(NSString*)str{
    self.areaNumberStr = str;
    [self.phoneInputView changeThePhoneArea:self.areaNumberStr];
    [self changeSendCodeBtnUIWithEnable:[self checkTheNumberlong:_phoneStr]];
}
/**跳转绑定手机界面*/
- (void)GoToBindPhoneViewWith:(NSString*)unionId{
    kWeakSelf(weakself);
    BKNewBindPhoneController *binCtr = [[BKNewBindPhoneController alloc]init];
    binCtr.unionId = unionId;
    [binCtr setIftryLoginAgainClick:^(NSString * _Nonnull phonestr, NSString * _Nonnull phoneArea) {
        [weakself.phoneInputView changeThePhoneNumber:phonestr];
        [weakself changeThePhoneAreaNumber:phoneArea];
        weakself.phoneStr = phonestr;
        weakself.areaNumberStr = phoneArea;
    }];
    [APP_DELEGATE.navigationController pushViewController:binCtr animated:YES];
}
#pragma mark - keyBoard相关
- (void)keyBoardIsUP:(BOOL)isup and:(CGFloat)y andTime:(CGFloat)time{
    if (isup) {
        [UIView animateWithDuration:time animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, -y);
        }];
    }else{
        [UIView animateWithDuration:time animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
    }
}
- (void)keyboardwillChange:(NSNotification *)note{
    NSDictionary *userInfo = note.userInfo;
    CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    CGRect keyboardRect =[userInfo[UIKeyboardFrameEndUserInfoKey]  CGRectValue];
    CGFloat keyboardY = CGRectGetMinY(keyboardRect);
    
    if (keyboardY == SCREEN_HEIGHT) {
        [self keyBoardIsUP:NO and:0 andTime:duration];

    }else{
        [self keyBoardIsUP:YES and:100 andTime:duration];
    }
}
-(void)textDidChangeBegin:(NSNotification*)noti{
    UITextField * TF = noti.object;
    TF.text = [TF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (@available(iOS 11.0, *)) {
        if(@available(iOS 12.0, *)){
        }else{
            TF.text = [self clearNumberForIOS11:TF.text];
        }
    }
    if(TF.tag == 66){//手机号textchange
        self.phoneStr = TF.text;
        if ([self checkTheNumberlong:self.phoneStr]) {
            [self changeSendCodeBtnUIWithEnable:YES];
        }else{
            [self changeSendCodeBtnUIWithEnable:NO];
        }
    }else if(TF.tag == 99){//验证码textchange
        self.codeStr = TF.text;
    }
    if ([self checkTheNumberlong:self.phoneStr] && (_codeStr.length == 4)) {
        [self changeLoginBtnUIWithIsEnable:YES];
    }else{
        [self changeLoginBtnUIWithIsEnable:NO];
    }
}
- (NSString *)clearNumberForIOS11:(NSString *)str {
    if ([str isKindOfClass:[NSString class]]) {
        return [[str componentsSeparatedByCharactersInSet:
                 [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
    } else {
        return str;
    }
}
- (BOOL)checkTheNumberlong:(NSString*)str{
    if ([_areaNumberStr isEqualToString:@"86"]) {//大陆 11位
        if (str.length == 11) {
            return YES;
        }
    }else if ([_areaNumberStr isEqualToString:@"852"]) {//香港 8位
        if (str.length == 8) {
            return YES;
        }
    }else if ([_areaNumberStr isEqualToString:@"853"]) {//澳门 8位
        if (str.length == 8) {
            return YES;
        }
    }else if ([_areaNumberStr isEqualToString:@"886"]) {//台湾 10位
        if (str.length == 10) {
            return YES;
        }
    }
    return NO;
}
#pragma mark - 登录注册相关请求
/**请求后台微信登录*/
- (void)wechatLoginWithCode:(NSString *)code{
    [MBProgressHUD showMessage:@""];
    
    [BKNewLoginRequestManage requestLoginWxAppWithCode:code AndFinish:^(id  _Nonnull responsed, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@",responsed);
        if(error == nil){
            if([[responsed objectForKey:@"code"] integerValue]==1){
                //用户已存在,登录成功
                [self LoginSuccessWithDictionary:[responsed objectForKey:@"data"]];
                
                [[BaiduMobStat defaultStat] logEvent:@"e_login100" eventLabel:@"微信登录"];
            }else if([[responsed objectForKey:@"code"] integerValue] == 11004){
                //调用微信登录的时候如果返回状态码为11004 表示用户未注册  需要解析data中参数unionId保存 在跳转到手机登录页面参入unionId字段
                NSDictionary *dic = [responsed objectForKey:@"data"];
                if (dic != nil) {
                    NSString *unionIdStr = [dic objectForKey:@"unionId"];
                    [self GoToBindPhoneViewWith:unionIdStr];
                }else{
                    [[[BKLoginCodeTip alloc]init] AddLoginRequestErrorTip:self.view];
                }
            }
            else{
                NSString *str = [responsed objectForKey:@"msg"];
                if (str.length) {
                    
                    [[[BKLoginCodeTip alloc]init] AddTextShowTip:str and:self.view];
                }else{
                    
                    [[[BKLoginCodeTip alloc]init] AddLoginRequestErrorTip:self.view];
                }

            }
        }else{
            [[[BKLoginCodeTip alloc]init] AddLoginNetErrorTip:self.view];
        }
    }];
}
/**登录成功*/
-(void)LoginSuccessWithDictionary:(NSDictionary *)dic{

    if (dic != nil) {
        [APP_DELEGATE saveLoginSuccessWithDictionary:dic];
        //切换首页控制器
        HomeViewController *mHomeViewController = [[HomeViewController alloc] init];
        APP_DELEGATE.navigationController = [[BKNavgationController alloc] initWithRootViewController:mHomeViewController];
        APP_DELEGATE.window.rootViewController = APP_DELEGATE.navigationController;
    }
}

@end
