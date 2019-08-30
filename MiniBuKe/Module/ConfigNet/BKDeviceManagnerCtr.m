//
//  BKDeviceManagnerCtr.m
//  MiniBuKe
//
//  Created by chenheng on 2019/1/29.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKDeviceManagnerCtr.h"
#import "BkDeviceTapCell.h"
#import "BKDeviceShowCell.h"
#import "PrepareConfigNetViewController.h"
#import "BKSelectConfigNetModelCtr.h"
#import "FetchUserSNService.h"
#import "UnlashRobotSerivce.h"
#import "BKSelectRobotModelCtr.h"
#import "BKConfigAddressBookCtr.h"
#import "BKRobotBindTipCtr.h"
#import "TallkNotificationController.h"
#import "WifiImportViewController.h"
#import "BKBabyCareMainCtr.h"
#import "BKCameraManager.h"
@interface BKDeviceManagnerCtr ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *backBtn;
@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *bottomBtn;

@property (nonatomic, copy) NSString *snStr;
@property (nonatomic, copy) NSString *sysInfoStr;
@property(nonatomic, assign) BOOL isUnbind;
@property(nonatomic, assign) BOOL isTitan;
@property(nonatomic, assign) XBK_RobotType robotType;
@end

@implementation BKDeviceManagnerCtr
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = YES;
    
    [self initFetchUserSNService];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = NO;
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_STRING(@"#F7F9FB");
    // Do any additional setup after loading the view.
    [self initTopBarView];
    [self.view addSubview:self.tableView];
    [self registerCustomTableViewCell];
    
    if(APP_DELEGATE.snData != nil && [APP_DELEGATE.snData.type isEqualToString:@"2"]){
        self.isTitan = YES;
    }else{
        self.isTitan = NO;
    }
    self.robotType = [APP_DELEGATE.snData.type integerValue];
}

- (void)initTopBarView{
    self.topView = [[UIView alloc]init];
    _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH,kNavbarH);
    _topView.backgroundColor = COLOR_STRING(@"#ffffff");
    [self.view addSubview:_topView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80,kStatusBarH,SCREEN_WIDTH-160,44)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    _titleLabel.textColor = COLOR_STRING(@"#2f2f2f");
    _titleLabel.text = @"设备管理";
    [_topView addSubview: _titleLabel];
    
    self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, kStatusBarH, 40, 44)];
    [self.backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.backBtn setImage:[UIImage imageNamed:@"mate_back"]
                  forState:UIControlStateNormal];
    [self.backBtn setImage:[UIImage imageNamed:@"mate_back"]
                  forState:UIControlStateSelected];
    [_topView addSubview:self.backBtn];
    
    self.bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCALE(88), self.view.frame.size.height-92, SCALE(200), 44)];
    self.bottomBtn.backgroundColor = COLOR_STRING(@"#F6922D");
    self.bottomBtn.layer.cornerRadius=22;
    self.bottomBtn.layer.masksToBounds=YES;
    [self.bottomBtn setTitle:@"解除绑定" forState:UIControlStateNormal];
    [self.bottomBtn addTarget:self action:@selector(unbindMachain) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview :self.bottomBtn];
}

- (void)backBtnClick{
    if ([self findTheControllerWith:NSStringFromClass([BKRobotBindTipCtr class])] == -1) {
        if ([self findTheControllerWith:NSStringFromClass([TallkNotificationController class])] != -1) {//返回消息页面入口
            NSInteger index = [self findTheControllerWith:NSStringFromClass([TallkNotificationController class])];
            [self.navigationController popToViewController:self.navigationController.viewControllers[index] animated:YES];
            
        }
        else if ([self findTheControllerWith:NSStringFromClass([BKBabyCareMainCtr class])] != -1){
            if (self.isUnbind == NO) {
                
                NSInteger index = [self findTheControllerWith:NSStringFromClass([BKBabyCareMainCtr class])];
                if ([self findTheControllerWith:NSStringFromClass([BKSelectRobotModelCtr class])] != -1) {
                    NSInteger index1 =[self findTheControllerWith:NSStringFromClass([BKSelectRobotModelCtr class])];
                    [self.navigationController popToViewController:self.navigationController.viewControllers[index1-1] animated:YES];

                }else{
                    
                    [self.navigationController popToViewController:self.navigationController.viewControllers[index-1] animated:YES];
                }
                
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    }else{
        
        if ([self findTheControllerWith:NSStringFromClass([TallkNotificationController class])] != -1) {//返回消息页面入口
            NSInteger index = [self findTheControllerWith:NSStringFromClass([TallkNotificationController class])];
            [self.navigationController popToViewController:self.navigationController.viewControllers[index] animated:YES];
            
        }
        else{
            NSInteger index = [self findTheControllerWith:NSStringFromClass([BKRobotBindTipCtr class])];
            [self.navigationController popToViewController:self.navigationController.viewControllers[index-1] animated:YES];
        }
    }
}

- (void)unbindMachain{
    if (self.isUnbind) {
        [self logout];
    }
    
}

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavbarH, self.view.frame.size.width, self.view.frame.size.height-kNavbarH-92-44) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.backgroundColor = COLOR_STRING(@"#F7F9FB");
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellEditingStyleNone;
    }
    return  _tableView;
}

- (void)registerCustomTableViewCell{
    
    [self.tableView registerClass:[BKDeviceShowCell class] forCellReuseIdentifier:NSStringFromClass([BKDeviceShowCell class])];
    [self.tableView registerClass:[BkDeviceTapCell class] forCellReuseIdentifier:NSStringFromClass([BkDeviceTapCell class])];
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isTitan) {
        return 3;
    }else{
        return 2;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        BKDeviceShowCell *cell = [BKDeviceShowCell BKBaseTableViewCellWithTableView:tableView];
        [cell setModelWithSN:self.snStr andSysInfo:self.sysInfoStr];
        return cell;

    }else{
        BkDeviceTapCell *cell = [BkDeviceTapCell BKBaseTableViewCellWithTableView:tableView];
        if(indexPath.section == 0){
            if (self.robotType == XBK_RobotType_chill) {
                [cell setModelWithtitle:@"给机器联网"];
            }else{
                [cell setModelWithtitle:@"给小布壳联网"];
            }
        }else{
            [cell setModelWithtitle:@"通讯管理"];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return [BKDeviceShowCell heightForCellWithObject:@1];
    }
    return [BkDeviceTapCell heightForCellWithObject:@(indexPath.section)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self pushToCtrWithIndex:indexPath.section];
}

- (void)pushToCtrWithIndex:(NSInteger)index{
    if (index == 0) {
        //给小布壳配网
        WifiImportViewController *ctr = [[WifiImportViewController alloc]init];
        ctr.isConfigNet = YES;
        ctr.robotType = self.robotType;
        [APP_DELEGATE.navigationController pushViewController:ctr animated:YES];
     
    }else if (index == 2){
        //跳转通讯录管理
        BKConfigAddressBookCtr *ctr = [[BKConfigAddressBookCtr alloc]init];
        [APP_DELEGATE.navigationController pushViewController:ctr animated:YES];
    }
}

//- (void)pushToCtrWithRobot:(NSInteger)RobotType{
//    //robotType 机器人类型: 0 Q1机器人, 1 TiTan机器人
//    if (RobotType == 0) {
//
//        PrepareConfigNetViewController *ctr = [[PrepareConfigNetViewController alloc]init];
//        ctr.robotType = RobotType;
//        [self.navigationController pushViewController:ctr animated:YES];
//
//    }else if (RobotType == 1){
//
//        BKSelectConfigNetModelCtr *ctr = [[BKSelectConfigNetModelCtr alloc]init];
//        ctr.robotType = RobotType;
//        [self.navigationController pushViewController:ctr animated:YES];
//
//    }
//}

#pragma mark - request
-(void)initFetchUserSNService
{
    kWeakSelf(weakSelf);
    [XBKNetWorkManager requestUserFetchSNAndAndFinish:^(BKUserSNFetchModel * _Nonnull model, NSError * _Nonnull error) {
        
        if (error == nil && 1 == model.code) {
            if (model.data != nil && model.data.sn.length) {
                
                APP_DELEGATE.mLoginResult.SN = model.data.sn;
                [APP_DELEGATE saveLoginSuccessWithModel];
                
                APP_DELEGATE.snData = model.data;
                [APP_DELEGATE saveSNInfoWithModel];
                
                weakSelf.robotType = [APP_DELEGATE.snData.type integerValue];
                
                weakSelf.sysInfoStr = model.data.version;
                weakSelf.snStr = model.data.sn;
                
                weakSelf.isUnbind = YES;
                [weakSelf updateDataView];
            }
        }
        
    }];
}

//解绑机器人
-(void)onUnlashRobotSerivce
{
    [XBKNetWorkManager requestUnLashRobotAndAndFinish:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        if (error == nil && 1 == [[responseObj objectForKey:@"code"]integerValue]) {
            [MBProgressHUD showSuccess:@"解绑成功" toView:self.view];
            [self onUnBindSuccess];
        }else{
            NSLog(@"onUnlashRobotSerivce ==> OnError");
            [MBProgressHUD showSuccess:@"解绑失败" toView:self.view];
        }
    }];
    
}

-(void) onUnBindSuccess
{
    if (4 == [APP_DELEGATE.snData.type integerValue]) {
        [[BKCameraManager shareInstance] DisconnectDevice];
    }
    self.isUnbind = NO ;
    LoginResult *mLoginResult = APP_DELEGATE.mLoginResult;
    mLoginResult.SN = @"";
    [APP_DELEGATE setMLoginResult:mLoginResult];
    [APP_DELEGATE saveLoginSuccessWithModel];
    
    //移除sn保存的本地信息.
    [APP_DELEGATE removeSNInfoSave];
    
    [APP_DELEGATE setIsUnbind:YES];
    self.sysInfoStr = @"";
    self.snStr = @"";
    self.robotType = 0;
    
    self.isTitan = NO;
    [self updateDataView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self backBtnClick];
    });
}
-(void)updateDataView
{
    if (self.isUnbind) {
        [self.bottomBtn setTitle:@"解除绑定" forState:UIControlStateNormal];
    } else {
        [self.bottomBtn setTitle:@"绑定" forState:UIControlStateNormal];
    }
    [self.tableView reloadData];
}

- (NSInteger)findTheControllerWith:(NSString*)name{
    
    for (NSInteger i = self.navigationController.viewControllers.count-1; i>=0; i--) {
        UIViewController *ctr = [self.navigationController.viewControllers objectAtIndex:i];
        NSString *str = NSStringFromClass([ctr class]);
        if ([str isEqualToString:name]) {
            return i;
        }
    }
    //    NSString *CnStr=[NSString stringWithUTF8String:object_getClassName(ctr)];
    return -1;
}

- (void) logout {
    // 初始化对话框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认解绑吗？" preferredStyle:UIAlertControllerStyleAlert];
    // 确定注销
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [self onUnlashRobotSerivce];
    }];
    UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    
    // 弹出对话框
    [self presentViewController:alert animated:true completion:nil];
}
@end
