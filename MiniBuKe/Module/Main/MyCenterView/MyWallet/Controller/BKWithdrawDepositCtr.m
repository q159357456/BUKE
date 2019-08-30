//
//  BKWithdrawDepositCtr.m
//  MiniBuKe
//
//  Created by chenheng on 2018/12/3.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKWithdrawDepositCtr.h"
#import "BKDepositTopCell.h"
#import "BKDepositBottomCell.h"
#import "BKTixianWeChartTipCtr.h"
#import "WeChatManager.h"
#import "BKLoginCodeTip.h"
#import "BKNewLoginRequestManage.h"
#import "XBKNetWorkManager.h"
#import "BKTiXianProgressCtr.h"
#import "BKWeChartBindUseTipCtr.h"
#import "CommonUsePackaging.h"

@interface BKWithdrawDepositCtr ()<UITableViewDelegate,UITableViewDataSource,WeChatManagerDelegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *tixianBtn;
@property (nonatomic, assign) BOOL isCanTixian;
@property (nonatomic, strong) UITableView *mytableView;
@property (nonatomic, assign) NSInteger selectMoneyType;//1,2,3 提现金额类型(100,500,1000)
@end

@implementation BKWithdrawDepositCtr

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
- (void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initTopBarView];
    [self addBottomView];
    [self addTableView];
    self.selectMoneyType = 0;
}

- (void)initTopBarView{
    self.topView = [[UIView alloc]init];
    _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH,kNavbarH);
    _topView.backgroundColor = COLOR_STRING(@"#ffffff");
    [self.view addSubview:_topView];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, kStatusBarH, 40, 40)];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"mate_back"]
             forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"mate_back"]
             forState:UIControlStateSelected];
    [_topView addSubview:backBtn];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80,kStatusBarH,SCREEN_WIDTH-160,44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"提现";
    titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    titleLabel.textColor = COLOR_STRING(@"#2f2f2f");
    [_topView addSubview: titleLabel];
}
- (void)addBottomView{
    UIView *bottomview = [[UIView alloc] init];
    bottomview.frame = CGRectMake(0,SCREEN_HEIGHT-60,SCREEN_WIDTH,60);
    bottomview.backgroundColor = COLOR_STRING(@"#F7F9FB");
    [self.view addSubview:bottomview];
    self.tixianBtn = [[UIButton alloc] init];
    self.tixianBtn.frame = CGRectMake(88, 9, SCREEN_WIDTH-2*88, 44);
    [self.tixianBtn setTitle:@"提现" forState:UIControlStateNormal];
    [self.tixianBtn setTitleColor:COLOR_STRING(@"#ffffff") forState:UIControlStateNormal];
    self.tixianBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.tixianBtn.backgroundColor = COLOR_STRING(@"#D7D7D7");
    _tixianBtn.layer.cornerRadius = 22;
    _tixianBtn.clipsToBounds = YES;
    [bottomview addSubview:self.tixianBtn];
    self.isCanTixian = NO;
    [self.tixianBtn addTarget:self action:@selector(tixianAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addTableView{
    
    self.mytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_topView.frame), SCREEN_WIDTH,SCREEN_HEIGHT-CGRectGetMaxY(_topView.frame)-60) style:UITableViewStyleGrouped];
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
    _mytableView.backgroundColor = COLOR_STRING(@"#FFFFFF");
    _mytableView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_mytableView];
    [self registerCustomTableViewCell];
    [self.mytableView reloadData];
}
- (void)registerCustomTableViewCell{
    [self.mytableView registerClass:[BKDepositTopCell class] forCellReuseIdentifier:NSStringFromClass([BKDepositTopCell class])];
    [self.mytableView registerClass:[BKDepositBottomCell class] forCellReuseIdentifier:NSStringFromClass([BKDepositBottomCell class])];
}

- (void)changeTheTixianBtnWith:(BOOL)isEnable{
    if(isEnable){
        self.tixianBtn.backgroundColor = COLOR_STRING(@"#FEA449");
    }else{
        self.tixianBtn.backgroundColor = COLOR_STRING(@"#D7D7D7");
    }
    self.isCanTixian = isEnable;
}
- (void)selectMoneyActionWithType:(NSInteger)index{
    self.selectMoneyType = index;
    if(self.selectMoneyType == 1){
        if (self.enableMoney >= 100) {
            [self changeTheTixianBtnWith:YES];
            [self showTipMoneyisOver:NO];
        }else{
            [self changeTheTixianBtnWith:NO];
            [self showTipMoneyisOver:YES];
        }
    }else if(self.selectMoneyType == 2){
        if (self.enableMoney >= 500) {
            [self changeTheTixianBtnWith:YES];
            [self showTipMoneyisOver:NO];
        }else{
            [self changeTheTixianBtnWith:NO];
            [self showTipMoneyisOver:YES];
        }
    }else if(self.selectMoneyType == 3){
        if (self.enableMoney >= 1000) {
            [self changeTheTixianBtnWith:YES];
            [self showTipMoneyisOver:NO];
        }else{
            [self changeTheTixianBtnWith:NO];
            [self showTipMoneyisOver:YES];
        }
    }else{
        [self changeTheTixianBtnWith:NO];
        [self showTipMoneyisOver:NO];
    }
}
- (void)showTipMoneyisOver:(BOOL)isOver{
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    BKDepositTopCell *cell = (BKDepositTopCell*)[self.mytableView cellForRowAtIndexPath:indexpath];
    [cell changeTheTipMoneyOver:!isOver];
}
#pragma mark - tableViewDelegate&dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        BKDepositTopCell *cell = [BKDepositTopCell BKBaseTableViewCellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        kWeakSelf(weakself);
        [cell setClickMoneyBtn:^(NSInteger selectIndex) {
            [weakself selectMoneyActionWithType:selectIndex];
        }];
        [cell setMoneyWith:self.enableMoney];
        return  cell;
    }else{
        BKDepositBottomCell *cell = [BKDepositBottomCell BKBaseTableViewCellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return  cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return [BKDepositTopCell heightForCellWithObject:nil];
    }else{
        return [BKDepositBottomCell heightForCellWithObject:nil];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

#pragma mark - //提现
- (void)tixianAction{
    if (_isCanTixian) {
        if (APP_DELEGATE.mLoginResult.bindWx) {
            if (APP_DELEGATE.isWXInstalled)
            {
                [WeChatManager sendAuthRequest];
                [WeChatManager sharedManager].delegate = self;
            }else
            {
                [CommonUsePackaging showSystemHint:@"您还未安装微信客户端，请先下载安装"];
            }
        }else{
            [self tixianTipWithisBind:NO];
        }
        
    }
}

- (void)tixianTipWithisBind:(BOOL)isbind{
    BKTixianWeChartTipCtr *ctr = [[BKTixianWeChartTipCtr alloc]init];
    ctr.view.frame = CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT);
    ctr.modalPresentationStyle = UIModalPresentationOverFullScreen;
    ctr.tipView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 233);
    if (isbind) {
        [ctr setUIWithImageUrl:APP_DELEGATE.mLoginResult.wxImageUrl andNameStr:APP_DELEGATE.mLoginResult.wxNickName andTitleStr:@"即将提现至您的微信" andBtnStr:@"确定"];
    }else{
        [ctr setUIWithImageUrl:@"" andNameStr:@"" andTitleStr:@"微信未绑定" andBtnStr:@"立即绑定"];
    }
    [ctr setClickDoneBtn:^{
        if (isbind) {
            NSLog(@"确认提现");
            [self requestNetTiXian];
        }else{
            if (APP_DELEGATE.isWXInstalled)
            {
                [WeChatManager sendAuthRequest];
                [WeChatManager sharedManager].delegate = self;
            }else
            {
                [CommonUsePackaging showSystemHint:@"您还未安装微信客户端，请先下载安装"];
            }

        }
    }];
    [self presentViewController:ctr animated:NO completion:^{
        [UIView animateWithDuration:0.25 animations:^{
            ctr.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
            ctr.tipView.frame = CGRectMake(0, SCREEN_HEIGHT-233, SCREEN_WIDTH, 233);
        }];
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
- (void)requestBindWXWWith:(NSString*)code{//绑定or更新
    if(APP_DELEGATE.mLoginResult.bindWx){//更新
        [MBProgressHUD showMessage:@""];
        [BKNewLoginRequestManage requestBindWeChartTXWithCode:code AndFinish:^(id  _Nonnull responsed, NSError * _Nonnull error) {
            [MBProgressHUD hideHUD];
            if (error == nil) {
                if ([[responsed objectForKey:@"code"]integerValue] == 1) {
                    NSDictionary *dic = [responsed objectForKey:@"data"];
                    if (dic != nil) {
                        NSString *wxname = [dic objectForKey:@"wxNickName"];
                        if (wxname.length) {
                            APP_DELEGATE.mLoginResult.bindWx = YES;
                            APP_DELEGATE.mLoginResult.wxNickName = wxname;
                        }
                        NSString *wxImageUrl = [dic objectForKey:@"wxImageUrl"];
                        if (wxImageUrl.length) {
                            APP_DELEGATE.mLoginResult.wxImageUrl = wxImageUrl;
                        }
                        //绑定成功提示
                        [self updateWeChartInfoSuccess];
                        [APP_DELEGATE saveLoginSuccessWithModel];
                    }
                }else{
                    NSString *str = [responsed objectForKey:@"msg"];
                    if (str.length) {
                        [[[BKLoginCodeTip alloc]init] AddTextShowTip:str and:self.view];
                    }else{
                        [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"更新绑定失败" and:self.view];
                    }
                }
            }else{
                [[[BKLoginCodeTip alloc]init] AddLoginNetErrorTip:self.view];
            }
        }];
    }else{//绑定
        [MBProgressHUD showMessage:@""];
        [BKNewLoginRequestManage requestBindWeChartWithCode:code AndFinish:^(id  _Nonnull responsed, NSError * _Nonnull error) {
            [MBProgressHUD hideHUD];
            if (error == nil) {
                if ([[responsed objectForKey:@"code"]integerValue] == 1) {
                    
                    NSDictionary *dic = [responsed objectForKey:@"data"];
                    if (dic != nil) {
                        NSString *wxname = [dic objectForKey:@"wxNickName"];
                        if (wxname.length) {
                            APP_DELEGATE.mLoginResult.bindWx = YES;
                            APP_DELEGATE.mLoginResult.wxNickName = wxname;
                        }
                        NSString *wxImageUrl = [dic objectForKey:@"wxImageUrl"];
                        if (wxImageUrl.length) {
                            APP_DELEGATE.mLoginResult.wxImageUrl = wxImageUrl;
                        }
                        //绑定成功提示
                        [[[BKLoginCodeTip alloc]init] AddBindWeChartOkTip:self.view];
                        [APP_DELEGATE saveLoginSuccessWithModel];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self updateWeChartInfoSuccess];
                        });
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
}
//更新绑定微信成功回调
- (void)updateWeChartInfoSuccess{
    [self tixianTipWithisBind:YES];
}

- (void)requestNetTiXian{
    [MBProgressHUD showMessage:@""];
    [XBKNetWorkManager requestWalletTiXianWithmoneyType:self.selectMoneyType AndAndFinish:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@",responseObj);
        if (error == nil) {
            if ([[responseObj objectForKey:@"code"]integerValue]==1) {
                [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"提现申请已提交" and:self.view];
                NSDictionary *dic = [responseObj objectForKey:@"data"];
                if(dic != nil){
                  tixianPgData *dataModel = [tixianPgData mj_objectWithKeyValues:dic];
                  [self gotoDetailTransactionWithModel:dataModel];
                }
            }else{
                NSString *str = [responseObj objectForKey:@"msg"];
                if (str.length) {
                    [[[BKLoginCodeTip alloc]init] AddTextShowTip:str and:self.view];
                }else{
                    [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"请求出错啦" and:self.view];
                }

            }
        }else{
            [[[BKLoginCodeTip alloc]init] AddLoginNetErrorTip:self.view];
        }
    }];
}

//跳转提现进度详情页
- (void)gotoDetailTransactionWithModel:(tixianPgData*)model{
    BKTiXianProgressCtr *ctr = [[BKTiXianProgressCtr alloc]init];
    ctr.data = model;
    [APP_DELEGATE.navigationController pushViewController:ctr animated:YES];
}
//微信已被其他账号绑定提示
- (void)bindWechartInUseTipWithNumber:(NSString*)number{
    BKWeChartBindUseTipCtr *ctr = [[BKWeChartBindUseTipCtr alloc]init];
    [ctr setTitleWithNumber:number];
    [ctr startShowTipWithController:self];
}

@end
