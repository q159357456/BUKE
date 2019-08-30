//
//  BKMoreNewBookListCtr.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/7.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKMoreNewBookListCtr.h"
#import "XBKNetWorkManager.h"
#import "BookListViewCell.h"
#import "IntensiveReadingController.h"
#import "MJRefresh.h"
#import "PBBaseViewControllerHelp.h"

@interface BKMoreNewBookListCtr ()<UITableViewDelegate,UITableViewDataSource,BookListViewCellDelegate,P_QLDragToRefresh>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) NSMutableArray *bookListArray;
@property(nonatomic, strong) NSMutableArray *mKBookListArray;
@property(nonatomic, assign) NSInteger currentPage;

@end

@implementation BKMoreNewBookListCtr

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideBarStyle];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self showBarStyle];
}

- (void)hideBarStyle {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = YES;
}

- (void)showBarStyle {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.currentPage = 1;
    [self configureHeaderDragRefreshView];
    [self configureFooterDragRefreshView];
    
    [BKLoadAnimationView ShowHitOn:self.view Frame:CGRectMake(0, kNavbarH, SCREEN_WIDTH, SCREEN_HEIGHT-kNavbarH)];

    [self requestLoadData];
}

- (void)initView{
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,kNavbarH)];
    [_topView setBackgroundColor:COLOR_STRING(@"#FFFFFF")];
    [self.view addSubview:_topView];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,kStatusBarH,self.view.frame.size.width,44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"最新上架";
    titleLabel.font = MY_FONT(19);
    titleLabel.textColor = COLOR_STRING(@"#2F2F2F");
    [_topView addSubview: titleLabel];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, kStatusBarH, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateSelected];
    
    [backButton.titleLabel setFont:MY_FONT(18)];
    [backButton setAdjustsImageWhenHighlighted:NO];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:backButton];
    
    [self.view addSubview:self.tableView];
}

-(void)backButtonClick:(id)sender
{
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
        } else {
            
        }
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.backgroundColor = COLOR_STRING(@"#FFFFFF");
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return  _tableView;
}
#pragma mark - requestData{
-(void)requestLoadData{
    
    [XBKNetWorkManager requestNewBookListWithPage:self.currentPage AndPageNumber:10 AndFinish:^(BKMoreNewBookListModel * _Nonnull model, NSError * _Nonnull error) {
        [BKLoadAnimationView HiddenFrom:self.view];
        if(error == nil){
            if(model.state == 1 && model.success){
                if (model.data.booklist.count) {

                    [self arrangeBookList:model.data.booklist];
                    [self.tableView reloadData];

                }else{
                    
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    return ;
                }
            }else{
                [MBProgressHUD showError:@"请求出错啦,请稍后重试"];
            }
        }else{
            if (self.currentPage == 1) {
                [self addNetError];
            }else{
                [MBProgressHUD showError:@"网络异常,请稍后重试"];
            }
        }
        
        [self stopRefresh];
    }];
}

-(void) arrangeBookList:(NSArray *) dataArray
{
    if (self.mKBookListArray == nil) {
        self.mKBookListArray = [[NSMutableArray alloc] init];
    }
    if(dataArray != nil && dataArray.count > 0){
        NSMutableArray *mMutableArray;
        for (int i = 0; i < dataArray.count; i ++) {
            BKNewBookData *mBooklistObjet = [dataArray objectAtIndex:i];
            if (i % 2 == 0) {
                mMutableArray = [[NSMutableArray alloc] init];
                [self.mKBookListArray addObject:mMutableArray];
                [mMutableArray addObject:mBooklistObjet];
            } else {
                [mMutableArray addObject:mBooklistObjet];
            }
        }
    }
}

#pragma mark - tableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"BookListViewCell";
    BookListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [BookListViewCell xibTableViewCell];
    }
    
    NSArray *mBooklistObjets = [self.mKBookListArray objectAtIndex:indexPath.row];
    
    [cell NewBookUpdateData:CGSizeMake(tableView.frame.size.width, 0) setArrayBooklistObjet:mBooklistObjets];
    cell.delegate = self;
    return cell;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mKBookListArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return BookListViewCell_height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

#pragma mark - BookListViewCellDelegate
- (void)NewbookClickWithBookId:(NSString *)bookId{
    NSLog(@"newbooklist-click-%@",bookId);
    IntensiveReadingController *vc = [[IntensiveReadingController alloc]init];
    vc.bookid = bookId;
    [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
}

#pragma mark - P_QLDragToRefresh 刷新
- (UIScrollView *)dragRefreshView{
    return self.tableView;
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
        self.currentPage += 1;
        [self requestLoadData];

    }else{
        self.currentPage = 1;
        [self.mKBookListArray removeAllObjects];
        [self requestLoadData];
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
    [self requestLoadData];
}

@end
