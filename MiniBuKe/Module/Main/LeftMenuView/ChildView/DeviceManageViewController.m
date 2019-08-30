////
////  DeviceManageViewController.m
////  MiniBuKe
////
////  Created by chenheng on 2018/5/4.
////  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
////
//
//#import "DeviceManageViewController.h"
//#import "UnlashRobotSerivce.h"
//#import "MBProgressHUD+XBK.h"
//#import "PrepareConfigNetViewController.h"
//#import "BindMaskViewController.h"
//#import "WifiImportViewController.h"
//#import "FetchUserSNService.h"
//#import "MBProgressHUD+XBK.h"
//#import "TencentIMManager.h"
//#define bottomView_height 0
//
//@interface DeviceManageViewController ()
//
//@property(nonatomic,strong) UIView *topView;
//@property(nonatomic,strong) UIView *middleView;
//@property(nonatomic,strong) UIView *bottomView;
//@property(nonatomic,strong) UILabel *snLabel;
//@property(nonatomic,strong) UILabel *vsLabel;
//
//@property(nonatomic,strong) UIButton *bindButton;
//
//@property(nonatomic) BOOL isUnbind;
//@property(nonatomic,strong) NSString *systemVersion;
//
//@end
//
//@implementation DeviceManageViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    [self initView];
//
////    [MobClick event:EVENT_DEVICE_MANAGE_10];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self hideBarStyle];
//
//    [self initFetchUserSNService];
//    //[self updateDataView];
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    //[self showBarStyle];
//}
//
//- (void)showBarStyle {
//    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    self.navigationController.navigationBar.hidden = NO;
//
//    self.view.backgroundColor = [UIColor whiteColor];
//}
//
//- (void)hideBarStyle {
//    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    self.navigationController.navigationBar.hidden = YES;
//
//    self.view.backgroundColor = [UIColor whiteColor];
//}
//
//- (void)initView{
//    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kNavbarH)];
//    [_topView setBackgroundColor:COLOR_STRING(@"#FFFFFF")];
//    [self.view addSubview:_topView];
//
//    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - bottomView_height, self.view.frame.size.width, bottomView_height)];
//    [_bottomView setBackgroundColor:COLOR_STRING(@"#E9E9E9")];
//    [self.view addSubview:_bottomView];
//
//    _middleView = [[UIView alloc] initWithFrame:CGRectMake(0, _topView.frame.origin.y + _topView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _topView.frame.size.height - _bottomView.frame.size.height)];
//    [_middleView setBackgroundColor:COLOR_STRING(@"#E9E9E9")];
//    //    [_middleView setBackgroundColor:[UIColor redColor]];
//    [self.view addSubview:_middleView];
//
//    [self createTopViewChild];
//    [self createMiddleViewChild];
//
//}
//
//-(void) createBottomViewChild
//{
//    self.bindButton = [[UIButton alloc] initWithFrame:CGRectMake(20,10,self.view.frame.size.width - 40,bottomView_height - 20)];
//    [self.bindButton setBackgroundColor:COLOR_STRING(@"#FF5001")];
//    [self.bindButton setTitleColor:COLOR_STRING(@"#FFFFFF") forState:UIControlStateNormal];
//    [self.bindButton.titleLabel setFont:MY_FONT(17)];
//
//    [self.bindButton.layer setBorderColor:COLOR_STRING(@"#FF5001").CGColor];
//    [self.bindButton.layer setBorderWidth:1.0f];
//    [self.bindButton.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
//    //边框宽度
//    [self.bindButton.layer setBorderWidth:1.0];
//    [self.bindButton.layer setMasksToBounds:YES];
//
//    [self.bindButton addTarget:self action:@selector(bindButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_bottomView addSubview:self.bindButton];
//}
//
//- (void) logout {
//    // 初始化对话框
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认解绑吗？" preferredStyle:UIAlertControllerStyleAlert];
//    // 确定注销
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
//        NSLog(@"点击提示");
//        [self onFetchUserSNService];
//    }];
//    UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//
//    [alert addAction:okAction];
//    [alert addAction:cancelAction];
//
//    // 弹出对话框
//    [self presentViewController:alert animated:true completion:nil];
//}
//
//-(IBAction)bindButtonClick:(id)sender
//{
//    NSLog(@"解除绑定");
//    if (self.isUnbind) {
//        [self logout];
//        //[self onUnlashRobotSerivce];
//    } else {
//        [BindMaskViewController pushViewController];
//
////        PrepareConfigNetViewController *mPrepareConfigNetViewController = [[PrepareConfigNetViewController alloc] init];
////        [APP_DELEGATE.navigationController pushViewController:mPrepareConfigNetViewController animated:YES];
//    }
//}
//
//-(void)updateDataView
//{
//    NSLog(@"bind sn1 ==> %@",APP_DELEGATE.mLoginResult.SN);
//    if (APP_DELEGATE.mLoginResult.SN != nil && APP_DELEGATE.mLoginResult.SN.length > 0 && ![@"" isEqualToString:APP_DELEGATE.mLoginResult.SN]) {
//        NSLog(@"bind sn2 ==> %@",APP_DELEGATE.mLoginResult.SN);
//        self.snLabel.text = [NSString stringWithFormat:@"  %@",APP_DELEGATE.mLoginResult.SN];
////        self.vsLabel.text = self.systemVersion;
//        self.isUnbind = YES;
//
//        self.vsLabel.text = self.systemVersion;
//    } else {
//        NSLog(@"bind sn3 ==> %@",APP_DELEGATE.mLoginResult.SN);
//        self.snLabel.text = @"";
////        self.vsLabel.text = @"";
//        self.isUnbind = NO;
//        self.vsLabel.text = @"";
//    }
//
//    if (self.isUnbind) {
//        [self.bindButton setTitle:@"解除绑定" forState:UIControlStateNormal];
//    } else {
//        [self.bindButton setTitle:@"绑定" forState:UIControlStateNormal];
//    }
//}
//
//-(void) onUnBindSuccess
//{
//    self.isUnbind = NO;
//
//    LoginResult *mLoginResult = APP_DELEGATE.mLoginResult;
//    mLoginResult.SN = @"";
//
//    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
//
//    [mutableDictionary setValue:mLoginResult.imageUlr forKey:@"imageUlr" ];
//    [mutableDictionary setValue:mLoginResult.nickName forKey:@"nickName" ];
//    [mutableDictionary setValue:mLoginResult.SN forKey:@"sn" ];
//    [mutableDictionary setValue:mLoginResult.userName forKey:@"userName" ];
//    [mutableDictionary setValue:mLoginResult.userId forKey:@"userId" ];
//    [mutableDictionary setValue:mLoginResult.token forKey:@"token" ];
//    [mutableDictionary setValue:mLoginResult.appellativeName forKey:@"appellativeName" ];
//
//    [[NSUserDefaults standardUserDefaults] setObject:mutableDictionary forKey:@"LoginResult"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//
//    [APP_DELEGATE setMLoginResult:mLoginResult];
//
//    [self updateDataView];
//
//    [APP_DELEGATE setIsUnbind:YES];
//}
//
//-(void)initFetchUserSNService
//{
////    [MBProgressHUD showMessage:@"加载中..."];
//    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
//        NSLog(@"FetchUserSNService ==> OnSuccess");
//        [MBProgressHUD hideHUD];
//        FetchUserSNService *service = (FetchUserSNService*)httpInterface;
//        NSString *mSN = @"";
//        if (service.mSNString != nil && service.mSNString.length > 0) {
//            NSLog(@" SN ===> %@",service.mSNString);
//            mSN = service.mSNString;
//
//        }
//
//        if (service.mRobotVersion.length > 0){
//            NSLog(@"systemVersion ===>%@",service.mRobotVersion);
//            self.systemVersion = service.mRobotVersion;
//            self.vsLabel.text = service.mRobotVersion;
//        }else {
//            NSLog(@" SN ===> %@",service.mSNString);
//            mSN = service.mSNString;
//            self.systemVersion = @"";
//            self.vsLabel.text = @"";
//        }
//
//        APP_DELEGATE.mLoginResult.SN = service.mSNString;
//        //更改本地保存的SN
//        NSDictionary *infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginResult"];
//        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:infoDic];
//        [mutableDic setObject:service.mSNString forKey:@"sn"];
//
//        [[NSUserDefaults standardUserDefaults] setObject:mutableDic forKey:@"LoginResult"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//
//        [self updateDataView];
//    };
//
//    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
//    {
//        NSLog(@"FetchUserSNService ==> OnError");
//        [MBProgressHUD hideHUD];
//    };
//
//    FetchUserSNService *service = [[FetchUserSNService alloc] init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token];
//    [service start];
//}
//
//-(void)onFetchUserSNService
//{
////    [MBProgressHUD showMessage:@"加载中..."];
//    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
//        NSLog(@"FetchUserSNService ==> OnSuccess");
//        [MBProgressHUD hideHUD];
//        FetchUserSNService *service = (FetchUserSNService*)httpInterface;
//        NSString *mSN = @"";
//        if (service.mSNString != nil && service.mSNString.length > 0) {
//            NSLog(@" SN ===> %@",service.mSNString);
//            mSN = service.mSNString;
//            self.systemVersion = service.mRobotVersion;
//            [self onUnlashRobotSerivce];
//        } else {
//            NSLog(@" SN ===> %@",service.mSNString);
//            mSN = service.mSNString;
//            self.systemVersion = @"";
//            [MBProgressHUD showText:@"已解绑"];
//        }
//
//        APP_DELEGATE.mLoginResult.SN = service.mSNString;
//        //更改本地保存的SN
//        NSDictionary *infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginResult"];
//        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:infoDic];
//        [mutableDic setObject:service.mSNString forKey:@"sn"];
//
//        [[NSUserDefaults standardUserDefaults] setObject:mutableDic forKey:@"LoginResult"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//
//        [self updateDataView];
//    };
//
//    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
//    {
//        NSLog(@"FetchUserSNService ==> OnError");
//        [MBProgressHUD hideHUD];
//    };
//
//    FetchUserSNService *service = [[FetchUserSNService alloc] init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token];
//    [service start];
//}
//
//-(void)onUnlashRobotSerivce
//{
//    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
//        NSLog(@"onUnlashRobotSerivce ==> OnSuccess");
////         [[TencentIMManager defautManager] tencentLoginOut];
//        [MBProgressHUD showSuccess:@"解绑成功"];
//        [self onUnBindSuccess];
//    };
//
//    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
//    {
//        NSLog(@"onUnlashRobotSerivce ==> OnError");
//        [MBProgressHUD showSuccess:@"解绑失败"];
//    };
//
//    UnlashRobotSerivce *service = [[UnlashRobotSerivce alloc] init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token];
//    [service start];
//}
//
//-(void)configNetButtonClick
//{
//    NSLog(@"点击给小布壳联网");
////    [WifiImportViewController pushViewController];
//}
//
//-(void) createMiddleViewChild
//{
//    UIImageView *backImg = [[UIImageView alloc] init];
//    backImg.frame = CGRectMake(0, 0, _middleView.frame.size.width, _middleView.frame.size.height);
//    backImg.image = [UIImage imageNamed:@"deviceManager_bg"];
//    backImg.userInteractionEnabled = YES;
//    [_middleView addSubview:backImg];
//
//    UIImageView *netImageBack = [[UIImageView alloc] init];
//    netImageBack.frame = CGRectMake(0, 4, SCREEN_WIDTH, 129);
//    netImageBack.image = [UIImage imageNamed:@"deviceManager_whiteBack"];
//    netImageBack.userInteractionEnabled = YES;
//    [backImg addSubview:netImageBack];
//
//    UIImageView *whiteImageView = [[UIImageView alloc] init];
//    whiteImageView.frame = CGRectMake(12, (netImageBack.frame.size.height - 90)*0.5, netImageBack.frame.size.width - 12*2, 90);
//    whiteImageView.image = [UIImage imageNamed:@"deviceManager_white"];
//    whiteImageView.layer.cornerRadius = 9;
//    whiteImageView.layer.masksToBounds = YES;
//    [netImageBack addSubview:whiteImageView];
//
//    UILabel *netLabel = [[UILabel alloc] init];
//    netLabel.frame = CGRectMake(16, (whiteImageView.frame.size.height - 20)*0.5, 150, 20);
//    netLabel.textColor = COLOR_STRING(@"#484848");
//    netLabel.font = [UIFont boldSystemFontOfSize:17];
//    netLabel.text = @"给小布壳联网";
//    [whiteImageView addSubview:netLabel];
//
//    UIImageView *indicateImgView = [[UIImageView alloc] init];
//    indicateImgView.frame = CGRectMake(whiteImageView.frame.size.width - 8 - 16, (whiteImageView.frame.size.height - 13)*0.5, 8, 13);
//    indicateImgView.image = [UIImage imageNamed:@"deviceManager_right"];
//    [whiteImageView addSubview:indicateImgView];
//
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(configNetButtonClick)];
//    whiteImageView.userInteractionEnabled = YES;
//    [whiteImageView addGestureRecognizer:tap];
//
//    UIView *view2 = [[UIView alloc] initWithFrame: CGRectMake(0, netImageBack.frame.origin.y + netImageBack.frame.size.height, self.view.frame.size.width,125 )];
//
//    view2.backgroundColor = [UIColor clearColor];
//    [_middleView addSubview: view2];
//
//    UILabel *systemLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10,self.view.frame.size.width,35)];
//    systemLabel.textAlignment = NSTextAlignmentLeft;
//    systemLabel.text = @"系统版本";
//    systemLabel.font = MY_FONT(14);
//    systemLabel.textColor = COLOR_STRING(@"#9D9D9D");
//    [view2 addSubview: systemLabel];
//
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, systemLabel.frame.origin.y + systemLabel.frame.size.height, self.view.frame.size.width - 20, 0.5)];
////    [imageView setBackgroundColor:[UIColor grayColor]];
//    imageView.backgroundColor = COLOR_STRING(@"#666666");
//    [view2 addSubview: imageView];
//
//    UILabel *snHitLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,imageView.frame.origin.y + imageView.frame.size.height + 5,self.view.frame.size.width,35)];
//    //[self.snLabel setBackgroundColor:[UIColor redColor]];
//    snHitLabel.textAlignment = NSTextAlignmentLeft;
//    snHitLabel.text = @"小布壳当前SN号:";
//    snHitLabel.font = MY_FONT(16);
//    [snHitLabel setBackgroundColor:[UIColor clearColor]];
//    snHitLabel.textColor = COLOR_STRING(@"#666666");
//    [view2 addSubview: snHitLabel];
//
//    self.snLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,imageView.frame.origin.y + imageView.frame.size.height + 5,self.view.frame.size.width - 20,35)];
//    //[self.snLabel setBackgroundColor:[UIColor redColor]];
//    self.snLabel.textAlignment = NSTextAlignmentRight;
//    //snLabel.text = @"当前绑定小布壳SN号:测试";
//    self.snLabel.font = MY_FONT(16);
//    [self.snLabel setBackgroundColor:[UIColor clearColor]];
//    self.snLabel.textColor = COLOR_STRING(@"#666666");
//    [view2 addSubview: self.snLabel];
//
//    UILabel *vsHitLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,snHitLabel.frame.origin.y + snHitLabel.frame.size.height - 5,self.view.frame.size.width,35)];
//    //[self.snLabel setBackgroundColor:[UIColor redColor]];
//    vsHitLabel.textAlignment = NSTextAlignmentLeft;
//    vsHitLabel.text = @"小布壳当前系统版本:";
//    vsHitLabel.font = MY_FONT(16);
//    [vsHitLabel setBackgroundColor:[UIColor clearColor]];
//    vsHitLabel.textColor = COLOR_STRING(@"#666666");
//    [view2 addSubview: vsHitLabel];
//
//    self.vsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,snHitLabel.frame.origin.y + snHitLabel.frame.size.height - 5,self.view.frame.size.width - 20,35)];
//    //[self.snLabel setBackgroundColor:[UIColor redColor]];
//    self.vsLabel.textAlignment = NSTextAlignmentRight;
//    //snLabel.text = @"当前绑定小布壳SN号:测试";
//    self.vsLabel.font = MY_FONT(16);
//    [self.vsLabel setBackgroundColor:[UIColor clearColor]];
//    self.vsLabel.textColor = COLOR_STRING(@"#666666");
//    [view2 addSubview: self.vsLabel];
//
//
//    self.bindButton = [[UIButton alloc] initWithFrame:CGRectMake(20,_middleView.frame.size.height - 43 - 26,self.view.frame.size.width - 20*2,43)];
//    [self.bindButton setBackgroundColor:COLOR_STRING(@"#FF5001")];
//    [self.bindButton setTitleColor:COLOR_STRING(@"#FFFFFF") forState:UIControlStateNormal];
//    [self.bindButton.titleLabel setFont:MY_FONT(17)];
//
//    [self.bindButton.layer setBorderColor:COLOR_STRING(@"#FF5001").CGColor];
//    [self.bindButton.layer setBorderWidth:1.0f];
//    [self.bindButton.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
//    //边框宽度
//    [self.bindButton.layer setBorderWidth:1.0];
//    [self.bindButton.layer setMasksToBounds:YES];
//
//    [self.bindButton addTarget:self action:@selector(bindButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_middleView addSubview:self.bindButton];
//
//}
//
//
//-(void) createTopViewChild {
//
//    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, kStatusBarH, 40, 40)];
//    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateNormal];
//    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateSelected];
//    [backButton.titleLabel setFont:MY_FONT(18)];
//    [backButton setAdjustsImageWhenHighlighted:NO];
//
//    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_topView addSubview:backButton];
//
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,kStatusBarH,self.view.frame.size.width-80,40)];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.text = @"设备管理";
//    titleLabel.font = MY_FONT(19);
//    titleLabel.textColor = COLOR_STRING(@"#2f2f2f");
//    [_topView addSubview: titleLabel];
//}
//
//-(IBAction)backButtonClick:(id)sender
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//@end
