//
//  BKSelectRobotModelCtr.m
//  MiniBuKe
//
//  Created by chenheng on 2019/1/29.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKSelectRobotModelCtr.h"
#import "BKSelectRobotCell.h"
#import "PrepareConfigNetViewController.h"
#import "BKSelectConfigNetModelCtr.h"

@interface BKSelectRobotModelCtr ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *backBtn;
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation BKSelectRobotModelCtr

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
    _titleLabel.text = @"选择你的设备";
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavbarH, self.view.frame.size.width, self.view.frame.size.height-kNavbarH) style:UITableViewStyleGrouped];
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
    
    [self.tableView registerClass:[BKSelectRobotCell class] forCellReuseIdentifier:NSStringFromClass([BKSelectRobotCell class])];
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BKSelectRobotCell *cell = [BKSelectRobotCell BKBaseTableViewCellWithTableView:tableView];
    [cell setModelWithRobotFlag:indexPath.section];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [BKSelectRobotCell heightForCellWithObject:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        return 5.f;
    }
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


        [tableView deselectRowAtIndexPath:indexPath animated:YES];

        [self pushToCtrWithRobot:indexPath.section];
}

- (void)pushToCtrWithRobot:(NSInteger)RobotType{
    //robotType 机器人类型: 0 chill机器人, 1 Q1机器人 ,2 super 机器人 ,3 babycare机器人
    if (RobotType == 0) {
        
        PrepareConfigNetViewController *ctr = [[PrepareConfigNetViewController alloc]init];
        ctr.robotType = XBK_RobotType_chill;
        [self.navigationController pushViewController:ctr animated:YES];
        
    }else if (RobotType == 1){
        
        PrepareConfigNetViewController *ctr = [[PrepareConfigNetViewController alloc]init];
        ctr.robotType = XBK_RobotType_Q1;
        [self.navigationController pushViewController:ctr animated:YES];

    }else if (RobotType == 2){
        
        BKSelectConfigNetModelCtr *ctr = [[BKSelectConfigNetModelCtr alloc]init];
        ctr.robotType = XBK_RobotType_super;
        [self.navigationController pushViewController:ctr animated:YES];
        
    }else if (RobotType == 3){
        
        PrepareConfigNetViewController *ctr = [[PrepareConfigNetViewController alloc]init];
        ctr.robotType = XBK_RobotType_babycare;
        [self.navigationController pushViewController:ctr animated:YES];
    }
}

@end
