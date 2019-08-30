//
//  UserLoginViewController.m
//  MiniBuKe
//
//  Created by zhangchunzhe on 2017/12/26.
//  Copyright © 2017年 深圳偶家科技有限公司. All rights reserved.
//

#import "UserLoginViewController.h"
#import "LoginResult.h"
#import "MBProgressHUD+XBK.h"
#import "WeChatManager.h"
#import "LoginService.h"
#import "MBProgressHUD+XBK.h"
#import "WechatUserInfo.h"
#import "UserRegisterViewController.h"
#import "UserForgetPwd1Controller.h"
#import "HomeViewController.h"
#import "UITextField+Border.h"

typedef NS_ENUM(NSInteger, Login_Type){
    Login_Type_telephone = 1,//消息已读
    Login_Type_Wechat,//消息未读
};


@interface UserLoginViewController ()<WeChatManagerDelegate>
@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIView *middleView;
@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) UIImageView *logoImageView;
@property(nonatomic,strong) BKInputView *phoneInput;
@property(nonatomic,strong) BKInputView *pwdInput;
@property(nonatomic,strong) UIButton *loginBtn;
@property(nonatomic,strong) UIButton *userRegistBtn;
@property(nonatomic,strong) UIButton *findPwdBtn;
@property(nonatomic,strong) UIButton *_showSecretBtn;

@property(nonatomic,strong) UIButton *wxLogin;

@property(nonatomic,assign) Login_Type loginType;
@end

@implementation UserLoginViewController{
    
    BOOL isSecretModel;
    UITapGestureRecognizer *singleTap;
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"账号登录"];
    
    isSecretModel = YES;
    [self setUpForDismissKeyboard];
//    [self hiddleBackNavigation];
    [self initView];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(choose_sex_complet) name:@"CHOOSE_SEX_DONE" object:nil];
}
#pragma mark - 性别选择完成后调用
-(void)choose_sex_complet{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CHOOSE_SEX_DONE" object:nil];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:Login_Type_telephone] forKey:@"LoginType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}



-(LoginResult *) getLoginResult
{
    LoginResult *mLoginResult = nil;
    NSMutableDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginResult"];
    if (dic != nil) {
        mLoginResult = [[LoginResult alloc] init];
        mLoginResult.imageUlr = [dic objectForKey:@"imageUlr" ];
        mLoginResult.nickName = [dic objectForKey:@"nickName" ];
        mLoginResult.SN = [dic objectForKey:@"sn" ];
        mLoginResult.userName = [dic objectForKey:@"userName" ];
        mLoginResult.userId = [dic objectForKey:@"userId" ];
        mLoginResult.token = [dic objectForKey:@"token" ];
        mLoginResult.appellativeName = [dic objectForKey:@"appellativeName"];
    }
    [APP_DELEGATE setMLoginResult:mLoginResult];
    return mLoginResult;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //选择性别成功回调
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = NO;
    
    [self.navigationController.navigationItem setHidesBackButton:YES];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar.backItem setHidesBackButton:YES];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    
    for (id view in [self.navigationController.navigationBar subviews]) {
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
        }
    }
    
//    [_phoneInput.inputText setText:@"123"];
    
    NSDictionary *dic = [self getHistoryAccountLogin];
    if (dic != nil) {
        [_phoneInput.inputText setText:[dic objectForKey:@"account" ]];
        [_pwdInput.inputText setText:[dic objectForKey:@"password" ]];
      
    }
    
  
    
    NSInteger loginType = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginType"] integerValue];
    NSLog(@"loginType===>>%ld",loginType);
    if (loginType == Login_Type_telephone) {
        LoginResult *mLoginResult = [self getLoginResult];
        if (mLoginResult != nil) {
            [self login:nil];
        }
    }else if (loginType == Login_Type_Wechat){
        
        NSData *infoData = [[NSUserDefaults standardUserDefaults] objectForKey:@"WechatUserInfo"];
        WechatUserInfo *wxInfo = [NSKeyedUnarchiver unarchiveObjectWithData:infoData];
        
//        WechatUserInfo *wxInfo = [dic objectForKey:@"wxInfo"];
        if (wxInfo != nil) {
            [WeChatManager weChatLoginWithWechatInfo:wxInfo];
        }
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationItem.leftBarButtonItem = nil;
//    self.navigationItem.hidesBackButton = NO;
    [MBProgressHUD hideHUD];
}



-(void)initView{
    _topView = [[UIView alloc] init];
//    [_topView setBackgroundColor:[UIColor redColor]];
    _middleView = [[UIView alloc] init];
//    [_middleView setBackgroundColor:[UIColor orangeColor]];
    _bottomView = [[UIView alloc] init];
//    [_bottomView setBackgroundColor:[UIColor blueColor]];
    
    
    [self.view addSubview:_topView];
    [self.view addSubview:_middleView];
    [self.view addSubview:_bottomView];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view).with.offset(50);
        make.right.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(_middleView.mas_top);
    }];
    
    [_middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.centerY.equalTo(self.view).with.offset(0);
        make.height.mas_offset(228);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.top.equalTo(_middleView.mas_bottom).with.offset(0);
    }];
    
    
    [self createTopViewChild];
    [self createMiddleViewChild];
    
    if (APP_DELEGATE.isWXInstalled) {
        
        WeChatManager *manager = [WeChatManager sharedManager];
        manager.delegate = self;
        
        [self createBottomViewChild];
        
    }
}

-(void)createTopViewChild{
    
    _logoImageView = [[UIImageView alloc] init];
    [_logoImageView setImage:[UIImage imageNamed:@"login_logo"]];
    [_topView addSubview:_logoImageView];
    //_logoImageView.hidden = YES;
    
    
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(68, 68));
        make.center.equalTo(_topView);
    }];
    
//    self.logoImageView.layer.cornerRadius = 68/7.0;
//    self.logoImageView.layer.masksToBounds = YES;
}

-(void)createMiddleViewChild{
    
    _phoneInput = [[BKInputView alloc] init];
    [_phoneInput setIcon:[UIImage imageNamed:@"shouji_icon"]];
    [_phoneInput.inputText setFont:MY_FONT(16)];
    [_phoneInput.inputText setKeyboardType:UIKeyboardTypePhonePad];
    [_phoneInput.inputText setPlaceholder:@"请输入手机号"];
    [_phoneInput.inputText setDelegate:self];
    if (self.phoneNum != nil) {
        [_phoneInput.inputText setText:self.phoneNum];
    }
    
    _pwdInput = [[BKInputView alloc] init];
    [_pwdInput.inputText setPlaceholder:@"请输入密码"];
    [_pwdInput.inputText setFont:MY_FONT(16)];
    [_pwdInput.inputText setSecureTextEntry:isSecretModel];
    [_pwdInput setIcon:[UIImage imageNamed:@"pwd_icon"]];
    [_pwdInput.inputText setDelegate:self];

    
    __showSecretBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 36)];
    [__showSecretBtn setImage:[UIImage imageNamed:@"pwd_hiddle"] forState:UIControlStateNormal];
    [__showSecretBtn setImage:[UIImage imageNamed:@"pwd_show"] forState:UIControlStateSelected];
    [__showSecretBtn addTarget:self action:@selector(switchSecretModel:) forControlEvents:UIControlEventTouchUpInside];
    [_pwdInput.inputText setRightViewMode:UITextFieldViewModeAlways];
    [_pwdInput.inputText setRightView:__showSecretBtn];
    
    
    _loginBtn = [[UIButton alloc] init];
    [_loginBtn setBackgroundColor:COLOR_STRING(@"#FF8C30")];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn.layer setCornerRadius:4.f];
    [_loginBtn.titleLabel setFont:MY_FONT(18)];
    [_loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    
    _userRegistBtn = [[UIButton alloc] init];
    [_userRegistBtn setTitle:@"新用户注册" forState:UIControlStateNormal];
    [_userRegistBtn.titleLabel setFont:MY_FONT(15)];
    
    [_userRegistBtn setTitleColor:COLOR_STRING(@"#909090") forState:UIControlStateNormal];
    [_userRegistBtn addTarget:self action:@selector(userRegister:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _findPwdBtn = [[UIButton alloc] init];
    [_findPwdBtn.titleLabel setFont:MY_FONT(15)];
    [_findPwdBtn setTitle:@"重置密码" forState:UIControlStateNormal];
    [_findPwdBtn setTitleColor:COLOR_STRING(@"#909090") forState:UIControlStateNormal];
    [_findPwdBtn addTarget:self action:@selector(findPassword:) forControlEvents:UIControlEventTouchUpInside];

    [_middleView addSubview:_phoneInput];
    [_middleView addSubview:_pwdInput];
    [_middleView addSubview:_loginBtn];
    [_middleView addSubview:_userRegistBtn];
    [_middleView addSubview:_findPwdBtn];
    
    
    [_phoneInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(30);
        make.left.equalTo(_middleView).with.offset(20);
        make.top.equalTo(_middleView).with.offset(0);
        make.right.equalTo(_middleView).with.offset(-20);
    }];
    
    [_pwdInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(30);
        make.left.equalTo(_middleView).with.offset(20);
        make.top.equalTo(_phoneInput.mas_bottom).with.offset(20);
        make.right.equalTo(_middleView).with.offset(-20);
    }];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(43);
        make.top.equalTo(_pwdInput.mas_bottom).with.offset(25);
        make.left.equalTo(_middleView).with.offset(20);
        make.right.equalTo(_middleView).with.offset(-20);
    }];
    
    [_userRegistBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginBtn.mas_bottom).with.offset(5);
        make.left.equalTo(_loginBtn.mas_left);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    //_userRegistBtn.backgroundColor = [UIColor redColor];
    [_findPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginBtn.mas_bottom).with.offset(5);
        make.right.equalTo(_loginBtn.mas_right);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    
}

-(void)createBottomViewChild{
    
    
    UILabel *wxLabel = [[UILabel alloc] init];
    wxLabel.font = MY_FONT(13);
    wxLabel.text = @"使用微信账号登录";
    wxLabel.textColor = COLOR_STRING(@"#909090");
    wxLabel.textAlignment = NSTextAlignmentCenter;
    [_bottomView addSubview:wxLabel];
    
    UIView *leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = COLOR_STRING(@"#D3D3D3");
    [_bottomView addSubview:leftLine];
    
    UIView *rightLine = [[UIView alloc] init];
    rightLine.backgroundColor = COLOR_STRING(@"#D3D3D3");
    [_bottomView addSubview:rightLine];
    
    UIImageView *wxLoginImgView = [[UIImageView alloc] init];
    wxLoginImgView.image = [UIImage imageNamed:@"wx_login"];
    wxLoginImgView.userInteractionEnabled = YES;
    [_bottomView addSubview:wxLoginImgView];
    
    _wxLogin = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_wxLogin setBackgroundImage:[UIImage imageNamed:@"wx_login"] forState:UIControlStateNormal];
    [_wxLogin addTarget:self action:@selector(wxLogin:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_wxLogin];
    
    [wxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bottomView.mas_centerX);
        make.top.mas_equalTo(_bottomView.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(120, 20));
    }];
    
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bottomView).offset(15);
        make.right.mas_equalTo(wxLabel.mas_left).offset(-5);
        make.centerY.mas_equalTo(wxLabel.mas_centerY);
        make.height.mas_equalTo(@0.5);
    }];
    
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(wxLabel.mas_right).offset(5);
        make.right.mas_equalTo(_bottomView).offset(-15);
        make.centerY.mas_equalTo(wxLabel.mas_centerY);
        make.height.mas_equalTo(@0.5);
    }];
    
    [wxLoginImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.top.equalTo(wxLabel.mas_bottom).offset(16);
        make.centerX.mas_equalTo(_bottomView);
    }];
    
    [_wxLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(55, 55));
        make.top.equalTo(wxLabel.mas_bottom).with.offset(11);
        make.centerX.mas_equalTo(_bottomView.mas_centerX);
    }];
    
//    [self drawLineOfDashByCAShapeLayer:leftLine lineLength:leftLine.frame.size.width lineSpacing:5 lineColor:COLOR_STRING(@"#D3D3D3") lineDirection:YES];
//    [self drawLineOfDashByCAShapeLayer:rightLine lineLength:rightLine.frame.size.width lineSpacing:5 lineColor:COLOR_STRING(@"#D3D3D3") lineDirection:YES];
}


-(IBAction)switchSecretModel:(id)sender{
    [__showSecretBtn setSelected:isSecretModel];
    isSecretModel =!isSecretModel;
    [_pwdInput.inputText setSecureTextEntry:isSecretModel];
}


-(IBAction)wxLogin:(id)sender{
    
    [WeChatManager sendAuthRequest];
}

-(IBAction)login:(id)sender{
    
    [self closeKeyboard];
    
    NSString *phone  = [_phoneInput.inputText text];
    NSString *pwd = [_pwdInput.inputText text];
    BOOL isOk = [self check:phone pwd:pwd];
    
    if(isOk){
//        [self showHUDLoadProgress:self.view doSomething:^{
//            [BKNetworkManager userLogin:@{@"userName":phone,@"passWord":pwd} successBlock:^(id responseObject) {
//            [self loginSuccess:responseObject];
//        } failBlock:^(int code,NSString *errorStr) {
//            [self showError:errorStr];
//        }];
//
//        }];
        
        [self onLoginService:phone setPassword:pwd];
    }
}

-(void)onLoginService:(NSString *) account setPassword:(NSString *) password
{
    [MBProgressHUD showMessage:@"登录中..."];
    
    NSLog(@"MBProgressHUD.description ==> %@",MBProgressHUD.description);
    
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"LoginService ==> OnSuccess");
        LoginService *service = (LoginService*)httpInterface;
        if (service.mLoginResult != nil) {
            [self loginSuccess:service.mLoginResult];
            [MBProgressHUD hideHUD];
//            [MBProgressHUD showText:@"登录成功"];
            //移除监听
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CHOOSE_SEX_DONE" object:nil];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:Login_Type_telephone] forKey:@"LoginType"];
            [[NSUserDefaults standardUserDefaults] synchronize];
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


-(NSDictionary *) getHistoryAccountLogin
{
    NSMutableDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"AccountLogin"];
//    if (dic != nil) {
//        self.mLoginResult = [[LoginResult alloc] init];
//        self.mLoginResult.imageUlr = [dic objectForKey:@"imageUlr" ];
//    }
    return dic;
}

-(void) saveHistoryAccountLogin:(NSString *) account setPassword:(NSString *) password
{
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
    
    [mutableDictionary setValue:account forKey:@"account" ];
    [mutableDictionary setValue:password forKey:@"password" ];
    
    [[NSUserDefaults standardUserDefaults] setObject:mutableDictionary forKey:@"AccountLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)loginSuccess:(LoginResult *)mLoginResult{
    
//    NSLog(@"loginSuccess ==> %@",dic);
    
//    LoginResult *mLoginResult = [LoginResult withLoginResultJson:dic];
    
    if (mLoginResult != nil) {
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
        
        //    @property (nonatomic,strong) NSString *imageUlr;
        //    @property (nonatomic,strong) NSString *nickName;
        //    @property (nonatomic,strong) NSString *SN;
        //    @property (nonatomic,strong) NSString *userName;
        //    @property (nonatomic,strong) NSString *userId;
        //    @property (nonatomic,strong) NSString *token;
        
        [mutableDictionary setValue:mLoginResult.imageUlr forKey:@"imageUlr" ];
        [mutableDictionary setValue:mLoginResult.nickName forKey:@"nickName" ];
        [mutableDictionary setValue:mLoginResult.SN forKey:@"sn" ];
        [mutableDictionary setValue:mLoginResult.userName forKey:@"userName" ];
        [mutableDictionary setValue:mLoginResult.userId forKey:@"userId" ];
        [mutableDictionary setValue:mLoginResult.token forKey:@"token" ];
        [mutableDictionary setValue:mLoginResult.appellativeName forKey:@"appellativeName" ];
        [mutableDictionary setValue:mLoginResult.hasBabyInfo forKey:@"hasBabyInfo"];
        
        [[NSUserDefaults standardUserDefaults] setObject:mutableDictionary forKey:@"LoginResult"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [APP_DELEGATE setMLoginResult:mLoginResult];
        
        NSString *phone  = [_phoneInput.inputText text];
        NSString *pwd = [_pwdInput.inputText text];
        [self saveHistoryAccountLogin:phone setPassword:pwd];
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    
        [self goTo:[[HomeViewController alloc] init]];
//        });
    }
    
}


//-(void)loginSuccess:(NSDictionary*)dic{
//
//    NSLog(@"loginSuccess ==> %@",dic);
//
//    LoginResult *mLoginResult = [LoginResult withLoginResultJson:dic];
//
//    if (mLoginResult != nil) {
//        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
//
//        //    @property (nonatomic,strong) NSString *imageUlr;
//        //    @property (nonatomic,strong) NSString *nickName;
//        //    @property (nonatomic,strong) NSString *SN;
//        //    @property (nonatomic,strong) NSString *userName;
//        //    @property (nonatomic,strong) NSString *userId;
//        //    @property (nonatomic,strong) NSString *token;
//
//        [mutableDictionary setValue:mLoginResult.imageUlr forKey:@"imageUlr" ];
//        [mutableDictionary setValue:mLoginResult.nickName forKey:@"nickName" ];
//        [mutableDictionary setValue:mLoginResult.SN forKey:@"SN" ];
//        [mutableDictionary setValue:mLoginResult.userName forKey:@"userName" ];
//        [mutableDictionary setValue:mLoginResult.userId forKey:@"userId" ];
//        [mutableDictionary setValue:mLoginResult.token forKey:@"token" ];
//        [mutableDictionary setValue:mLoginResult.appellativeName forKey:@"appellativeName" ];
//
//        [[NSUserDefaults standardUserDefaults] setObject:mutableDictionary forKey:@"LoginResult"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//
//        [APP_DELEGATE setMLoginResult:mLoginResult];
//
//        NSString *phone  = [_phoneInput.inputText text];
//        NSString *pwd = [_pwdInput.inputText text];
//        [self saveHistoryAccountLogin:phone setPassword:pwd];
//
//        [self goTo:[[HomeViewController alloc] init]];
//    }
//
//}

#pragma mark - WeChatManagerDelegate
-(void)wechatLoginSuccessWithDictionary:(NSDictionary *)dic
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:Login_Type_Wechat] forKey:@"LoginType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"weixinLoginCallback---->%@",dic);
    
    LoginResult *mLoginResult = [LoginResult withLoginResultJson:dic];
    
    if (mLoginResult != nil) {
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
        
        [mutableDictionary setValue:mLoginResult.imageUlr forKey:@"imageUlr" ];
        [mutableDictionary setValue:mLoginResult.nickName forKey:@"nickName" ];
        [mutableDictionary setValue:mLoginResult.SN forKey:@"sn" ];
        [mutableDictionary setValue:mLoginResult.userName forKey:@"userName" ];
        [mutableDictionary setValue:mLoginResult.userId forKey:@"userId" ];
        [mutableDictionary setValue:mLoginResult.token forKey:@"token" ];
        [mutableDictionary setValue:mLoginResult.appellativeName forKey:@"appellativeName" ];
        [mutableDictionary setValue:mLoginResult.hasBabyInfo forKey:@"hasBabyInfo"];
        
        [[NSUserDefaults standardUserDefaults] setObject:mutableDictionary forKey:@"LoginResult"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [APP_DELEGATE setMLoginResult:mLoginResult];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:[[HomeViewController alloc] init] animated:YES];
        });
    }
    
}


-(BOOL)check:(NSString*)phone pwd:(NSString*)pwd{
    if([BKUtils isEmpty:phone]){
        [self showHUDToast:self.view text:@"手机号不能为空"];
        return NO;
    }
    NSLog(@"手机长度：%lu",[phone length]);
    
    NSInteger count = [phone length];
    if(count != 11){
        [self showHUDToast:self.view text:@"非有效的手机号"];
        return NO;
    }
//    if([BKUtils checkPhoneFormat:phone]){
//        [self showHUDToast:self.view text:@"非有效的手机号"];
//        return NO;
//    }
    
    if([BKUtils isEmpty:pwd]){
        [self showHUDToast:self.view text:@"密码不能为空"];
        return NO;
    }
    
    return YES;
}

-(IBAction)userRegister:(id)sender{
    [self closeKeyboard];
    UserRegisterViewController *registerController =  [[UserRegisterViewController alloc] init];
    [self goTo:registerController];
}

-(IBAction)findPassword:(id)sender{
    [self closeKeyboard];
    UserForgetPwd1Controller *findPwdController =  [[UserForgetPwd1Controller alloc] init];
    [self goTo:findPwdController];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)closeKeyboard{
    [self.view removeGestureRecognizer:singleTap];
    [_pwdInput.inputText resignFirstResponder];//收起键盘
    [_phoneInput.inputText resignFirstResponder];//收起键盘
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

/**
 *  通过 CAShapeLayer 方式绘制虚线
 *
 *  param lineView:       需要绘制成虚线的view
 *  param lineLength:     虚线的宽度
 *  param lineSpacing:    虚线的间距
 *  param lineColor:      虚线的颜色
 *  param lineDirection   虚线的方向  YES 为水平方向， NO 为垂直方向
 **/
-(void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    
    if (isHorizonal) {
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) * 0.5, CGRectGetHeight(lineView.frame))];
    }else{
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) * 0.5, CGRectGetHeight(lineView.frame) * 0.5)];
    }
    
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    [shapeLayer setStrokeColor:lineColor.CGColor];
    
    if (isHorizonal) {
        [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    }else{
        [shapeLayer setLineWidth:CGRectGetWidth(lineView.frame)];
    }
    
    [shapeLayer setLineJoin:kCALineJoinRound];
    //设置线宽.线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength],[NSNumber numberWithInt:lineSpacing], nil]];
    
    //设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    if (isHorizonal) {
        CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
    }else{
        CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(lineView.frame));
    }
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    [lineView.layer addSublayer:shapeLayer];
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
