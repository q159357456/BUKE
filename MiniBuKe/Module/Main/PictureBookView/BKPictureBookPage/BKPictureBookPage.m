//
//  BKPictureBookPage.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/1.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKPictureBookPage.h"
#import "BKHomeJingDuTableViewCell.h"
#import "BKHomeBookTableViewCell.h"
#import "NewPagedFlowView.h"
#import "BKHomeCellHeadView.h"
#import "BKHomeBookCellHeadView.h"
#import "XBKNetWorkManager.h"
#import "BkHomeCategory.h"
#import "PBBaseViewControllerHelp.h"
#import "MJRefresh.h"
#import "BookListViewController.h"
#import "IntensiveReadingController.h"
#import "BKMoreNewBookListCtr.h"
#import "ComboToBuyController.h"
#import "BKHomeBookSelectionCell.h"
#import "BKRecommendBookListCtr.h"
#import "BKRecommendDetailsCtr.h"
#import "BookCategoryObject.h"
#import "AREntrance.h"
#import "BKlineLessonsTableCell.h"
#import "OnlineClassPlayController.h"
@interface BKPictureBookPage()<UITableViewDelegate,UITableViewDataSource,NewPagedFlowViewDelegate,NewPagedFlowViewDataSource,BKHomeBookCellHeadViewRightBtnDelegate,P_QLDragToRefresh,BkHomeCategoryDelegate,BKHomeBookCellDelegate,BKHomeJingDuCellDelegate,UIScrollViewDelegate>

@property(nonatomic, strong) UITableView *hometableView;
@property(nonatomic, strong) NewPagedFlowView *BarnerView;
@property(nonatomic, strong) NSMutableArray *barnerList;
@property(nonatomic, strong) NSMutableArray *bookCategoryList;
@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) HomeListData *listdata;
@property(nonatomic, strong) UIImageView *ToplineImageView;

@end

@implementation BKPictureBookPage

-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
    }
    
    [self customUI];
    [self requestLoadData];
    [self configureHeaderDragRefreshView];
    //添加easyar入口
//    AREntrance *entrance = [AREntrance initialEntranceWithFrame:CGRectMake(SCREEN_WIDTH-12-SCALE(68),kStatusBarH == 20?SCREEN_HEIGHT-kNavbarH-SCALE(74) - 61:SCREEN_HEIGHT-kNavbarH-SCALE(74) - 100, SCALE(68), SCALE(74))];
//    [self addSubview:entrance];
//    [self bringSubviewToFront:entrance];
    
    return self;
}

- (void)registerCustomTableViewCell{
    
    [self.hometableView registerClass:[BKHomeJingDuTableViewCell class] forCellReuseIdentifier:NSStringFromClass([BKHomeJingDuTableViewCell class])];
    [self.hometableView registerClass:[BKHomeBookTableViewCell class] forCellReuseIdentifier:NSStringFromClass([BKHomeBookTableViewCell class])];
    [self.hometableView registerClass:[BKHomeBookSelectionCell class] forCellReuseIdentifier:NSStringFromClass([BKHomeBookSelectionCell class])];
    [self.hometableView registerClass:[BKlineLessonsTableCell class] forCellReuseIdentifier:NSStringFromClass([BKlineLessonsTableCell class])];
    

}

-(void)requestLoadData{
    
    [XBKNetWorkManager requestBarnnerWithType:@"2" AndFinish:^(BKBannerDataModel * _Nonnull model, NSError * _Nonnull error) {
        if(error == nil){
            if(model.state == 1 && model.success){
                self.barnerList = model.data.BannerList;
                if (self.barnerList.count == 1) {
                    [self.barnerList addObject:model.data.BannerList.lastObject];
                }
                [self.BarnerView reloadData];
            }else{
                [MBProgressHUD showError:@"请求出错啦,请稍后重试"];
            }
        }else{
            [MBProgressHUD showError:@"网络异常,请稍后重试"];
        }
    }];
    
    [XBKNetWorkManager requestHomebookCategoryAndFinish:^(BKHomeBookCategoryModel * _Nonnull model, NSError * _Nonnull error) {
        if(error == nil){
            if(model.state == 1 && model.success){
                self.bookCategoryList = model.data.bookCategoryList;
                [self creatCategoryView];
                
            }else{
                [MBProgressHUD showError:@"请求出错啦,请稍后重试"];
            }
        }else{
            [MBProgressHUD showError:@"网络异常,请稍后重试"];
        }
    }];
    
    [XBKNetWorkManager requestHomeBookListWithType:@"2" andPage:1 andPageNumber:6 AndFinish:^(BKHomeListModel * _Nonnull model, NSError * _Nonnull error) {
        if(error == nil){
            if(model.state == 1 && model.success){
                self.listdata = model.data;
                [self.hometableView reloadData];
            }else{
                [MBProgressHUD showError:@"请求出错啦,请稍后重试"];
            }
        }else{
            [MBProgressHUD showError:@"网络异常,请稍后重试"];
        }
        [self stopRefresh];

    }];
}

-(void)customUI{
    
    [self addSubview:self.hometableView];
    [self registerCustomTableViewCell];

    self.BarnerView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_WIDTH*(163/375.0))];
    _BarnerView.delegate = self;
    _BarnerView.dataSource = self;
    _BarnerView.minimumPageAlpha = 0;
    _BarnerView.isCarousel = YES;
    _BarnerView.orientation = NewPagedFlowViewOrientationHorizontal;
    _BarnerView.isOpenAutoScroll = YES;
    _BarnerView.autoTime = 5.0;
    _BarnerView.topBottomMargin = 8;
    _BarnerView.leftRightMargin = 20;
    //初始化pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _BarnerView.frame.size.height - 32, 10, 8)];
    _BarnerView.pageControl = pageControl;
    [_BarnerView addSubview:pageControl];
    pageControl.hidden = YES;
    
    [_BarnerView reloadData];

    CGFloat h = (42.f/375.f)*SCREEN_WIDTH+23.f+20.f;

    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.BarnerView.frame.size.height+h*2+15.f)];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self.topView addSubview:_BarnerView];
    self.hometableView.tableHeaderView = self.topView;
    
    self.ToplineImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, -3, self.frame.size.width, 5)];
    _ToplineImageView.image = [UIImage imageNamed:@"navibar_bg line"];
    _ToplineImageView.hidden = YES;
    _ToplineImageView.alpha = 0.4;
    [self addSubview:_ToplineImageView];

}

- (void)creatCategoryView{
    
    for (id view in self.topView.subviews) {
        if (![view isKindOfClass:[NewPagedFlowView class]]) {
            [view removeFromSuperview];
        }
    }
    CGFloat w = (42.f/375.f)*SCREEN_WIDTH+20.f;
    CGFloat h = (42.f/375.f)*SCREEN_WIDTH+23.f+20.f;
    CGFloat offest = (SCREEN_WIDTH-4*w)/5.0;
    UIView *CView = [[UIView alloc]initWithFrame:CGRectMake(0,self.BarnerView.frame.size.height+15.f, SCREEN_WIDTH, 200)];
    NSInteger maxcount = self.bookCategoryList.count>8?8:self.bookCategoryList.count;
    for (int i= 0; i<maxcount; i++) {
        if (i<4) {
            BkHomeCategory *view = [[BkHomeCategory alloc]initWithFrame:CGRectMake(offest*(i+1)+w*i, 0, w, h)];
            bookCategoryDataModel *data = self.bookCategoryList[i];
            view.tag = i;
            [view setImageURl:data.picUrl andTitle:data.categoryName];
            view.delegate = self;
            [CView addSubview:view];
        }else{
            BkHomeCategory *view = [[BkHomeCategory alloc]initWithFrame:CGRectMake(offest*(i-4+1)+w*(i-4), h, w, h)];
            bookCategoryDataModel *data = self.bookCategoryList[i];
            view.tag = i;
            [view setImageURl:data.picUrl andTitle:data.categoryName];
            view.delegate = self;
            [CView addSubview:view];
        }
    }
    [self.topView addSubview: CView];
}

#pragma mark - CategoryBtnClick

-(void)CategoryBtnClick:(int)type{
    
    BookCategoryObject *data = (BookCategoryObject*)self.bookCategoryList[type];
    //统计上报
    [[BaiduMobStat defaultStat] logEvent:@"c_hCategory100" eventLabel:data.categoryName];
    BookListViewController *mBookListViewController = [[BookListViewController alloc] init:nil mBookCategoryObject:data];
    [APP_DELEGATE.navigationController pushViewController:mBookListViewController animated:YES];
}

#pragma mark - tableviewDelegate&dataSource
-(UITableView *)hometableView{
    if (_hometableView == nil) {
        _hometableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStyleGrouped];
        _hometableView.delegate = self;
        _hometableView.dataSource = self;
        _hometableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _hometableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            
        }
        _hometableView.estimatedRowHeight = 0;
        _hometableView.estimatedSectionFooterHeight = 0;
        _hometableView.estimatedSectionHeaderHeight = 0;
        _hometableView.backgroundColor = COLOR_STRING(@"#FFFFFF");
        _hometableView.showsVerticalScrollIndicator = NO;
    }
    return  _hometableView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (indexPath.section == 0 ) {//每周精读模块
//        if (self.listdata.themeList.xbkThemeList.count) {
//            cell = [BKHomeJingDuTableViewCell BKBaseTableViewCellWithTableView:tableView];
//            [(BKHomeJingDuTableViewCell*)cell setModelWith:self.listdata.themeList];
//            ((BKHomeJingDuTableViewCell*)cell).delegate = self;
//
//        }else{
//            return nil;
//        }
        if (self.listdata.onlineCourse.onlineCourseList.count) {
            cell = [BKlineLessonsTableCell BKBaseTableViewCellWithTableView:tableView];
            [(BKlineLessonsTableCell*)cell setModelWith:self.listdata.onlineCourse];
//            ((BKHomeJingDuTableViewCell*)cell).delegate = self;
            
        }else{
            return nil;
        }
    }else if (indexPath.section == 2 && self.listdata.recommendRanks.recommendBookList.count){//小布书单模块
        
        cell = [BKHomeBookSelectionCell BKBaseTableViewCellWithTableView:tableView];
        [(BKHomeBookSelectionCell*)cell setImageWithIndex:indexPath.row andModel:self.listdata.recommendRanks.recommendBookList[indexPath.row]];
    }
    else {
        cell = [BKHomeBookTableViewCell BKBaseTableViewCellWithTableView:tableView];
        NSInteger index = indexPath.section -1;
        if (self.listdata.recommendRanks.recommendBookList.count) {
            index = indexPath.section >2 ? indexPath.section-2:indexPath.section-1;
        }
        [(BKHomeBookTableViewCell*)cell setModelWith:self.listdata.seriesBookList[index]];
        ((BKHomeBookTableViewCell*)cell).delegate = self;

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section == 0 && self.listdata.themeList.xbkThemeList.count==0) {
//        return 0;
//    }else if (section == 2 && self.listdata.recommendRanks.recommendBookList.count){
//        return self.listdata.recommendRanks.recommendBookList.count;
//    }
    if (section == 0 && self.listdata.onlineCourse.onlineCourseList.count==0) {
        return 0;
    }else if (section == 2 && self.listdata.recommendRanks.recommendBookList.count){
        return self.listdata.recommendRanks.recommendBookList.count;
    }
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger number = 0;
    number = self.listdata.seriesBookList.count;
//    if (self.listdata.themeList.xbkThemeList.count) {
//        number +=1;
//    }
    if (self.listdata.onlineCourse.onlineCourseList.count) {
        number +=1;
    }
    if (self.listdata.recommendRanks.recommendBookList.count) {
        number +=1;
    }
    return number;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.listdata.onlineCourse.onlineCourseList.count) {
            return [BKlineLessonsTableCell heightForCellWithObject:nil];
        }else{
            return 0;
        }
    }else if (indexPath.section == 2 && self.listdata.recommendRanks.recommendBookList.count){
        
        return [BKHomeBookSelectionCell heightForCellWithObject:nil];
    }
    else {
        NSInteger index = indexPath.section -1;
        if (self.listdata.recommendRanks.recommendBookList.count) {
            index = indexPath.section >2 ? indexPath.section-2:indexPath.section-1;
        }
        return [BKHomeBookTableViewCell heightForCellWithObject:self.listdata.seriesBookList[index]];
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.listdata.onlineCourse.onlineCourseList.count) {
            BKHomeCellHeadView *view = [[BKHomeCellHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 65)];
            [view setThemeTitleWith:self.listdata.onlineCourse.seriesName];
            [view.moreBtn addTarget:self action:@selector(moreLineClass) forControlEvents:UIControlEventTouchUpInside];
            return view;

        }else{
            return nil;
        }
//        if (self.listdata.onlineCourse.onlineCourseList.count) {
//            BKHomeBookCellHeadView *view = [[BKHomeBookCellHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60) andTitleStr:self.listdata.onlineCourse.seriesName andSection:44 andisHideLine:NO];
//            view.delegate = self;
//            return view;
//
//        }else{
//            return nil;
//        }
    }else if (section == 2 && self.listdata.recommendRanks.recommendBookList.count){
        BKHomeBookCellHeadView *view = [[BKHomeBookCellHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60) andTitleStr:self.listdata.recommendRanks.seriesName andSection:44 andisHideLine:NO];
        view.delegate = self;
        return view;
    }
    else{
        NSInteger index = section -1;
        if (self.listdata.recommendRanks.recommendBookList.count) {
            index = section >2 ? section-2:section-1;
        }
        seriesBookDataModel *data = self.listdata.seriesBookList[index];
        bool ishide = data.seriesType==2?NO:YES;
        BKHomeBookCellHeadView *view = [[BKHomeBookCellHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60) andTitleStr:data.seriesName andSection:data.seriesType andisHideLine:ishide];
        view.delegate = self;
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
//        if (self.listdata.themeList.xbkThemeList.count) {
//            return 65.f;
//        }else{
//            return 0.01f;
//        }
        if (self.listdata.onlineCourse.onlineCourseList.count) {
            return 65.f;
        }else{
            return 0.01f;
        }
    }else if (self.listdata.recommendRanks.recommendBookList.count && section == 2){
        return 60.f;
    }
    else{
        return 60.f;
    }
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2 && self.listdata.recommendRanks.recommendBookList.count) {
        return 12.f;
    }
    return 0.01f;
}
#pragma mark - 跳转书单详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2 && self.listdata.recommendRanks.recommendBookList.count) {
        recommendBookModel *model = self.listdata.recommendRanks.recommendBookList[indexPath.row];
        NSLog(@"点击了第id=%@ 书单",model.recommendId);
        if (model.recommendId.length) {
            BKRecommendDetailsCtr *ctr = [[BKRecommendDetailsCtr alloc]init];
            ctr.recommeId = model.recommendId;
            [APP_DELEGATE.navigationController pushViewController:ctr animated:YES];
            //百度埋点
            [[BaiduMobStat defaultStat] logEvent:@"c_brcd101" eventLabel:@"绘本首页" attributes:@{@"book": model.recommendName, @"id": model.recommendId}];
        }
    }
}
#pragma mark - BKHomeBookCellHeadViewRightBtnDelegate
-(void)homeTableHeaderViewRightBtnAction:(NSInteger)section{
    if (section == 2) {// 最新上架 更多
        BKMoreNewBookListCtr *ctr = [[BKMoreNewBookListCtr alloc]init];
        [APP_DELEGATE.navigationController pushViewController:ctr animated:YES];

    }else if (section == 44){ //小布书单-全部
        NSLog(@"All 书单");
        BKRecommendBookListCtr *ctr = [[BKRecommendBookListCtr alloc]init];
        [APP_DELEGATE.navigationController pushViewController:ctr animated:YES];
        
        [[BaiduMobStat defaultStat] logEvent:@"c_brcd100" eventLabel:@"绘本首页"];
    }
}

#pragma mark - BarnerCycleView

#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return  CGSizeMake(SCREEN_WIDTH-20, (flowView.frame.size.width - (30/375.0)*flowView.frame.size.width) * (150 / 345.0));
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    NSLog(@"点击了第%ld张图",(long)subIndex);
    BannerDataDetail *data = self.barnerList[subIndex];
    if(data.sortNum == 1){//跳转详情
        if (data.bookId.length) {
            IntensiveReadingController *vc = [[IntensiveReadingController alloc]init];
            vc.bookid = data.bookId;
            [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
        }
    }else if(data.sortNum == 2)
    {

        ComboToBuyController *vc = [[ComboToBuyController alloc]init];
        vc.url = ComboLongPic;
        vc.HaveBotom = YES;
        [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
//        [MobClick event:EVENT_Custom_100];
        

    }else if(data.sortNum == 3)
    {
        ComboToBuyController *vc = [[ComboToBuyController alloc]init];
        vc.url = ComboReturnIntroduce;
        vc.HaveBotom = NO;
        [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
//        [MobClick event:EVENT_Custom_100];
    }

}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
//    NSLog(@"ViewController 滚动到了第%ld页",pageNumber);
}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    return self.barnerList.count;
}

- (PGIndexBannerSubiew *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    PGIndexBannerSubiew *bannerView = [flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] init];
        bannerView.tag = index;
    }
    bannerView.mainImageView.backgroundColor = COLOR_STRING(@"EAEAEA");
    BannerDataDetail *data = self.barnerList[index];
    CGFloat width = (SCREEN_WIDTH-20)*[UIScreen mainScreen].scale;
    NSString *picurl = [NSString stringWithFormat:@"%@?x-oss-process=image/resize,w_%d",data.picURL,(int)width];
    //在这里下载网络图片
    [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", picurl]] placeholderImage:[UIImage imageNamed:@"place_kidbook_a"] options:SDWebImageRetryFailed];
    
    return bannerView;
}

#pragma mark - BKHomeBookCellDelegate& jingduClickDelegate
-(void)BKHomeBookClickWith:(NSString *)bookid{
//    NSLog(@"点击bookID=%@",bookid);
    IntensiveReadingController *vc = [[IntensiveReadingController alloc]init];
    vc.bookid = bookid;
    [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
}
-(void)BKHomeJingDuClickWith:(NSString *)bookid{
//    NSLog(@"点击bookID=%@",bookid);
    IntensiveReadingController *vc = [[IntensiveReadingController alloc]init];
    vc.bookid = bookid;
    [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
//    [MobClick event:EVENT_Custom_130];
}
#pragma mark - P_QLDragToRefresh 刷新
- (UIScrollView *)dragRefreshView{
    return self.hometableView;
}

- (BOOL)hasHeaderDragRefresh{
    return YES;
}

- (BOOL)hasFootterDragRefresh{
    return NO;
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
    }else{
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

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y>=200 && self.ToplineImageView.hidden == YES) {
        [UIView animateWithDuration:0.2 animations:^{
            self.ToplineImageView.alpha = 0.4;
        } completion:^(BOOL finished) {
            self.ToplineImageView.hidden = NO;
        }];
    }else if (scrollView.contentOffset.y<=200 && self.ToplineImageView.hidden == NO){
        [UIView animateWithDuration:0.2 animations:^{
            self.ToplineImageView.alpha = 0;
        } completion:^(BOOL finished) {
            self.ToplineImageView.hidden = YES;
            self.ToplineImageView.alpha = 0.4;
        }];
    }
}

#pragma mark - action
-(void)moreLineClass{
    NSLog(@"更多");
    OnlineClassPlayController * vc = [[OnlineClassPlayController alloc]init];
    vc.url = MoreCourseList;
    vc.titleSetting = @"在线课程";
    [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
}
@end
