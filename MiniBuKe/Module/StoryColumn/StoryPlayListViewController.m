//
//  StoryPlayListViewController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/14.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "StoryPlayListViewController.h"
#import "StoryPlayListViewCell.h"
#import "StoryPlayListService.h"
#import "StoryPlayListModel.h"
#import "MusicPlayTool.h"
#import "StoryManagerViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "SendAudioToRobotSerive.h"
#import "StoryCollectService.h"
#import "StoryCollectListService.h"
#import "RobotIsOnlineService.h"
#import "MBProgressHUD+XBK.h"
#import "BindMaskViewController.h"
#import "AudioCachModel.h"
#import "NoDataBackView.h"
#import "BKRobotBindTipCtr.h"
#import "XYDMPlaySoruceManage.h"
#define FRAME_WIDTH   self.view.frame.size.width
#define FRAME_HEIGHT  self.view.frame.size.height
#define PAGE_NUM    10
#define PUSHTAG     10000
#define CACH_SIZE   50.0
#import "BKCameraManager.h"
@interface StoryPlayListViewController ()<UITableViewDelegate,UITableViewDataSource,MusicPlayToolDelegate>

@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIView *middleView;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIView *bottomView;

@property(nonatomic,strong) UIImageView *playAllImg;
@property(nonatomic,strong) UIImageView *managerImg;

@property(nonatomic,strong) NSMutableArray *playList;
@property(nonatomic,assign) NSInteger page;

@property(nonatomic,strong) NSMutableArray *selectes;//记录cell 有没有被选中 (点击播放故事)

//播放器显示相关
@property(nonatomic,strong) UILabel *playNameLabel;// 界面取消
@property(nonatomic,strong) UILabel *serialNameLabel;
@property(nonatomic,strong) MusicPlayTool *playTool;

@property(nonatomic,assign) NSInteger index;//记录点击播放下标

@property(nonatomic,strong) NSMutableArray *recentPlayArray;

@property(nonatomic,assign) BOOL isAllPlay;

@property(nonatomic,strong) NSMutableArray *cachMutableArray;//缓存下载音频文件本地path

@property(nonatomic,strong) NoDataBackView *backView;

@end

@implementation StoryPlayListViewController

-(NSMutableArray *)playList
{
    if (!_playList) {
        _playList = [NSMutableArray array];
    }
    
    return _playList;
}

-(NSMutableArray *)cachMutableArray
{
    if (!_cachMutableArray) {
        _cachMutableArray = [NSMutableArray array];
    }
    
    return _cachMutableArray;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
//        self.playList = [NSMutableArray array];
        _selectes = [NSMutableArray array];
        
        //从本地获取
        
        NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"recent_UserID"];
        if (userId == nil) {
            NSData *readData = [[NSUserDefaults standardUserDefaults] objectForKey:@"recentPlay"];
            NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:readData];
            if (array.count >0) {
                _recentPlayArray = [NSMutableArray arrayWithArray:array];
            }else{
                _recentPlayArray = [NSMutableArray array];
            }
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"recentPlay"];
            [[NSUserDefaults standardUserDefaults] setObject:APP_DELEGATE.mLoginResult.userId forKey:@"recent_UserID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else{
            if( [[NSString stringWithFormat:@"%@",APP_DELEGATE.mLoginResult.userId] isEqualToString:[NSString stringWithFormat:@"%@",userId]]){
                NSData *readData = [[NSUserDefaults standardUserDefaults] objectForKey:@"recentPlay"];
                NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:readData];
                if (array.count > 0) {
                    _recentPlayArray = [NSMutableArray arrayWithArray:array];
                }else{
                    _recentPlayArray = [NSMutableArray array];
                }
            }else{
                _recentPlayArray = [NSMutableArray array];
                
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_recentPlayArray];
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"recentPlay"];
                [[NSUserDefaults standardUserDefaults] setObject:APP_DELEGATE.mLoginResult.userId forKey:@"recent_UserID"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initView];
    
    NSData *cachData = [[NSUserDefaults standardUserDefaults] objectForKey:@"storyAudioCach"];
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:cachData];
    if (array.count > 0) {
        self.cachMutableArray = [NSMutableArray arrayWithArray:array];
    }else{
        self.cachMutableArray = [NSMutableArray array];
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = NO;

    _playTool = [MusicPlayTool shareMusicPlay];
    _playTool.delegat = self;
    
    self.statusView.backgroundColor = COLOR_STRING(@"#FFFFFF");
    self.navigationController.navigationBar.backgroundColor = COLOR_STRING(@"#FFFFFF");
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.playList removeAllObjects];
    [self headerRereshing];
    [self initNaviBar];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    //移除播放
    [self play_pause];
    _playTool.delegat = nil;
    _playTool = nil;
    
    [self resetSelectedArrayState];
    
    [self deleteLocalCach];
}

-(void)resetSelectedArrayState
{
    //重新归置selects 播放栏不选中状态
    for (int i = 0; i < _selectes.count; i++) {
        NSNumber *num = _selectes[i];
        if ([num isEqualToNumber:@(1)]) {
            num = @(0);
            [_selectes replaceObjectAtIndex:i withObject:num];
        }
    }
    [self.tableView reloadData];
}

-(void)initView
{
    [self initTopView];
    
    [self initMiddleView];
    
    [self initTableView];
    
    [self initNaviBar];
}

-(void)initNaviBar
{

    [self.leftButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateNormal];
    [self.leftButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateSelected];
    [self.leftButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.sourceType == StoryPlaySourceType_PlayList) {
        self.titleLabel.text = @"播放列表";
        _topView.backgroundColor = COLOR_STRING(@"#FFFFFF");
        self.statusView.backgroundColor = COLOR_STRING(@"FFFFFF");
        self.navigationController.navigationBar.backgroundColor = COLOR_STRING(@"#FFFFFF");
        
    }else if (self.sourceType == StoryPlaySourceType_Collect){
        self.statusView.backgroundColor = COLOR_STRING(@"FFFFFF");
        self.navigationController.navigationBar.backgroundColor = COLOR_STRING(@"#FFFFFF");
        _topView.backgroundColor = COLOR_STRING(@"#FFFFFF");
        self.titleLabel.text = @"听听收藏";
        self.topView.hidden = YES;
        self.middleView.frame = CGRectMake(0, _topView.frame.origin.y + 0, FRAME_WIDTH, 0);
        self.tableView.frame = CGRectMake(0, _middleView.frame.origin.y + _middleView.frame.size.height, FRAME_WIDTH, FRAME_HEIGHT - _middleView.frame.origin.y - _middleView.frame.size.height);
        
//        UIButton *leftbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
//
//        //[leftbutton setBackgroundColor:[UIColor blackColor]];
//        [leftbutton addTarget:self action:@selector(storyManager:) forControlEvents:UIControlEventTouchUpInside];
//        [leftbutton setTitle:@"管理" forState:UIControlStateNormal];
//
//        UIBarButtonItem *rightitem = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
//
//        self.navigationItem.rightBarButtonItem = rightitem;
        
        [self.rightButton setTitle:@"管理" forState:UIControlStateNormal];
        [self.rightButton setTitleColor:COLOR_STRING(@"#2f2f2f") forState:UIControlStateNormal];
        self.rightButton.titleLabel.font = MY_FONT(17);
        [self.rightButton addTarget:self action:@selector(storyManager:) forControlEvents:UIControlEventTouchUpInside];
        
    }else if (self.sourceType == StoryPlaySourceType_Recent){
        _topView.backgroundColor = COLOR_STRING(@"#FFFFFF");
        self.statusView.backgroundColor = COLOR_STRING(@"FFFFFF");
        self.navigationController.navigationBar.backgroundColor = COLOR_STRING(@"#FFFFFF");
        
        self.titleLabel.text = @"最近播放";
        self.topView.hidden = YES;
        self.middleView.frame = CGRectMake(0, _topView.frame.origin.y + 0, FRAME_WIDTH, 0);
        self.tableView.frame = CGRectMake(0, _middleView.frame.origin.y + _middleView.frame.size.height, FRAME_WIDTH, FRAME_HEIGHT - _middleView.frame.origin.y - _middleView.frame.size.height);
        
        
        [self.rightButton setTitle:@"管理" forState:UIControlStateNormal];
        self.rightButton.titleLabel.font = MY_FONT(17);
        [self.rightButton addTarget:self action:@selector(storyManager:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightButton setTitleColor:COLOR_STRING(@"#2f2f2f") forState:UIControlStateNormal];
    }
}

-(void)backButtonClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initTopView
{
    //根据屏幕尺寸 调整高度 -- 以6高度为基准
    CGFloat topH = 136;
    _topView = [[UIView alloc]init];
    _topView.frame = CGRectMake(0, Height_NavBar, FRAME_WIDTH, phResizeHeight(topH));
    _topView.backgroundColor = COLOR_STRING(@"#FFFFFF");
    self.titleColor = COLOR_STRING(@"#2f2f2f");
    [self.view addSubview:_topView];
    
    UIImageView *titleImageView = [[UIImageView alloc]init];
    [titleImageView sd_setImageWithURL:[NSURL URLWithString:[self.listModel.picUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"place_kidbook_c"]];
    
    [_topView addSubview:titleImageView];
    [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(10);
        make.left.with.offset(15);
        make.size.mas_equalTo(CGSizeMake(phResizeWidth(100), phResizeWidth(100)));
    }];
    
    titleImageView.layer.cornerRadius = 100/9.9;
    titleImageView.layer.masksToBounds = YES;
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = COLOR_STRING(@"#2f2f2f");
    titleLabel.font = MY_FONT(18);
    titleLabel.text = self.listModel.name?:@"小王芝士蛋糕子";
    [_topView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleImageView.mas_right).with.offset(15);
        make.top.equalTo(titleImageView).with.offset(12);
        make.right.mas_equalTo(_topView.mas_right).with.offset(-10);
    }];
    [titleLabel sizeToFit];
    
    UILabel *totalTimeLabel = [[UILabel alloc]init];
    totalTimeLabel.font = MY_FONT(14);
    totalTimeLabel.textColor = COLOR_STRING(@"#2f2f2f");

    NSLog(@"self.listModel.sumTime ===> %@",self.listModel.sumTime);
    totalTimeLabel.text = self.listModel.sumTime?:@"12:45";
    [_topView addSubview:totalTimeLabel];
    [totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(15);
    }];
    [totalTimeLabel sizeToFit];
    
    UILabel *pageCountLabel = [[UILabel alloc]init];
    pageCountLabel.font = MY_FONT(14);
    pageCountLabel.textColor = COLOR_STRING(@"#2f2f2f");
    NSInteger pageCount = self.listModel.storyCount?:0;
    pageCountLabel.text = [NSString stringWithFormat:@"%ld 集",pageCount];
    [_topView addSubview:pageCountLabel];
    [pageCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(totalTimeLabel);
        make.top.mas_equalTo(totalTimeLabel.mas_bottom).offset(15);
    }];
}

-(void)initMiddleView
{
    _middleView = [[UIView alloc]initWithFrame:CGRectMake(0, _topView.frame.origin.y + _topView.frame.size.height, FRAME_WIDTH, 50)];
    _middleView.backgroundColor = COLOR_STRING(@"#FFFFFF");
    [self.view addSubview:_middleView];
    
    UIImageView *playAllImg = [[UIImageView alloc]init];
    playAllImg.frame = CGRectMake(14, (_middleView.frame.size.height - 24)*0.5, 24, 24);
    playAllImg.userInteractionEnabled = YES;
    playAllImg.image = [UIImage imageNamed:@"playList_allPlay"];
    self.playAllImg = playAllImg;
    [_middleView addSubview:playAllImg];
    
    UILabel *playAllLabel = [[UILabel alloc]init];
    playAllLabel.frame = CGRectMake(playAllImg.frame.origin.x + playAllImg.frame.size.width + 8, (_middleView.frame.size.height - 15)*0.5, 60, 15);
    playAllLabel.textColor = COLOR_STRING(@"#202020");
    playAllLabel.font = MY_FONT(16);
    playAllLabel.text = @"全部播放";
    [playAllLabel sizeToFit];
    [_middleView addSubview:playAllLabel];
    
    UIButton *playAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playAllButton.frame = CGRectMake(14, (_middleView.frame.size.height - 24)*0.5, 24 + 60 + 8, 24);
    [playAllButton addTarget:self action:@selector(playAllSong:) forControlEvents:UIControlEventTouchUpInside];
    [_middleView addSubview:playAllButton];
    
    UILabel *managerLabel = [[UILabel alloc]init];
    managerLabel.frame = CGRectMake(_middleView.frame.size.width - 30 - 20, (_middleView.frame.size.height - 15)*0.5, 30, 15);
    managerLabel.text = @"管理";
    managerLabel.textColor = COLOR_STRING(@"#212121");
    managerLabel.font = MY_FONT(16);
    [managerLabel sizeToFit];
    [_middleView addSubview:managerLabel];
    managerLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *labelTapGestureRecognizer2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(storyManager:)];
    [managerLabel addGestureRecognizer:labelTapGestureRecognizer2];
    
    UIImageView *managerImg = [[UIImageView alloc]init];
    managerImg.frame = CGRectMake(managerLabel.frame.origin.x - 24 - 6, (_middleView.frame.size.height - 24)*0.5, 24, 24);
    managerImg.image = [UIImage imageNamed:@"playList_group"];
    managerImg.userInteractionEnabled = YES;
    self.managerImg = managerImg;
    [_middleView addSubview:managerImg];
    
    UIButton *managerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    managerButton.frame = CGRectMake(managerImg.frame.origin.x, (_middleView.frame.size.height - 24)*0.5, 24 + 30 + 6, 24);
    [managerButton addTarget:self action:@selector(storyManager:) forControlEvents:UIControlEventTouchUpInside];
    [_middleView addSubview:managerButton];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, _middleView.frame.size.height - 1, _middleView.frame.size.width, 1)];
    line.backgroundColor = COLOR_STRING(@"#D3D3D3");
    [_middleView addSubview:line];
}

-(void)initTableView
{
    //底下的播放器 不要了
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _middleView.frame.origin.y + _middleView.frame.size.height, FRAME_WIDTH, FRAME_HEIGHT - _middleView.frame.origin.y - _middleView.frame.size.height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = COLOR_STRING(@"#FFFFFF");
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    if (self.sourceType != StoryPlaySourceType_Recent) {
        [self setupRefresh];
    }
}

-(void)initBottomView
{
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, FRAME_HEIGHT - 68, FRAME_WIDTH, 68)];
    _bottomView.backgroundColor = COLOR_STRING(@"#FFFFFF");
    [self.view addSubview:_bottomView];
    
    UIImageView *icon = [[UIImageView alloc]init];
    [_bottomView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(48, 48));
        make.left.equalTo(_bottomView).with.offset(10);
        make.centerX.equalTo(_bottomView);
    }];
    
    UILabel *playNameLabel = [[UILabel alloc]init];
    playNameLabel.textColor = COLOR_STRING(@"#202020");
    playNameLabel.font = MY_FONT(16);
    playNameLabel.text = @"马克与彩丽的故事";//待传值
    [_bottomView addSubview:playNameLabel];
    [playNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(icon.mas_right).with.offset(10);
        make.top.equalTo(icon).with.offset(8);
    }];
    [playNameLabel sizeToFit];
    self.playNameLabel = playNameLabel;
    
    UILabel *serialNameLabel = [[UILabel alloc]init];
    serialNameLabel.text = @"系列名称";//待传值
    serialNameLabel.font = MY_FONT(12);
    serialNameLabel.textColor = COLOR_STRING(@"#909090");
    [_bottomView addSubview:serialNameLabel];
    [serialNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(playNameLabel);
        make.top.mas_equalTo(playNameLabel.mas_bottom).with.offset(8);
    }];
    [serialNameLabel sizeToFit];
    self.serialNameLabel = serialNameLabel;
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [nextButton setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    [_bottomView addSubview:nextButton];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bottomView).with.offset(-20);
        make.centerX.equalTo(_bottomView);
        make.size.mas_equalTo(CGSizeMake(18, 16));
    }];
    
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [playButton setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    [_bottomView addSubview:playButton];
    [playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(nextButton.mas_left).with.offset(-34);
        make.centerX.equalTo(nextButton);
        make.size.mas_equalTo(CGSizeMake(12, 18));
    }];
    
    UIButton *frontButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [frontButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [frontButton setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    [_bottomView addSubview:frontButton];
    [frontButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(playButton.mas_left).with.offset(-34);
        make.centerX.equalTo(nextButton);
        make.size.equalTo(nextButton);
    }];
}

-(void)storyManager:(UIButton *)sender
{
    if (self.playList == nil || self.playList.count == 0) {
        [MBProgressHUD showText:@"没有数据需要管理"];
        return;
    }
    StoryManagerViewController *managerVC = [[StoryManagerViewController alloc]init];
    managerVC.dataArray = self.playList;
    managerVC.sourceType = self.sourceType;
    [self.navigationController pushViewController:managerVC animated:NO];
    
//    [self.view addSubview:managerVC.view];
}

#pragma mark - 刷新相关
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
    
    //移除播放
    [_playTool musicPause];
    _playTool = nil;
    
    [self.playTool musicPause];
    self.playTool = nil;
    [[MusicPlayTool shareMusicPlay] musicPause];
    [[MusicPlayTool shareMusicPlay] removeObserverStatus];
    [[MusicPlayTool shareMusicPlay].player replaceCurrentItemWithPlayerItem:nil];
    
    //"全部播放"按钮恢复默认
    self.playAllImg.image = [UIImage imageNamed:@"playList_allPlay"];
    self.isAllPlay = NO;
    [self play_pause];
    [self resetSelectedArrayState];
    
    //判断数据源,调用不同接口
    self.page = 1;
    if (self.sourceType == StoryPlaySourceType_PlayList) {
        [self getDataWithPage:1 PageNum:PAGE_NUM];//默认每次取10条数据
        
    }else if (self.sourceType == StoryPlaySourceType_Collect){
        [self getCollectListDataWithPage:1 PageNum:PAGE_NUM];//收藏故事列表
        
    }else if (self.sourceType == StoryPlaySourceType_Recent){
//        [self getRecentPlayData];
        [self showNoDataImage];//秦根
    }
}

-(void)footerRereshing
{
    self.page++;
    if (self.sourceType == StoryPlaySourceType_PlayList) {
        
        [self getMoreDataWithPage:self.page PageNum:PAGE_NUM];
    }else if (self.sourceType == StoryPlaySourceType_Collect){
        [self getMoreCollectListDataWithPage:self.page PageNum:PAGE_NUM];
    }else if (self.sourceType == StoryPlaySourceType_Recent){
        
    }
}

-(void)headEndRefresh
{
    if (self.tableView.visibleCells.count != 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    
    [self.tableView.mj_header endRefreshing];
}

-(void)getRecentPlayData
{
    if (self.playList.count > 0) {
        [self.playList removeAllObjects];
    }
    
    if (_selectes.count > 0) {
        [_selectes removeAllObjects];
    }
    
    NSArray *recentPlayArray;
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"recent_UserID"];
    if ([[NSString stringWithFormat:@"%@",APP_DELEGATE.mLoginResult.userId] isEqualToString:[NSString stringWithFormat:@"%@",userId]]) {
        //从本地获取
        NSData *readData = [[NSUserDefaults standardUserDefaults] objectForKey:@"recentPlay"];
        recentPlayArray = [NSKeyedUnarchiver unarchiveObjectWithData:readData];
    }else{
        recentPlayArray = [NSMutableArray array];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:recentPlayArray];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"recentPlay"];
        [[NSUserDefaults standardUserDefaults] setObject:APP_DELEGATE.mLoginResult.userId forKey:@"recent_UserID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if (recentPlayArray.count != 0) {
        
        self.rightButton.userInteractionEnabled = YES;
//        [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rightButton setTitleColor:COLOR_STRING(@"#2f2f2f") forState:UIControlStateNormal];

        
        self.playList = [NSMutableArray arrayWithArray:recentPlayArray];
        for (int i = 0; i < self.playList.count; i++) {
            [_selectes addObject:@(0)];//默认没有选中
        }
        
        if (self.playList.count < PAGE_NUM) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }else{
        //加载没有数据image
        [self showNoDataImage];
    }
    
    [self headEndRefresh];
}

-(void)showNoDataImage
{
    //"管理"按钮不能点击
    if (self.sourceType == StoryPlaySourceType_Recent || self.sourceType == StoryPlaySourceType_Collect) {
        self.rightButton.userInteractionEnabled = NO;
//        [self.rightButton setTitleColor:[UIColor colorWithHexStr:@"#FFFFFF" alpha:0.5] forState:UIControlStateNormal];
        [self.rightButton setTitleColor:COLOR_STRING(@"#2f2f2f") forState:UIControlStateNormal];

    }
    CGRect imageBound = CGRectMake(0, 0, 375, 180);
    UIImage *backImage;
    NSString *title = @"";
    if (self.backView == nil) {
        
        if (self.sourceType == StoryPlaySourceType_Recent) {
            
            backImage = [UIImage imageNamed:@"noData_recentPlay"];
            title = @"暂无播放,快去听听最精彩的故事吧!";
            
        }else if (self.sourceType == StoryPlaySourceType_Collect){
            
            backImage = [UIImage imageNamed:@"noData_collect"];
            title = @"快去挑选宝宝喜欢的故事,添加到收藏吧!";
        }
        
        self.backView = [[NoDataBackView alloc] initWithImageBound:imageBound WithImage:backImage WithTitle:title];
        [self.tableView addSubview:self.backView];
    }else{
        self.backView.hidden = NO;
    }
}

#pragma mark - 接口相关
-(void)getDataWithPage:(NSInteger)page PageNum:(NSInteger)pageNum
{
    void(^OnSuccess)(id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"StoryPlayListService ===> OnSuccess");
        
        [self displayDataBy:httpInterface];
    };
    
    void(^OnError)(NSInteger,NSString *) = ^(NSInteger httpInterface,NSString *description){
        NSLog(@"StoryPlayListService === > OnEoor");
        [self headEndRefresh];
    };
    
    //类型定为 2级
    StoryPlayListService *playListService = [[StoryPlayListService alloc]initWithCategoryId:self.listModel.storyId setToken:APP_DELEGATE.mLoginResult.token setType:@"2" setPage:page setPageNum:pageNum setOnSuccess:OnSuccess setOnError:OnError];
    [playListService start];
}

-(void)getCollectListDataWithPage:(NSInteger)page PageNum:(NSInteger)pageNum
{
//    void (^OnSuccess)(id,NSString *) = ^(id httpInterface,NSString *description){
//        NSLog(@"StoryCollectListService ===> OnSuccess");
//        [self displayDataBy:httpInterface];
//    };
//    void (^OnError)(NSInteger,NSString *) = ^(NSInteger httpInterface,NSString *description){
//        NSLog(@"StoryCollectListService ===> OnError");
//        [self headEndRefresh];
//    };
//
//    StoryCollectListService *collectListService = [[StoryCollectListService alloc]init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token setPage:[NSString stringWithFormat:@"%ld",page] setPageNum:[NSString stringWithFormat:@"%ld",pageNum]];
//    [collectListService start];
    MJWeakSelf;
    [XYDMPlaySoruceManage GetCollectResultPage:page PageNum:pageNum CallBack:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 1) {
            NSArray * array = (NSArray*)response[@"data"][@"list"];
            if (array.count) {
                [StoryPlayListModel getObjectList:response[@"data"][@"list"] CallBack:^(NSArray *array) {
                    [weakSelf displayDataBy:array];
                }];
            }else
            {
                 [weakSelf displayDataBy:@[]];
            }
           
        }else
        {
            [MBProgressHUD showError:response[@"msg"]];
        }
    }];
}

-(void)getMoreDataWithPage:(NSInteger)page PageNum:(NSInteger)pageNum
{
    void(^OnSuccess)(id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"StoryPlayListService ===> OnSuccess");
        
        [self displayFootDataBy:httpInterface];
        
    };
    
    void(^OnError)(NSInteger,NSString *) = ^(NSInteger httpInterface,NSString *description){
        NSLog(@"StoryPlayListService === > OnEoor");
        [self.tableView.mj_footer endRefreshing];
    };
    
    //类型定为 2级
    StoryPlayListService *playListService = [[StoryPlayListService alloc]initWithCategoryId:self.listModel.storyId setToken:APP_DELEGATE.mLoginResult.token setType:@"2" setPage:page setPageNum:pageNum setOnSuccess:OnSuccess setOnError:OnError];
    [playListService start];
}

-(void)getMoreCollectListDataWithPage:(NSInteger)page PageNum:(NSInteger)pageNum
{
//    void (^OnSuccess)(id,NSString *) = ^(id httpInterface,NSString *description){
//        NSLog(@"StoryCollectListService ===> OnSuccess");
//        [self displayFootDataBy:httpInterface];
//    };
//
//    void (^OnError) (NSInteger ,NSString *) = ^(NSInteger httpInterface, NSString *description){
//        NSLog(@"StoryCollectListService ===> OnError");
//    };
//
//    StoryCollectListService *collectListService = [[StoryCollectListService alloc]init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token setPage:[NSString stringWithFormat:@"%ld",page] setPageNum:[NSString stringWithFormat:@"%ld",pageNum]];
//    [collectListService start];
    MJWeakSelf;
    [XYDMPlaySoruceManage GetCollectResultPage:page PageNum:pageNum CallBack:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 1) {
            [StoryPlayListModel getObjectList:response[@"data"][@"list"] CallBack:^(NSArray *array) {
                   [weakSelf displayDataBy:array];
            }];
        }else
        {
            [MBProgressHUD showError:response[@"msg"]];
        }
    }];
}

-(void)robotIsOnlineServiceWithButton:(UIButton *)button
{
    
    void (^OnSuccess)(id,NSString *) = ^(id httpIterface,NSString *description){
        RobotIsOnlineService *service = (RobotIsOnlineService *)httpIterface;
        BOOL isOnline = service.isOnline;
        if (isOnline == YES) {
            [self pushAudioToRobotWithButton:button];
        }else{
            button.selected = NO;
            [MBProgressHUD showText:@"设备不在线"];
        }
    };
    
    void (^OnError)(NSInteger,NSString *) = ^(NSInteger httpInterface,NSString *description){
        button.selected = NO;
        [MBProgressHUD showText:description];
    };
    
    NSString *deviceId = APP_DELEGATE.mLoginResult.SN?:@"";
    if ([deviceId isEqualToString:@""]) {
        //跳转 绑定页面
//        [BindMaskViewController pushViewController];
        BKRobotBindTipCtr *ctr = [[BKRobotBindTipCtr alloc]init];
        [APP_DELEGATE.navigationController pushViewController:ctr animated:YES];
    }else{
        if(4 == [APP_DELEGATE.snData.type integerValue]){//babycare机型
            if ([BKCameraManager shareInstance].deviceState != DeviceContentStateType_onLine) {
                button.selected = NO;
                [[BKCameraManager shareInstance] ConnectDevice];
                [MBProgressHUD showText:@"设备不在线"];
            }else{
                
                StoryPlayListModel *listModel = [self.playList objectAtIndex:(button.tag - PUSHTAG)];
                NSString *audioStr = listModel.musicUrl.length?listModel.musicUrl:@"";
                NSArray *audioArray = [NSArray arrayWithObject:audioStr];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PUSHMUSIC-BabyCare" object:[audioArray mutableCopy]];
            }
            
        }else{
            RobotIsOnlineService *onlineService = [[RobotIsOnlineService alloc] initWithDeviceId:deviceId setToken:APP_DELEGATE.mLoginResult.token setOnSuccess:OnSuccess setOnError:OnError];
            [onlineService start];
        }
        
    }
}

-(void)pushAudioToRobotWithButton:(UIButton *)button
{
    //秦根改
    StoryPlayListModel *listModel = [self.playList objectAtIndex:(button.tag - PUSHTAG)];
    NSString *temp = listModel.musicId?[NSString stringWithFormat:@"%ld",(long)listModel.musicId]:listModel.musicUrl;
    NSArray *audioArray = @[temp];
    NSLog(@"推送数据===> %@",audioArray);
    FHWeakSelf;
    [XYDMPlaySoruceManage push:audioArray CallBack:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.001 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
                
                [MBProgressHUD showSuccess:@"推送成功"];
                StoryPlayListModel *listModel = [weakSelf.playList objectAtIndex:(button.tag - PUSHTAG)];
                listModel.isPush = NO;
                
                [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(button.tag - PUSHTAG) inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                
            });
     
        }else
        {
            button.selected = NO;
            [MBProgressHUD showError:response[@"msg"]];
            
        }
        
    }];
//    void(^OnSuccess)(id,NSString *) = ^(id httpInterface,NSString *description){
//        NSLog(@"SendAudioToRobotSerive ===> OnSuccess");
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.001 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
//
//            [MBProgressHUD showSuccess:@"推送成功"];
//            StoryPlayListModel *listModel = [self.playList objectAtIndex:(button.tag - PUSHTAG)];
//            listModel.isPush = NO;
//
//            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(button.tag - PUSHTAG) inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//
//        });
//
//    };
//    void(^OnError)(NSInteger,NSString *) = ^(NSInteger httpInterface,NSString *description){
//        NSLog(@"SendAudioToRobotSerive ===> OnError");
//        button.selected = NO;
//        [MBProgressHUD showError:@"推送失败"];
//    };
//
//    StoryPlayListModel *listModel = [self.playList objectAtIndex:(button.tag - PUSHTAG)];
//    NSString *audioStr = listModel.musicUrl;
//    NSArray *audioArray = [NSArray arrayWithObject:audioStr];
//    NSLog(@"audioArray===>%@",audioArray);
//    SendAudioToRobotSerive *robotService = [[SendAudioToRobotSerive alloc]init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token setAudioUrlList:audioArray];
//    [robotService start];
}

-(void)displayDataBy:(id)httpInterface
{
    if (self.playList.count > 0) {
        [self.playList removeAllObjects];
    }
    
    if (_selectes.count > 0) {
       [_selectes removeAllObjects];
    }
    
    if (self.sourceType == StoryPlaySourceType_PlayList) {
        
        StoryPlayListService *listSerice = httpInterface;
        if (listSerice.storyPlayList != nil) {
            
            self.playList = [NSMutableArray arrayWithArray:listSerice.storyPlayList];
        }
    }else if (self.sourceType == StoryPlaySourceType_Collect){
        
//        StoryCollectListService *collectListService = httpInterface;
        NSArray *array = (NSArray*)httpInterface;
        if (array.count) {
            
            self.rightButton.userInteractionEnabled = YES;
//            [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.rightButton setTitleColor:COLOR_STRING(@"#2f2f2f") forState:UIControlStateNormal];

            self.playList = [NSMutableArray arrayWithArray:array];
        }else{
            //加载无数据image
            [self showNoDataImage];
        }
    }
    
    if (self.playList.count != 0) {
        for (int i = 0; i < self.playList.count; i++) {
            [_selectes addObject:@(0)];//默认没有选中
        }
        
        if (self.playList.count < PAGE_NUM) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    [self headEndRefresh];
}

-(void)displayFootDataBy:(id)httpInterface
{
    NSArray *temArray = [NSArray array];
    if (self.sourceType == StoryPlaySourceType_PlayList) {
        
        StoryPlayListService *listSerice = httpInterface;
        if (listSerice.storyPlayList != nil) {
            temArray = listSerice.storyPlayList;
        }
    }else if (self.sourceType == StoryPlaySourceType_Collect){
        
        StoryCollectListService *collectListService = httpInterface;
        if (collectListService.dataArray != nil) {
            temArray = collectListService.dataArray;
        }
    }else if (self.sourceType == StoryPlaySourceType_Recent){
        
    }
    
    if (temArray.count != 0) {
        for (int i = 0; i < temArray.count; i++) {
            [_selectes addObject:@(0)];//新增加的默认没有选中
        }
        
        [self.playList addObjectsFromArray:temArray];
        
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

-(void)pushVoiceToRobotWithButton:(UIButton *)button
{
    //先检测 小布壳是否在线
    [self robotIsOnlineServiceWithButton:button];
}

-(void)collectByNetWithType:(NSInteger )type WithButton:(UIButton *)sender
{
    //秦根改
    StoryPlayListModel *listModel = [self.playList objectAtIndex:sender.tag];
    FHWeakSelf;
    [XYDMPlaySoruceManage collectStorylist:@[@(listModel.oj_id)] CallBack:^(NSDictionary * _Nonnull response) {
        
        if ([response[@"code"] integerValue] == 1) {
            
            [MBProgressHUD showSuccess:@"取消收藏成功"];
            [weakSelf.playList removeObject:listModel];
            [weakSelf.tableView reloadData];
         ;
        }else
        {
            [MBProgressHUD showError:response[@"msg"]];
            
        }
    }];
//    void(^OnSuccess)(id,NSString *) = ^(id httpInterface,NSString *description){
//        NSLog(@"StoryCollectService ===> OnSuccess");
//
//        StoryPlayListModel *listModel = [self.playList objectAtIndex:sender.tag];
//        if (self.sourceType == StoryPlaySourceType_Collect) {
//            //故事收藏列表 直接删除
//            [self.playList removeObject:listModel];
//            [self.tableView reloadData];
//        }else{
//            if (type == 0) {
//                listModel.isCollected = YES;
//            }else{
//                listModel.isCollected = NO;
//            }
//
//            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//        }
//    };
//
//    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description){
//        NSLog(@"StoryCollectService ==> OnError");
//        if (type == 0) {
//            sender.selected = NO;
//        }else{
//            sender.selected = YES;
//        }
//        [[[BKLoginCodeTip alloc]init] AddTextShowTip:description and:self.view];
//    };
//
//    StoryPlayListModel *listModel = [self.playList objectAtIndex:sender.tag];
//    NSString *storyId = [NSString stringWithFormat:@"%ld",listModel.musicId];//若是多个id 以,隔开
//    StoryCollectService *collectService = [[StoryCollectService alloc]initWithUerToken:APP_DELEGATE.mLoginResult.token setStoryId:storyId setType:type setOnSuccess:OnSuccess setOnError:OnError];
//
//    [collectService start];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.playList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    StoryPlayListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[StoryPlayListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    StoryPlayListModel *listModel = self.playList[indexPath.row];
//    NSLog(@"listModel.musicId===>%ld",listModel.musicId);
    cell.isSelected = _selectes[indexPath.row];
    cell.playModel = listModel;
    
    
    cell.playButton.tag = indexPath.row;
    [cell.playButton addTarget:self action:@selector(clickPlay:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.collectButton.tag = indexPath.row;
    cell.collectButton.selected = listModel.isCollected;
    [cell.collectButton addTarget:self action:@selector(clickCollect:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.pushButton.tag = indexPath.row + PUSHTAG;
    cell.pushButton.selected = listModel.isPush;
    [cell.pushButton addTarget:self action:@selector(clickPush:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [cell setCellWithStoryPlayListModel:listModel setStoryPlaySourceType:self.sourceType];
    
    return cell;
}

#pragma mark - UITableViewDelegate
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self updateCellClickState:indexPath];
    
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.sourceType == StoryPlaySourceType_PlayList) {
        return 60;
    }else if (self.sourceType == StoryPlaySourceType_Collect){
        return 77;
    }else if (self.sourceType == StoryPlaySourceType_Recent){
        return 77;
    }
    return 60;
}

-(void)updateCellClickState:(NSIndexPath *)indexPath
{
    //替换cell点击状态
    if ([_selectes[indexPath.row] isEqualToNumber:@(0)]) {
        //有且仅有1个cell 是选中状态
        for (int i = 0; i < _selectes.count; i++) {
            NSNumber *num = _selectes[i];
            if (i == indexPath.row) {
                num = @(1);
            }else{
                num = @(0);
            }
            
            [_selectes replaceObjectAtIndex:i withObject:num];
        }
    }else{
        [_selectes replaceObjectAtIndex:indexPath.row withObject:@(0)];
    }
    
    self.index = indexPath.row;
    [self.tableView reloadData];
    
}

-(void)setIndex:(NSInteger)index
{
    _index = index;
    
    if ([_selectes containsObject:@(1)]) {
        [self p_play];
    }else{
        [self play_pause];
    }
}

-(void)p_play
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        StoryPlayListModel *playModel = self.playList[self.index];
        if (playModel.musicUrl && playModel.musicUrl.length>0) {
            [MusicPlayTool shareMusicPlay].urlString = playModel.musicUrl;
            
            [[MusicPlayTool shareMusicPlay] musicPrePlay];
        }else
        {
            [MBProgressHUD showError:@"音频错误"];
            
        }

        return ;//秦根改
        
        if (self.cachMutableArray.count > 0) {
            for (AudioCachModel *cachmodel in self.cachMutableArray) {
                if ([playModel.musicUrl isEqualToString:cachmodel.urlString]) {
                    //先拼接路径
                    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
                    NSString *urlStr = [NSString stringWithFormat:@"%@%@",path,cachmodel.localPath];
                    [MusicPlayTool shareMusicPlay].urlString = urlStr;
                    break;
                }
            }
        }
        
        
        
        //将播放的音乐 放入最近播放数组中记录
        //根据歌曲名判断是否已存在歌曲
        BOOL isExist = NO;
        for (StoryPlayListModel *recentModel in _recentPlayArray) {
            
            if ([playModel.musicName isEqualToString:recentModel.musicName]) {
                isExist = YES;
                break;
            }
        }
        
        if (isExist == NO) {
            //添加到数组首个
            [_recentPlayArray insertObject:playModel atIndex:0];
        }
        
//        if (![_recentPlayArray containsObject:playModel]) {
//            [_recentPlayArray addObject:playModel];
//        }
        
        //保存本地
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_recentPlayArray];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"recentPlay"];
        [[NSUserDefaults standardUserDefaults] setObject:APP_DELEGATE.mLoginResult.userId forKey:@"recent_UserID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        

        if ([[MusicPlayTool shareMusicPlay].urlString isEqualToString:playModel.musicUrl]) {
            [self downloadMusicWithUrl:playModel.musicUrl];
        }
        
    });
    
}

-(void)play_pause
{
    // 根据AVPlayer的rate判断.
//    if ([MusicPlayTool shareMusicPlay].player.rate == 0) {
//        [[MusicPlayTool shareMusicPlay] musicPlay];
//    }else{
//        [[MusicPlayTool shareMusicPlay] musicPause];
//    }
    
    [[MusicPlayTool shareMusicPlay] musicPause];
    [[MusicPlayTool shareMusicPlay] removeObserverStatus];
    [[MusicPlayTool shareMusicPlay].player replaceCurrentItemWithPlayerItem:nil];
    [MusicPlayTool shareMusicPlay].delegat = nil;
}

//全部播放
-(void)playAllSong:(UIButton *)button
{
    if(self.playList == nil || self.playList.count == 0){
        return;
    }
    button.selected = !button.selected;
    
    if (button.selected == YES) {
        self.playAllImg.image = [UIImage imageNamed:@"playList_allPause"];
        self.isAllPlay = YES;
//        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
         [self updateCellClickState:[NSIndexPath indexPathForRow:0 inSection:0]];
    }else{
        self.playAllImg.image = [UIImage imageNamed:@"playList_allPlay"];
        self.isAllPlay = NO;
        [self play_pause];
        [self resetSelectedArrayState];
        [self.tableView reloadData];
    }
}

-(void)clickPlay:(UIButton *)button
{
    button.selected = !button.selected;
    NSIndexPath *path = [NSIndexPath indexPathForRow:button.tag inSection:0];
//    [self tableView:self.tableView didSelectRowAtIndexPath:path];
    [self updateCellClickState:path];
}

-(void)clickCollect:(UIButton *)button
{
    NSInteger type; // 0: 收藏  1:取消收藏
    if (button.selected == NO) {
        type = 0;
    }else{
        type = 1;
    }
    
    [self collectByNetWithType:type WithButton:button];
}

-(void)clickPush:(UIButton *)button
{
    button.selected = !button.selected;
    
    if (button.selected == YES) {
        [self pushVoiceToRobotWithButton:button];
    }
}

#pragma mark - MusicPlayToolDelegate
//播放结束,自动进行播放下一首
-(void)endOfPlayAction
{
    if (self.isAllPlay == YES) {
        [self playNext];
    }else{
        //单首歌曲播放完成后,重置cell状态
        [self resetSelectedArrayState];
    }
}

-(void)playNext
{
    NSInteger integer = self.index + 1;
    if (integer > self.playList.count - 1) {
        [self play_pause];
        return;
    }
    
//    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:integer inSection:0]];
    [self updateCellClickState:[NSIndexPath indexPathForRow:integer inSection:0]];
}

-(void)downloadMusicWithUrl:(NSString *)urlString
{
    AudioCachModel *cachModel = [[AudioCachModel alloc] init];
    cachModel.urlString = urlString;
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *storyMusic = [[paths firstObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"/storyMusic"]];
    if (![self isFileExit:storyMusic]) {
        [self createPath:storyMusic];
    }
    NSLog(@"avatar--->path:%@",storyMusic);
    
    NSArray *componentArray = [urlString componentsSeparatedByString:@"/file/"];
    NSString *name = componentArray.count > 0 ? [componentArray lastObject] : @"";
    
    if ([name isEqualToString:@""]) {
        
        return;//下载的url 格式有问题
    }
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",storyMusic,name];
    
    NSLog(@"storyMusic--->filePath:%@",filePath);
    
    
    BOOL result = [data writeToFile:filePath atomically:YES];
    if (result == YES) {
        NSLog(@"下载音频成功");
        NSString *localPath = [NSString stringWithFormat:@"%@%@",@"/storyMusic/",name];
        cachModel.localPath = localPath;
        [self.cachMutableArray addObject:cachModel];
        
        //保存磁盘
        NSData *cachData = [NSKeyedArchiver archivedDataWithRootObject:self.cachMutableArray];
        [[NSUserDefaults standardUserDefaults] setObject:cachData forKey:@"storyAudioCach"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//检测文件是否存在
-(BOOL)isFileExit:(NSString*)path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

-(void)createPath:(NSString*)path
{
    if (![self isFileExit:path]) {
        NSFileManager * fileManager = [NSFileManager defaultManager];
        NSString * parentPath = [path stringByDeletingLastPathComponent];
        if ([self isFileExit:parentPath]) {
            NSError * error;
            [fileManager createDirectoryAtPath:path withIntermediateDirectories:path attributes:nil error:&error];
        }else{
            [self createPath:parentPath];
            [self createPath:path];
        }
    }
}

-(void)deleteLocalCach
{
//    __block long long folderSize = 0;
    long long folderSize = 0;
    
    if (self.cachMutableArray.count > 0) {
        
        NSArray *temArray = [NSArray arrayWithArray:self.cachMutableArray];
        
        for (AudioCachModel *cachModel in temArray) {
            folderSize += [self fileSizeAtPath:cachModel.localPath];
            if ((folderSize / (1024.0 * 1024.0)) > CACH_SIZE){
                AudioCachModel *model = [self.cachMutableArray firstObject];
                
                [self deletePath:model.localPath];
                [self.cachMutableArray removeObject:model];
            }
        }

    }
    
    //保存磁盘
    NSData *cachData = [NSKeyedArchiver archivedDataWithRootObject:self.cachMutableArray];
    [[NSUserDefaults standardUserDefaults] setObject:cachData forKey:@"storyAudioCach"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//单个文件大小
- (long long)fileSizeAtPath:(NSString*) filePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    
    return 0;
}

-(void)deletePath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isHave = [self isFileExit:path];
    if (!isHave) {
        return;
    }else {
        BOOL dele = [fileManager removeItemAtPath:path error:nil];
        if (dele) {
            NSLog(@"deleteSuccess");
        }else{
            NSLog(@"deleteError");
        }
    }
}

-(void)dealloc
{

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
