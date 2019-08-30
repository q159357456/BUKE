//
//  UserForgetPwd2Controller.m
//  MiniBuKe
//
//  Created by zhangchunzhe on 2018/3/25.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "UserForgetPwd2Controller.h"
#import "MBProgressHUD+XBK.h"
#import "BKNetworkManager.h"
#import "UserForgetPwd3Controller.h"
#import "CheckMessageCodeService.h"

@interface UserForgetPwd2Controller ()<UITextFieldDelegate>
@property(nonatomic,strong) UITextField *smsCodeInput;
@property(nonatomic,strong) CountdownView *getSmsCodeBtn;
@property(nonatomic,strong) BKUIButton *nextBtn;
@end

@implementation UserForgetPwd2Controller{
    NSString* requestSmsCode;
    UITapGestureRecognizer *singleTap;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"重置密码"];
    [self createView];
}
-(void)createView{
    
    _smsCodeInput = [[UITextField alloc] init];
    [_smsCodeInput setBackgroundColor:COLOR_STRING(@"#E9E9E9")];
    [_smsCodeInput.layer setCornerRadius:4.0f];
    [_smsCodeInput setKeyboardType:UIKeyboardTypeNumberPad];
    [_smsCodeInput setFont:MY_FONT(15)];
    [_smsCodeInput setPlaceholder:@"请输入验证码"];
    [_smsCodeInput setInputSpace:5.f];
    [_smsCodeInput setDelegate:self];
    
    _nextBtn = [[BKUIButton alloc] init];
    _nextBtn.layer.cornerRadius = 4.0f;
    _nextBtn.layer.masksToBounds = YES;
    [_nextBtn setTitle:@"下一步"];
    [_nextBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    
    _getSmsCodeBtn = [[CountdownView alloc] init];
    [_getSmsCodeBtn setTitle:@"获取验证码"];
    [_getSmsCodeBtn.titleLabel setFont:MY_FONT(15)];
    _getSmsCodeBtn.layer.cornerRadius = 4.0f;
    _getSmsCodeBtn.layer.masksToBounds = YES;
    [_getSmsCodeBtn addTarget:self action:@selector(getSmsCode:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:_smsCodeInput];
    [self.view addSubview:_getSmsCodeBtn];
    [self.view addSubview:_nextBtn];
    
    [_getSmsCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(80, 38));
        make.right.equalTo(self.view).with.offset(-20);
        make.top.equalTo(self.view).with.offset(93);
   
    }];
    
    [_smsCodeInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(38);
        make.left.equalTo(self.view).with.offset(20);
        make.top.equalTo(self.view).with.offset(93);
        make.right.equalTo(_getSmsCodeBtn.mas_left).with.offset(-20);
    }];
    
    
    
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(43);
        make.left.equalTo(self.view).with.offset(20);
        make.top.equalTo(self.view).with.offset(151);
        make.right.equalTo(self.view).with.offset(-20);
    }];
}

-(IBAction)getSmsCode:(id)sender{
    [self closeKeyboard];
    [self showHUDLoadProgress:self.view doSomething:^{
        [BKNetworkManager userSMSCode:@{@"userToken":_token} successBlock:^(id responseObject) {
            [_getSmsCodeBtn setTime:60];
            
            [_getSmsCodeBtn setBackgroundImage:[BKUtils createImageWithColor:COLOR_STRING(@"#9B9B9B")] forState:UIControlStateNormal];
            
//            [_getSmsCodeBtn.layer setBorderColor:COLOR_STRING(@"#9B9B9B").CGColor];
//            [_getSmsCodeBtn.layer setBorderWidth:1.0f];
//            [_getSmsCodeBtn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
//            //边框宽度
//            [_getSmsCodeBtn.layer setBorderWidth:1.0];
//            [_getSmsCodeBtn.layer setMasksToBounds:YES];
//            #9B9B9B
            
            NSLog(@"%@",[responseObject description]);
        } failBlock:^(int code,NSString *errorStr) {
            [MBProgressHUD showText:errorStr];
        }];
    }];
}

-(IBAction)next:(id)sender{
    [self closeKeyboard];
    NSString *smsCode = [_smsCodeInput text];
    if([BKUtils isEmpty:smsCode]){
        [self showHUDToast:self.view text:@"请输入手机验证码"];
        return;
    }

    [self checkSmsCode:_token setSmsCode:smsCode ];
//    [self showHUDLoadProgress:self.view doSomething:^{
//        [BKNetworkManager checkSmsCode:@{@"userToken":_token,@"smsCode":smsCode} successBlock:^(id responseObject) {
//            NSLog(@"%@",[responseObject description]);
//
//            if ([responseObject isKindOfClass:[NSDictionary class]]){
//                NSDictionary *userTokenDic = responseObject;
//
//                NSString * token = [userTokenDic objectForKey:@"userToken"];
//                NSLog(@"userToken2 ==> %@",token);
//                UserForgetPwd3Controller *forget3 = [[UserForgetPwd3Controller alloc] init];
//                [forget3 setToken:token];
//                [self goTo:forget3];
//            } else {
//                [MBProgressHUD showText:@"data异常"];
//            }
//
//
//        } failBlock:^(int code,NSString *errorStr) {
//            [MBProgressHUD showText:errorStr];
//        }];
//    }];
    

}

-(void)checkSmsCode:(NSString *) userToken setSmsCode:(NSString *) smsCode
{
    [MBProgressHUD showMessage:@"请稍候..."];
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        
        CheckMessageCodeService *service = (CheckMessageCodeService *)httpInterface;
        if (service != nil && service.userToken != nil && service.userToken.length > 0) {
            NSLog(@"service.userToken ==> %@",service.userToken);

            UserForgetPwd3Controller *forget3 = [[UserForgetPwd3Controller alloc] init];
            [forget3 setToken:service.userToken];
            [self goTo:forget3];
        }
        
        [MBProgressHUD hideHUD];
    };
    
    void (^OnError) (NSInteger,NSString *) = ^(NSInteger httpInterface,NSString *description){
        [MBProgressHUD hideHUD];
    };
    
    CheckMessageCodeService *service = [[CheckMessageCodeService alloc]init:OnSuccess setOnError:OnError setUserToken:userToken setSMSCode:smsCode];
    [service start];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)closeKeyboard{
    [self.view removeGestureRecognizer:singleTap];
    [_smsCodeInput resignFirstResponder];//收起键盘
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

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MBProgressHUD hideHUD];
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
