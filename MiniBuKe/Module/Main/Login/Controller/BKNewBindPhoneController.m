//
//  BKNewBindPhoneController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/23.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKNewBindPhoneController.h"
#import "BKLoginCodeInputView.h"
#import "BKLoginPhoneInputView.h"
#import "BKNewPhoneSelectAreaCtr.h"
#import "BKPhoneNumInUseTipCtr.h"
#import "BKNewLoginRequestManage.h"
#import "BKLoginCodeTip.h"
#import "HomeViewController.h"

@interface BKNewBindPhoneController ()

@property(nonatomic, strong) BKLoginCodeInputView *codeInputView;
@property(nonatomic, strong) BKLoginPhoneInputView *phoneInputView;
@property(nonatomic, strong) UIButton *bindBtn;
@property(nonatomic, copy) NSString *phoneStr;
@property(nonatomic, copy) NSString *codeStr;

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *subTitleLabel;
@property(nonatomic, strong) UIButton *backBtn;

@property(nonatomic, copy) NSString *areaNumberStr;
@property(nonatomic, assign) BOOL isEnableLogin;

@end

@implementation BKNewBindPhoneController

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
        [weakSelf selectAreaAction];
    }];
    [self.view addSubview:_phoneInputView];
    
    self.bindBtn = [[UIButton alloc]init];
    _bindBtn.backgroundColor = COLOR_STRING(@"#d7d7d7");
    [_bindBtn setTitle:@"绑定" forState:UIControlStateNormal];
    [_bindBtn setTitleColor:COLOR_STRING(@"#FFFFFF") forState:UIControlStateNormal];
    _bindBtn.titleLabel.font = [UIFont systemFontOfSize:16.f weight:UIFontWeightMedium];
    _bindBtn.layer.cornerRadius = 25.f;
    _bindBtn.clipsToBounds = YES;
    [_bindBtn addTarget:self action:@selector(bindBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bindBtn];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.text = @"请绑定手机号";
    _titleLabel.textColor = COLOR_STRING(@"#2F2F2F");
    _titleLabel.font = [UIFont systemFontOfSize:25.f weight:UIFontWeightMedium];
    [self.view addSubview:_titleLabel];
    
    self.subTitleLabel = [[UILabel alloc]init];
    self.subTitleLabel.text = @"之后您可以用手机号或者微信账号登录";
    _subTitleLabel.textColor = COLOR_STRING(@"#999999");
    _subTitleLabel.font = [UIFont systemFontOfSize:12.f weight:UIFontWeightRegular];
    [self.view addSubview:_subTitleLabel];
    
    self.backBtn = [[UIButton alloc]init];
    [_backBtn setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateNormal];
    [_backBtn setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateSelected];
    [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    
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
    [self.bindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.codeInputView.mas_left);
        make.right.mas_equalTo(self.codeInputView.mas_right);
        make.height.mas_equalTo(50.f);
        make.top.mas_equalTo(self.codeInputView.mas_bottom).offset(15.f);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.codeInputView.mas_left);
        make.bottom.mas_equalTo(self.phoneInputView.mas_top).offset(-90.f);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.codeInputView.mas_left);
        make.bottom.mas_equalTo(self.subTitleLabel.mas_top).offset(-10.f);
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.top.mas_equalTo(self.view.mas_top).offset(kStatusBarH);
    }];
}

- (void)closeKeyboard{
    [self.phoneInputView cancelFirstResponder];
    [self.codeInputView cancelFirstResponder];
}

#pragma mark - changeBtnUI
- (void)changeLoginBtnUIWithIsEnable:(BOOL)isEnabel{
    if (isEnabel) {
        [_bindBtn setBackgroundColor:COLOR_STRING(@"#FEA449")];
    }else{
        [_bindBtn setBackgroundColor:COLOR_STRING(@"#d7d7d7")];
    }
    self.isEnableLogin = isEnabel;
}
- (void)changeSendCodeBtnUIWithEnable:(BOOL)isEnabel{
    [_codeInputView changeSendCodeBtnUIWithEnabel:isEnabel];
}
#pragma mark - BtnClick Action
/**手机绑定*/
- (void)bindBtnClick{
    if (!self.isEnableLogin) return;
    if (self.phoneStr.length && self.codeStr.length) {
        [self closeKeyboard];
        
        if (![BKUtils checkPhoneNumberIsValidity:_phoneStr withAreaPhone:[_phoneInputView GetThePhoneAreaNUmber]]) {
            [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"绑定失败,请检查手机号" and:self.view];

        }else{
            if(_codeStr.length){
                [MBProgressHUD showMessage:@""];
                NSString *unionIdStr = self.unionId.length?self.unionId:@"";
                [BKNewLoginRequestManage requestLoginWithPhone:self.phoneStr WithCode:self.codeStr WithUnionId:unionIdStr AndFinish:^(id  _Nonnull responsed, NSError * _Nonnull error) {
                    [MBProgressHUD hideHUD];
                    //11006 验证码已失效
                    if(error == nil){
                        if([[responsed objectForKey:@"code"] integerValue]==1){
                            //绑定成功
                            [self LoginSuccessWithDictionary:[responsed objectForKey:@"data"]];
                            [[BaiduMobStat defaultStat] logEvent:@"e_login100" eventLabel:@"手机账号登录"];

                        }else if ([[responsed objectForKey:@"code"] integerValue]==11008){
                            //11008 手机号已绑定其它微信
                            //手机号已绑定提示
                            [self phoneInUseTip];
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

- (void)backBtnClick{
    [self closeKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)changeThePhoneAreaNumber:(NSString*)str{
    self.areaNumberStr = str;
    [self.phoneInputView changeThePhoneArea:self.areaNumberStr];
    [self changeSendCodeBtnUIWithEnable:[self checkTheNumberlong:_phoneStr]];
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
                }else{
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
#pragma mark - tip
/**手机号已绑定提示*/
-(void)phoneInUseTip{
    kWeakSelf(wekself);
    BKPhoneNumInUseTipCtr *ctr = [[BKPhoneNumInUseTipCtr alloc]init];
    ctr.view.frame = CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT);
    ctr.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [ctr setTryLoginAgainClick:^{
        if (wekself.iftryLoginAgainClick) {
            wekself.iftryLoginAgainClick(wekself.phoneStr,wekself.areaNumberStr);
        }
        [wekself backBtnClick];
    }];
    [self presentViewController:ctr animated:NO completion:^{
        [UIView animateWithDuration:0.25 animations:^{
            ctr.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        }];
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
