//
//  BabyBookViewController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/21.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BabyBookViewController.h"
//#import "BookListViewCell.h"
#import "BabyBookCell.h"
#import "BookShelfListService.h"
#import "BooklistObjet.h"
#import "BookShelfRemoveSerivce.h"
#import <MJRefresh/MJRefresh.h>
#import "MBProgressHUD+XBK.h"
#import "NoDataBackView.h"

#define bottomView_height 0

@interface BabyBookViewController ()<UITableViewDelegate, UITableViewDataSource,BabyBookCellDelegate>

@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIView *middleView;
@property(nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *itemButton;
@property (nonatomic) BOOL isSelect;

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *deleteArray;
@property (nonatomic,strong) NSMutableArray *netWorkDataArray;

@property (nonatomic) int mPage;

@property(nonatomic,strong) NoDataBackView *backView;

@end

@implementation BabyBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isSelect = NO;
    
    [self initView];
    self.deleteArray = [[NSMutableArray alloc] init];
    
    self.mPage = 1;
    [self onBookShelfListService:self.mPage];
}

-(void)onBookShelfListService:(int) page
{
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"BookShelfListService ==> OnSuccess");
        BookShelfListService *service = (BookShelfListService*)httpInterface;
        if (service.dataArray != nil && service.dataArray.count > 0) {
            
            self.itemButton.userInteractionEnabled = YES;
            [self.itemButton setTitleColor:COLOR_STRING(@"#2f2f2f") forState:UIControlStateNormal];
            
            [self manageNetWorkDataArray:service.dataArray];
            [self arrangeBookList:self.netWorkDataArray];
            
            if (self.tableView != nil) {
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            }
        } else {
            if (self.tableView != nil) {
                if (self.mPage > 1) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.tableView.mj_footer endRefreshing];
                }
            }
        }
        
        if (self.dataArray.count == 0) {
            //加载无数据image
            [self.tableView.mj_footer resetNoMoreData];
            [self showNoDataImage];
        }
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"BookShelfListService ==> OnError");
    };
    
    BookShelfListService *service = [[BookShelfListService alloc] init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token setPage:[NSString stringWithFormat:@"%i",page] setPageNum:@"15"];
    [service start];
}

-(void)onBookShelfRemoveSerivce
{
    if (self.deleteArray.count == 0) {
        return;
    }
    
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"onBookShelfRemoveSerivce ==> OnSuccess");
        self.isSelect = false;
        self.itemButton.userInteractionEnabled = YES;
        [self.itemButton setTitle:@"管理" forState:UIControlStateNormal];
        [self.itemButton setTitleColor:COLOR_STRING(@"#2f2f2f") forState:UIControlStateNormal];

        [self manageDeleteArray];
        [self arrangeBookList:self.netWorkDataArray];
        
        if (self.tableView != nil) {
            [self.tableView reloadData];
        }
        
        if (self.dataArray.count == 0) {
            [self.tableView.mj_footer resetNoMoreData];
            [self showNoDataImage];
        }
        //[self onBookShelfListService];
        
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"onBookShelfRemoveSerivce ==> OnError");
    };
    NSString *str = @"";
    for (int i = 0; i < self.deleteArray.count; i++) {
        if (i == 0) {
            BooklistObjet *mBooklistObjet = [self.deleteArray objectAtIndex:i];
            str = mBooklistObjet.mid;
        } else {//} if (i == self.deleteArray.count - 1) {
            BooklistObjet *mBooklistObjet = [self.deleteArray objectAtIndex:i];
            str = [NSString stringWithFormat:@"%@,%@",str,mBooklistObjet.mid];
        }
//        else {
//
//        }
//        [NSString stringWithFormat:@"%@,%@",];
//        str = str + [self.deleteArray objectAtIndex:i];
    }
    NSLog(@"BookShelfRemoveSerivce ids => %@",str);
    BookShelfRemoveSerivce *service = [[BookShelfRemoveSerivce alloc] init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token setIds:str];
    [service start];
}

-(void)showNoDataImage
{
    self.itemButton.userInteractionEnabled = NO;
    [self.itemButton setTitleColor:[UIColor colorWithHexStr:@"#2f2f2f" alpha:0.5] forState:UIControlStateNormal];
    
    if (self.backView == nil) {
        CGRect imageBound = CGRectMake(0, 0, 375, 180);
        UIImage *backImage = [UIImage imageNamed:@"noData_babyBook"];
        NSString *title = @"哦呵~您的书架里还没有绘本哦,\n快去让宝宝使用小布壳读书吧!";
        self.backView = [[NoDataBackView alloc] initWithImageBound:imageBound WithImage:backImage WithTitle:title];
        [self.tableView addSubview:self.backView];
    }else{
        self.backView.hidden = NO;
    }
}

-(void) manageNetWorkDataArray:(NSArray *) array
{
    if (self.netWorkDataArray == nil) {
        self.netWorkDataArray = [[NSMutableArray alloc] init];
    }
    
    if (array != nil && array.count > 0) {
        for (int i = 0; i < array.count; i ++) {
            BooklistObjet *mBooklistObjet = [array objectAtIndex:i];
            [self.netWorkDataArray addObject:mBooklistObjet];
        }
    }
}

-(void) manageDeleteArray
{
    if (self.deleteArray != nil && self.deleteArray.count > 0) {
        for (int i = 0; i < self.deleteArray.count ; i ++) {
            if (self.netWorkDataArray != nil && self.netWorkDataArray.count > 0) {
                BooklistObjet *mBooklistObjet = [self.deleteArray objectAtIndex:i];
                [self.netWorkDataArray removeObject:mBooklistObjet];
            }
        }
        
        [self.dataArray removeAllObjects];
    }
}

-(void) arrangeBookList:(NSArray *) array
{
    if (self.dataArray == nil) {
        self.dataArray = [[NSMutableArray alloc] init];
    }
    if(array != nil && array.count > 0){
        NSMutableArray *mTempArray = [[NSMutableArray alloc] init];
        NSMutableArray *mMutableArray;
        for (int i = 0; i < array.count; i ++) {
            
            NSLog(@"mKBookListArray ==> %i",(i % 3));
            BooklistObjet *mBooklistObjet = [array objectAtIndex:i];
            if (i % 3 == 0) {
                mMutableArray = [[NSMutableArray alloc] init];
                [mTempArray addObject:mMutableArray];
                [mMutableArray addObject:mBooklistObjet];
            } else if (i % 2 == 0) {
                [mMutableArray addObject:mBooklistObjet];
            } else {
                [mMutableArray addObject:mBooklistObjet];
            }
        }
        self.dataArray = mTempArray;
        NSLog(@"self.dataArray ==> %li => %@",self.dataArray.count,self.dataArray);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideBarStyle];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self showBarStyle];
}

- (void)showBarStyle {
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)hideBarStyle {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)initView{
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 73)];
    [_topView setBackgroundColor:COLOR_STRING(@"#FFFFFF")];
    [self.view addSubview:_topView];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - bottomView_height, self.view.frame.size.width, bottomView_height)];
    //[_bottomView setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:_bottomView];
    
    _middleView = [[UIView alloc] initWithFrame:CGRectMake(0, _topView.frame.origin.y + _topView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _topView.frame.size.height - _bottomView.frame.size.height)];
    [_middleView setBackgroundColor:COLOR_STRING(@"#FFFFFF")];
    //    [_middleView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:_middleView];
    
    
    NSLog(@" %f == %f",self.view.frame.size.height,self.view.frame.size.width);
    
    [self createTopViewChild];
    //[self createBottomViewChild];
    [self createMiddleViewChild];
}

-(void) createMiddleViewChild
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height - 73) style:UITableViewStylePlain];
    //[tableView setBackgroundColor:COLOR_STRING(@"#FFF011")];
    //    self.tableView.bounds = CGRectMake(0, 0, self.frame.size.width,self.frame.size.height);
    //    self.tableView.center = CGPointMake(self.frame.size.width/2,self.frame.size.height/2);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    //self.tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_middleView addSubview:self.tableView];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [footer setTitle:MJRefreshStateIdle_Str forState:MJRefreshStateIdle];
    [footer setTitle:MJRefreshStatePulling_Str forState:MJRefreshStatePulling];
    [footer setTitle:MJRefreshStateRefreshing_Str forState:MJRefreshStateRefreshing];
    [footer setTitle:MJRefreshStateWillRefresh_Str forState:MJRefreshStateWillRefresh];
    [footer setTitle:MJRefreshStateNoMoreData_Str forState:MJRefreshStateNoMoreData];
    
    self.tableView.mj_footer = footer;
}

-(void)footerRereshing
{
    self.mPage++;
    NSLog(@"loading ...");
    
    [self onBookShelfListService:self.mPage];
}

-(void) createTopViewChild {
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 40, 40)];
    //[_moveButton setBackgroundColor:[UIColor whiteColor]];
    
    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateSelected];
    //[_moveButton setTitle:@"故事" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:MY_FONT(18)];
    [backButton setAdjustsImageWhenHighlighted:NO];
    //[_moveButton setTitleColor:COLOR_STRING(@"#FFD1C7") forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,25,self.view.frame.size.width,48)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"宝宝书架";
    titleLabel.font = MY_FONT(19);
    titleLabel.textColor = COLOR_STRING(@"#2f2f2f");
    [_topView addSubview: titleLabel];
    
    self.itemButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40 - 10, 30, 40, 40)];
    //[_moveButton setBackgroundColor:[UIColor whiteColor]];
    
    [self.itemButton setTitle:@"管理" forState:UIControlStateNormal];
    [self.itemButton setTitleColor:COLOR_STRING(@"#2f2f2f") forState:UIControlStateNormal];
    [self.itemButton.titleLabel setFont:MY_FONT(18)];
    [self.itemButton setAdjustsImageWhenHighlighted:NO];
    
    [self.itemButton addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:self.itemButton];
}

-(IBAction)itemButtonClick:(id)sender
{
    NSLog(@"选择");
    if (self.isSelect) {
        
        if (self.deleteArray != nil && self.deleteArray.count > 0) {
            [self logout];
        } else {
            [MBProgressHUD showError:@"请勾选需要删除的绘本"];
        }
        
    } else {
        self.isSelect = true;
        self.itemButton.userInteractionEnabled = YES;
        [self.itemButton setTitleColor:COLOR_STRING(@"#2f2f2f") forState:UIControlStateNormal];
        [self.itemButton setTitle:@"删除" forState:UIControlStateNormal];
        [self.tableView reloadData];
    }
}

- (void) logout {
    // 初始化对话框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"这些书本将从您的'宝宝书架'中删除？" preferredStyle:UIAlertControllerStyleAlert];
    // 确定注销
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        NSLog(@"点击提示");
        [self onBookShelfRemoveSerivce];
    }];
    UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    
    // 弹出对话框
    [self presentViewController:alert animated:true completion:nil];
}

-(void) onSelectCell:(BooklistObjet *) obj select:(BOOL) isSelect
{
    NSLog(@"===> %@",obj.mid);
    //self.dataArray
    if (isSelect) {
        //选中
        [self.deleteArray addObject:obj];
    } else {
        //删除
        [self.deleteArray removeObject:obj];
    }
    [self setSelectDataArray:obj select:isSelect];
    
    NSLog(@"deleteArray ==> %@",self.deleteArray);
}

-(IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return BabyBookCell_height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UILabel *label = [cell.contentView viewWithTag:1];
    label.text = [@(indexPath.row + 1) stringValue];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"BabyBookCell";
    BabyBookCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [BabyBookCell xibTableViewCell];
        //        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
        
    }
    //    [cell updateData:CGSizeMake(tableView.frame.size.width, 0)];
//    NSArray *mBooklistObjets = [self.mKBookListArray objectAtIndex:indexPath.row];
    
    //NSLog(@"NSArray *mBooklistObjets ===> %i",mBooklistObjets.count);
    
    NSArray *mBooklistObjets = [self.dataArray objectAtIndex:indexPath.row];
    
    NSLog(@"NSArray *mBooklistObjets ===> %i",mBooklistObjets.count);
    
//    mBooklistObjets = [self getBooklistArraySelect:mBooklistObjets];
    
//    [cell updateData:CGSizeMake(tableView.frame.size.width, 0) setArrayBooklistObjet:mBooklistObjets ];
    cell.delegate = self;
    [cell updateViewData:CGSizeMake(tableView.frame.size.width, 0) setArrayBooklistObjet:mBooklistObjets isSelect:self.isSelect];
    return cell;
}

-(void) setSelectDataArray:(BooklistObjet *) mBooklistObjet select:(BOOL) select
{
    NSLog(@"self.deleteArray.count ===> %i",self.deleteArray.count);
    for (int i = 0; i < self.dataArray.count; i ++) {
        NSArray *array = [self.dataArray objectAtIndex:i];
        for (int j = 0; j < array.count; j ++) {
            BooklistObjet *obj = [array objectAtIndex:j];
            if (mBooklistObjet.mid == obj.mid) {
                ((BooklistObjet *)([[self.dataArray objectAtIndex:i] objectAtIndex:j])).isSelect = select;
            }
        }
    }
}

-(NSArray *) getBooklistArraySelect:(NSArray *) mBooklistObjets
{
    NSLog(@"self.deleteArray.count ===> %i",self.deleteArray.count);
    NSMutableArray *array = [[NSMutableArray alloc] init];

    for (int i = 0; i < mBooklistObjets.count; i ++) {
        BooklistObjet *mBooklistObjet = [mBooklistObjets objectAtIndex:i];
        for (int j = 0; j < self.deleteArray.count; j ++) {
            BooklistObjet *mDeleteBooklistObjet = [self.deleteArray objectAtIndex:j];
            if (mBooklistObjet.mid == mDeleteBooklistObjet.mid) {
                mBooklistObjet.isSelect = YES;
            } else {
                mBooklistObjet.isSelect = NO;
            }
        }
        [array addObject:mBooklistObjet];
    }

    return array;
}

@end
