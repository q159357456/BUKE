//
//  StoryManagerViewController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/16.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "StoryManagerViewController.h"
#import "StoryManagerCell.h"
#import "StoryPlayListModel.h"
#import "StoryCollectService.h"
#import "MusicPlayTool.h"
#import "SendAudioToRobotSerive.h"
#import "MBProgressHUD+XBK.h"
#import "RobotIsOnlineService.h"
#import "BindMaskViewController.h"
#import "BKRobotBindTipCtr.h"
#import "BKCameraManager.h"
#import "XYDMPlaySoruceManage.h"
#define AnimationTime   1.0

@interface StoryManagerViewController ()<UITableViewDelegate,UITableViewDataSource,MusicPlayToolDelegate>

@property(nonatomic,assign) BOOL selectAll;
@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) NSMutableArray *selectedArray;
@property(nonatomic,strong) MusicPlayTool *playTool;

@property(nonatomic,assign) NSInteger playIndex;//记录全部播放下标

@property(nonatomic,strong) NSMutableArray *plays;
@property(nonatomic,assign) NSInteger index;//记录单独播放


@end

@implementation StoryManagerViewController

-(NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

-(NSMutableArray *)selectedArray
{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

-(NSMutableArray *)plays
{
    if (!_plays) {
        _plays = [NSMutableArray array];
    }
    
    return _plays;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = COLOR_STRING(@"#E9E9E9");
    self.selectAll = NO; //默认不全选
    
    if (self.dataArray.count != 0) {
        for (StoryPlayListModel *listModel in self.dataArray) {
            listModel.isSelect = NO;//默认没有模型被选择
            
            [self.plays addObject:@(0)];//0 : 未播放 1:播放
        }
    }
    [self setUI];
    [self initView];
    [self initBottomView];
    
    self.playTool = [MusicPlayTool shareMusicPlay];
    self.playTool.delegat = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

    self.statusView.backgroundColor = COLOR_STRING(@"#FFFFFF");
    self.navigationController.navigationBar.backgroundColor = COLOR_STRING(@"#FFFFFF");
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.playTool musicPause];
    self.playTool = nil;
    self.playTool.delegat = nil;
}

-(void)setUI
{
    self.titleLabel.text = @"管理";
    self.titleLabel.font = MY_FONT(18);
    self.titleLabel.textColor = COLOR_STRING(@"#2f2f2f");
    [self.leftButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateNormal];
    [self.leftButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateSelected];
    [self.leftButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    self.leftButton.titleLabel.font = MY_FONT(16);
    
    [self.rightButton setTitle:@"全选" forState:UIControlStateNormal];
    [self.rightButton setTitle:@"全选" forState:UIControlStateSelected];
    [self.rightButton addTarget:self action:@selector(selectAll:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setTitleColor:COLOR_STRING(@"#2f2f2f") forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = MY_FONT(16);
}

-(void)initView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, self.view.frame.size.width, self.view.frame.size.height - 68 - (Height_NavBar)) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

-(void)initBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 68, self.view.frame.size.width, 68)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
//    if (self.sourceType == StoryPlaySourceType_PlayList) {
//        CGFloat labelW = bottomView.frame.size.width / 4.0;//label宽度
//        CGFloat LRpadding = (labelW - 24)/2.0;//左右边距
//        CGFloat padding = LRpadding * 2;//按钮中间间距
//        CGFloat insetHeight = 12;//距离上面间距
//
//        for (int i = 0; i < 4; i++) {
//
//            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            button.frame = CGRectMake(LRpadding + (24 + padding)*i, insetHeight, 24, 24);
//            button.tag = i;
//            [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
//            [bottomView addSubview:button];
//
//            UILabel *label = [[UILabel alloc]init];
//            label.frame = CGRectMake(labelW * i, button.frame.origin.y + button.frame.size.height + 6, labelW, 14);
//            label.textAlignment = NSTextAlignmentCenter;
//            label.textColor = COLOR_STRING(@"#909090");
//            label.font = MY_FONT(12);
//            [bottomView addSubview:label];
//            switch (i) {
//                case 0:
//                    [button setImage:[UIImage imageNamed:@"storyManager_collect"] forState:UIControlStateNormal];
//                    [button setImage:[UIImage imageNamed:@"storyManager_collect"] forState:UIControlStateSelected];
//                    label.text = @"收藏";
//                    break;
//                case 1:
//                    [button setImage:[UIImage imageNamed:@"storyManager_collectCancel"] forState:UIControlStateNormal];
//                    [button setImage:[UIImage imageNamed:@"storyManager_collectCancel"] forState:UIControlStateSelected];
//                    label.text = @"取消收藏";
//                    break;
//                case 2:
//                    [button setImage:[UIImage imageNamed:@"storyManager_play"] forState:UIControlStateNormal];
//                    [button setImage:[UIImage imageNamed:@"playList_allPause"] forState:UIControlStateSelected];
//                    label.text = @"播放";
//                    break;
//                case 3:
//                    [button setImage:[UIImage imageNamed:@"storyManager_push"] forState:UIControlStateNormal];
//                    [button setImage:[UIImage imageNamed:@"storyManager_push"] forState:UIControlStateSelected];
//                    label.text = @"小布壳";
//                    break;
//
//                default:
//                    break;
//            }
//        }
//
//    } else
        if (self.sourceType == StoryPlaySourceType_Recent || self.sourceType == StoryPlaySourceType_PlayList) {
    
        CGFloat labelW = bottomView.frame.size.width / 2.0;//label宽度
        CGFloat LRpadding = (labelW - 24)/2.0;//左右边距
        CGFloat padding = LRpadding * 2;//按钮中间间距
        CGFloat insetHeight = 12;//距离上面间距
        
        for (int i = 0; i < 2; i++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(LRpadding + (24 + padding)*i, insetHeight, 24, 24);
            button.tag = i;
            [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            [bottomView addSubview:button];
            
            UILabel *label = [[UILabel alloc]init];
            label.frame = CGRectMake(labelW * i, button.frame.origin.y + button.frame.size.height + 6, labelW, 14);
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = COLOR_STRING(@"#909090");
            label.font = MY_FONT(12);
            [bottomView addSubview:label];
            switch (i) {
                case 0:
                    [button setImage:[UIImage imageNamed:@"storyManager_collect"] forState:UIControlStateNormal];
                    [button setImage:[UIImage imageNamed:@"storyManager_collect"] forState:UIControlStateSelected];
                    label.text = @"收藏";
                    break;
                case 1:
                    [button setImage:[UIImage imageNamed:@"playList_push"] forState:UIControlStateNormal];
                    [button setImage:[UIImage imageNamed:@"playList_push"] forState:UIControlStateSelected];
                    label.text = @"小布壳";
                    break;
                    
                default:
                    break;
            }
        }
        
    } else if(self.sourceType == StoryPlaySourceType_Collect) {
        CGFloat labelW = bottomView.frame.size.width / 2.0;//label宽度
        CGFloat LRpadding = (labelW - 24)/2.0;//左右边距
        CGFloat padding = LRpadding * 2;//按钮中间间距
        CGFloat insetHeight = 12;//距离上面间距
        
        for (int i = 0; i < 2; i++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(LRpadding + (24 + padding)*i, insetHeight, 24, 24);
            button.tag = i;
            [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            [bottomView addSubview:button];
            
            UILabel *label = [[UILabel alloc]init];
            label.frame = CGRectMake(labelW * i, button.frame.origin.y + button.frame.size.height + 6, labelW, 14);
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = COLOR_STRING(@"#909090");
            label.font = MY_FONT(12);
            [bottomView addSubview:label];
            switch (i) {
                case 0:
                    [button setImage:[UIImage imageNamed:@"storyManager_collectCancel"] forState:UIControlStateNormal];
                    [button setImage:[UIImage imageNamed:@"storyManager_collectCancel"] forState:UIControlStateSelected];
                    label.text = @"取消收藏";
                    break;
//                case 1:
//                    [button setImage:[UIImage imageNamed:@"storyManager_play"] forState:UIControlStateNormal];
//                    [button setImage:[UIImage imageNamed:@"playList_allPause"] forState:UIControlStateSelected];
//                    label.text = @"播放";
//                    break;
                case 1:
                    [button setImage:[UIImage imageNamed:@"playList_push"] forState:UIControlStateNormal];
                    [button setImage:[UIImage imageNamed:@"playList_push"] forState:UIControlStateSelected];
                    label.text = @"小布壳";
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    
}

-(void)clickButton:(UIButton *)sender
{
//    if (self.sourceType == StoryPlaySourceType_PlayList) {
//        switch (sender.tag) {
//            case 0:
//                //收藏
//                [self collectAudiosWithType:0];
//                break;
//            case 1:
//                //取消收藏
//                [self collectAudiosWithType:1];
//                break;
//            case 2:
//                //播放
//                [self playAudio:sender];
//                break;
//            case 3:
//                //小布壳
//                [self pushToRobot];
//                break;
//
//            default:
//                break;
//        }
//    } else
    if (self.sourceType == StoryPlaySourceType_Recent || self.sourceType == StoryPlaySourceType_PlayList){
        
        switch (sender.tag) {
            case 0:
                [self collectAudiosWithType:0];
                break;
            case 1:
                //小布壳
                [self pushToRobot];
                break;
                
            default:
                break;
        }
        
    } else if(self.sourceType == StoryPlaySourceType_Collect){
        switch (sender.tag) {
            case 0:
                //取消收藏
                [self collectAudiosWithType:1];
                break;
//            case 1:
//                //播放
//                [self playAudio:sender];
//                break;
            case 1:
                //小布壳
                [self pushToRobot];
                break;
                
            default:
                break;
        }
    }
    
}

-(void)selectAll:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.selectAll = sender.selected;
    
    if (sender.selected == YES) {
        [self.selectedArray removeAllObjects];
        for (StoryPlayListModel *listModel in self.dataArray) {
            listModel.isSelect = YES;
            [self.selectedArray addObject:listModel];
        }
    }else{
        for (StoryPlayListModel *listModel in self.dataArray) {
            listModel.isSelect = NO;
        }
        
        [self.selectedArray removeAllObjects];
    }
    
    [self.tableView reloadData];
    
    if (!self.selectAll) {
        [self.rightButton setTitle:@"全选" forState:UIControlStateNormal];
        [self.rightButton setTitle:@"全选" forState:UIControlStateSelected];
    } else {
        [self.rightButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.rightButton setTitle:@"取消" forState:UIControlStateSelected];
    }
}

-(void)clickSelect:(UIButton *)sender
{
    sender.selected = !sender.selected;
    StoryPlayListModel *listModel = [self.dataArray objectAtIndex:sender.tag];
    listModel.isSelect = sender.selected;
    if (listModel.isSelect == YES) {
        [self.selectedArray addObject:listModel];
    }else{
        for (StoryPlayListModel *model in self.selectedArray) {
            if ([model.musicName isEqualToString:listModel.musicName]) {
                [self.selectedArray removeObject:model];
                break;
            }
        }
    }
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)clickPlay:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if ([self.plays[sender.tag] isEqualToNumber:@(0)]) {
        //有且仅有1个cell 是选中状态
        for (int i = 0; i < self.plays.count; i++) {
            NSNumber *num = self.plays[i];
            if (i == sender.tag) {
                num = @(1);
            }else{
                num = @(0);
            }
            
            [self.plays replaceObjectAtIndex:i withObject:num];
        }
    }else{
        [self.plays replaceObjectAtIndex:sender.tag withObject:@(0)];
    }
    
    StoryPlayListModel *listModel = [self.dataArray objectAtIndex:sender.tag];
    
    if (sender.selected == YES) {
        if (listModel.musicUrl.length > 0) {
            [MusicPlayTool shareMusicPlay].urlString = listModel.musicUrl;
            [[MusicPlayTool shareMusicPlay] musicPrePlay];
        }
    }else{
        [self play_pause];
    }
    
//    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadData];
   
}

-(void)close:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - 底部bar 操作
-(void)collectAudiosWithType:(NSInteger )type
{
    //秦根改
    NSMutableArray *array = [NSMutableArray array];
    for (StoryPlayListModel *listModel in self.dataArray) {
        if (listModel.isSelect == YES) {
            [array addObject:@(listModel.oj_id)];
        }
    }
    
 
    if (!array.count) {
        [MBProgressHUD showError:@"请先选择听听选项"];
        return;
    }
    [MBProgressHUD showMessage:@"加载中...." toView:self.view];
    [XYDMPlaySoruceManage collectStorylist:array CallBack:^(NSDictionary * _Nonnull response) {
        [MBProgressHUD hideHUD];
        if ([response[@"code"] integerValue] == 1) {
            
//            [MBProgressHUD showSuccess:@"取消收藏成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, AnimationTime * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:NO];
            });
        }else
        {
            [MBProgressHUD showError:response[@"msg"]];
            
        }
    }];
    

//    void(^OnSuccess)(id,NSString *) = ^(id httpInterface,NSString *description){
//        if (type == 0) {
//            [MBProgressHUD showSuccess:@"收藏成功"];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, AnimationTime * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:NO];
//            });
//        }else if (type == 1){
//            [MBProgressHUD showSuccess:@"取消收藏成功"];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, AnimationTime * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:NO];
//            });
//        }
//    };
//
//    void(^OnError)(NSInteger,NSString *) = ^(NSInteger httpInterface,NSString *description){
//        if (type == 0) {
//            if (description.length) {
//                [[[BKLoginCodeTip alloc]init] AddTextShowTip:description and:self.view];
//            }else{
//                [MBProgressHUD showError:@"收藏失败"];}
//        }else if (type == 1){
//            if (description.length) {
//                [[[BKLoginCodeTip alloc]init] AddTextShowTip:description and:self.view];
//            }else{
//            [MBProgressHUD showError:@"取消收藏失败"];
//            }
//        }
//    };
//
//    NSString *str;
//    for (StoryPlayListModel *listModel in self.dataArray) {
//        if (listModel.isSelect == YES) {
//            if (str.length == 0) {
//                str = [NSString stringWithFormat:@"%ld",listModel.musicId];
//            }else{
//                str = [str stringByAppendingString:[NSString stringWithFormat:@",%ld",listModel.musicId]];
//            }
//        }
//    }
//
//    NSLog(@"选择的语音id集合为----->>:%@",str);
//    if (str == nil) {
//        [MBProgressHUD showError:@"请先选择听听选项"];
//        return;
//    }
//    StoryCollectService *collectService = [[StoryCollectService alloc]initWithUerToken:APP_DELEGATE.mLoginResult.token setStoryId:str setType:type setOnSuccess:OnSuccess setOnError:OnError];
//    [collectService start];
}

-(void)playAudio:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (sender.selected == YES) {
        NSLog(@"开始播放音乐");
        
        self.playIndex = 0;//从第一首开始
        
        [self startPlay];
    }else{
        [self play_pause];
    }
    
}

-(void)startPlay
{
    if (self.selectedArray.count > 0 ) {
        StoryPlayListModel *listModel = [self.selectedArray objectAtIndex:self.playIndex];
        [MusicPlayTool shareMusicPlay].urlString = listModel.musicUrl;
        [[MusicPlayTool shareMusicPlay] musicPrePlay];
        
//        [self.navigationController popViewControllerAnimated:NO];
    }else{
        NSLog(@"请先选择需要播放的音乐");
        [MBProgressHUD showText:@"请先选择需要播放的音乐"];
    }
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
}

-(void)pushToRobot
{
    
    if (self.selectedArray.count == 0) {
        NSLog(@"请先选择音乐再进行推送");
        [MBProgressHUD showText:@"请先选择音乐再进行推送"];
        return ;
    }
    //秦根改
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (StoryPlayListModel *listModel in self.dataArray) {
        if (listModel.isSelect == YES) {
            if (listModel.musicId)
            {
                [mutableArray addObject:[NSString stringWithFormat:@"%ld",(long)listModel.musicId]];
            }else
            {
                [mutableArray addObject:listModel.musicUrl];
            }
            
        }
    }
    NSLog(@"推送数据===> %@",mutableArray);
    [XYDMPlaySoruceManage pushMusic:mutableArray];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:NO];
    });
    //先检测小布壳是否在线
//    [self RobotIsOnline];
}

-(void)RobotIsOnline
{
    void (^OnSuccess)(id,NSString *) = ^(id httpIterface,NSString *description){
        RobotIsOnlineService *service = (RobotIsOnlineService *)httpIterface;
        BOOL isOnline = service.isOnline;
        if (isOnline == YES) {
            [self pushAudioToRobot];
        }else{
//            button.selected = NO;
            [MBProgressHUD showText:@"设备不在线"];
        }
    };
    
    void (^OnError)(NSInteger,NSString *) = ^(NSInteger httpInterface,NSString *description){
//        button.selected = NO;
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
                [[BKCameraManager shareInstance] ConnectDevice];
                [MBProgressHUD showText:@"设备不在线"];
            }else{
                
                NSMutableArray *mutableArray = [NSMutableArray array];
                for (StoryPlayListModel *listModel in self.dataArray) {
                    if (listModel.isSelect == YES) {
                        if (listModel.musicUrl.length) {
                            [mutableArray addObject:listModel.musicUrl];
                        }
                    }
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PUSHMUSIC-BabyCare" object:[mutableArray mutableCopy]];
            }
            
        }else{
            
            RobotIsOnlineService *onlineService = [[RobotIsOnlineService alloc] initWithDeviceId:deviceId setToken:APP_DELEGATE.mLoginResult.token setOnSuccess:OnSuccess setOnError:OnError];
            [onlineService start];
        }
    }
}

-(void)pushAudioToRobot
{
    void(^OnSuccess)(id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"管理集体推送 ===> OnSuccess");

        [MBProgressHUD showSuccess:@"推送小布壳成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, AnimationTime * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:NO];
        });
        //        [self.navigationController popViewControllerAnimated:NO];

    };

    void(^OnError)(NSInteger,NSString *) = ^(NSInteger httpInterface,NSString *description){
        NSLog(@"管理集体推送 ===> OnError");
        [MBProgressHUD showError:@"推送小布壳失败"];
    };
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (StoryPlayListModel *listModel in self.dataArray) {
        if (listModel.isSelect == YES) {
            [mutableArray addObject:listModel.musicUrl];
        }
    }

    //    NSArray *array = [NSArray arrayWithObjects:@"http://xiaobuke.oss-cn-beijing.aliyuncs.com/story/20160316/11.mp3",@"http://xiaobuke.oss-cn-beijing.aliyuncs.com/story/20160316/11.mp3", nil];
    NSArray *array = [NSArray arrayWithArray:mutableArray];
    SendAudioToRobotSerive *robotService = [[SendAudioToRobotSerive alloc]init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token setAudioUrlList:array];
    [robotService start];
}

#pragma mark - MusicPlayToolDelegate
-(void)endOfPlayAction
{
    //播放结束,播放下一首
    self.playIndex++;
    if (self.playIndex > self.selectedArray.count - 1) {
        self.playIndex = 0;
    }
    
    [self startPlay];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"managerCell";
    StoryManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[StoryManagerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    StoryPlayListModel *list = self.dataArray[indexPath.row];
    
    cell.isAllSelected = self.selectAll;
    [cell setDisplayValueByData:list setStoryPlaySourceType:self.sourceType];
    
    cell.selectButton.selected = list.isSelect;
    cell.selectButton.tag = indexPath.row;
    [cell.selectButton addTarget:self action:@selector(clickSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    NSInteger playIndex = [self.plays[indexPath.row] integerValue];
    BOOL isPlay = playIndex == 1 ? YES : NO;
    cell.playButton.selected = isPlay;
    cell.playButton.tag = indexPath.row;
    [cell.playButton addTarget:self action:@selector(clickPlay:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - UITableViewDelegate
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    StoryManagerCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self clickSelect:cell.selectButton];
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
