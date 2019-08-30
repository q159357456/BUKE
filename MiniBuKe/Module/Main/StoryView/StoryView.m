//
//  StoryView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/3.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "StoryView.h"
#import "ClassifyMenuView.h"
#import "SeriesOfBooks.h"
#import "BookCategoryObject.h"
#import "BookTableCell.h"
#import "SeriesBookService.h"
#import "FetchBannerPicService.h"
#import "FetchBannerPicObjec.h"
#import "UIImageView+WebCache.h"
#import "StoryCategoryObject.h"
#import "SeriesBookSeriesNameService.h"
#import "GCCycleScrollView.h"
#import "XBKWebViewController.h"
#import "MBProgressHUD+XBK.h"
#import "MiniBuKe-Swift.h"
#import "StoryV1CategoryService.h"
#import "NewPagedFlowView.h"
#import "XBKNetWorkManager.h"
#import "IntensiveReadingController.h"
#import "ComboToBuyController.h"

@interface StoryView ()<UIScrollViewDelegate,GCCycleScrollViewDelegate,NewPagedFlowViewDelegate,NewPagedFlowViewDataSource>

//@property(nonatomic,strong) UIImageView *advertisingImageView;
@property(nonatomic,strong) UIView *centerView;
@property(nonatomic,strong) UIView *bottomView;

@property(nonatomic,strong) NSMutableArray *classifyMenuViews;
@property(nonatomic,strong) UIScrollView *myScrollView;
@property(nonatomic,strong) SeriesOfBooks *seriesOfBooks;

@property(nonatomic,strong) NSArray *dataArray;
@property(nonatomic,strong) NSArray *advArray;
@property(nonatomic,strong) NSArray *mSeriesBookServiceArray;
@property(nonatomic,strong) GCCycleScrollView *cycleScroll;
@property(nonatomic,strong) StoryViewModule *mStoryViewModel;

@property(nonatomic, strong) NewPagedFlowView *BarnerView;
@property(nonatomic, strong) NSMutableArray *barnerList;
@property(nonatomic, strong) UIImageView *ToplineImageView;

@end

@implementation StoryView


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        [self initView];
    }
    
    self.mStoryViewModel = [[StoryViewModule alloc] init];
    [self.mStoryViewModel initViewModuleWithScrollView:self.myScrollView view:self];
    
    [self loadData];
    
    return self;
}

-(void) loadData
{
    //获取故事广告页
    [self onFetchBannerPicService];
    //获取故事分类
     [self onStoryCategoryService];
    //获取推荐系列
      [self onSeriesBookSeriesNameService];
}

-(void)onSeriesBookSeriesNameService
{
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"SeriesBookSeriesNameService ==> OnSuccess");
        SeriesBookSeriesNameService *service = (SeriesBookSeriesNameService*)httpInterface;
        if (service.dataArray != nil && service.dataArray.count > 0) {
            
            self.mSeriesBookServiceArray = service.dataArray;
            [self updateSeriesOfBooks:self.mSeriesBookServiceArray];
            
            [self.mStoryViewModel onServiceSuccess];

        }
   
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"SeriesBookSeriesNameService ==> OnError");
        [MBProgressHUD showError:description];
        
        [self.mStoryViewModel onServiceError];
    };
    
    SeriesBookSeriesNameService *service = [[SeriesBookSeriesNameService alloc] init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token setType:SeriesBookSeriesNameServiceType_Story];
    [service start];
}

-(void)updateSeriesOfBooks:(NSArray *) array
{
    if(array != nil && array.count > 0){
        [self.seriesOfBooks removeFromSuperview];
        CGRect rectSize;
        SeriesOfBooks *mSeriesOfBooks;
        for (int i = 0; i < array.count; i ++) {
            if (i != 0) {
                rectSize = CGRectMake(0, mSeriesOfBooks.frame.origin.y + mSeriesOfBooks.frame.size.height + 10, self.frame.size.width, BookTableCell_kCellHeight + 37);
            } else {
                rectSize = CGRectMake(0, _centerView.frame.origin.y + _centerView.frame.size.height + 10, self.frame.size.width, BookTableCell_kCellHeight + 37);
            }
            
            SeriesListObject *obj = [array objectAtIndex:i];
            mSeriesOfBooks = [[SeriesOfBooks alloc]initWithFrame:rectSize setSeriesListObject:obj setType:SeriesBookServiceType_Story];
            
            [_myScrollView addSubview:mSeriesOfBooks];
        }
        
        //[self.seriesOfBooks updateData:array];
        
        _myScrollView.contentSize = CGSizeMake(self.frame.size.width,mSeriesOfBooks.frame.origin.y + mSeriesOfBooks.frame.size.height + 10);
        
    }
}

-(void)onFetchBannerPicService
{
//    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
//        NSLog(@"FetchBannerPicService ==> OnSuccess");
//        FetchBannerPicService *service = (FetchBannerPicService*)httpInterface;
//        if (service.array != nil && service.array.count > 0) {
//
//            self.advArray = service.array;
//            [self updateADVImageView:self.advArray];
//
//        }
//    };
//
//    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
//    {
//        NSLog(@"FetchBannerPicService ==> OnError");
//        [MBProgressHUD showError:description];
//
//        [self.mStoryViewModel onServiceError];
//    };
//
//    FetchBannerPicService *service = [[FetchBannerPicService alloc] init:OnSuccess setOnError:OnError setFetchBannerPicServiceType:FetchBannerPicServiceType_Story];
//    [service start];
    
    [XBKNetWorkManager requestBarnnerWithType:@"3" AndFinish:^(BKBannerDataModel * _Nonnull model, NSError * _Nonnull error) {
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
}

-(void) updateADVImageView:(NSArray *) array
{
    if (array != nil && array.count > 0) {
        NSMutableArray *advURLs = [[NSMutableArray alloc] init];
        for (int i = 0; i < array.count; i ++) {
            FetchBannerPicObjec *mFetchBannerPicObjec = (FetchBannerPicObjec *)[array objectAtIndex:i];
            [advURLs addObject: [mFetchBannerPicObjec.picURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
        self.cycleScroll.imageUrlGroups = advURLs;
    }
}

-(void)onStoryCategoryService
{
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"StoryV1CategoryService ==> OnSuccess");
        StoryV1CategoryService *service = (StoryV1CategoryService*)httpInterface;
        if (service.array != nil && service.array.count > 0) {
            [self updateClassifyMenuView:service.array];
        }
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"StoryV1CategoryService ==> OnError");
        [MBProgressHUD showError:description];
        
        [self.mStoryViewModel onServiceError];
    };
    
    StoryV1CategoryService *service = [[StoryV1CategoryService alloc] init:OnSuccess setOnError:OnError];
    [service start];
}

-(void) updateClassifyMenuView:(NSMutableArray *) array
{
    for (int i = 0; i < 8; i ++) {
        if (i < array.count) {
//            BookCategoryObject *mBookCategoryObject = (BookCategoryObject *)[array objectAtIndex:i];
            StoryCategoryObject *mStoryCategoryObject = (StoryCategoryObject *)[array objectAtIndex:i];
            ClassifyMenuView *mClassifyMenuView = (ClassifyMenuView *)[_classifyMenuViews objectAtIndex:i];
            [mClassifyMenuView show];
//            [mClassifyMenuView updateData:mBookCategoryObject.categoryName setImageUrl:mBookCategoryObject.picUrl];
            [mClassifyMenuView updateData:mStoryCategoryObject.categoryName setImageUrl:mStoryCategoryObject.picUrl];
            mClassifyMenuView.categoryType = CategoryStory;
            mClassifyMenuView.mStoryCategoryObject = mStoryCategoryObject;
        } else {
            ClassifyMenuView *mClassifyMenuView = (ClassifyMenuView *)[_classifyMenuViews objectAtIndex:i];
            [mClassifyMenuView hide];
        }
        
    }
}

-(void)initView{
    //[self setBackgroundColor: [UIColor blueColor]];
    
    _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    //[_myScrollView setBackgroundColor:[UIColor redColor]];
    _myScrollView.accessibilityActivationPoint = CGPointMake(100, 100);
    //    imgView = [[UIImageView alloc]initWithImage:
    //               [UIImage imageNamed:@"AppleUSA.jpg"]];
    //    [myScrollView addSubview:imgView];
    _myScrollView.minimumZoomScale = 0.5;
    _myScrollView.maximumZoomScale = 3;
    
    _myScrollView.delegate = self;
    [_myScrollView setShowsVerticalScrollIndicator:NO];
    [self addSubview:_myScrollView];
    
    [self setBackgroundColor:COLOR_STRING(@"#F4F4F4")];
    
    
    self.BarnerView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_WIDTH*(163/375.0))];
    _BarnerView.delegate = self;
    _BarnerView.dataSource = self;
    _BarnerView.minimumPageAlpha = 0;
    _BarnerView.isCarousel = YES;
    _BarnerView.orientation = NewPagedFlowViewOrientationHorizontal;
    _BarnerView.isOpenAutoScroll = YES;
    _BarnerView.autoTime = 5.0;
    _BarnerView.topBottomMargin = 8;
    _BarnerView.leftRightMargin = 10;
    //初始化pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _BarnerView.frame.size.height - 32, 10, 8)];
    _BarnerView.pageControl = pageControl;
    [_BarnerView addSubview:pageControl];
    pageControl.hidden = YES;
    _BarnerView.backgroundColor = [UIColor whiteColor];
    [_myScrollView addSubview:_BarnerView];

    
    _centerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.BarnerView.frame.size.height, self.frame.size.width, 180)];
    [_centerView setBackgroundColor: [UIColor whiteColor] ];
    [_myScrollView addSubview:_centerView];
    
    
    [self addCenterViewChild];
    
    self.seriesOfBooks = [[SeriesOfBooks alloc]initWithFrame:CGRectMake(0, _centerView.frame.origin.y + _centerView.frame.size.height + 10, self.frame.size.width, BookTableCell_kCellHeight + 37)];
    [_myScrollView addSubview:self.seriesOfBooks];
    
    _myScrollView.contentSize = CGSizeMake(self.frame.size.width,self.seriesOfBooks.frame.origin.y + self.seriesOfBooks.frame.size.height);
    
    self.ToplineImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, -3, self.frame.size.width, 5)];
    _ToplineImageView.image = [UIImage imageNamed:@"navibar_bg line"];
    _ToplineImageView.hidden = YES;
    _ToplineImageView.alpha = 0.4;
    [self addSubview:_ToplineImageView];

}

-(void)cycleScrollView:(GCCycleScrollView *)cycleScrollView didSelectItemAtRow:(NSInteger)row{
    NSLog(@"click => i% =%ld",(long)row);
    
    if (self.advArray != nil && self.advArray.count > 0) {
//        FetchBannerPicObjec *mFetchBannerPicObjec = [self.advArray objectAtIndex:row];
//        XBKWebViewController *mXBKWebViewController = [[XBKWebViewController alloc] init:mFetchBannerPicObjec.picURL];
//        [APP_DELEGATE.navigationController pushViewController:mXBKWebViewController animated:YES];
    }
}

-(void) addCenterViewChild{
    
    _classifyMenuViews = [[NSMutableArray alloc] init];
    for(int i = 0;i < 8;i ++){
        if (i < 4) {
            ClassifyMenuView *classifyMenuView = [[ClassifyMenuView alloc]initWithFrame:CGRectMake((self.frame.size.width/4) * i +(self.frame.size.width/4) / 2 - 60/2, 180/4 - 80/2, 60, 80)];
            [_centerView addSubview:classifyMenuView];
            [_classifyMenuViews addObject:classifyMenuView];
            
//            [classifyMenuView updateData:@"故事" setColor:COLOR_STRING(@"#1B9EEC")];
        } else {
            ClassifyMenuView *classifyMenuView = [[ClassifyMenuView alloc]initWithFrame:CGRectMake((self.frame.size.width/4) * (i - 4) +(self.frame.size.width/4) / 2 - 60/2, 180/2 + 180/4 - 80/2, 60, 80)];
            
            [_centerView addSubview:classifyMenuView];
            [_classifyMenuViews addObject:classifyMenuView];
            
//            [classifyMenuView updateData:@"故事" setColor:COLOR_STRING(@"#1B9EEC")];
        }
    }
    
    SeriesOfBooks *seriesOfBooks = [[SeriesOfBooks alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, BookTableCell_kCellHeight + 37)];
    [_bottomView addSubview:seriesOfBooks];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    NSLog(@"Did end decelerating,%f",scrollView.contentOffset.y);
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//        NSLog(@"Did scroll");
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
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                 willDecelerate:(BOOL)decelerate{
//    NSLog(@"Did end dragging");
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
//    NSLog(@"Did begin decelerating");
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    NSLog(@"Did begin dragging");
}


#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return  CGSizeMake(flowView.frame.size.width - (30/375.0)*flowView.frame.size.width, (flowView.frame.size.width - (30/375.0)*flowView.frame.size.width) * (150 / 345.0));
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
//        bannerView.layer.cornerRadius = 20;
//        bannerView.layer.masksToBounds = YES;
    }
    bannerView.mainImageView.backgroundColor = COLOR_STRING(@"EAEAEA");
    BannerDataDetail *data = self.barnerList[index];
    CGFloat width = (SCREEN_WIDTH-20)*[UIScreen mainScreen].scale;
    NSString *picurl = [NSString stringWithFormat:@"%@?x-oss-process=image/resize,w_%d",data.picURL,(int)width];
    //在这里下载网络图片
    [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",picurl]] placeholderImage:[UIImage imageNamed:@"place_kidbook_a"]];
    
    return bannerView;
}

@end
