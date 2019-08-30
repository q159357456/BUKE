//
//  BKMessageCtr.m
//  MiniBuKe
//
//  Created by chenheng on 2018/12/27.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKMessageCtr.h"
#import "BKNotificationSettingTipView.h"
#import "BKMessageActivityCell.h"
#import "BKMessageBookUpdateCell.h"
#import "NoDataBackView.h"
#import "BKMessageNODataBackView.h"
#import "PBBaseViewControllerHelp.h"
#import "MJRefresh.h"
#import "XG_PushManager.h"
#import "BKCustomWebViewCtr.h"
#import "IntensiveReadingController.h"

//#define H kNavbarH
#define H 0.f

@interface BKMessageCtr ()<UITableViewDelegate,UITableViewDataSource,P_QLDragToRefresh>

@property (nonatomic, strong) BKNotificationSettingTipView *notSetTipView;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, assign) CGFloat topOffest;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) BKMessageNODataBackView *backView;
@end

@implementation BKMessageCtr
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground)name:UIApplicationWillEnterForegroundNotification object:nil];
}
- (void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self applicationWillEnterForeground];
    [self addNotification];
    [self getDataArrayForDB];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeNotification];
}

- (void)applicationWillEnterForeground{
    if (![self checkSysNoticSetting]) {
        if (self.notSetTipView == nil) {
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"SysNoticTip"] == nil) {
                [self setupNoticTip];
                self.topOffest = CGRectGetHeight(self.notSetTipView.frame);
            }
        }else{
            [self.view addSubview:self.notSetTipView];
            self.topOffest = CGRectGetHeight(self.notSetTipView.frame);
        }
    }else{
        self.topOffest = 0.f;
        if (self.notSetTipView) {
            [self.notSetTipView removeFromSuperview];
        }
    }
    [self updateTableViewFrame];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_STRING(@"#F7F9FB");
    
    [self.view addSubview:self.myTableView];
    [self registerCustomTableViewCell];
    [self configureHeaderDragRefreshView];
    [self configureFooterDragRefreshView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushMessageNotComing) name:PushNoticComing object:nil];
}
- (void)pushMessageNotComing{
    [self getDataArrayForDB];
}
- (void)getDataArrayForDB{
    [XG_PushManager getAllLocalNotifactionDataCallback:^(NSMutableArray * _Nonnull array) {
//        NSLog(@"刷新到%ld条最新消息",array.count);
        //切换主线程更新UI
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (array.count) {
                self.dataArray = array;
                for (int i = 0; i<array.count; i++) {
                    XG_NoticeModel *model = self.dataArray[i];
                    if (!model.isRead) {
                        self.ChangeRedTip(NO);
                        break;
                    }
                    if (i == array.count-1 && model.isRead) {
                        self.ChangeRedTip(YES);
                    }
                }
                if (self.backView.superview) {
                    [self.backView removeFromSuperview];
                }
                self.myTableView.backgroundColor = COLOR_STRING(@"#f1f1f1");
            }else{
                [self addDataTempView];
                self.myTableView.backgroundColor = COLOR_STRING(@"#FFFFFF");
            }
            [self stopRefresh];
            [self.myTableView reloadData];
        }];
        
    }];
}

- (void)updateTableViewFrame{
    self.myTableView.frame = CGRectMake(0, H+self.topOffest,CGRectGetWidth(self.view.frame),CGRectGetHeight(self.view.frame)-self.topOffest-H);
}

- (void)setupNoticTip{
    if (self.notSetTipView == nil) {
        kWeakSelf(weakSelf);
        self.notSetTipView = [[BKNotificationSettingTipView alloc]init];
        self.notSetTipView.frame = CGRectMake(0,H,SCREEN_WIDTH, 44.f);
        [self.notSetTipView setCloseBtnClick:^{
            [weakSelf.notSetTipView removeFromSuperview];
            weakSelf.topOffest = 0;
            [weakSelf updateTableViewFrame];
            //本地记录弹窗次数
            [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:[NSString stringWithFormat:@"SysNoticTip"]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
        [self.notSetTipView setOpenBtnClick:^{
            [weakSelf goToOpenSysNoticSetting];
        }];
        [self.view addSubview:self.notSetTipView];
    }
}
//检查系统通知设置是否开启
- (BOOL)checkSysNoticSetting{
    BOOL isEnable = NO;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f) { // iOS版本 >=8.0 处理逻辑
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        isEnable = (UIUserNotificationTypeNone == setting.types) ? NO : YES;
    } else { // iOS版本 <8.0 处理逻辑
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        isEnable = (UIRemoteNotificationTypeNone == type) ? NO : YES;
    }
    return isEnable;
}
//跳转系统通知设置
- (void)goToOpenSysNoticSetting{
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([application canOpenURL:url]) {
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            if (@available(iOS 10.0, *)) {
                [application openURL:url options:@{} completionHandler:nil];
            } else {
                [application openURL:url];
            }
        } else {
            [application openURL:url];
        }
    }
}
#pragma mark - tableviewDelegate&dataSource
- (UITableView *)myTableView{
    if (_myTableView == nil) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.topOffest,CGRectGetWidth(self.view.frame),CGRectGetHeight(self.view.frame)-self.topOffest) style:UITableViewStyleGrouped];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else{
            
        }
        _myTableView.estimatedRowHeight = 0;
        _myTableView.estimatedSectionFooterHeight = 0;
        _myTableView.estimatedSectionHeaderHeight = 0;
        _myTableView.backgroundColor = COLOR_STRING(@"#F1F1F1");
        _myTableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_myTableView];
    }
    return _myTableView;
}

- (void)registerCustomTableViewCell{
    [self.myTableView registerClass:[BKMessageBookUpdateCell class] forCellReuseIdentifier:NSStringFromClass([BKMessageBookUpdateCell class])];
    [self.myTableView registerClass:[BKMessageActivityCell class] forCellReuseIdentifier:NSStringFromClass([BKMessageActivityCell class])];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    XG_NoticeModel *model = self.dataArray[indexPath.section];
    if (model.showType == 1) {//showType 1活动 2缺书登记
        return [BKMessageActivityCell heightForCellWithObject:model];
    }else if (model.showType == 2){
        return [BKMessageBookUpdateCell heightForCellWithObject:nil];
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    XG_NoticeModel *model = self.dataArray[indexPath.section];
    if (model.showType == 1) {//showType 1活动 2缺书登记
        cell = [BKMessageActivityCell BKBaseTableViewCellWithTableView:tableView];
        [(BKMessageActivityCell*)cell setDataModel:model];
    }else if (model.showType == 2){
        cell = [BKMessageBookUpdateCell BKBaseTableViewCellWithTableView:tableView];
        [(BKMessageBookUpdateCell*)cell setDataModel:model];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 7.f;
    }
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XG_NoticeModel *model = self.dataArray[indexPath.section];
    if (model.showType == 1) {//showType 1活动 2缺书登记
        if (model.templateUrl.length) {

        BKCustomWebViewCtr *ctr = [[BKCustomWebViewCtr alloc]init];
        ctr.url = model.templateUrl;
        [APP_DELEGATE.navigationController pushViewController:ctr animated:YES];
        }
    }else if (model.showType == 2){
        if (model.jumpType == 2 && model.indoorType == 1 && model.activityId) {
            IntensiveReadingController *vc = [[IntensiveReadingController alloc]init];
            vc.bookid = [NSString stringWithFormat:@"%d",model.activityId];
            [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
        }else{
            if (model.templateUrl.length) {
                BKCustomWebViewCtr *ctr = [[BKCustomWebViewCtr alloc]init];
                ctr.url = model.templateUrl;
                [APP_DELEGATE.navigationController pushViewController:ctr animated:YES];
            }
        }
    }
    if (!model.isRead) {
        [XG_PushManager upDate:model Statuse:!model.isRead Callback:^(BOOL result) {
            NSLog(@"更新已读状态-%ld",result);
        }];
    }
}

- (void)addDataTempView{
    if (self.backView == nil) {
        CGRect imageBound = CGRectMake(0, 0, 375, 200);
        UIImage *backImage = [UIImage imageNamed:@"Message_cellNOData_icon"];
        NSString *title = @"小布还没有给你发消息哦~";
        self.backView = [[BKMessageNODataBackView alloc]initWithImageBound:imageBound WithImage:backImage WithTitle:title andPicOffset:-100 andLableOffset:-15];
        _backView.frame = CGRectMake(0, 0, self.myTableView.frame.size.width, self.myTableView.frame.size.height);
        _backView.backgroundColor = COLOR_STRING(@"#F7F9FB");
        _backView.titlefont = [UIFont systemFontOfSize:13.f];
        _backView.titlefontColor = COLOR_STRING(@"#999999");
    }
    [self.myTableView addSubview:_backView];
}

#pragma mark - P_QLDragToRefresh 刷新
- (UIScrollView *)dragRefreshView{
    return self.myTableView;
}
- (BOOL)hasHeaderDragRefresh{
    return YES;
}
- (BOOL)hasFootterDragRefresh{
    return NO;
}
- (void)dragReload:(BOOL)bMore{
    if (bMore == YES) {
        //加载更多
    }else{
        //刷新
        [self getDataArrayForDB];
    }
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

@end
