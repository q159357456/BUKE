//
//  BKCallRecordViewController.m
//  MiniBuKe
//
//  Created by chenheng on 2019/5/5.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKCallRecordViewController.h"
#import "BKCallReocrdCell.h"
#import "PBBaseViewControllerHelp.h"
#import "MJRefresh.h"
#import "BKMessageNODataBackView.h"

@interface BKCallRecordViewController ()<UITableViewDelegate,UITableViewDataSource,P_QLDragToRefresh>
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, assign) NSInteger currenPage;
@property (nonatomic, strong) BKSNCallRecordsModel *recordModel;
@property (nonatomic, strong) BKMessageNODataBackView *backView;
@end

@implementation BKCallRecordViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTopBarView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.myTableView];
    [self registerCustomTableViewCell];
    self.currenPage = 1;
    [self configureHeaderDragRefreshView];
    [self configureFooterDragRefreshView];
    [self requestRecordHistory];

}

- (void)initTopBarView{
    
    self.topView = [[UIView alloc]init];
    _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH,kNavbarH);
    _topView.backgroundColor = COLOR_STRING(@"#ffffff");
    [self.view addSubview:_topView];
    UIView *sepView = [[UIView alloc]init];
    sepView.backgroundColor = COLOR_STRING(@"#F7F9FB");
    sepView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), CGRectGetWidth(self.topView.frame), 10);
    [self.view addSubview:sepView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80,kStatusBarH,SCREEN_WIDTH-160,40)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    _titleLabel.textColor = COLOR_STRING(@"#2f2f2f");
    _titleLabel.text = @"通话记录";
    [_topView addSubview: _titleLabel];
    
    self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, kStatusBarH, 40, 40)];
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

- (void)registerCustomTableViewCell{
    
    [self.myTableView registerClass:[BKCallReocrdCell class] forCellReuseIdentifier:NSStringFromClass([BKCallReocrdCell class])];
}

#pragma mark - tableviewDelegate&dataSource
-(UITableView *)myTableView{
    if (_myTableView == nil) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame)+10, self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(self.topView.frame)-10) style:UITableViewStyleGrouped];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _myTableView.estimatedRowHeight = 0;
        _myTableView.estimatedSectionFooterHeight = 0;
        _myTableView.estimatedSectionHeaderHeight = 0;
        _myTableView.backgroundColor = COLOR_STRING(@"#FFFFFF");
        _myTableView.showsVerticalScrollIndicator = NO;
    }
    return  _myTableView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BKCallReocrdCell *cell = [BKCallReocrdCell BKBaseTableViewCellWithTableView:tableView];
    [cell setModelWith:self.recordModel.data.list[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.recordModel.data.list.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [BKCallReocrdCell heightForCellWithObject:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)requestRecordHistory{
    kWeakSelf(weakSelf);
    [XBKNetWorkManager requestFetchSNCallRecordsWithSN:APP_DELEGATE.mLoginResult.SN Page:self.currenPage PageNumber:10 AndAndFinish:^(BKSNCallRecordsModel * _Nonnull model, NSError * _Nonnull error) {
        [BKLoadAnimationView HiddenFrom:weakSelf.view];
        if(error == nil){
            if(model.code == 1){
                if (model.data.list.count) {
                    if (weakSelf.currenPage != 1) {
                        [weakSelf.recordModel.data.list addObjectsFromArray:model.data.list];
                        weakSelf.recordModel.data.isLastPage = model.data.isLastPage;
                        
                    }else{
                        weakSelf.recordModel = nil;
                        weakSelf.recordModel = model;
                    }
                    
                    [weakSelf.myTableView reloadData];
                    
                    [weakSelf removeNoDataView];

                }else{
                    if (!weakSelf.recordModel.data.list.count) {
                        [weakSelf showNoDataView];
                    }
                    
                    [weakSelf stopRefresh];
                    [weakSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
                    return ;
                }
            }else{
                [MBProgressHUD showError:@"请求出错啦,请稍后重试"];
            }
        }else{
            if (weakSelf.currenPage == 1 && weakSelf.recordModel == nil) {
                [weakSelf addNetError];
            }else{
                [MBProgressHUD showError:@"网络异常,请稍后重试"];
            }
        }
        
        [weakSelf stopRefresh];
    }];
}

#pragma mark - P_QLDragToRefresh 刷新
- (UIScrollView *)dragRefreshView{
    return self.myTableView;
}
- (BOOL)hasHeaderDragRefresh{
    return YES;
}
- (BOOL)hasFootterDragRefresh{
    return YES;
}

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

- (void)dragReload:(BOOL)bMore{
    if (bMore == YES) {
        self.currenPage += 1;
        [self requestRecordHistory];
        
    }else{
        self.currenPage = 1;
        [self requestRecordHistory];
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

#pragma mark - netError
- (void)addNetError{
    BKNetWorkErrorBackView *backView = [BKNetWorkErrorBackView showOn:self.view WithFrame:CGRectMake(0, kNavbarH, SCREEN_WIDTH, SCREEN_HEIGHT-kNavbarH)];
    kWeakSelf(weakSelf);
    [backView setTryAgainAction:^{
        [weakSelf reloadAgain];
    }];
}
-(void)reloadAgain{
    //loading
    [BKLoadAnimationView ShowHitOn:self.view Frame:CGRectMake(0, kNavbarH, SCREEN_WIDTH, SCREEN_HEIGHT-kNavbarH)];
    [self requestRecordHistory];
}

- (void)showNoDataView{
    if (self.backView == nil) {
        CGRect imageBound = CGRectMake(0, 0, 375, 200);
        UIImage *backImage = [UIImage imageNamed:@"bc_ringRecord_noData"];
        NSString *title = @"暂无通话记录";
        self.backView = [[BKMessageNODataBackView alloc]initWithImageBound:imageBound WithImage:backImage WithTitle:title andPicOffset:-50 andLableOffset:-15];
        self.backView.backgroundColor = COLOR_STRING(@"#F7F9FB");
        self.backView.titlefont = [UIFont systemFontOfSize:13.f];
        self.backView.titlefontColor = COLOR_STRING(@"#999999");
    }
    self.backView.frame = CGRectMake(0, 0, CGRectGetWidth(self.myTableView.frame), CGRectGetHeight(self.myTableView.frame));
    [self.myTableView addSubview:self.backView];
}
- (void)removeNoDataView{
    if (self.backView != nil) {
        [self.backView removeFromSuperview];
        self.backView = nil;
    }
}

@end
