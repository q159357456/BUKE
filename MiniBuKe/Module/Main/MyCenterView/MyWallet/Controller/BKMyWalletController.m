//
//  BKMyWalletController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/30.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKMyWalletController.h"
#import "BKWalletTopView.h"
#import "BKWalletFriendBuyView.h"
#import "XBKNetWorkManager.h"
#import "WalletDealDetailsCell.h"
#import "BKWithdrawDepositCtr.h"
#import "BKTiXianProgressCtr.h"
#import "MJRefresh.h"
#import "PBBaseViewControllerHelp.h"

@interface BKMyWalletController ()<P_QLDragToRefresh,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) BKWalletTopView *topViewContent;
@property (nonatomic, strong) BKWalletFriendBuyView *friendView;
@property (nonatomic, strong) UIButton *tixianBtn;
@property (nonatomic, assign) BOOL isCanTixian;
@property (nonatomic, strong) UITableView *mytableView;
@property (nonatomic, strong) UILabel *headLabel;

@property (nonatomic, strong) BkWalletInfoModel *infoModel;
@property (nonatomic, strong) BKWalletDetailsModel *detailsModel;

@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation BKMyWalletController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self requestReloadisMore:NO];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
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
    
    [self addWalletdetailTableView];
    self.currentPage = 1;
//    [self requestReloadisMore:NO];
    
    [self configureHeaderDragRefreshView];
    [self configureFooterDragRefreshView];
}

- (void)initTopBarView{
    self.topView = [[UIView alloc]init];
    _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH,kNavbarH);
    _topView.backgroundColor = COLOR_STRING(@"#474747");
    [self.view addSubview:_topView];
    
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:_topView.frame];
    bgView.image = [UIImage imageNamed:@"wallet_top_bg"];
    [self.topView addSubview:bgView];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, kStatusBarH, 40, 40)];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"wallet_back_icon"]
             forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"wallet_back_icon"]
             forState:UIControlStateSelected];
    [_topView addSubview:backBtn];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80,kStatusBarH,SCREEN_WIDTH-160,44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"我的钱包";
    titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    titleLabel.textColor = COLOR_STRING(@"#FFFFFF");
    [_topView addSubview: titleLabel];
}

- (BKWalletFriendBuyView *)friendView{
    if (_friendView == nil) {
        _friendView = [[BKWalletFriendBuyView alloc]init];
        _friendView.frame = CGRectMake(0,CGRectGetMaxY(_topViewContent.frame), SCREEN_WIDTH, 94);
    }
    return _friendView;
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

- (void)changeTheTixianBtnWith:(BOOL)isEnable{
    if(isEnable){
        self.tixianBtn.backgroundColor = COLOR_STRING(@"#FEA449");
    }else{
        self.tixianBtn.backgroundColor = COLOR_STRING(@"#D7D7D7");
    }
    self.isCanTixian = isEnable;
}

- (void)addWalletdetailTableView{
    
    self.mytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_topView.frame), SCREEN_WIDTH,SCREEN_HEIGHT-CGRectGetMaxY(_topView.frame)-60) style:UITableViewStyleGrouped];
    _mytableView.delegate = self;
    _mytableView.dataSource = self;
    _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        _mytableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        
    }
    _mytableView.estimatedRowHeight = 0;
    _mytableView.estimatedSectionFooterHeight = 0;
    _mytableView.estimatedSectionHeaderHeight = 0;
    _mytableView.backgroundColor = COLOR_STRING(@"#FFFFFF");
    _mytableView.showsVerticalScrollIndicator = NO;
   
    [self.view addSubview:_mytableView];
    [self registerCustomTableViewCell];
    
    self.topViewContent = [[BKWalletTopView alloc]initWithFrame:CGRectMake(0, kNavbarH, SCREEN_WIDTH, 190)];
    self.mytableView.tableHeaderView = self.topViewContent;
}

- (void)registerCustomTableViewCell{
    [self.mytableView registerClass:[WalletDealDetailsCell class] forCellReuseIdentifier:NSStringFromClass([WalletDealDetailsCell class])];
}

#pragma mark- tableViewdelegate&dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return self.detailsModel.data.contentList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return nil;
    }
    WalletDealDetailsCell *cell = [WalletDealDetailsCell BKBaseTableViewCellWithTableView:tableView];
    [cell setUIModelWith:self.detailsModel.data.contentList[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    kWeakSelf(weakself)
    [cell setClickDetailBtnClick:^(NSString * _Nonnull transactionId) {
        [weakself gotoDetailTransactionWith:transactionId];
    }];
    return  cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.infoModel.data != nil && (self.infoModel.data.registerCount || self.infoModel.data.transactionCount)) {
            return CGRectGetHeight(self.friendView.frame);
        }else{
            return 0;
        }
    }else{
        return CGRectGetHeight(self.headLabel.frame);
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.infoModel.data != nil && (self.infoModel.data.registerCount || self.infoModel.data.transactionCount)) {
            [self.friendView reloadContentShow:self.infoModel.data.transactionCount and:self.infoModel.data.registerCount];
            return self.friendView;
        }
        return nil;
    }else{
        if (_detailsModel.data.contentList.count) {
            return self.headLabel;
        }
    }
    return nil;
}
- (UILabel *)headLabel{
    if (_headLabel == nil) {
        _headLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.alignment = NSTextAlignmentJustified;
        // 首行缩进
        style.firstLineHeadIndent = 15.0f;
        // 头部缩进
        style.headIndent = 15.0f;
        NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:@"钱包明细" attributes:@{ NSParagraphStyleAttributeName : style}];
        _headLabel.attributedText = attrText;
        _headLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        _headLabel.textColor = COLOR_STRING(@"#2f2f2f");
    }
    return _headLabel;
}
#pragma mark - 跳转详情,提现
//跳转提现进度详情页
- (void)gotoDetailTransactionWith:(NSString*)transactionId{
    if (transactionId.length) {
        BKTiXianProgressCtr *ctr = [[BKTiXianProgressCtr alloc]init];
        ctr.transactionId = transactionId;
        [APP_DELEGATE.navigationController pushViewController:ctr animated:YES];
    }
}
//提现
- (void)tixianAction{
    if (_isCanTixian) {
        BKWithdrawDepositCtr *ctr = [[BKWithdrawDepositCtr alloc]init];
        ctr.enableMoney = self.infoModel.data.money;
        [APP_DELEGATE.navigationController pushViewController:ctr animated:YES];
    }
//    BKWithdrawDepositCtr *ctr = [[BKWithdrawDepositCtr alloc]init];
//    ctr.enableMoney = 888;
//    [APP_DELEGATE.navigationController pushViewController:ctr animated:YES];
}

#pragma mark - 刷新
- (UIScrollView *)dragRefreshView{
    return self.mytableView;
}
- (BOOL)hasHeaderDragRefresh{
    return YES;
}
- (BOOL)hasFootterDragRefresh{
    if (self.detailsModel.data.last) {
        return NO;
    }
    return YES;
}
- (void)dragReload:(BOOL)bMore{
    [self requestReloadisMore:bMore];
}

#pragma mark - request
- (void)requestReloadisMore:(BOOL)isMore{
    if (isMore) {
        self.currentPage += 1;
    }else{
        self.currentPage = 1;
        [self requestbaseInfo];
    }
    [XBKNetWorkManager requestWalletDetailsDWithpage:self.currentPage pageNumber:10 AndAndFinish:^(BKWalletDetailsModel * _Nonnull model, NSError * _Nonnull error) {
        if (error == nil) {
            if (model.code == 1) {
                if (self.currentPage>1) {
                    [self.detailsModel.data.contentList addObjectsFromArray:model.data.contentList];
                    self.detailsModel.data.last = model.data.last;
                }else{
                    self.detailsModel = model;
                }
                [self.mytableView reloadData];
                if (self.detailsModel.data && self.infoModel.data) {
                    [self stopRefresh];
                    return ;
                }
            }else{
                
            }
        }else{
            
        }
        [self stopRefresh];
    }];
}
- (void)requestbaseInfo{
    [XBKNetWorkManager requestWalletInfoAndAndFinish:^(BkWalletInfoModel * _Nonnull model, NSError * _Nonnull error) {
        if (error == nil) {
            if (model.code == 1) {
                self.infoModel = model;
                [self.topViewContent reloadContentWithEnableMoney:model.data.money andAllMoney:model.data.totalMoney];
                [self.mytableView reloadData];
                if(self.infoModel.data.money>0){
                    [self changeTheTixianBtnWith:YES];
                }else{
                    [self changeTheTixianBtnWith:NO];
                }
                if (self.detailsModel.data && self.infoModel.data) {
                    [self stopRefresh];
                    return ;
                }

            }else{
                
            }
        }else{
            
        }
        [self stopRefresh];
    }];
}
#pragma mark - P_QLDragToRefresh 刷新
- (void)configureHeaderDragRefreshView {
    id <P_QLDragToRefresh> dragObj = (id <P_QLDragToRefresh>)self;
    
    if ( ![self conformsToProtocol:@protocol(P_QLDragToRefresh)] ) {
        return;
    }
    
    UIScrollView * scrollView = [dragObj dragRefreshView];
    
    MJRefreshComponentRefreshingBlock refreshingBlock = ^(){
        [self dragReload:NO];
    };
    
    if ([dragObj hasHeaderDragRefresh] ) {
        if(scrollView.mj_header == nil){
            
            MJRefreshNormalHeader *header =[MJRefreshNormalHeader headerWithRefreshingBlock:refreshingBlock];
            scrollView.mj_header = header;
        }
    }else{
        scrollView.mj_header = nil;
    }
}

- (void)configureFooterDragRefreshView {
    id <P_QLDragToRefresh> dragObj = (id <P_QLDragToRefresh>)self;
    
    if ( ![self conformsToProtocol:@protocol(P_QLDragToRefresh)] ) {
        return;
    }
    
    UIScrollView * scrollView = [dragObj dragRefreshView];
    
    MJRefreshComponentRefreshingBlock refreshingBlock = ^(){
        [self dragReload:YES];
    };
    
    if([dragObj hasFootterDragRefresh]){
        if(scrollView.mj_footer == nil){
            scrollView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:refreshingBlock];
        }
    }else{
        scrollView.mj_footer = nil;
        scrollView.mj_reloadDataBlock = nil;
    }
}

- (void)stopRefresh{
    id <P_QLDragToRefresh> dragObj = (id <P_QLDragToRefresh>)self;
    
    if ( ![self conformsToProtocol:@protocol(P_QLDragToRefresh)] ) {
        return;
    }
    
    UIScrollView * scrollView = [dragObj dragRefreshView];
    
    if(scrollView != nil &&  [scrollView isKindOfClass:[UIScrollView class]]){
        [scrollView.mj_header endRefreshing];
        [scrollView.mj_footer endRefreshing];
    }
    
    if ( [self conformsToProtocol:@protocol(P_QLDragToRefresh)] ) {
        // Drag Refresh
        [self configureFooterDragRefreshView];
    }
}

@end
