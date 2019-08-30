//
//  BKCenterView_New.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/23.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKCenterView_New.h"
#import "BKCenterTableViewCell.h"
#import "BKCenterBtnListCell.h"
#import "BKCenterDeviceCell.h"
#import "BKCenterConnect.h"
#import "UIResponder+Event.h"
#import "TalkViewController.h"
#import "BKBookReportH5Ctr.h"
#import "BKCenterSettingCtr.h"
#import "DeviceManageViewController.h"
#import "FeedbackViewController.h"
#import "AboutViewController.h"
#import "BindMaskViewController.h"
#import "CenterSevice.h"
#import "BabyRobotInfo.h"
#import "BKMyWalletController.h"
#import "OJBillViewController.h"
#import <MJRefresh.h>
#import "BKH5WalletCtr.h"
#import "BKSelectRobotModelCtr.h"
#import "BKConfigAddressBookCtr.h"
#import "BKDeviceManagnerCtr.h"
#import "FetchUserSNService.h"

#import "BookReportController.h"
#import "BKBabyCareMainCtr.h"
#import "BKCameraManager.h"

#import "BookReportController.h"
#import "OnlineClassPlayController.h"
@interface BKCenterView_New ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *topWhiteView;
@end
@implementation BKCenterView_New
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:self.tableView];
        
//        IOTYPE_BATTERY_LEVEL_RESP
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryChange:) name:@"IOTYPE_BATTERY_LEVEL_RESP" object:nil];
    }
    return self;
}

- (void)batteryChange:(NSNotification*)notic{
    CGFloat value = [notic.object floatValue];
    APP_DELEGATE.ElectricQuantity = value > 100 ? 100:value;
    APP_DELEGATE.isOnLine = [BKCameraManager shareInstance].deviceState == DeviceContentStateType_onLine ? YES:NO;
    NSIndexSet * set = [[NSIndexSet alloc]initWithIndex:0];
    [self.tableView reloadSections:set withRowAnimation:NO];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"IOTYPE_BATTERY_LEVEL_RESP" object:nil];
}
#pragma mark - 懒加载
-(UIView *)topWhiteView
{
    if (!_topWhiteView) {
        _topWhiteView = [[UIView alloc]initWithFrame:CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kStatusBarH)];
        _topWhiteView.backgroundColor = [UIColor whiteColor];
    }
    return _topWhiteView;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kStatusBarH, SCREEN_WIDTH, self.bounds.size.height-kStatusBarH) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = COLOR_STRING(@"#F7F9FB");
        [_tableView registerNib:[UINib nibWithNibName:@"BKCenterTableViewCell" bundle:nil] forCellReuseIdentifier:@"BKCenterTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"BKCenterDeviceCell" bundle:nil] forCellReuseIdentifier:@"BKCenterDeviceCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"BKCenterConnect" bundle:nil] forCellReuseIdentifier:@"BKCenterConnect"];
        [_tableView registerClass:[BKCenterBtnListCell class] forCellReuseIdentifier:@"BKCenterBtnListCell"];
        _tableView.separatorColor = COLOR_STRING(@"#EAEAEA");;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.centerHeaderView;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(judgeDeviceCurrentState)];
        
    }
    return _tableView;
}
-(BKCenterHeaderView *)centerHeaderView
{
    if (!_centerHeaderView) {
        
        _centerHeaderView = [[BKCenterHeaderView alloc]init];
        
    }
    return _centerHeaderView;
}

#pragma mark - public
-(void)reload{
    [self initFetchUserSNService];
    
    if (4 == [APP_DELEGATE.snData.type integerValue]) {
        if ([BKCameraManager shareInstance].deviceState != DeviceContentStateType_onLine) {
            [[BKCameraManager shareInstance] ConnectDevice];
        }
        [[BKCameraManager shareInstance] postGetTheDeviceInfoCMD];
        APP_DELEGATE.isOnLine = [BKCameraManager shareInstance].deviceState == DeviceContentStateType_onLine ? YES:NO;
        NSIndexSet * set = [[NSIndexSet alloc]initWithIndex:0];
        [self.tableView reloadSections:set withRowAnimation:NO];
        
    }else{
        [self judgeDeviceCurrentState];
    }

    
  [self fetchBabyInfo];
  [self memberFetchUserInfo];
  [self.centerHeaderView.userInfoView reloadData];

}

#pragma mark - private
//判断当前设备状态
-(void)judgeDeviceCurrentState{
    if (4 == [APP_DELEGATE.snData.type integerValue]) {
        [self.tableView.mj_header endRefreshing];
        if ([BKCameraManager shareInstance].deviceState != DeviceContentStateType_onLine) {
            [[BKCameraManager shareInstance] ConnectDevice];
        }
        [[BKCameraManager shareInstance] postGetTheDeviceInfoCMD];
        APP_DELEGATE.isOnLine = [BKCameraManager shareInstance].deviceState == DeviceContentStateType_onLine ? YES:NO;
        NSIndexSet * set = [[NSIndexSet alloc]initWithIndex:0];
        [self.tableView reloadSections:set withRowAnimation:NO];
        
    }else{
        
        if(APP_DELEGATE.mLoginResult.SN != nil && APP_DELEGATE.mLoginResult.SN.length > 0)
        {
            
            //已经连了设备 1机器连了wifi 2机器没有连wifi
            
            [CenterSevice robot_isOnline:^(id responsed, NSError *error) {
                [self.tableView.mj_header endRefreshing];
                NSDictionary *dic = (NSDictionary*)responsed;
                if (!error) {
                    if ([dic[@"state"] intValue] != 1)
                    {
                        [MBProgressHUD showError:dic[@"message"]];
                        
                    }else
                    {
                        APP_DELEGATE.isOnLine = [dic[@"data"][@"online"] intValue];
                        NSIndexSet * set = [[NSIndexSet alloc]initWithIndex:0];
                        [self.tableView reloadSections:set withRowAnimation:NO];
                    }
                    [self.tableView.mj_header endRefreshing];
                }
                
            }];
            
            [CenterSevice pub_robot_battery:^(id responsed, NSError *error) {
                
                [self.tableView.mj_header endRefreshing];
                NSDictionary *dic = (NSDictionary*)responsed;
                //            NSLog(@"responsed2:%@",responsed);
                if (!error) {
                    if ([dic[@"state"] intValue] != 1)
                    {
                        [MBProgressHUD showError:dic[@"message"]];
                    }else
                    {
                        APP_DELEGATE.ElectricQuantity = [dic[@"data"][@"battery"] floatValue];
                        NSIndexSet * set = [[NSIndexSet alloc]initWithIndex:0];
                        [self.tableView reloadSections:set withRowAnimation:NO];
                    }
                    
                }
            }];
            
            
        }
        else
        {
            //没有连设备
            NSIndexSet * set = [[NSIndexSet alloc]initWithIndex:0];
            [self.tableView reloadSections:set withRowAnimation:NO];
            [self.tableView.mj_header endRefreshing];
        }
    }
}
#pragma mark - 拉取宝贝信息数据
-(void)fetchBabyInfo{
//    [MBProgressHUD showMessage:@""];
    [CenterSevice user_fetchBabyInfo:^(id responsed, NSError *error) {
//        [MBProgressHUD hideHUD];
        if (!error) {
            NSDictionary *dic =(NSDictionary*)responsed;
            
            BabyRobotInfo *info = [BabyRobotInfo parseDataByDictionary:dic[@"data"][@"baby"]];
            NSDictionary*dic1 = (NSDictionary*)dic[@"data"];
            if (dic1.count) {
               self.centerHeaderView.babyRobotInfo = info;
            }
            
            
        }
    }];
    
}

#pragma mark - tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
    
        case 0:
        {
            return 2;
        }
            break;
        case 1:
        {
            return 6;
        }
            break;
        case 2:
        {
            return 1;
        }
            break;
     
    
    }
    
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

   if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            BKCenterConnect *cell =[tableView dequeueReusableCellWithIdentifier:@"BKCenterConnect"];
//            cell.selectionStyle =  UITableViewCellSelectionStyleNone;
            cell.selectedBackgroundView = [self cellHightLight];
            cell.title.text = @"设备管理";
            [cell DeviceReload];
            return cell;
        }else
        {
            BKCenterDeviceCell *cell =[tableView dequeueReusableCellWithIdentifier:@"BKCenterDeviceCell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectedBackgroundView = [self cellHightLight];
             [cell DeviceReload];
            return cell;
        }
    }
    else
    {
        BKCenterTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"BKCenterTableViewCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectedBackgroundView = [self cellHightLight];
        switch (indexPath.section) {
            case 1:
            {
                if (indexPath.row == 0)
                {
                    cell.title.text = @"阅读报告";
                }else if (indexPath.row == 1)
                {
                    cell.title.text = @"已购课程";
                }else if (indexPath.row == 2)
                {
                    cell.title.text = @"我的购买";
                }else if (indexPath.row == 3)
                {
                    cell.title.text = @"我的钱包";
                    
                }else if (indexPath.row == 4)
                {
                    cell.title.text = @"意见反馈";
                    
                }else if (indexPath.row == 5)
                {
                    cell.title.text = @"关于";
                }
                
            }
                break;
            case 2:
            {
                if (indexPath.row == 0)
                {
                   cell.title.text = @"设置";
                    
                }
            }
                break;
//            case 3:
//            {
//                cell.title.text = @"设置";
//            }
//                break;
        }
        return cell;
    }
    return nil;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
//        return 110;
//    }
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        return 10;
    }
    return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 1) {
                
                if (APP_DELEGATE.mLoginResult.SN.length && APP_DELEGATE.mLoginResult.SN != nil) {
                    if (4 == [APP_DELEGATE.snData.type integerValue]) {
                        BKBabyCareMainCtr *babyCareCtr = [[BKBabyCareMainCtr alloc]init];
                        babyCareCtr.isNeedPopMore = NO;
                        [APP_DELEGATE.navigationController pushViewController:babyCareCtr animated:YES];
                    }else{
                        BKDeviceManagnerCtr *ctr = [[BKDeviceManagnerCtr alloc]init];
                        [APP_DELEGATE.navigationController pushViewController:ctr animated:YES];
                    }
                }else{
                    
                    BKSelectRobotModelCtr *ctr = [[BKSelectRobotModelCtr alloc]init];
                    [APP_DELEGATE.navigationController pushViewController:ctr animated:YES];
                }

            }else
            {

                if (APP_DELEGATE.mLoginResult.SN.length && APP_DELEGATE.mLoginResult.SN != nil) {
                    if (4 == [APP_DELEGATE.snData.type integerValue]) {
                        BKBabyCareMainCtr *babyCareCtr = [[BKBabyCareMainCtr alloc]init];
                        babyCareCtr.isNeedPopMore = NO;
                        [APP_DELEGATE.navigationController pushViewController:babyCareCtr animated:YES];
                    }else{
                        BKDeviceManagnerCtr *ctr = [[BKDeviceManagnerCtr alloc]init];
                        [APP_DELEGATE.navigationController pushViewController:ctr animated:YES];
                    }
                    
                }else{
                    
                    BKSelectRobotModelCtr *ctr = [[BKSelectRobotModelCtr alloc]init];
                    [APP_DELEGATE.navigationController pushViewController:ctr animated:YES];
                }

            }
        }
            break;
            
        case 1:
        {
            if (indexPath.row == 0) {//阅读报告  babycare支持阅读报告

//                if(4 == [APP_DELEGATE.snData.type integerValue]){
//                    //babycare不支持提示
//                    ScoreRemindView *reminde =[[ScoreRemindView alloc]initWithFrame:[UIScreen mainScreen].bounds Title:@"此设备暂不支持该功能" Info:@"" ImageName:@"bc_DontUse_tip" Block:^{
//
//                    }];
//                    [APP_DELEGATE.window addSubview:reminde];
//                }else{
                    BKBookReportH5Ctr *vc= [[BKBookReportH5Ctr alloc]init];
                    [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
                    
//                    BookReportController *vc = [[BookReportController alloc]init];
//                    [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
//                }
                
            }else if (indexPath.row == 1){//我的已购课程
                OnlineClassPlayController * vc = [[OnlineClassPlayController alloc]init];
                vc.titleSetting = @"已购课程";
                vc.url = BuyedCourseList;
                [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
              
            }else if (indexPath.row == 2){//我的购买包
                OJBillViewController *vc= [[OJBillViewController alloc]init];
                NSString * url = MyOrders;
                vc.url =url;
                [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
            }else if (indexPath.row == 3){//我的钱
                BKH5WalletCtr *vc = [[BKH5WalletCtr alloc]init];
                vc.url = [NSString stringWithFormat:@"%@?token=%@",H5Wallet,APP_DELEGATE.mLoginResult.token];
                [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
            }else if (indexPath.row == 4){
                FeedbackViewController *mFeedbackViewController = [[FeedbackViewController alloc] init];
                [APP_DELEGATE.navigationController pushViewController:mFeedbackViewController animated:YES];
            }else if (indexPath.row == 5){
                AboutViewController *mAboutViewController = [[AboutViewController alloc] init];
                [APP_DELEGATE.navigationController pushViewController:mAboutViewController animated:YES];
            }
        }
            break;
        case 2:
        {
            if (indexPath.row == 0) {
                BKCenterSettingCtr *vc = [[BKCenterSettingCtr alloc]init];
                [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
//        case 3://跳转设置
//        {
//            BKCenterSettingCtr *vc = [[BKCenterSettingCtr alloc]init];
//            [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
//        }
//            break;
    }
}

-(UIView*)cellHightLight{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = COLOR_STRING(@"#F7F9FB");
    return view;
}


#pragma mark - scroView
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (kStatusBarH == 20) {
        if (scrollView.contentOffset.y<=10)
        {
            
            [self.topWhiteView removeFromSuperview];
            
            
        }else
        {
            
            [self addSubview:self.topWhiteView];
            [self bringSubviewToFront:self.topWhiteView];
            
        }
    }
   
}

-(void)initFetchUserSNService
{
    kWeakSelf(weakSelf);
    [XBKNetWorkManager requestUserFetchSNAndAndFinish:^(BKUserSNFetchModel * _Nonnull model, NSError * _Nonnull error) {
        if (error == nil && 1 == model.code) {
            if (model.data !=nil && model.data.sn.length) {
                
                APP_DELEGATE.snData = model.data;
                [APP_DELEGATE saveSNInfoWithModel];
                
                APP_DELEGATE.mLoginResult.SN = model.data.sn;
                [APP_DELEGATE saveLoginSuccessWithModel];
                
                NSIndexSet * set = [[NSIndexSet alloc]initWithIndex:0];
                [weakSelf.tableView reloadSections:set withRowAnimation:NO];
            }
        }
        
    }];

}

-(void)memberFetchUserInfo{
    MJWeakSelf;
    [XBKNetWorkManager memberFetchUserInfoFinish:^(MemberModel * _Nonnull model, NSError * _Nonnull error) {
       
        [weakSelf.centerHeaderView setMemberInfo:model.data];
        
    }];
    
}
@end
