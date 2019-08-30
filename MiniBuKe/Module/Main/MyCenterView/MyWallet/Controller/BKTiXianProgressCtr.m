//
//  BKTiXianProgressCtr.m
//  MiniBuKe
//
//  Created by chenheng on 2018/12/4.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKTiXianProgressCtr.h"
#import "XBKNetWorkManager.h"
#import "BKTiXianProgressCell.h"
#import "BKLoginCodeTip.h"

@interface BKTiXianProgressCtr ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UITableView *mytableView;
@property (nonatomic, strong) BKTixianProgressModel *model;
@end

@implementation BKTiXianProgressCtr
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

}
- (void)backBtnClick{
    if (self.transactionId.length) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count-3>=0?self.navigationController.viewControllers.count-3:0] animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = COLOR_STRING(@"#f9f9f9");
    
    [self initTopBarView];
    [self addBottomBtn];

    if (self.transactionId.length) {
        [MBProgressHUD showMessage:@""];
        [XBKNetWorkManager requestWalletTiXianProgressWithTransactionId:self.transactionId AndAndFinish:^(BKTixianProgressModel * _Nonnull model, NSError * _Nonnull error) {
            [MBProgressHUD hideHUD];
            if(error == nil){
                if (model.code == 1) {
                    self.model = model;
                    [self addTableView];
                    [self.mytableView reloadData];
                }else{
                    if (model.msg.length) {
                        [[[BKLoginCodeTip alloc]init] AddTextShowTip:model.msg and:self.view];
                    }else{
                        [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"请求出错啦" and:self.view];
                    }
                }
            }else{
                [[[BKLoginCodeTip alloc]init] AddLoginNetErrorTip:self.view];
            }
        }];
    }else if (self.data != nil){
        if (self.model == nil) {
            self.model = [[BKTixianProgressModel alloc]init];
        }
        self.model.data = self.data;
        [self addTableView];
        [self.mytableView reloadData];
    }
    
}
- (void)initTopBarView{
    self.topView = [[UIView alloc]init];
    _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH,kNavbarH);
    _topView.backgroundColor = COLOR_STRING(@"#ffffff");
    [self.view addSubview:_topView];
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80,kStatusBarH,SCREEN_WIDTH-160,44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"提现进度";
    titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    titleLabel.textColor = COLOR_STRING(@"#2f2f2f");
    [_topView addSubview: titleLabel];
}

- (void)addBottomBtn{
    UIButton* doneBtn = [[UIButton alloc] init];
    doneBtn.frame = CGRectMake(88, SCREEN_HEIGHT-48-44, SCREEN_WIDTH-2*88, 44);
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [doneBtn setTitleColor:COLOR_STRING(@"#2f2f2f") forState:UIControlStateNormal];
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    doneBtn.backgroundColor = COLOR_STRING(@"#ffffff");
    doneBtn.layer.cornerRadius = 22;
    doneBtn.clipsToBounds = YES;
    [doneBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];
}
- (void)addTableView{
    self.mytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_topView.frame), SCREEN_WIDTH,SCREEN_HEIGHT-CGRectGetMaxY(_topView.frame)-92-20) style:UITableViewStyleGrouped];
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
    _mytableView.backgroundColor = COLOR_STRING(@"#F9f9f9");
    _mytableView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_mytableView];
    [self registerCustomTableViewCell];
}
- (void)registerCustomTableViewCell{
    [self.mytableView registerClass:[BKTiXianProgressCell class] forCellReuseIdentifier:NSStringFromClass([BKTiXianProgressCell class])];
}
#pragma mark - tableViewDelegate&dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    BKTiXianProgressCell *cell = [BKTiXianProgressCell BKBaseTableViewCellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(self.model.data){
        [cell setProgressStateWithtype:_model.data.applyType andTime:_model.data.expectTime];
    }
    return  cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [BKTiXianProgressCell heightForCellWithObject:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.f;
}

@end
