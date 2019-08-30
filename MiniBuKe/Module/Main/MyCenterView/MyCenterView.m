//
//  MyCenterView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/3.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "MyCenterView.h"
#import "MyCenterTopView.h"
#import "MyCenterCenterView.h"
#import "StaticIndexService.h"
#import "StaticIndexObject.h"
#import "SeriesBookSeriesNameService.h"
#import "SeriesOfBooks.h"
#import "BookTableCell.h"
#import "BookHistoryReadInfoService.h"
#import "BookHistoryReadInfo.h"
#import <MJRefresh.h>

@interface MyCenterView ()<UIScrollViewDelegate,MyCenterCenterViewDelegate>

@property(nonatomic,strong) UIScrollView *myScrollView;

@property(nonatomic,strong) UIView *topView;
//@property(nonatomic,strong) UIView *centerView;
//@property(nonatomic,strong) UIView *bottomView;

@property(nonatomic,strong) UIView *viwe1;
@property(nonatomic,strong) SeriesOfBooks *seriesOfBooks;

@property (nonatomic,strong) StaticIndexObject *mStaticIndexObject;
@property(nonatomic,strong) NSArray *mSeriesBookServiceArray;
@property (nonatomic,strong) MyCenterCenterView *mMyCenterCenterView;

@property (nonatomic,strong) BookHistoryReadInfo *mBookHistoryReadInfo;

@property (nonatomic,strong) MyCenterTopView *mBabyBookrackMenu;
@property (nonatomic,strong) MyCenterTopView *mListenCollectMenu;
@property (nonatomic,strong) MyCenterTopView *mRecentlyPlayMenu;
@property (nonatomic,strong) MyCenterTopView *mMyCenterTopView;

@end

@implementation MyCenterView


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        [self setBackgroundColor: COLOR_STRING(@"#F3F2F2")];
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 360/2, self.frame.size.height/2 - 238/2, 360, 238)];
//        //[imageView setImage: UIImage];
//        [self addSubview:imageView];

        
        [self onStaticIndexService];
        //[self initView];
    }
    return  self;
}

- (void)headRefresh{
    
    [self onStaticIndexService];
}

-(void) updateTopMenuData
{
    [self updateStaticIndexService];
}

-(void) updateTopMenuDataView
{
    if (self.mBabyBookrackMenu != nil) {
        [self.mBabyBookrackMenu updateDataView:@"宝宝书架" setIcon:@"我的_宝宝书架" setNumber:[NSString stringWithFormat:@"%@",self.mStaticIndexObject != nil ?self.mStaticIndexObject.book : @"0" ] ];
    }
    
    if (self.mListenCollectMenu != nil) {
        [self.mListenCollectMenu updateDataView:@"听听收藏" setIcon:@"我的_故事收藏" setNumber:[NSString stringWithFormat:@"%@",self.mStaticIndexObject != nil ?self.mStaticIndexObject.story : @"0"] ];
    }
    
    if (self.mMyCenterTopView != nil) {
        [self.mMyCenterTopView updateDataView:@"K绘本" setIcon:@"我的_K绘本" setNumber:[NSString stringWithFormat:@"%@",self.mStaticIndexObject.kbook != nil ?self.mStaticIndexObject.kbook : @"0"] ];
    }
    
    //最近播放
    if (self.mRecentlyPlayMenu != nil) {
        
        NSData *readData = [[NSUserDefaults standardUserDefaults] objectForKey:@"recentPlay"];
        NSArray *recentPlayArray = [NSKeyedUnarchiver unarchiveObjectWithData:readData];
        
        if (recentPlayArray.count > 0) {
            [self.mRecentlyPlayMenu updateDataView:@"最近播放" setIcon:@"我的_最近播放" setNumber:[NSString stringWithFormat:@"%ld",recentPlayArray.count]];
        }else{
            [self.mRecentlyPlayMenu updateDataView:@"最近播放" setIcon:@"我的_最近播放" setNumber:[NSString stringWithFormat:@"%d",0]];
        }
        
//        [self.mRecentlyPlayMenu updateDataView:@"最近播放" setIcon:@"我的_最近播放" setNumber:[NSString stringWithFormat:@"%@",self.mStaticIndexObject != nil ?self.mStaticIndexObject.recentlyPlay : @"0"] ];
    }
}

-(void)updateStaticIndexService
{
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"StaticIndexService ==> OnSuccess");
        StaticIndexService *service = (StaticIndexService*)httpInterface;
        if (service.mStaticIndexObject != nil) {
            self.mStaticIndexObject = service.mStaticIndexObject;
            
            [self updateTopMenuDataView];
        }
        
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"StaticIndexService ==> OnError");
        //[self initView];
    };
    
    StaticIndexService *service = [[StaticIndexService alloc] init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token];
    [service start];
}


-(void)onStaticIndexService
{
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"StaticIndexService ==> OnSuccess");
        StaticIndexService *service = (StaticIndexService*)httpInterface;
        if (service.mStaticIndexObject != nil) {
            self.mStaticIndexObject = service.mStaticIndexObject;
            
            [self onBookHistoryReadInfoService];
            
        }
        
    };

    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"StaticIndexService ==> OnError");
        [self initView];
        [self.myScrollView.mj_header endRefreshing];
    };

    StaticIndexService *service = [[StaticIndexService alloc] init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token];
    [service start];
}

-(void)onBookHistoryReadInfoService
{
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"onBookHistoryReadInfoService ==> OnSuccess");
        BookHistoryReadInfoService *service = (BookHistoryReadInfoService*)httpInterface;
        
        self.mBookHistoryReadInfo = service.mBookHistoryReadInfo;
        [self.myScrollView.mj_header endRefreshing];
        [self initView];
        
        //[self onSeriesBookSeriesNameService];
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"onBookHistoryReadInfoService ==> OnError");
        [self initView];
        [self.myScrollView.mj_header endRefreshing];
    };
    
    BookHistoryReadInfoService *service = [[BookHistoryReadInfoService alloc] init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token];
//    NSLog(@"token===>%@",APP_DELEGATE.mLoginResult.token);
    [service start];
}

-(void)onSeriesBookSeriesNameService
{
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"SeriesBookSeriesNameService ==> OnSuccess");
        SeriesBookSeriesNameService *service = (SeriesBookSeriesNameService*)httpInterface;
        if (service.dataArray != nil && service.dataArray.count > 0) {
            
            self.mSeriesBookServiceArray = service.dataArray;
            [self.myScrollView.mj_header endRefreshing];
            [self initView];
            
            [self updateSeriesOfBooks:self.mSeriesBookServiceArray];
            
        }
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"SeriesBookSeriesNameService ==> OnError");
        [self initView];
        [self.myScrollView.mj_header endRefreshing];
    };
    
    SeriesBookSeriesNameService *service = [[SeriesBookSeriesNameService alloc] init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token setType:SeriesBookSeriesNameServiceType_My];
    [service start];
}

-(void)updateSeriesOfBooks:(NSArray *) array
{
    NSLog(@"updateSeriesOfBooks ===> %lu",(unsigned long)array.count);
    if(array != nil && array.count > 0){
        [self.seriesOfBooks removeFromSuperview];
        CGRect rectSize;
        SeriesOfBooks *mSeriesOfBooks;
        for (int i = 0; i < array.count; i ++) {
            if (i != 0) {
                rectSize = CGRectMake(0, mSeriesOfBooks.frame.origin.y + mSeriesOfBooks.frame.size.height + 10, self.frame.size.width, BookTableCell_kCellHeight + 37);
            } else {
                rectSize = CGRectMake(0, self.mMyCenterCenterView.frame.origin.y + self.mMyCenterCenterView.frame.size.height + 10, self.frame.size.width, BookTableCell_kCellHeight + 37);
            }
            
            SeriesListObject *obj = [array objectAtIndex:i];
            mSeriesOfBooks = [[SeriesOfBooks alloc]initWithFrame:rectSize setSeriesListObject:obj setType:SeriesBookServiceType_My];
            
            [_myScrollView addSubview:mSeriesOfBooks];
        }
        
        //[self.seriesOfBooks updateData:array];
        
        _myScrollView.contentSize = CGSizeMake(self.frame.size.width,mSeriesOfBooks.frame.origin.y + mSeriesOfBooks.frame.size.height + 20 );
        
    }
}


-(void)initView{
    [self setBackgroundColor: COLOR_STRING(@"#E9E9E9")];
//    if (self.myScrollView != nil) {
//        [self.myScrollView removeFromSuperview];
//    }
    
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
    
    //if (IS_FULL_VERSION) {
//        [self createTopViewChild];
    //}
    [self createCenterViewChild];
    //[self createBottomViewChild];
    
    //_myScrollView.contentSize = CGSizeMake(self.frame.size.width,2000.0f);
    
//    self.myScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
}

-(void) createTopViewChild
{
    self.viwe1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 150)];
    [self.viwe1 setBackgroundColor:[UIColor whiteColor]];
    [_myScrollView addSubview: self.viwe1];
    //self.viwe1.hidden = YES;
    int itemCount = 4;
    
    //宝宝书架
    self.mBabyBookrackMenu = [MyCenterTopView xibView];
    self.mBabyBookrackMenu.frame = CGRectMake((_myScrollView.frame.size.width / itemCount - 4) * 0 , 0, self.mBabyBookrackMenu.frame.size.width, self.mBabyBookrackMenu.frame.size.height);
    [self.viwe1 addSubview:self.mBabyBookrackMenu];
    
    [self.mBabyBookrackMenu updateDataView:@"宝宝书架" setIcon:@"我的_宝宝书架" setNumber:[NSString stringWithFormat:@"%@",self.mStaticIndexObject != nil ?self.mStaticIndexObject.book : @"0" ] ];
    
    //听听收藏
    self.mListenCollectMenu = [MyCenterTopView xibView];
    self.mListenCollectMenu.frame = CGRectMake((_myScrollView.frame.size.width / itemCount - 4) * 1 , 0, self.mListenCollectMenu.frame.size.width, self.mListenCollectMenu.frame.size.height);
    [self.viwe1 addSubview:self.mListenCollectMenu];
    
    [self.mListenCollectMenu updateDataView:@"听听收藏" setIcon:@"我的_故事收藏" setNumber:[NSString stringWithFormat:@"%@",self.mStaticIndexObject != nil ?self.mStaticIndexObject.story : @"0"] ];
    
    self.mMyCenterTopView = [MyCenterTopView xibView];
    self.mMyCenterTopView.frame = CGRectMake((_myScrollView.frame.size.width / itemCount - 4) * 2 , 0, self.mMyCenterTopView.frame.size.width, self.mMyCenterTopView.frame.size.height);
    [self.viwe1 addSubview:self.mMyCenterTopView];
    
    [self.mMyCenterTopView updateDataView:@"K绘本" setIcon:@"我的_K绘本" setNumber:[NSString stringWithFormat:@"%@",self.mStaticIndexObject != nil ?self.mStaticIndexObject.kbook : @"0"] ];
    
    self.mRecentlyPlayMenu = [MyCenterTopView xibView];
    self.mRecentlyPlayMenu.frame = CGRectMake((_myScrollView.frame.size.width / itemCount - 4) * 3 , 0, self.mRecentlyPlayMenu.frame.size.width, self.mRecentlyPlayMenu.frame.size.height);
    [self.viwe1 addSubview:self.mRecentlyPlayMenu];
    
    NSData *readData = [[NSUserDefaults standardUserDefaults] objectForKey:@"recentPlay"];
    NSArray *recentPlayArray = [NSKeyedUnarchiver unarchiveObjectWithData:readData];
    if (recentPlayArray != nil) {
        [self.mRecentlyPlayMenu updateDataView:@"最近播放" setIcon:@"我的_最近播放" setNumber:[NSString stringWithFormat:@"%i",recentPlayArray.count] ];
    } else {
        [self.mRecentlyPlayMenu updateDataView:@"最近播放" setIcon:@"我的_最近播放" setNumber:@"0" ];
    }
    
}

-(void) createCenterViewChild
{
    self.mMyCenterCenterView = [MyCenterCenterView xibView];
    self.mMyCenterCenterView.frame = CGRectMake(0, self.viwe1.frame.size.height + self.viwe1.frame.origin.y, _myScrollView.frame.size.width, self.mMyCenterCenterView.frame.size.height);
    [_myScrollView addSubview:self.mMyCenterCenterView];
    [self.mMyCenterCenterView updateDataView:CGSizeMake(_myScrollView.frame.size.width, 0) setBookHistoryReadInfo:self.mBookHistoryReadInfo setDelegate:self];
}

#pragma MyCenterCenterViewDelegate
-(void) onViewFrameChange
{
    NSLog(@"self.mMyCenterCenterView.frame.origin.y + self.mMyCenterCenterView.frame.size.height => %f",self.mMyCenterCenterView.frame.origin.y + self.mMyCenterCenterView.frame.size.height);
    _myScrollView.contentSize = CGSizeMake(self.frame.size.width,self.mMyCenterCenterView.frame.origin.y + self.mMyCenterCenterView.frame.size.height + 20);
}

-(void) createBottomViewChild
{
    self.seriesOfBooks = [[SeriesOfBooks alloc]initWithFrame:CGRectMake(0, self.mMyCenterCenterView.frame.origin.y + self.mMyCenterCenterView.frame.size.height + 10, self.frame.size.width, BookTableCell_kCellHeight + 37)];
    [_myScrollView addSubview:self.seriesOfBooks];
    
    _myScrollView.contentSize = CGSizeMake(self.frame.size.width,self.seriesOfBooks.frame.origin.y + self.seriesOfBooks.frame.size.height + 20);
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"Did end decelerating");
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    NSLog(@"Did scroll");
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                 willDecelerate:(BOOL)decelerate{
    NSLog(@"Did end dragging");
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    NSLog(@"Did begin decelerating");
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"Did begin dragging");
}



@end
