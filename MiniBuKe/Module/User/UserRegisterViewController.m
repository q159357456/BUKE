//
//  UserRegisterViewController.m
//  MiniBuKe
//
//  Created by zhangchunzhe on 2017/12/26.
//  Copyright © 2017年 深圳偶家科技有限公司. All rights reserved.
//

#import "UserRegisterViewController.h"
#import "UserRegisterAgreementView.h"
#import "UserLoginViewController.h"
#import "MBProgressHUD+XBK.h"
#import "GetVerificationCodeService.h"
#import "BKNetworkManager.h"
#import "MiniBuKe-Swift.h"
#import "LoginService.h"
@interface UserRegisterViewController ()
@property (nonatomic,strong) BKInputView *phoneInput;
@property (nonatomic,strong) BKInputView *pwdInput;
@property (nonatomic,strong) BKInputView *smsCodeInput;
@property (nonatomic,strong) UIButton *registerBtn;
@property (nonatomic,strong) CountdownView *requestSMSCodeBtn;

@property (nonatomic,strong) NSTimer *timer;

@end

@implementation UserRegisterViewController{
    NSString *smsCode;
    NSString *phoneNum;
    NSString *password;
    UITapGestureRecognizer *singleTap;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"注册新用户"];
//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    UIView *statusView = [[UIView alloc] init];
    if (iPhoneX) {
        statusView.frame = CGRectMake(0, -44, SCREEN_WIDTH, 44);
    }else{
        statusView.frame = CGRectMake(0, -20, SCREEN_WIDTH, 20);
    }

//    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, 20)];
    statusView.backgroundColor = COLOR_STRING(@"#FFFFFF");
    [self.navigationController.navigationBar addSubview:statusView];
    
    self.navigationController.navigationBar.backgroundColor = COLOR_STRING(@"#FFFFFF");
    [self setNeedsStatusBarAppearanceUpdate];
    
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    [self createView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self startTimer];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self endTimer];
}

-(void) startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timeDo) userInfo:nil repeats:YES];

}
-(void)timeDo{
    
    if (self.requestSMSCodeBtn.userInteractionEnabled) {
        //NSLog(@"input ===> %i",self.phoneInput.inputText.text.length);
        if (self.phoneInput.inputText.text.length > 0) {
            [_requestSMSCodeBtn setBackgroundImage:[BKUtils createImageWithColor:COLOR_STRING(@"#FF7216")] forState:UIControlStateNormal];
            //                _requestSMSCodeBtn.backgroundColor = COLOR_STRING(@"#FF7216");
            [_requestSMSCodeBtn.layer setBorderColor:COLOR_STRING(@"#FF7216").CGColor];
            [_requestSMSCodeBtn.layer setBorderWidth:1.0f];
            [_requestSMSCodeBtn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
            //边框宽度
            [_requestSMSCodeBtn.layer setBorderWidth:1.0];
            [_requestSMSCodeBtn.layer setMasksToBounds:YES];
        } else {
            [_requestSMSCodeBtn setBackgroundImage:[BKUtils createImageWithColor:COLOR_STRING(@"#9B9B9B")] forState:UIControlStateNormal];
            //                _requestSMSCodeBtn.backgroundColor = COLOR_STRING(@"#9B9B9B");
            [_requestSMSCodeBtn.layer setBorderColor:COLOR_STRING(@"#9B9B9B").CGColor];
            [_requestSMSCodeBtn.layer setBorderWidth:1.0f];
            [_requestSMSCodeBtn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
            //边框宽度
            [_requestSMSCodeBtn.layer setBorderWidth:1.0];
            [_requestSMSCodeBtn.layer setMasksToBounds:YES];
        }
    }
}
-(void) endTimer
{
    [self.timer invalidate];
}

-(void)createView{
    _phoneInput = [[BKInputView alloc] init];
    [_phoneInput setIcon:[UIImage imageNamed:@"shouji_icon"]];
    [_phoneInput.inputText setFont:MY_FONT(15)];
    [_phoneInput.inputText setKeyboardType:UIKeyboardTypeNumberPad];
    [_phoneInput.inputText setPlaceholder:@"请输入您的手机号"];
    [_phoneInput.inputText setDelegate:self];
    
    
    
    UITextView *hintText = [[UITextView alloc] initWithFrame:CGRectMake(0, 0,150, 0)];
    [hintText setText:@"仅支持中国大陆手机号"];
    [hintText setTextColor:[UIColor colorWithHexStr:@"#909090"]];
    [hintText setFont:MY_FONT(13)];
    //[_phoneInput setRightView:hintText];
    hintText.hidden = YES;
    
    _pwdInput = [[BKInputView alloc] init];
    [_pwdInput.inputText setPlaceholder:@"请输入8-16位密码"];
    [_pwdInput.inputText setFont:MY_FONT(15)];
    [_pwdInput.inputText setSecureTextEntry:YES];
    [_pwdInput setIcon:[UIImage imageNamed:@"pwd_icon"]];
    [_pwdInput.inputText setDelegate:self];
    
    _smsCodeInput = [[BKInputView alloc] init];
    [_smsCodeInput.inputText setPlaceholder:@"请输入短信验证码"];
    [_smsCodeInput.inputText setFont:MY_FONT(15)];
    [_smsCodeInput.inputText setKeyboardType:UIKeyboardTypeNumberPad];
    [_smsCodeInput setIcon:[UIImage imageNamed:@"sms_icon"]];
    [_smsCodeInput.inputText setDelegate:self];
    
    _requestSMSCodeBtn = [[CountdownView alloc] initWithFrame:CGRectMake(0, 0,91, 0)];
    [_requestSMSCodeBtn setBackgroundImage:[BKUtils createImageWithColor:COLOR_STRING(@"#FF7216")] forState:UIControlStateNormal];
//    [_requestSMSCodeBtn setBackgroundColor:COLOR_STRING(@"#FF7216")];
    [_requestSMSCodeBtn.layer setBorderColor:COLOR_STRING(@"#FF7216").CGColor];
    [_requestSMSCodeBtn.layer setBorderWidth:1.0f];
    [_requestSMSCodeBtn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    //边框宽度
    [_requestSMSCodeBtn.layer setBorderWidth:1.0];
    [_requestSMSCodeBtn.layer setMasksToBounds:YES];
    
    [_requestSMSCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_requestSMSCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_requestSMSCodeBtn.titleLabel setFont:MY_FONT(13)];
    
    
    [_requestSMSCodeBtn addTarget:self action:@selector(requestSMSCode:) forControlEvents:UIControlEventTouchUpInside];
    [_smsCodeInput setRightView:_requestSMSCodeBtn];
    
    _registerBtn = [[UIButton alloc] init];
    [_registerBtn setBackgroundColor:COLOR_STRING(@"#FF8C30")];
    [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [_registerBtn.layer setCornerRadius:4.f];
    [_registerBtn.titleLabel setFont:MY_FONT(18)];
    [_registerBtn addTarget:self action:@selector(startRegister:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_phoneInput];
    [self.view addSubview:_pwdInput];
    [self.view addSubview:_smsCodeInput];
    [self.view addSubview:_registerBtn];
    
    [_phoneInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(30);
        make.left.equalTo(self.view).with.offset(20);
        make.top.equalTo(self.view).with.offset(180);
        make.right.equalTo(self.view).with.offset(-20);
    }];
    
    [_pwdInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(30);
        make.left.equalTo(self.view).with.offset(20);
        make.top.equalTo(self.view).with.offset(221);
        make.right.equalTo(self.view).with.offset(-20);
    }];
    
    [_smsCodeInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(30);
        make.left.equalTo(self.view).with.offset(20);
        make.top.equalTo(self.view).with.offset(265);
        make.right.equalTo(self.view).with.offset(-20);
    }];
    
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(43);
        make.left.equalTo(self.view).with.offset(20);
        make.top.equalTo(self.view).with.offset(310);
        make.right.equalTo(self.view).with.offset(-20);
    }];
    
    UserRegisterAgreementView *mUserRegisterAgreementView = [UserRegisterAgreementView xibView];
    [self.view addSubview:mUserRegisterAgreementView];
    
//    mUserRegisterAgreementView.frame = CGRectMake(self.view.frame.size.width/2 - mUserRegisterAgreementView.frame.size.width/2, self.view.frame.size.height - mUserRegisterAgreementView.frame.size.height, mUserRegisterAgreementView.frame.size.width, mUserRegisterAgreementView.frame.size.height);
    
    [mUserRegisterAgreementView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_registerBtn.mas_bottom).offset(25);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_offset(45);
    }];
    
}


-(IBAction)startRegister:(id)sender{
     //TODO: 请求注册

    [self closeKeyboard];
    phoneNum = _phoneInput.inputText.text;
    password = _pwdInput.inputText.text;
    smsCode = _smsCodeInput.inputText.text;

    if([self checkRegister:phoneNum pwd:password smsCode:smsCode]){

        [self showHUDLoadProgress:self.view doSomething:^{
            [BKNetworkManager userRegister:@ {
                @"userName":phoneNum,
                @"passWord":password,
                @"accountType":@"1",
                @"verificationCode":smsCode
            } successBlock:^(id responseObject) {
                 NSLog(@"<<====>> 注册成功");
                //登录
                [self onLoginService:phoneNum setPassword:password];
            } failBlock:^(int code,NSString *errorStr) {
                [MBProgressHUD showText:errorStr];
            }];
        }];

    }
}

//新增登录  (秦根18.9.11)
-(void)onLoginService:(NSString *) account setPassword:(NSString *) password
{
  
 
    
    NSLog(@"MBProgressHUD.description ==> %@",MBProgressHUD.description);
    
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"LoginService ==> OnSuccess");
        LoginService *service = (LoginService*)httpInterface;
        if (service.mLoginResult != nil) {
            
            NSLog(@"<<====>> 登录成功");
            [self loginSuccess:service.mLoginResult];
            OJSexChooseController *sexChooseVC = [[OJSexChooseController alloc] init];
            [self.navigationController pushViewController:sexChooseVC animated:YES];
            
           
        }
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"LoginService ==> OnError");
        [MBProgressHUD hideHUD];
        [MBProgressHUD showText:description];
    };
    
    
    
    LoginService *service = [[LoginService alloc] init:OnSuccess setOnError:OnError setAccount:account setPassword:password];
    [service start];
}
-(void)loginSuccess:(LoginResult *)mLoginResult{
    if (mLoginResult != nil) {
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
        [mutableDictionary setValue:mLoginResult.imageUlr forKey:@"imageUlr" ];
        [mutableDictionary setValue:mLoginResult.nickName forKey:@"nickName" ];
        [mutableDictionary setValue:mLoginResult.SN forKey:@"sn" ];
        [mutableDictionary setValue:mLoginResult.userName forKey:@"userName" ];
        [mutableDictionary setValue:mLoginResult.userId forKey:@"userId" ];
        [mutableDictionary setValue:mLoginResult.token forKey:@"token" ];
        [mutableDictionary setValue:mLoginResult.appellativeName forKey:@"appellativeName" ];
        
        [[NSUserDefaults standardUserDefaults] setObject:mutableDictionary forKey:@"LoginResult"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [APP_DELEGATE setMLoginResult:mLoginResult];
        NSString *phone  = _phoneInput.inputText.text;
        NSString *pwd = _pwdInput.inputText.text;
        [self saveHistoryAccountLogin:phone setPassword:pwd];
        
 
}
}
    
-(void) saveHistoryAccountLogin:(NSString *) account setPassword:(NSString *) password
{
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
    
    [mutableDictionary setValue:account forKey:@"account" ];
    [mutableDictionary setValue:password forKey:@"password" ];
    
    [[NSUserDefaults standardUserDefaults] setObject:mutableDictionary forKey:@"AccountLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
    
    
-(IBAction)requestSMSCode:(id)sender{
    NSLog(@" ====> register <====");
    [self closeKeyboard];
    phoneNum = _phoneInput.inputText.text;
    password = _pwdInput.inputText.text;
    if([self checkGetSmsCode:phoneNum pwd:password]){
        
        [MBProgressHUD showMessage:@"请等待..."];
        
        void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
            NSLog(@"GetUpdateSoftwareInfoService ==> OnSuccess");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                [self logout];
                //[MBProgressHUD showText:@"验证码已发送,请注意查收短信,如有拦截短信功能，请前往拦截列表查看"];
            });
            
            _requestSMSCodeBtn.userInteractionEnabled = NO;
            [_requestSMSCodeBtn setBackgroundImage:[BKUtils createImageWithColor:COLOR_STRING(@"#9B9B9B")] forState:UIControlStateNormal];
            
            [_requestSMSCodeBtn.layer setBorderColor:COLOR_STRING(@"#9B9B9B").CGColor];
            [_requestSMSCodeBtn.layer setBorderWidth:1.0f];
            [_requestSMSCodeBtn.layer setCornerRadius:6.0]; //设置矩形四个圆角半径
            //边框宽度
            [_requestSMSCodeBtn.layer setBorderWidth:1.0];
            [_requestSMSCodeBtn.layer setMasksToBounds:YES];
            
            [_requestSMSCodeBtn setTime:60];
            
        };
        
        void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
        {
            NSLog(@"GetUpdateSoftwareInfoService ==> OnError");
            
            [MBProgressHUD hideHUD];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [MBProgressHUD showText:description];
//
//            });
            [MBProgressHUD showText:description];
            
        };
        
        GetVerificationCodeService *service = [[GetVerificationCodeService alloc] initWithOnSuccess:OnSuccess setOnError:OnError setPhoneNum:phoneNum];
        [service start];
    }
}

- (void) logout {
    // 初始化对话框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"验证码已发送,请注意查收短信,如有拦截短信功能，请前往拦截列表查看" preferredStyle:UIAlertControllerStyleAlert];
    // 确定注销
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        NSLog(@"点击提示");
    }];
//    UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:okAction];
//    [alert addAction:cancelAction];
    
    // 弹出对话框
    [self presentViewController:alert animated:true completion:nil];
}


-(BOOL)checkGetSmsCode:(NSString*)phone pwd:(NSString*)password{
    if([BKUtils isEmpty:phone]){
        [self showHUDToast:self.view text:@"手机号不能为空"];
        return NO;
    }
    
    long count = [phone length];
    if(count != 11){
        [self showHUDToast:self.view text:@"非有效的手机号"];
        return NO;
    }
    
    //    if([BKUtils checkPhoneFormat:phone]){
    //        [self showHUDToast:self.view text:@"非有效的手机号"];
    //        return NO;
    //    }
    
    if([BKUtils isEmpty:password]){
        [self showHUDToast:self.view text:@"请输入密码"];
        return NO;
    }
    
    if (password.length > 16 || password.length < 8) {
        [self showHUDToast:self.view text:@"密码最少8位,最多16位"];
        return NO;
    }
    
    if(![self judgePassWordLegal:password]){
        [self showHUDToast:self.view text:@"只能使用数字或者英文"];
        return NO;
    }
    
    
    return YES;
}

-(BOOL)judgePassWordLegal:(NSString *)pass{
    BOOL result = false;
    if ([pass length] >= 8){
        // 判断长度大于8位后再接着判断是否同时包含数字和字符
        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:pass];
    }
    if (result != true && [pass length] >= 8){
        // 判断长度大于8位后再接着判断是否同时包含数字和字符
        NSString * regex = @"^(?![0-9]+$)[0-9A-Za-z]{8,16}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:pass];
    }
    if (result != true && [pass length] >= 8){
        // 判断长度大于8位后再接着判断是否同时包含数字和字符
        NSString * regex = @"^(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:pass];
    }
    return result;
}




-(BOOL)checkRegister:(NSString*)phone pwd:(NSString*)password smsCode:(NSString*)sms{
    
    if(![self checkGetSmsCode:phone pwd:password]){

        return NO;
    }
    
    if([BKUtils isEmpty:sms]){
        [self showHUDToast:self.view text:@"请输入短信验证码"];
        return NO;
    }
    
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)closeKeyboard{
    [self.view removeGestureRecognizer:singleTap];
    [_pwdInput.inputText resignFirstResponder];//收起键盘
    [_phoneInput.inputText resignFirstResponder];//收起键盘
    [_smsCodeInput.inputText resignFirstResponder];//收起键盘
}


- (void)setUpForDismissKeyboard {
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
}

-(void)fingerTapped:(id)sender{
    [self closeKeyboard];
}



-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self setUpForDismissKeyboard];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self closeKeyboard];
    return YES;
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
