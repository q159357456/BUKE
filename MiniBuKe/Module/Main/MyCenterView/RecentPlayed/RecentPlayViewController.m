//
//  RecentPlayViewController.m
//  MiniBuKe
//
//  Created by chenheng on 2019/5/29.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "RecentPlayViewController.h"
#import "XYDMSetting.h"
#import "ListenerCollectCell.h"
#import "MusicPlayTool.h"
#import "NoDataBackView.h"
@interface RecentPlayViewController ()<UITableViewDelegate, UITableViewDataSource,MusicPlayToolDelegate>
@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIView *middleView;
@property(nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) UIButton *itemButton;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray * dataArray;
@property(nonatomic,strong) MusicPlayTool *playTool;
@property(nonatomic,assign)NSIndexPath * path;
@property(nonatomic,strong) NoDataBackView *backView;
@end

@implementation RecentPlayViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
    FHWeakSelf;
    [XYDMSetting getAllRecentlyPlayCallback:^(NSArray * _Nonnull data) {

        if (!data.count) {
            dispatch_async(dispatch_get_main_queue(), ^{
                  [weakSelf showNoDataImage];
            });
        }else
        {
            weakSelf.dataArray = data;
            [weakSelf.tableView reloadData];
        }
     
    }];
    _playTool = [MusicPlayTool shareMusicPlay];
    _playTool.delegat = self;
    // Do any additional setup after loading the view.

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
    
//    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - bottomView_height, self.view.frame.size.width, bottomView_height)];
    //[_bottomView setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:_bottomView];
    
    _middleView = [[UIView alloc] initWithFrame:CGRectMake(0, _topView.frame.origin.y + _topView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _topView.frame.size.height - _bottomView.frame.size.height)];
    [_middleView setBackgroundColor:COLOR_STRING(@"#FFFFFF")];
    //    [_middleView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:_middleView];
    
    
    NSLog(@" %f == %f",self.view.frame.size.height,self.view.frame.size.width);
    
    [self createTopViewChild];
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
    
//    [self.itemButton setTitle:@"管理" forState:UIControlStateNormal];
//    [self.itemButton.titleLabel setFont:MY_FONT(18)];
//    [self.itemButton setAdjustsImageWhenHighlighted:NO];
    //[_moveButton setTitleColor:COLOR_STRING(@"#FFD1C7") forState:UIControlStateNormal];
    
    [_topView addSubview:self.itemButton];
}
-(void) createMiddleViewChild
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height - 73) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_middleView addSubview:self.tableView];
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"ListenerCollectCell";
    ListenerCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [ListenerCollectCell xibTableViewCell];
    }
    [cell updateViewData:CGSizeMake(tableView.frame.size.width, 0)];
    XYDMCustomMusicPlayModel * model = self.dataArray[indexPath.row];
    [cell loadData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 77;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UILabel *label = [cell.contentView viewWithTag:1];
    label.text = [@(indexPath.row + 1) stringValue];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.path.row != indexPath.row) {
        if (self.path)
        {
            XYDMCustomMusicPlayModel * oldModel = self.dataArray[self.path.row];
            oldModel.isPlaying = NO;
        }
    }
     XYDMCustomMusicPlayModel * model = self.dataArray[indexPath.row];
     model.isPlaying  = !model.isPlaying;
     [self.tableView reloadData];

     self.path = indexPath;
     [self play:model];
}

-(void)play:(XYDMCustomMusicPlayModel*)model{
   
    if (model.isPlaying)
    {
        [MusicPlayTool shareMusicPlay].urlString = model.musicUrl;
        
        [[MusicPlayTool shareMusicPlay] musicPrePlay];
    }else
    {
        
        [[MusicPlayTool shareMusicPlay] musicPause];
    }
}
#pragma mark - MusicPlayToolDelegate
-(void)endOfPlayAction
{
     NSInteger index = self.path.row;
     if (self.dataArray.count>=index+1) {
         NSIndexPath * newPath = [NSIndexPath indexPathForRow:index+1 inSection:0];
         [self tableView:self.tableView didSelectRowAtIndexPath:newPath];
     }else
     {
         NSIndexPath * newPath = [NSIndexPath indexPathForRow:0 inSection:0];
         [self tableView:self.tableView didSelectRowAtIndexPath:newPath];
     }

}
-(IBAction)backButtonClick:(id)sender
{
    [[MusicPlayTool shareMusicPlay] musicPause];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showNoDataImage
{
  
        CGRect imageBound = CGRectMake(0, 0, 375, 180);
        UIImage *backImage;
        NSString *title = @"";
        backImage = [UIImage imageNamed:@"noData_recentPlay"];
        title = @"暂无播放,快去听听最精彩的故事吧!";
            
        self.backView = [[NoDataBackView alloc] initWithImageBound:imageBound WithImage:backImage WithTitle:title];
        [self.tableView addSubview:self.backView];
    
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
