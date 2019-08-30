//
//  ListenerCollectViewController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/6/13.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "RecentlyPlayNewViewController.h"
#import "ListenerCollectCell.h"

#define bottomView_height 0

@interface RecentlyPlayNewViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIView *middleView;
@property(nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) UIButton *itemButton;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation RecentlyPlayNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
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
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
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
    titleLabel.text = @"最近播放";
    titleLabel.font = MY_FONT(19);
    titleLabel.textColor = COLOR_STRING(@"#2f2f2f");
    [_topView addSubview: titleLabel];
    
    self.itemButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40 - 10, 30, 40, 40)];
    //[_moveButton setBackgroundColor:[UIColor whiteColor]];
    
    [self.itemButton setTitle:@"管理" forState:UIControlStateNormal];
    [self.itemButton.titleLabel setFont:MY_FONT(18)];
    [self.itemButton setAdjustsImageWhenHighlighted:NO];
    //[_moveButton setTitleColor:COLOR_STRING(@"#FFD1C7") forState:UIControlStateNormal];
    
    [self.itemButton addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:self.itemButton];
}

-(IBAction)itemButtonClick:(id)sender
{
    NSLog(@"选择");
}

-(IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    //    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    //    [footer setTitle:MJRefreshStateIdle_Str forState:MJRefreshStateIdle];
    //    [footer setTitle:MJRefreshStatePulling_Str forState:MJRefreshStatePulling];
    //    [footer setTitle:MJRefreshStateRefreshing_Str forState:MJRefreshStateRefreshing];
    //    [footer setTitle:MJRefreshStateWillRefresh_Str forState:MJRefreshStateWillRefresh];
    //    [footer setTitle:MJRefreshStateNoMoreData_Str forState:MJRefreshStateNoMoreData];
    //
    //    self.tableView.mj_footer = footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 77;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UILabel *label = [cell.contentView viewWithTag:1];
    label.text = [@(indexPath.row + 1) stringValue];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"ListenerCollectCell";
    ListenerCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [ListenerCollectCell xibTableViewCell];
        //        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    }
    //    [cell updateData:CGSizeMake(tableView.frame.size.width, 0)];
    //    NSArray *mBooklistObjets = [self.mKBookListArray objectAtIndex:indexPath.row];
    
    //NSLog(@"NSArray *mBooklistObjets ===> %i",mBooklistObjets.count);
    
    //    NSArray *mBooklistObjets = [self.dataArray objectAtIndex:indexPath.row];
    //
    //    NSLog(@"NSArray *mBooklistObjets ===> %i",mBooklistObjets.count);
    //
    //    //    [cell updateData:CGSizeMake(tableView.frame.size.width, 0) setArrayBooklistObjet:mBooklistObjets ];
    //    cell.delegate = self;
    
    [cell updateViewData:CGSizeMake(tableView.frame.size.width, 0)];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
