//
//  BKSelectConfigNetModelCtr.m
//  MiniBuKe
//
//  Created by chenheng on 2019/1/29.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKSelectConfigNetModelCtr.h"
#import "BKSelectConfigNetCell.h"
#import "PrepareConfigNetViewController.h"
#import "WifiImportViewController.h"
@interface BKSelectConfigNetModelCtr
()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *backBtn;
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation BKSelectConfigNetModelCtr

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = COLOR_STRING(@"#F7F9FB");
    [self initTopBarView];
    [self.view addSubview:self.tableView];
    [self registerCustomTableViewCell];
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
    _titleLabel.text = @"选择绑定方式";
    [_topView addSubview: _titleLabel];
    
    self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, kStatusBarH, 40, 44)];
    [self.backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.backBtn setImage:[UIImage imageNamed:@"mate_back"]
                  forState:UIControlStateNormal];
    [self.backBtn setImage:[UIImage imageNamed:@"mate_back"]
                  forState:UIControlStateSelected];
    [_topView addSubview:self.backBtn];
}

- (void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(15, kNavbarH, self.view.frame.size.width-30, self.view.frame.size.height-kNavbarH) style:UITableViewStyleGrouped];
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
    
    [self.tableView registerClass:[BKSelectConfigNetCell class] forCellReuseIdentifier:NSStringFromClass([BKSelectConfigNetCell class])];
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BKSelectConfigNetCell *cell = [BKSelectConfigNetCell BKBaseTableViewCellWithTableView:tableView];
    [cell setModelWithFlag:indexPath.section];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [BKSelectConfigNetCell heightForCellWithObject:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        return 10.f;
    }
    return 5.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self pushToCtrWithRobot:indexPath.section];
}

- (void)pushToCtrWithRobot:(NSInteger)type{
    //robotType 机器人类型: 0 wifi配网, 1 蓝牙配网
    if (self.isConfigNet) {
        if (type==0) {
            WifiImportViewController *ctr = [[WifiImportViewController alloc]init];
            ctr.isConfigNet = self.isConfigNet;
            ctr.robotType = self.robotType;
            [APP_DELEGATE.navigationController pushViewController:ctr animated:YES];
            
        }else
        {
            QRCodeViewController *mQRCodeViewController = [[QRCodeViewController alloc] init];
            mQRCodeViewController.isConfigNet = self.isConfigNet;
            mQRCodeViewController.robotType = self.robotType;
            mQRCodeViewController.configMold = FourthGConfigNet;
            [self.navigationController pushViewController:mQRCodeViewController animated:YES];
        }
       
        
    }else
    {
        PrepareConfigNetViewController *ctr = [[PrepareConfigNetViewController alloc]init];
        ctr.robotType = self.robotType;
        ctr.configMold = type==0?WifiConfigNet:FourthGConfigNet;
        [self.navigationController pushViewController:ctr animated:YES];
    }
//    if (type == 0) {
//        PrepareConfigNetViewController *ctr = [[PrepareConfigNetViewController alloc]init];
//        ctr.robotType = self.robotType;
//        ctr.configMold = WifiConfigNet;
//        [self.navigationController pushViewController:ctr animated:YES];
//
//    }else if (type == 1){
//        //4G配网
////        [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"敬请期待" and:self.view];
//        PrepareConfigNetViewController *ctr = [[PrepareConfigNetViewController alloc]init];
//        ctr.robotType = self.robotType;
//        ctr.configMold = FourthGConfigNet;
//        [self.navigationController pushViewController:ctr animated:YES];
//    }
}

@end
