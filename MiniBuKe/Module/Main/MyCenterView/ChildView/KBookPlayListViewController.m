//
//  KBookPlayListViewController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/27.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "KBookPlayListViewController.h"
#import "KBookTableViewCell.h"
#import "KBookListService.h"
#import "KBookBottomView.h"

#define bottomView_height 0

@interface KBookPlayListViewController ()<UITableViewDelegate, UITableViewDataSource,KBookTableViewCellDelegate>

@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIView *middleView;
@property(nonatomic,strong) UIView *bottomView;

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) NSArray *dataArray;

@property(nonatomic,strong) KBookBottomView *mKBookBottomView;

@end

@implementation KBookPlayListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
}

-(void) onClickRightCell:(KbookListObject *) obj
{
    NSLog(@"===> onClickRightCell <===");
//    if (self.mKBookBottomView.isHidden) {
//        self.mKBookBottomView.hidden = NO;
//    } else {
//        self.mKBookBottomView.hidden = YES;
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideBarStyle];
    
    [self onKBookListService];
}

-(void)onKBookListService
{
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"KBookListService ==> OnSuccess");
        KBookListService *service = (KBookListService*) httpInterface;
        if (service.dataArray != nil && service.dataArray.count > 0) {
            self.dataArray = service.dataArray;
//            [self arrangeBookList];
            if (self.tableView != nil) {
                [self.tableView reloadData];
            }
        }
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"KBookListService ==> OnError");
    };
    
    KBookListService *service = [[KBookListService alloc] init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token setPage:@"1" setPageNum:@"200"];
    [service start];
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
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_middleView addSubview:self.tableView];
    
    self.mKBookBottomView = [KBookBottomView xibView];
    self.mKBookBottomView.frame = CGRectMake(0, self.view.frame.size.height - 73 - self.mKBookBottomView.frame.size.height, self.view.frame.size.width, self.mKBookBottomView.frame.size.height);
    [_middleView addSubview:self.mKBookBottomView];
    self.mKBookBottomView.hidden = YES;
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
    titleLabel.text = @"K绘本";
    titleLabel.font = MY_FONT(19);
    titleLabel.textColor = COLOR_STRING(@"#2f2f2f");
    [_topView addSubview: titleLabel];
}

-(IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KBookTableViewCell_Height;
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
    static NSString *reuseIdentifier = @"KBookTableViewCell";
    KBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [KBookTableViewCell xibTableViewCell];
    }
    cell.delegate = self;
    KbookListObject *mKbookListObject = [self.dataArray objectAtIndex:indexPath.row];
    [cell updateData:mKbookListObject];
    
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.mKBookBottomView.hidden = YES;
}

@end
