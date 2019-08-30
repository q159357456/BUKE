//
//  UserForgetPwd1Controller.m
//  MiniBuKe
//
//  Created by zhangchunzhe on 2018/3/25.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "UserForgetPwd1Controller.h"
#import "UserForgetPwd2Controller.h"
#import "BKNetworkManager.h"
#import "GetUserInfoByPhoneService.h"

@interface UserForgetPwd1Controller ()<UITextFieldDelegate>
@property(nonatomic,strong) BKInputView *phoneInput;
@property(nonatomic,strong) BKUIButton *button;
@end

@implementation UserForgetPwd1Controller{
    UITapGestureRecognizer *singleTap;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"重置密码"];
    [self createView];
}

-(void)createView{
    _phoneInput = [[BKInputView alloc] init];
    [_phoneInput setBackgroundColor:COLOR_STRING(@"#E9E9E9")];
    [_phoneInput.layer setCornerRadius:4.0f];
    [_phoneInput.inputText setPlaceholder:@"请输入手机号"];
    [_phoneInput.inputText setFont:MY_FONT(15)];
    [_phoneInput.inputText setKeyboardType:UIKeyboardTypeNumberPad];
    [_phoneInput setImageFrame:CGRectMake(0, 0, 60, 0)];
    [_phoneInput setIcon:[UIImage imageNamed:@"phone"]];
    [_phoneInput setBorderW:0];
    [_phoneInput.inputText setDelegate:self];
    
    NSInteger loginType = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginType"] integerValue];
    if (loginType == 1 && APP_DELEGATE.mLoginResult != nil) {
        NSMutableDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"AccountLogin"];
        [_phoneInput.inputText setText:[dic objectForKey:@"account" ]];
        _phoneInput.inputText.enabled = NO;
    }
    
    _button = [[BKUIButton alloc] init];
    [_button setTitle:@"下一步"];
    [_button.layer setCornerRadius:5.0f];
    _button.layer.masksToBounds = YES;
    [_button addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_phoneInput];
    [self.view addSubview:_button];
    [_phoneInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(38);
        make.left.equalTo(self.view).with.offset(20);
        make.top.equalTo(self.view).with.offset(93);
        make.right.equalTo(self.view).with.offset(-20);
    }];
    
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(43);
        make.left.equalTo(self.view).with.offset(20);
        make.top.equalTo(self.view).with.offset(151);
        make.right.equalTo(self.view).with.offset(-20);
    }];
}


-(IBAction)next:(id)sender{
    [self closeKeyboard];
    NSString *phone = _phoneInput.inputText.text;
    if([self check:phone]){
        
        [self getUserInfoByPhone:phone];
        
//        [self showHUDLoadProgress:self.view doSomething:^{
//            [BKNetworkManager getUserTokenByPhone:@{@"phone":phone} successBlock:^(id responseObject) {
//                NSDictionary *userTokenDic = responseObject;
//                NSString * token = [userTokenDic objectForKey:@"userToken"];
//                NSLog(@"userToken1 ==> %@",token);
//                UserForgetPwd2Controller *forget2 = [[UserForgetPwd2Controller alloc] init];
//                [forget2 setPhoneNum:phone];
//                [forget2 setToken:token];
//                [self goTo:forget2];
//
//            } failBlock:^(int code,NSString *errorStr) {
//                [self showError:errorStr];
//            }];
//        }];
        
        
    }
}

-(void)getUserInfoByPhone:(NSString *) phone
{
    [MBProgressHUD showMessage:@"请稍候..."];
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        
        GetUserInfoByPhoneService *service = (GetUserInfoByPhoneService *)httpInterface;
        if (service != nil && service.userToken != nil && service.userToken.length > 0) {
            NSLog(@"service.userToken ==> %@",service.userToken);
            
            UserForgetPwd2Controller *forget2 = [[UserForgetPwd2Controller alloc] init];
            [forget2 setPhoneNum:phone];
            [forget2 setToken:service.userToken];
            
            [self goTo:forget2];
        }
        
        [MBProgressHUD hideHUD];
    };
    
    void (^OnError) (NSInteger,NSString *) = ^(NSInteger httpInterface,NSString *description){
        [MBProgressHUD hideHUD];
    };
    
    GetUserInfoByPhoneService *service = [[GetUserInfoByPhoneService alloc]init:OnSuccess setOnError:OnError setPhone:phone];
    [service start];
}

-(BOOL)check:(NSString*)phone{
    
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
    
    
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)closeKeyboard{
    [self.view removeGestureRecognizer:singleTap];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
