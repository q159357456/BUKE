//
//  BKCenterSettingCtr.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/28.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKCenterSettingCtr.h"
#import "BKNewLoginController.h"
#import "BKSettingBindWeChartCell.h"
#import "BKCancelBindWechartTipCtr.h"
#import "BKLoginCodeTip.h"
#import "BKNewLoginRequestManage.h"
#import "WeChatManager.h"
#import "BKCommonShowTipCtr.h"
#import "BKWeChartBindUseTipCtr.h"
#import "CommonUsePackaging.h"
#import "ARRecognitionView.h"
#import "XYDMSetting.h"
@interface BKCenterSettingCtr ()<UITableViewDelegate,UITableViewDataSource,WeChatManagerDelegate>
@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) UITableView *mytableView;

@property(nonatomic, assign) BOOL isbindWechart;
@property(nonatomic, copy) NSString *wechartName;

@end

@implementation BKCenterSettingCtr
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = COLOR_STRING(@"#F7F9FB");
    [self initTopBar];
    [self initBottomBtn];
    [self initTableView];
    [self registerCustomTableViewCell];
    
    [self changeWechartState];
    [self.mytableView reloadData];
}

- (void)changeWechartState{
    if (APP_DELEGATE.mLoginResult.bindWx) {
        self.wechartName = APP_DELEGATE.mLoginResult.wxNickName;
        self.isbindWechart = YES;
    }else{
        self.wechartName = @"去绑定";
        self.isbindWechart = NO;
    }
}

- (void)registerCustomTableViewCell{
    [self.mytableView registerClass:[BKSettingBindWeChartCell class] forCellReuseIdentifier:NSStringFromClass([BKSettingBindWeChartCell class])];
}

- (void)initTopBar{
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,kNavbarH)];
    [_topView setBackgroundColor:COLOR_STRING(@"#FFFFFF")];
    [self.view addSubview:_topView];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,kStatusBarH,self.view.frame.size.width,44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"设置";
    titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    titleLabel.textColor = COLOR_STRING(@"#2F2F2F");
    [_topView addSubview: titleLabel];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, kStatusBarH, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateSelected];
    [backButton.titleLabel setFont:MY_FONT(18)];
    [backButton setAdjustsImageWhenHighlighted:NO];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:backButton];
}

- (void)initBottomBtn{
    UIButton *logoutBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    logoutBtn.backgroundColor = COLOR_STRING(@"#FFFFFF");
    logoutBtn.layer.cornerRadius = 22.f;
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:COLOR_STRING(@"#F04348") forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(logoutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    logoutBtn.center = CGPointMake(self.view.center.x, self.view.center.y+SCREEN_HEIGHT*0.5-70.f);
    [self.view addSubview:logoutBtn];
}

- (void)initTableView{
    self.mytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), self.view.frame.size.width,SCREEN_HEIGHT-self.topView.frame.size.height-102) style:UITableViewStyleGrouped];
    _mytableView.delegate = self;
    _mytableView.dataSource = self;
    _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        _mytableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        
    }
    _mytableView.estimatedRowHeight = 0;
    _mytableView.estimatedSectionFooterHeight = 0;
    _mytableView.estimatedSectionHeaderHeight = 0;
    _mytableView.backgroundColor = COLOR_STRING(@"#F7F9FB");
    _mytableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_mytableView];
}

- (void)backButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)logoutBtnClick{
    // 初始化对话框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认退出登录吗？" preferredStyle:UIAlertControllerStyleAlert];
    // 确定注销
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LoginResult"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"WechatUserInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if ([XYDMSetting IsPlaying]) {
            [XYDMSetting pause];
        }
        [APP_DELEGATE removeLoginResult];
        BKNewLoginController *LoginController = [[BKNewLoginController alloc]init];
        APP_DELEGATE.navigationController = [[BKNavgationController alloc] initWithRootViewController:LoginController];
        APP_DELEGATE.window.rootViewController = APP_DELEGATE.navigationController;
        [[ARRecognitionView singleton] stopARAndAnimation];
        
//        [MobClick event:EVENT_OUT_LOGIN_2];
        [[BaiduMobStat defaultStat] logEvent:@"e_login101" eventLabel:@"退出登录"];
    }];
    UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    // 弹出对话框
    [self presentViewController:alert animated:true completion:nil];
}

#pragma mark- tableViewdelegate&dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BKSettingBindWeChartCell *cell = [BKSettingBindWeChartCell BKBaseTableViewCellWithTableView:tableView];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setNameTitle:self.wechartName and:self.isbindWechart];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [BKSettingBindWeChartCell heightForCellWithObject:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (self.isbindWechart) {//解绑
        [self cancelBindTip];
        
    }else{//绑定
        if (APP_DELEGATE.isWXInstalled)
        {
            [WeChatManager sendAuthRequest];
            [WeChatManager sharedManager].delegate = self;
        }else
        {
            [CommonUsePackaging showSystemHint:@"您还未安装微信客户端，请先下载安装"];
        }
        
    }}

- (void)bindWechartInUseTipWithNumber:(NSString*)number{
    BKWeChartBindUseTipCtr *ctr = [[BKWeChartBindUseTipCtr alloc]init];
    [ctr setTitleWithNumber:number];
    [ctr startShowTipWithController:self];
}

-(void)cancelBindTip{
//    kWeakSelf(wekself);
//    BKCancelBindWechartTipCtr *ctr = [[BKCancelBindWechartTipCtr alloc]init];
//    ctr.view.frame = CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT);
//    ctr.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    [ctr setGoCancelBindWeChart:^{
//        //取消绑定操作
//        [self requestUnBindWX];
//    }];
//    [self presentViewController:ctr animated:NO completion:^{
//        [UIView animateWithDuration:0.25 animations:^{
//            ctr.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
//        }];
//    }];
    
    BKCommonShowTipCtr *ctr = [[BKCommonShowTipCtr alloc]init];
    [ctr showWithTitle:@"解除绑定" andsubTitle:@"解除后,将无法使用微信登录" andLeftBtntitel:@"解除绑定" andRightBtnTitle:@"取消" andIsTap:NO AndLeftBtnAction:^{
        [self requestUnBindWX];
    } AndRightBtnAction:^{
        
    }];
    [ctr startShowTipWithController:self];
}

#pragma mark - 绑定解绑微信请求
- (void)requestBindWXWWith:(NSString*)code{//绑定
    [MBProgressHUD showMessage:@""];
    [BKNewLoginRequestManage requestBindWeChartWithCode:code AndFinish:^(id  _Nonnull responsed, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        if (error == nil) {
            if ([[responsed objectForKey:@"code"]integerValue] == 1) {

                NSDictionary *dic = [responsed objectForKey:@"data"];
                if (dic != nil) {
                    NSString *wxname = [dic objectForKey:@"wxNickName"];
                    if (wxname.length) {
                        self.isbindWechart = YES;
                        APP_DELEGATE.mLoginResult.bindWx = YES;
                        APP_DELEGATE.mLoginResult.wxNickName = wxname;
                        NSString *wxImageUrl = [dic objectForKey:@"wxImageUrl"];
                        if (wxImageUrl.length) {
                            APP_DELEGATE.mLoginResult.wxImageUrl = wxImageUrl;
                        }
                        [self changeWechartState];
                        [self.mytableView reloadData];
                    }
                    [APP_DELEGATE saveLoginSuccessWithModel];
                    //绑定成功提示
                    [[[BKLoginCodeTip alloc]init] AddBindWeChartOkTip:self.view];
                }
            }else if ([[responsed objectForKey:@"code"]integerValue] == 11014){//微信绑定过其他账号
                NSString *dic = [responsed objectForKey:@"data"];
                [self bindWechartInUseTipWithNumber:dic];
            }
            else{
                NSString *str = [responsed objectForKey:@"msg"];
                if (str.length) {
                    [[[BKLoginCodeTip alloc]init] AddTextShowTip:str and:self.view];
                }else{
                    [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"绑定失败" and:self.view];
                }
            }
        }else{
            [[[BKLoginCodeTip alloc]init] AddLoginNetErrorTip:self.view];
        }
    }];
}
- (void)requestUnBindWX{//解绑
    [MBProgressHUD showMessage:@""];
    [BKNewLoginRequestManage requestunBindWeChartAndFinish:^(id  _Nonnull responsed, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        if (error == nil) {
            if ([[responsed objectForKey:@"code"] integerValue] == 1) {
                [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"解绑成功" and:self.view];
                self.isbindWechart = NO;
                APP_DELEGATE.mLoginResult.bindWx = 0;
                APP_DELEGATE.mLoginResult.wxNickName = @"";
                APP_DELEGATE.mLoginResult.wxImageUrl = @"";
                [self changeWechartState];
                [self.mytableView reloadData];
                [APP_DELEGATE saveLoginSuccessWithModel];

            }else{
                NSString *str = [responsed objectForKey:@"msg"];
                if(str.length){
                    [[[BKLoginCodeTip alloc]init] AddTextShowTip:str and:self.view];
                }else{
                    [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"解绑失败" and:self.view];
                }
            }
        }else{
            [[[BKLoginCodeTip alloc]init] AddLoginNetErrorTip:self.view];
        }
    }];
}
/**拉起微信成功回调code*/
-(void)wechatLoginWithCode:(NSString*)code{
    if (code.length) {
        [self requestBindWXWWith:code];
    }else{
        //授权失败提示
        [[[BKLoginCodeTip alloc]init] AddBindWeChartFailTip:self.view];
    }
}
/**拉起微信失败回调*/
-(void)wechatLoginError{
    //授权失败提示
    [[[BKLoginCodeTip alloc]init] AddBindWeChartFailTip:self.view];
}



@end
