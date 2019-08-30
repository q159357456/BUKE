//
//  AccountManagerViewController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/5/22.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "AccountManagerViewController.h"
#import "UpdateUserInfoService.h"
#import "MBProgressHUD+XBK.h"
#import "UploadUserAvatarService.h"
#import "UserForgetPwd1Controller.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <Photos/Photos.h>
#import "FetchUserInfoService.h"
#import "FetchUserInfo.h"
#import "BKCenterView_New.h"
@interface AccountManagerViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIView *middleView;
@property(nonatomic,strong) UIImageView *iconImageView;
@property(nonatomic,strong) UITextField *nickTextField;
@property(nonatomic,strong) UILabel *rankLabel;
@property(nonatomic,strong) UIButton *saveButton;
@property(nonatomic,strong) UIView *backgroundView;
@property(nonatomic,strong) UIView *alertView;
@property(nonatomic,strong) UIPickerView *pickerView;
@property(nonatomic,copy) NSArray *dataArray;
@property(nonatomic,copy) NSString *selectedItem;

@property(nonatomic,copy) NSString *filePath;

@end

@implementation AccountManagerViewController

-(NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSArray arrayWithObjects:@"爸爸",@"妈妈",@"爷爷",@"奶奶",@"外公/姥爷",@"外婆/姥姥",@"其它", nil];
    }
    
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self createPickerView];
    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeValue:) name:UITextFieldTextDidChangeNotification object:self.nickTextField];
    
    
    [self requestFetchUserInfoService];
}

-(void) requestFetchUserInfoService
{
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        
        FetchUserInfoService *service = (FetchUserInfoService *)httpInterface;
        if (service != nil && service.mFetchUserInfo != nil) {
//            pickerView selectRow:<#(NSInteger)#> inComponent:0 animated:<#(BOOL)#>
            
            self.rankLabel.text = service.mFetchUserInfo.appellativeName.length?service.mFetchUserInfo.appellativeName:@"其它";
//            self.rankLabel.text = @"爷爷";
        }
    };
    
    void (^OnError) (NSInteger,NSString *) = ^(NSInteger httpInterface,NSString *description){
        
    };
    
    FetchUserInfoService *service = [[FetchUserInfoService alloc]init:OnSuccess setOnError:OnError setUserToken:APP_DELEGATE.mLoginResult.token];
    [service start];
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
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = NO;
    
    //    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)hideBarStyle {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = YES;
    
    //    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)initView{
    
    self.view.backgroundColor = COLOR_STRING(@"#F4F4F4");
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 73)];
    [_topView setBackgroundColor:COLOR_STRING(@"#FFFFFF")];
    [self.view addSubview:_topView];
    
    _middleView = [[UIView alloc] initWithFrame:CGRectMake(0, _topView.frame.origin.y + _topView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _topView.frame.size.height)];
    _middleView.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:_middleView belowSubview:_topView];
    
    NSLog(@" %f == %f",self.view.frame.size.height,self.view.frame.size.width);
    
    [self createTopViewChild];
    [self createMiddleViewChild];

}

-(void) createTopViewChild {
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 40, 40)];
    
    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateSelected];
    [backButton.titleLabel setFont:MY_FONT(18)];
    [backButton setAdjustsImageWhenHighlighted:NO];
    
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,25,self.view.frame.size.width,48)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"个人信息";
    titleLabel.font = MY_FONT(19);
    titleLabel.textColor = COLOR_STRING(@"#2f2f2f");
    [_topView addSubview: titleLabel];
}

-(void)createMiddleViewChild
{
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, _middleView.frame.size.width, 194);
    bgView.backgroundColor = [UIColor whiteColor];
    [_middleView addSubview:bgView];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.frame = CGRectMake((bgView.frame.size.width - 124)*0.5, 36, 124, 124);
    iconImageView.userInteractionEnabled = YES;
    iconImageView.layer.cornerRadius = 62;
    iconImageView.layer.borderWidth = 0.5;
    iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    iconImageView.layer.masksToBounds = YES;
    self.iconImageView = iconImageView;
    [bgView addSubview:iconImageView];
    if (APP_DELEGATE.mLoginResult.imageUlr != nil && APP_DELEGATE.mLoginResult.imageUlr.length != 0) {
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:[APP_DELEGATE.mLoginResult.imageUlr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"userInfo_iconHold"]];
    }else{
        iconImageView.image = [UIImage imageNamed:@"userInfo_iconHold"];
    }
    
    UIImageView *photoImageView = [[UIImageView alloc] init];
    photoImageView.frame = CGRectMake((bgView.frame.size.width - 35)*0.5 + 25, 132, 35, 35);
    photoImageView.image = [UIImage imageNamed:@"userInfo_photo"];
    photoImageView.userInteractionEnabled = YES;
    [bgView addSubview:photoImageView];
    
    UIButton *selectPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectPhotoBtn.frame = CGRectMake((bgView.frame.size.width - 150)*0.5, 27, 150, 150);
    [selectPhotoBtn setBackgroundColor:[UIColor clearColor]];
    [selectPhotoBtn addTarget:self action:@selector(selectPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:selectPhotoBtn];
    
    UIView *line1 = [[UIView alloc] init];
    line1.frame = CGRectMake(16, bgView.frame.size.height - 1, bgView.frame.size.width - 16*2, 1);
    line1.backgroundColor = COLOR_STRING(@"#F4F4F4");
    [bgView addSubview:line1];
    
    UIView *nickView = [[UIView alloc] initWithFrame:CGRectMake(0, bgView.frame.origin.y + bgView.frame.size.height, _middleView.frame.size.width, 60)];
    nickView.backgroundColor = [UIColor whiteColor];
    [_middleView addSubview:nickView];
    
    UILabel *nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, (nickView.frame.size.height - 20)*0.5, 120, 20)];
    nickLabel.textColor = COLOR_STRING(@"#9D9D9D");
    nickLabel.font = MY_FONT(14);
    nickLabel.text = @"您的昵称";
    [nickView addSubview:nickLabel];
    
    UITextField *nickTextField = [[UITextField alloc] initWithFrame:CGRectMake(nickLabel.frame.origin.x + nickLabel.frame.size.width + 20, (nickView.frame.size.height - 40)*0.5, nickView.frame.size.width - nickLabel.frame.origin.x - nickLabel.frame.size.width - 20 - 19, 40)];
    nickTextField.textAlignment = NSTextAlignmentRight;
    nickTextField.textColor = COLOR_STRING(@"#666666");
    nickTextField.font = MY_FONT(14);
    nickTextField.text = APP_DELEGATE.mLoginResult.nickName.length >0 ?APP_DELEGATE.mLoginResult.nickName : @"取个名字";
    self.nickTextField = nickTextField;
    [nickView addSubview:nickTextField];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(16, nickView.frame.size.height - 1, nickView.frame.size.width - 16*2, 1)];
    line2.backgroundColor = COLOR_STRING(@"#F4F4F4");
    [nickView addSubview:line2];
    
    UIView *roleView = [[UIView alloc] init];
    roleView.frame = CGRectMake(0, nickView.frame.origin.y + nickView.frame.size.height, _middleView.frame.size.width, 60);
    roleView.backgroundColor = [UIColor whiteColor];
    [_middleView addSubview:roleView];
    
    UILabel *roleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, (roleView.frame.size.height - 20)*0.5, 120, 20)];
    roleLabel.textColor = nickLabel.textColor;
    roleLabel.font = nickLabel.font;
    roleLabel.text = @"您的身份";
    [roleView addSubview:roleLabel];
    
    UILabel *rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(roleView.frame.size.width - 19 - 120, (roleView.frame.size.height - 20)*0.5, 120, 20)];
    rankLabel.textColor = COLOR_STRING(@"#666666");
    rankLabel.textAlignment = NSTextAlignmentRight;
    rankLabel.font = MY_FONT(14);
    rankLabel.text = APP_DELEGATE.mLoginResult.appellativeName ? : @"";
    self.rankLabel = rankLabel;
    [roleView addSubview:rankLabel];
    
    NSLog(@"个人信息管理===>%@",APP_DELEGATE.mLoginResult.appellativeName);
    UIButton *rankButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rankButton.frame = CGRectMake(roleView.frame.size.width - 220, 0, 220, roleView.frame.size.height);
    [rankButton addTarget:self action:@selector(choseRole:) forControlEvents:UIControlEventTouchUpInside];
    [roleView addSubview:rankButton];
    
    UIView *codeView = [[UIView alloc] init];
    codeView.frame = CGRectMake(0, roleView.frame.origin.y + roleView.frame.size.height + 6, _middleView.frame.size.width, 60);
    codeView.backgroundColor = [UIColor whiteColor];
    [_middleView addSubview:codeView];
    
    UILabel *codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, (codeView.frame.size.height - 20)*0.5, 120, 20)];
    codeLabel.textColor = COLOR_STRING(@"#666666");
    codeLabel.text = @"重置密码";
    codeLabel.font = MY_FONT(14);
    [codeView addSubview:codeLabel];
    
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    finishButton.frame = CGRectMake((_middleView.frame.size.width - 200)*0.5,codeView.frame.origin.y + codeView.frame.size.height + 23, 200, 46);
//    [finishButton setBackgroundColor:COLOR_STRING(@"#FF721C")];
    [finishButton setBackgroundColor:COLOR_STRING(@"#D7D7D7")];
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [finishButton setTitle:@"完成" forState:UIControlStateSelected];
    finishButton.layer.cornerRadius = 23.0f;
    finishButton.layer.masksToBounds = YES;
    finishButton.userInteractionEnabled = NO;
//    finishButton.hidden = YES;
    [finishButton addTarget:self action:@selector(clickFinish:) forControlEvents:UIControlEventTouchUpInside];
    self.saveButton = finishButton;
    [_middleView addSubview:finishButton];
    
    NSInteger loginType = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginType"] integerValue];
    if (loginType == 2 || self.NeedFixCode) {
        codeView.hidden = YES;
        codeLabel.hidden = YES;
//        finishButton.frame = CGRectMake((_middleView.frame.size.width - 200)*0.5,codeView.frame.origin.y + codeView.frame.size.height - 50, 200, 46);
        finishButton.frame = CGRectMake((_middleView.frame.size.width - 200)*0.5,self.view.frame.size.height - 80 -64, 200, 46);
    }
    
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeCode:)];
    [codeView addGestureRecognizer:tap];
    
}

-(void)createPickerView
{
    //遮罩层
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    backgroundView.userInteractionEnabled = YES;
    backgroundView.hidden = YES;
    self.backgroundView = backgroundView;
    [self.view addSubview:backgroundView];
    
    UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 240, self.view.frame.size.width, 240)];
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.hidden = YES;
    self.alertView = alertView;
    [self.view addSubview:alertView];
    
    UILabel *cancelLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 60, 20)];
    cancelLabel.text = @"取消";
    cancelLabel.textColor = COLOR_STRING(@"#FF721C");
    cancelLabel.font = MY_FONT(16);
    [alertView addSubview:cancelLabel];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 100, 40);
    [cancelBtn addTarget:self action:@selector(selectRoleCancel:) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:cancelBtn];
    
    UILabel *sureLabel = [[UILabel alloc] initWithFrame:CGRectMake(alertView.frame.size.width - 15 - 60, 20, 60, 20)];
    sureLabel.text = @"确定";
    sureLabel.textAlignment = NSTextAlignmentRight;
    sureLabel.textColor = cancelLabel.textColor;
    sureLabel.font = cancelLabel.font;
    [alertView addSubview:sureLabel];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(alertView.frame.size.width - 100, 0, 100, 40);
    [sureButton addTarget:self action:@selector(selectRole:) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:sureButton];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, alertView.frame.size.width, 200)];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    self.pickerView = pickerView;
    [alertView addSubview:pickerView];
    
    __weak typeof(self) weakSelf = self;
    [self.dataArray enumerateObjectsUsingBlock:^(NSString *rowItem, NSUInteger rowIdx, BOOL *stop) {
        if ([weakSelf.selectedItem isEqualToString:rowItem]) {
            [weakSelf.pickerView selectRow:rowIdx inComponent:0 animated:NO];
            *stop = YES;
        }
    }];
    
    UITapGestureRecognizer *maskTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alertHidden:)];
    [backgroundView addGestureRecognizer:maskTap];
}

//选择照片
-(void)selectPhoto:(UIButton *)sender
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    
    
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf checkVideoStatusWith:imagePickerController];
        
    }];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf checkPhotoStautsWith:imagePickerController];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [alertVC addAction:cameraAction];
    }
    
    [alertVC addAction:photoAction];
    [alertVC addAction:cancelAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

-(void)checkVideoStatusWith:(UIImagePickerController *)imagePickerController
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
        //没有授权
        [self alertCamera];
    }else{
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

-(void)checkPhotoStautsWith:(UIImagePickerController *)imagePickerController
{
    PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
    if (photoAuthorStatus == PHAuthorizationStatusRestricted || photoAuthorStatus == PHAuthorizationStatusDenied) {
        //没有授权
        [self alertPhoto];
    }else{
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

-(void) alertCamera
{
    UIAlertController *tipAlert = [UIAlertController alertControllerWithTitle:@"无法启动相机" message:@"请为小布壳开启相机权限: 请进入手机【设置】>【隐私】>【相机】>小布壳(打开)" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [tipAlert addAction:cancelAction];
    [self presentViewController:tipAlert animated:YES completion:nil];
}

-(void)alertPhoto
{
    UIAlertController *tipAlert = [UIAlertController alertControllerWithTitle:nil message:@"请在iPhone的""设置-隐私-照片""选项中,允许访问你的手机相册" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [tipAlert addAction:cancelAction];
    [self presentViewController:tipAlert animated:YES completion:nil];
}

-(void)alertHidden:(id) sender
{
    self.backgroundView.hidden = YES;
    self.alertView.hidden = YES;
}

-(void)selectRoleCancel:(UIButton *)sender
{
    self.backgroundView.hidden = YES;
    self.alertView.hidden = YES;
}

-(void)selectRole:(UIButton *)sender
{
    if (self.selectedItem == nil || self.selectedItem.length == 0) {
        self.selectedItem = [self.dataArray firstObject];
    }
    self.rankLabel.text = self.selectedItem;
    
    self.backgroundView.hidden = YES;
    self.alertView.hidden = YES;
}

//选择身份
-(void)choseRole:(UIButton *)sender
{
    [self.nickTextField resignFirstResponder];
    
    int index = [self getIdenlityIndexFromDataArray:self.dataArray];
    [self.pickerView selectRow:index inComponent:0 animated:NO];
    
    self.backgroundView.hidden = NO;
    self.alertView.hidden = NO;
    
    if (self.iconImageView.image && self.nickTextField.text.length > 0) {
        self.saveButton.userInteractionEnabled = YES;
        [self.saveButton setBackgroundColor:COLOR_STRING(@"#FF721C")];
    }
}

-(int) getIdenlityIndexFromDataArray:(NSArray *) dataArray
{
    int result = 0;
    for (int i = 0 ; i < dataArray.count; i ++) {
        NSString *str = (NSString *)[dataArray objectAtIndex:i];
        if ([str isEqualToString:self.rankLabel.text]) {
            result = i;
            break;
        }
    }
    return result;
}

//重置密码
-(void)changeCode:(id) sender
{
    UserForgetPwd1Controller *forgetVC = [[UserForgetPwd1Controller alloc] init];
    [APP_DELEGATE.navigationController pushViewController:forgetVC animated:YES];
}

//完成
-(void)clickFinish:(UIButton *)sender
{
    if (self.iconImageView.image == nil || self.iconImageView.image == [UIImage imageNamed:@"children"]) {
        [MBProgressHUD showText:@"请设置头像"];
        
        return;
    }
    
    if (self.nickTextField.text == nil || self.nickTextField.text.length == 0) {
        [MBProgressHUD showText:@"昵称不能为空"];
        
        return;
    }
    
    if (self.rankLabel.text == nil || self.rankLabel.text.length == 0) {
        [MBProgressHUD showText:@"请设置身份"];
        
        return;
    }
    
    if (self.nickTextField.text.length > 0 && self.rankLabel.text.length > 0) {
        [self updateUserInfo];
    }
}

#pragma mark - 网络相关
-(void)updateUserInfo
{
    __weak typeof(self) weakSelf = self;
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"UpdateUserInfoService ===>OnSuccess");
        
        NSString *nickname = weakSelf.nickTextField.text;
        NSString *appellativeName = weakSelf.rankLabel.text;
        //保存本地default
        APP_DELEGATE.mLoginResult.nickName = nickname;
        APP_DELEGATE.mLoginResult.appellativeName = appellativeName;
        
        NSDictionary *infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginResult"];
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:infoDic];
        [mutableDic setObject:nickname forKey:@"nickName"];
        [mutableDic setObject:appellativeName forKey:@"appellativeName"];
        
        [[NSUserDefaults standardUserDefaults] setObject:mutableDic forKey:@"LoginResult"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"更新用户信息--->%@",mutableDic);

        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    void (^OnError) (NSInteger,NSString *) = ^(NSInteger httpInterface,NSString *description){
        NSLog(@"UpdateUserInfoService ===>OnError");
        [MBProgressHUD showError:description];
    };
    
    NSString *nickName = self.nickTextField.text;
    NSString *rankName = self.rankLabel.text;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:nickName forKey:@"nickName"];
    [params setObject:rankName forKey:@"appellativeName"];
//    [params setObject:@"" forKey:@"newPwd"];
//    [params setObject:@"" forKey:@"oldPwd"];
    
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:params];
    
    UpdateUserInfoService *infoService = [[UpdateUserInfoService alloc] initWithOnSuccess:OnSuccess setOnError:OnError setToken:APP_DELEGATE.mLoginResult.token setDictionary:dic];
    [infoService start];
    
}

-(void)uploadUserAvatarWithPath:(NSString *)path
{
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface, NSString *description){
        NSLog(@"UploadUserAvatarService===>OnSuccess");
        
        UploadUserAvatarService *service = (UploadUserAvatarService *)httpInterface;
        NSString *iconUrl = service.ossImgUrl;
        //保存本地default
        APP_DELEGATE.mLoginResult.imageUlr = iconUrl;
        
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginResult"];
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mutableDic setValue:iconUrl forKey:@"imageUlr"];
        
        [[NSUserDefaults standardUserDefaults] setObject:mutableDic forKey:@"LoginResult"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"保存头像后的用户信息: --- >%@",mutableDic);
        
        //删除沙盒内的图片
//        [self deletePath:path];
    };
    
    void (^OnError) (NSInteger,NSString *) = ^(NSInteger httpInterface,NSString *description){
        NSLog(@"UploadUserAvatarService===>OnError");
        NSLog(@"UploadUserAvatarService--->%@",description);
    };
    
    UploadUserAvatarService *avatarService = [[UploadUserAvatarService alloc] initWithImagePath:path setOnSuccess:OnSuccess setOnError:OnError setToken:APP_DELEGATE.mLoginResult.token];
    [avatarService start];
}


#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    /* 此处参数 info 是一个字典，下面是字典中的键值 （从相机获取的图片和相册获取的图片时，两者的info值不尽相同）
     * UIImagePickerControllerMediaType; // 媒体类型
     * UIImagePickerControllerOriginalImage; // 原始图片
     * UIImagePickerControllerEditedImage; // 裁剪后图片
     * UIImagePickerControllerCropRect; // 图片裁剪区域（CGRect）
     * UIImagePickerControllerMediaURL; // 媒体的URL
     * UIImagePickerControllerReferenceURL // 原件的URL
     * UIImagePickerControllerMediaMetadata // 当数据来源是相机时，此值才有效
     */
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    
    //压缩图片 大小<1M
    UIImage *targetImage = [self imageByScalingAndCroppingForSize:CGSizeMake(124*3, 124*3) withSourceImage:image];
    //保存到沙盒
    [self saveImage:targetImage];
    
    self.iconImageView.image = targetImage;
    
    if (self.filePath != nil || self.filePath.length > 0) {
        [self uploadUserAvatarWithPath:self.filePath];
    }
    
    if (self.nickTextField.text.length > 0 && self.rankLabel.text.length > 0) {
        self.saveButton.userInteractionEnabled = YES;
        [self.saveButton setBackgroundColor:COLOR_STRING(@"#FF721C")];
    }
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataArray.count;
}

#pragma mark - UIPickerViewDelegate
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.dataArray[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedItem = self.dataArray[row];
}

#pragma mark - 监听键盘
-(void)keyboardWasShow:(NSNotification *)notification
{
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = [UIScreen mainScreen].bounds.size.height - _topView.frame.size.height - frame.size.height;
    if (height < 255) {
        _middleView.frame = CGRectMake(0, _topView.frame.origin.y + _topView.frame.size.height - 30, self.view.frame.size.width, self.view.frame.size.height - _topView.frame.origin.y -_topView.frame.size.height + 30);
        [_middleView layoutIfNeeded];
    }
}

-(void)keyboardWillHidden:(NSNotification *)notification
{
    _middleView.frame = CGRectMake(0, _topView.frame.origin.y + _topView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _topView.frame.origin.y - _topView.frame.size.height);
    [_middleView layoutIfNeeded];
}

-(void)textFieldDidChangeValue:(NSNotification *)notification
{
    UITextField *sender = (UITextField *)[notification object];
    if (sender.text.length != 0) {
        
        if (self.iconImageView.image && self.rankLabel.text.length > 0) {
            self.saveButton.userInteractionEnabled = YES;
            [self.saveButton setBackgroundColor:COLOR_STRING(@"#FF721C")];
        }
    }else{

        self.saveButton.userInteractionEnabled = NO;
        [self.saveButton setBackgroundColor:COLOR_STRING(@"#D7D7D7")];
    }
}

//压缩图片
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withSourceImage:(UIImage *)sourceImage
{
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO){
        CGFloat widthFactor = targetWidth/ width;
        CGFloat heightFactor = targetHeight/height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor;
        }else{
            scaleFactor = heightFactor;
        }

        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if (widthFactor > heightFactor) {
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else{
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }

    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"image error");
    }
    
    UIGraphicsEndImageContext();

    return newImage;
}



//保存图片到沙盒
- (void)saveImage:(UIImage *)image
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *avatar = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/avatar"]];
    if (![self isFileExit:avatar]) {
        [self createPath:avatar];
    }
    NSLog(@"avatar--->path:%@",avatar);
    NSString *timeStr = [self getCurrentTime:@"YYYYMMddHHmmss"];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.jpg",avatar,timeStr];
    // 保存成功会返回YES
    BOOL result = [UIImagePNGRepresentation(image)writeToFile:filePath atomically:YES];
    if (result == YES) {
        NSLog(@"头像保存成功");
        self.filePath = filePath;
    }
}

-(void)deletePath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isHave = [self isFileExit:path];
    if (!isHave) {
        return;
    }else {
        BOOL dele = [fileManager removeItemAtPath:path error:nil];
        if (dele) {
            NSLog(@"删除照片成功");
        }else{
            NSLog(@"删除照片失败");
        }
    }
}

-(NSString *)getCurrentTime:(NSString*)formatter
{
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:formatter];
    NSString *locationString = [dateformatter stringFromDate:senddate];
    return locationString;
}

//检测文件是否存在
-(BOOL)isFileExit:(NSString*)path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

-(void)createPath:(NSString*)path
{
    if (![self isFileExit:path]) {
        NSFileManager * fileManager = [NSFileManager defaultManager];
        NSString * parentPath = [path stringByDeletingLastPathComponent];
        if ([self isFileExit:parentPath]) {
            NSError * error;
            [fileManager createDirectoryAtPath:path withIntermediateDirectories:path attributes:nil error:&error];
        }else{
            [self createPath:parentPath];
            [self createPath:path];
        }
        
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.nickTextField resignFirstResponder];
}

-(void)backButtonClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.nickTextField];
}

@end
