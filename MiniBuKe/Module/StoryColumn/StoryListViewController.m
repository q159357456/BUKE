//
//  StoryListViewController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/13.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "StoryListViewController.h"
#import "StoryListViewCell.h"
#import "StoryListModel.h"
#import "StoryPlayListViewController.h"
#import "AppDelegate.h"
#import <MJRefresh.h>
#import "StoryListService.h"

#define PAGE_NUM    20

@interface StoryListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,assign) NSInteger page;

@end

@implementation StoryListViewController

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.dataArray = [NSMutableArray array];
    
    [self initView];
    
     [self headerRereshing];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

    self.statusView.backgroundColor = COLOR_STRING(@"#FFFFFF");
    self.navigationController.navigationBar.backgroundColor = COLOR_STRING(@"#FFFFFF");
//    self.statusView.backgroundColor = COLOR_STRING(@"#FF5001");
//    self.navigationController.navigationBar.backgroundColor = COLOR_STRING(@"#FF5001");
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

}

-(void)initView
{
    self.titleLabel.textColor = COLOR_STRING(@"#2f2f2f");
    [self.leftButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateNormal];
    [self.leftButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateSelected];
    [self.leftButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[[UIDevice currentDevice] systemVersion] integerValue] < 10) {
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        titleView.backgroundColor = [UIColor clearColor];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.6, 44)];
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = COLOR_STRING(@"#2F2F2F");
        title.font = MY_FONT(18);
        title.text = self.storyObject.categoryName?:@"故事列表";
        [titleView addSubview:title];
        
//        self.navigationItem.title = self.storyObject.categoryName?:@"故事列表";
        self.navigationController.navigationItem.titleView = titleView;
        
    }else{
        
        self.titleLabel.text = self.storyObject.categoryName?:@"故事列表";
    }
    
    _tableView = [[UITableView alloc] init];
    if ([[[UIDevice currentDevice] systemVersion] integerValue] <= 10 ) {
        
        if (IS_IPHONE_X) {
            _tableView.frame = CGRectMake(0, 88, SCREEN_WIDTH, SCREEN_HEIGHT - 88);
        }else{
            _tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        }

    }else{
        _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    
    
    [_tableView setBackgroundColor:COLOR_STRING(@"#FFFFFF")];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self setupRefresh];
}

-(void)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [footer setTitle:MJRefreshStateIdle_Str forState:MJRefreshStateIdle];
    [footer setTitle:MJRefreshStatePulling_Str forState:MJRefreshStatePulling];
    [footer setTitle:MJRefreshStateRefreshing_Str forState:MJRefreshStateRefreshing];
    [footer setTitle:MJRefreshStateWillRefresh_Str forState:MJRefreshStateWillRefresh];
    [footer setTitle:MJRefreshStateNoMoreData_Str forState:MJRefreshStateNoMoreData];
    
    self.tableView.mj_footer = footer;
}

//下拉刷新
-(void)headerRereshing
{
    //消除尾部"没有更多数据"状态
    [self.tableView.mj_footer resetNoMoreData];
    
    //判断数据源,调用不同接口
    self.page = 1;
    
    [self getDataWithPage:self.page PageNum:PAGE_NUM];//默认每次取20条数据
}

-(void)headEndRefresh
{
    if (self.tableView.visibleCells.count != 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    
    [self.tableView.mj_header endRefreshing];
}

-(void)footerRereshing
{
    self.page++;
    [self getMoreDataWithPage:self.page PageNum:PAGE_NUM];
}

-(void)displayFootDataBy:(id)httpInterface
{
    NSArray *temArray = [NSArray array];
    
    StoryListService *listSerice = httpInterface;
    if (listSerice.storyListArray != nil) {
        temArray = listSerice.storyListArray;
    }
    
    if (temArray.count != 0) {
        
        [self.dataArray addObjectsFromArray:temArray];
        
        if (temArray.count < PAGE_NUM) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
    
    [self.tableView.mj_footer endRefreshing];
}

-(void)getDataWithPage:(NSInteger )page  PageNum:(NSInteger )pageNum
{
    void(^OnSuccess)(id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"StoryListService ===> OnSuccess");
        
        if (self.dataArray.count > 0) {
             [self.dataArray removeAllObjects];
        }
       
        StoryListService *service = (StoryListService *)httpInterface;
        if (service.storyListArray.count > 0) {
            [self.dataArray addObjectsFromArray:service.storyListArray];
             [self.tableView reloadData];
        }
        
        [self headEndRefresh];
    };
    
    void(^OnError)(NSInteger,NSString *) = ^(NSInteger httpInterface,NSString *description){
        NSLog(@"StoryListService === > OnEoor");
        [self headEndRefresh];
    };
    
    StoryListService *listService = [[StoryListService alloc] initWithCategoryId:self.storyObject.storyId setPage:page setPageNum:pageNum setOnSuccess:OnSuccess setOnError:OnError];
    [listService start];
}

-(void)getMoreDataWithPage:(NSInteger )page PageNum:(NSInteger )pageNum
{
    void(^OnSuccess)(id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"StoryListService ===> OnSuccess");
        
        [self displayFootDataBy:httpInterface];
    };
    
    void(^OnError)(NSInteger,NSString *) = ^(NSInteger httpInterface,NSString *description){
        NSLog(@"StoryListService === > OnEoor");
        [self.tableView.mj_footer endRefreshing];
    };
    
    StoryListService *listService = [[StoryListService alloc] initWithCategoryId:self.storyObject.storyId setPage:page setPageNum:pageNum setOnSuccess:OnSuccess setOnError:OnError];
    [listService start];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    StoryListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[StoryListViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (self.dataArray.count) {
        StoryListModel *listModel = self.dataArray[indexPath.row];
        [cell setCellWithStoryListModel:listModel];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    StoryListModel *listModel = self.dataArray[indexPath.row];
    StoryPlayListViewController *playListVC = [[StoryPlayListViewController alloc]init];
    
    playListVC.listModel = listModel;
    playListVC.sourceType = StoryPlaySourceType_PlayList;
    
    [self.navigationController pushViewController:playListVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
