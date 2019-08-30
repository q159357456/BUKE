//
//  UserForgetPwd3Controller.m
//  MiniBuKe
//
//  Created by zhangchunzhe on 2018/3/25.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "UserForgetPwd3Controller.h"
#import "MBProgressHUD+XBK.h"
#import "UserLoginViewController.h"
#import "BKNetworkManager.h"

@interface UserForgetPwd3Controller ()<UITextFieldDelegate>

@property(strong,nonatomic) UITextField *inputPwd;
@property(strong,nonatomic) UITextField *inputPwdAgain;
@property(strong,nonatomic) BKUIButton *submitNewPwdBtn;

@end

@implementation UserForgetPwd3Controller{
    UITapGestureRecognizer *singleTap;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"重置密码"];
    [self createView];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MBProgressHUD hideHUD];
}

-(void)createView{
    
    _inputPwd = [[UITextField alloc] init];
    [_inputPwd setBackgroundColor:COLOR_STRING(@"#E9E9E9")];
    [_inputPwd.layer setCornerRadius:4.0f];
    [_inputPwd setFont:MY_FONT(15)];
    [_inputPwd setInputSpace:5.f];
    [_inputPwd setSecureTextEntry:YES];
    [_inputPwd setPlaceholder:@"请输入密码"];
    [_inputPwd setDelegate:self];
    
    _inputPwdAgain = [[UITextField alloc] init];
    [_inputPwdAgain setBackgroundColor:COLOR_STRING(@"#E9E9E9")];
    [_inputPwdAgain.layer setCornerRadius:4.0f];
    [_inputPwdAgain setFont:MY_FONT(15)];
    [_inputPwdAgain setInputSpace:5.f];
    [_inputPwdAgain setSecureTextEntry:YES];
    [_inputPwdAgain setPlaceholder:@"请再次输入密码"];
    [_inputPwdAgain setDelegate:self];
    
    
    _submitNewPwdBtn = [[BKUIButton alloc] init];
    [_submitNewPwdBtn setTitle:@"保存新密码"];
    _submitNewPwdBtn.layer.cornerRadius = 4.0f;
    _submitNewPwdBtn.layer.masksToBounds = YES;
    [_submitNewPwdBtn addTarget:self action:@selector(changeNewPassword:) forControlEvents:UIControlEventTouchUpInside];
    

    
    [self.view addSubview:_inputPwd];
    [self.view addSubview:_inputPwdAgain];
    [self.view addSubview:_submitNewPwdBtn];
    
    [_inputPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(38);
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.top.equalTo(self.view).with.offset(93);
        
    }];
    
    [_inputPwdAgain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(38);
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.top.equalTo(self.view).with.offset(151);
    }];
    
    [_submitNewPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(43);
        make.left.equalTo(self.view).with.offset(20);
        make.top.equalTo(self.view).with.offset(209);
        make.right.equalTo(self.view).with.offset(-20);
    }];
}

-(IBAction)changeNewPassword:(id)sender{
    [self closeKeyboard];
    NSString * pwd1 = _inputPwd.text;
    NSString * pwd2 = _inputPwdAgain.text;
    
    if (pwd1.length < 8 && pwd2.length < 8) {
        [MBProgressHUD showText: @"密码最少要8位"];
        return;
    }
    NSLog(@"userToken ==> %@",_token);
    
    if([self check:pwd1 again:pwd2]){
        [self showHUDLoadProgress:self.view doSomething:^{
            [BKNetworkManager userChangePassword:@{@"userToken":_token,@"pwd":pwd1} successBlock:^(id responseObject) {
                
                NSDictionary *dic = [self getHistoryAccountLogin];
                if (dic != nil) {
                    [self saveHistoryAccountLogin:[dic objectForKey:@"account" ] setPassword: pwd1];
                }
                
                [self showHUDToast:self.view text:@"重置密码成功"];
                
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    
                    if ([controller isKindOfClass:[UserLoginViewController class]]) {
                        [self.navigationController popToViewController:controller animated:YES];
                    }
                    
                }
                
//                [self.navigationController popToRootViewControllerAnimated:YES];
            } failBlock:^(int code,NSString *errorStr) {
                [self showError:errorStr];
            }];
        }];
    }
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

-(BOOL)check:(NSString*)pwd1 again:(NSString*)pwd2{
    if([BKUtils isEmpty:pwd1]){
        [self showHUDToast:self.view text:@"请输入密码"];
        return NO;
    }
    
    if([BKUtils isEmpty:pwd2]){
        [self showHUDToast:self.view text:@"请再次输入密码"];
        return NO;
    }
    
    if(![pwd1 isEqualToString:pwd2]){
        [self showHUDToast:self.view text:@"两次输入的密码不一致"];
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
    [_inputPwdAgain resignFirstResponder];//收起键盘
    [_inputPwd resignFirstResponder];//收起键盘
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
