//
//  KBookListViewController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/6/27.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "KBookListViewController.h"
#import "KBookListCell.h"
#import "KBookListService.h"
#import "KBookListModel.h"
#import "KBookDeleteService.h"

#import "KBookViewController.h"
#import "MusicPlayTool.h"
#import <MJRefresh.h>
#import "NoDataBackView.h"

#define PAGENUM 10

@interface KBookListViewController ()<UITableViewDelegate,UITableViewDataSource,KBookListCellDelegate,MusicPlayToolDelegate>

@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIView *middleView;

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) NSMutableArray *selectes;//记录哪个cell被点击,改变播放按钮状态

@property(nonatomic,strong) UIView *bottomMaskView;
@property(nonatomic,strong) UIView *alertMaskView;

@property(nonatomic,strong) MusicPlayTool *playTool;
@property(nonatomic,strong) NSMutableArray *playArrray;
@property(nonatomic,assign) NSInteger playIndex;
@property(nonatomic,assign) BOOL isPlayEnd;

@property(nonatomic,assign) NSInteger page;
@property(nonatomic,strong) NoDataBackView *backView;

@end

@implementation KBookListViewController

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [[MusicPlayTool shareMusicPlay] musicPause];
//    self.playTool = nil;
//}
-(MusicPlayTool *)playTool
{
    if (!_playTool) {
        _playTool = [MusicPlayTool shareMusicPlay];
        _playTool.delegat = self;
    }
    
    return _playTool;
}

-(NSMutableArray *)playArrray
{
    if (!_playArrray) {
        _playArrray = [NSMutableArray array];
    }
    
    return _playArrray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
    _selectes = [NSMutableArray array];
    
}

-(void)initView
{
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 73)];
    [_topView setBackgroundColor:COLOR_STRING(@"#FFFFFF")];
    [self.view addSubview:_topView];
    
    _middleView = [[UIView alloc] initWithFrame:CGRectMake(0, _topView.frame.origin.y + _topView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _topView.frame.size.height)];
    _middleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_middleView];
    
    [self createTopViewChild];
    [self createMiddleViewChild];
    
}

-(void)createTopViewChild
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 40, 40)];
    
    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateSelected];
    
    [backButton.titleLabel setFont:MY_FONT(18)];
    [backButton setAdjustsImageWhenHighlighted:NO];
    
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,25,self.view.frame.size.width,48)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"K绘本";
    titleLabel.font = MY_FONT(19);
    titleLabel.textColor = COLOR_STRING(@"#2f2f2f");
    [_topView addSubview: titleLabel];
}

-(void)createMiddleViewChild
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:_middleView.bounds style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.allowsSelection = NO;
    
    self.tableView = tableView;
    [_middleView addSubview:tableView];
    
    [self setupRefresh];
}

-(void)creatAlertViewWithIndex:(NSInteger )index
{
    UIView *alertMaskView = [[UIView alloc] initWithFrame:self.view.bounds];
    alertMaskView.backgroundColor = [UIColor colorWithHexStr:@"#202020" alpha:0.7];
    self.alertMaskView = alertMaskView;
    [self.view addSubview:alertMaskView];
    
    UIView *recordAlertView = [[UIView alloc] initWithFrame:CGRectMake(36, (alertMaskView.frame.size.height - 153)*0.5, alertMaskView.frame.size.width - 36*2, 153)];
    recordAlertView.backgroundColor = COLOR_STRING(@"#F6F6F6");
    recordAlertView.layer.cornerRadius = 8;
    recordAlertView.layer.masksToBounds = YES;
    [alertMaskView addSubview:recordAlertView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((recordAlertView.frame.size.width - 32)*0.5, 18, 32, 32)];
    imageView.image = [UIImage imageNamed:@"kBook_alert"];
    [recordAlertView addSubview:imageView];
    
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.frame.origin.y + imageView.frame.size.height + 12, recordAlertView.frame.size.width, 20)];
    content.textAlignment = NSTextAlignmentCenter;
    content.textColor = COLOR_STRING(@"#9B9B9B");
    content.font = MY_FONT(14);
    content.text = @"当前配音不完整,确定继续录制吗?";
    [recordAlertView addSubview:content];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, recordAlertView.frame.size.height - 42, (recordAlertView.frame.size.width - 1)*0.5, 42);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:COLOR_STRING(@"#666666") forState:UIControlStateNormal];
    cancelButton.titleLabel.font = MY_FONT(18);
    [cancelButton setBackgroundColor:COLOR_STRING(@"#E5E5E5")];
    [cancelButton addTarget:self action:@selector(clickRecordAlertCancel:) forControlEvents:UIControlEventTouchUpInside];
    [recordAlertView addSubview:cancelButton];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(cancelButton.frame.origin.x + cancelButton.frame.size.width, cancelButton.frame.origin.y, recordAlertView.frame.size.width - cancelButton.frame.origin.x - cancelButton.frame.size.width, 42);
    [sureButton setTitle:@"确认" forState:UIControlStateNormal];
    [sureButton setTitleColor:COLOR_STRING(@"#FFFFFF") forState:UIControlStateNormal];
    sureButton.titleLabel.font = MY_FONT(18);
    sureButton.backgroundColor = COLOR_STRING(@"#FF721C");
    [sureButton addTarget:self action:@selector(clickRecordAlertSure:) forControlEvents:UIControlEventTouchUpInside];
    sureButton.tag = index;
    [recordAlertView addSubview:sureButton];

}

-(void)createBottomViewWithIndex:(NSInteger) index
{
    UIView *maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    maskView.backgroundColor = [UIColor colorWithHexStr:@"#202020" alpha:0.7];
    self.bottomMaskView = maskView;
    [self.view addSubview:maskView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, maskView.frame.size.height - 182, maskView.frame.size.width, 182)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [maskView addSubview:bottomView];
    
    UIImageView *recordImgView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 28, 19, 21)];
    recordImgView.image = [UIImage imageNamed:@"kBookList_record"];
    [bottomView addSubview:recordImgView];
    
    UILabel *recordLabel = [[UILabel alloc] initWithFrame:CGRectMake(recordImgView.frame.origin.x + recordImgView.frame.size.width + 17, 30, 100, 20)];
    recordLabel.font = MY_FONT(16);
    recordLabel.textColor = COLOR_STRING(@"#666666");
    
    KBookListModel *model = self.dataArray[index];
    if (model.status == 1) {
        recordLabel.text = @"重新录制";//未完成 是 "继续录制"
    }else{
        recordLabel.text = @"继续录制";
    }
    [bottomView addSubview:recordLabel];
    
    UIButton *recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    recordButton.frame = CGRectMake(0, 10, bottomView.frame.size.width, 50);
    [recordButton addTarget:self action:@selector(clickRecord:) forControlEvents:UIControlEventTouchUpInside];
    recordButton.tag = index;
    [bottomView addSubview:recordButton];
    
    UIImageView *deleteImgView = [[UIImageView alloc] initWithFrame:CGRectMake(recordImgView.frame.origin.x, recordImgView.frame.origin.y + recordImgView.frame.size.height + 34, recordImgView.frame.size.width, 21)];
    deleteImgView.image = [UIImage imageNamed:@"kBookList_delete"];
    [bottomView addSubview:deleteImgView];
    
    UILabel *deleteLabel = [[UILabel alloc] initWithFrame:CGRectMake(recordLabel.frame.origin.x, deleteImgView.frame.origin.y, 100, deleteImgView.frame.size.height)];
    deleteLabel.textColor = COLOR_STRING(@"#666666");
    deleteLabel.font = MY_FONT(16);
    deleteLabel.text = @"删除语音";
    [bottomView addSubview:deleteLabel];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(0, deleteImgView.frame.origin.y - 15, bottomView.frame.size.width, 50);
    [deleteButton addTarget:self action:@selector(clickDeleteAudio:) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.tag = index;
    [bottomView addSubview:deleteButton];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, bottomView.frame.size.height - 55 - 0.5, bottomView.frame.size.width, 0.5)];
    line.backgroundColor = COLOR_STRING(@"#E3E3E3");
    [bottomView addSubview:line];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, line.frame.origin.y + line.frame.size.height, bottomView.frame.size.width, 55);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:COLOR_STRING(@"#666666") forState:UIControlStateNormal];
    [cancelButton setTitle:@"取消" forState:UIControlStateSelected];
    [cancelButton setTitleColor:COLOR_STRING(@"#666666") forState:UIControlStateSelected];
    cancelButton.titleLabel.font = MY_FONT(18);
    [cancelButton addTarget:self action:@selector(clickCancelBottom:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:cancelButton];
    
}

-(void)backButtonClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    //判断数据源,调用不同接口
    self.page = 1;//从第一页开始
    
    //默认每次取10条数据
    [self getKBookListWithPage:self.page PageNum:PAGENUM];
}

-(void)footerRereshing
{
    self.page++;
    
    [self getMoreKBookListWithPage:self.page PageNum:PAGENUM];
}

-(void)headEndRefresh
{
    if (self.tableView.visibleCells.count != 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    
    [self.tableView.mj_header endRefreshing];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"KBookListCell";
    KBookListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[KBookListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.delegate = self;
    cell.playButton.tag = indexPath.row;
    cell.isSelected = [_selectes[indexPath.row] isEqualToNumber:@(1)] ? YES : NO;
    if (self.isPlayEnd == YES) {
        cell.playButton.selected = NO;
    }
    cell.indicateButton.tag = indexPath.row;
    
    KBookListModel *listModel = [self.dataArray objectAtIndex:indexPath.row];
    cell.bookName = listModel.bookName;
    cell.iconUrl = listModel.picUrl;
    cell.status = listModel.status;

    NSString *dateString = [self getDateByTimestamp:listModel.kTime];
    cell.identity = dateString;
    if (indexPath.row == 0) {
        NSLog(@"_selectes==> %@", _selectes);
    }
    return cell;
}

#pragma mark -UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}

-(void)showNoDataImage
{
    if (self.backView == nil) {
        CGRect imageBound = CGRectMake(0, 0, 375, 180);
        UIImage *backImage = [UIImage imageNamed:@"noData_kbook"];
        NSString *title = @"宝宝很期待爸爸妈妈给他讲故事,\n快去录制绘本吧~";
        self.backView = [[NoDataBackView alloc] initWithImageBound:imageBound WithImage:backImage WithTitle:title];
        [self.tableView addSubview:self.backView];
    }else{
        self.backView.hidden = NO;
    }
}

#pragma mark - 网络接口
-(void)getKBookListWithPage:(NSInteger)page PageNum:(NSInteger)pageNum
{
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        
        NSLog(@"KBookListService ==> OnSuccess");
        
        [self.tableView.mj_header endRefreshing];
        
        KBookListService *service = (KBookListService *)httpInterface;
        self.dataArray = [NSMutableArray arrayWithArray:service.dataArray];
        
        if (self.dataArray.count == 0 || self.dataArray == nil) {
            //展示无数据图片
            [self showNoDataImage];
            return ;
        }
        
        [_selectes removeAllObjects];
        for (int i = 0; i < self.dataArray.count; i++) {
            [_selectes addObject:@(0)];
        }
//        NSLog(@"_selects===>%@",_selectes);
        if (self.dataArray.count < pageNum) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
        });
        
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"KBookListService ==> OnError");
        [self.tableView.mj_header endRefreshing];
    };
    
//    NSString *token = @"4D011CC02EB9A6E8B66125C7A1C6CC21F183709F6A9E3DB6EB606EB8F45272548549BACDF9333F3AF62D2088F9061124F8A1E69FDAE236A40620FEDDE33ED590720C8253F936A8FEB1B799A18ED2F7FF08E53C051F016681CE1C60A87D55202DFC830B606E88113DF6CACB7347E7F4723F6EB7EBD45A636E750A8DC618BB4AA8";//测试用
    NSString *token = APP_DELEGATE.mLoginResult.token;
    KBookListService *service = [[KBookListService alloc] init:OnSuccess setOnError:OnError setUSER_TOKEN:token setPage:page setPageNum:pageNum];
    [service start];
}

-(void)getMoreKBookListWithPage:(NSInteger)page PageNum:(NSInteger)pageNum
{
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        
        NSLog(@"KBookListService ==> OnSuccess");
        
        KBookListService *service = (KBookListService *)httpInterface;
        NSArray *temArray = service.dataArray;
        for (int i = 0; i < temArray.count; i++) {
            [_selectes addObject:@(0)];
        }
        
        if (temArray.count != 0) {
            
            [self.dataArray addObjectsFromArray:temArray];
            
            if (temArray.count < pageNum) {
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
        
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"KBookListService ==> OnError");
        [self.tableView.mj_footer endRefreshing];
    };
    
    NSString *token = APP_DELEGATE.mLoginResult.token;
    KBookListService *service = [[KBookListService alloc] init:OnSuccess setOnError:OnError setUSER_TOKEN:token setPage:page setPageNum:pageNum];
    [service start];
}

//删除K语音
-(void)deleteKbookAudioWithBookid:(NSInteger)groupId
{
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        
        NSLog(@"KBookDeleteService ==> OnSuccess");
        
        [self.tableView reloadData];
        
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"KBookDeleteService ==> OnError");
    };
    
    NSString *token = APP_DELEGATE.mLoginResult.token;
    KBookDeleteService *service = [[KBookDeleteService alloc] initWithOnSuccess:OnSuccess setOnError:OnError setToken:token setBookId:groupId];
    [service start];
}

#pragma mark - KBookListCellDelegate
-(void)isShowAlertView:(UIButton *)sender
{
    NSLog(@"ShowAlertView");
    
    [self creatAlertViewWithIndex:sender.tag];
}

-(void)showBottom:(UIButton *)sender
{
    NSLog(@"showBottom--sender.tag===>%ld",sender.tag);
    
    [self createBottomViewWithIndex:sender.tag];
}

-(void)playKbookAudio:(UIButton *)sender
{
    
    
  
    //能进入这个方法,sender肯定是选中状态
    
    if ([_selectes[sender.tag] isEqualToNumber:@(0)]) {
        if ([_selectes containsObject:@(1)]) {
            NSInteger index = [_selectes indexOfObject:@(1)];
            KBookListCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            cell.playButton.selected = NO;//将播放选中状态改变
            [self kBookAudioPause:sender];
//            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            cell.maskImageView.image = [UIImage imageNamed:@"kBookList_play"];
            
            //将原来至0
            [_selectes replaceObjectAtIndex:index withObject:@(0)];
        }
        
        //将现在点击至1
        [_selectes replaceObjectAtIndex:sender.tag withObject:@(1)];
    }
//    NSLog(@"_selects===>%@",_selectes);
    NSLog(@"播放k绘本列表");
    [self.playArrray removeAllObjects];
    
    KBookListModel *model = self.dataArray[sender.tag];
    if (model.kList.count > 0) {
        for (NSDictionary *kListDic in model.kList) {
            NSString *voiceUrl = ![[kListDic objectForKey:@"voiceUrl"] isKindOfClass:[NSNull class]] ? [kListDic objectForKey:@"voiceUrl"] : @"";
            if (voiceUrl.length > 0) {
                [self.playArrray addObject:voiceUrl];
            }
        }
    }
    
    self.playIndex = 0;
    [self musicPlay];
//    NSLog(@"_selectes: %@",_selectes);
}

-(void)kBookAudioPause:(UIButton *)sender
{
    self.playIndex = 10000;
    [self.playTool musicPause];
    self.playTool = nil;
    
    if ([_selectes[sender.tag] isEqualToNumber:@(1)]) {
        [_selectes replaceObjectAtIndex:sender.tag withObject:@(0)];
    }
//    NSLog(@"_selects===>%@",_selectes);
}

-(void)clickRecordAlertCancel:(UIButton *)sender
{
    [self.alertMaskView removeFromSuperview];
}

-(void)clickRecordAlertSure:(UIButton *)sender
{
//    NSLog(@"Alert继续录制===>%ld",sender.tag);
    [self.alertMaskView removeFromSuperview];
    
    KBookListModel *model = self.dataArray[sender.tag];
    
    KBookViewController *kBookVC = [[KBookViewController alloc]init];
    kBookVC.bookId = [NSString stringWithFormat:@"%@",model.kbookId];
    [self.navigationController pushViewController:kBookVC animated:YES];
}

//重录 / 继续录制
-(void)clickRecord:(UIButton *)sender
{
    NSLog(@"继续录制tag===>%ld",(long)sender.tag);
    
    [self.bottomMaskView removeFromSuperview];
    
    KBookListModel *model = self.dataArray[sender.tag];
    
    NSLog(@"KBookID====>%@",model.kbookId);
    
    KBookViewController *kBookVC = [[KBookViewController alloc]init];
//    kBookVC.bookId = [NSString stringWithFormat:@"%ld",model.kbookId];
    kBookVC.bookId = model.kbookId;
    [self.navigationController pushViewController:kBookVC animated:YES];
}

//删除语音
-(void)clickDeleteAudio:(UIButton *)sender
{
    NSLog(@"删除语音tag===>%ld",sender.tag);
    KBookListModel *model = self.dataArray[sender.tag];
    NSInteger groupId = model.groupId;
    
    [self.dataArray removeObject:model];
    [self deleteKbookAudioWithBookid:groupId];
    
    [self.bottomMaskView removeFromSuperview];
}

-(void)clickCancelBottom:(UIButton *)sender
{
    [self.bottomMaskView removeFromSuperview];
}

#pragma mark - MusicPlayToolDelegate
-(void)endOfPlayAction
{
    if (self.playIndex == 10000) {
        return;
    }
    
    if (self.playIndex < self.playArrray.count - 1) {
        self.playIndex++;
        [self musicPlay];
        
    }else if (self.playIndex == self.playArrray.count - 1){
        //最后一首播完
        [self.playTool musicPause];
        //播放按钮状态 回位为 未选中状态
        self.isPlayEnd = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

-(void)musicPlay
{
    if (self.playIndex < self.playArrray.count && self.playIndex != 10000) {
        NSString *url = [self.playArrray objectAtIndex:self.playIndex];
        if (url.length > 0) {
            self.playTool.urlString = url;
            [self.playTool musicPrePlay];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideBarStyle];
    
    self.page = 1;//从第一页 开始
    [self getKBookListWithPage:self.page PageNum:PAGENUM];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self showBarStyle];
    
//    if (self.playTool.player.rate > 0) {
    
        [[MusicPlayTool shareMusicPlay] musicPause];
        [self.playTool.player replaceCurrentItemWithPlayerItem:nil];
        self.playTool = nil;
//    }
}
-(void)dealloc
{
    

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

//时间戳转换成date
-(NSString *)getDateByTimestamp:(NSString *)timeStampString
{
    NSTimeInterval interval = [timeStampString doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd"];
    NSString *dateString = [formatter stringFromDate:date];
    
    return dateString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
