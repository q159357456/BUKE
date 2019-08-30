//
//  PictureBookView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/3.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "PictureBookView.h"
#import "ClassifyMenuView.h"
#import "SeriesOfBooks.h"
#import "BookCategoryService.h"
#import "BookCategoryObject.h"
#import "BookTableCell.h"
#import "FetchBannerPicService.h"
#import "FetchBannerPicObjec.h"
#import "UIImageView+WebCache.h"
#import "SeriesBookService.h"
#import "SeriesBookSeriesNameService.h"
#import "XBKWebViewController.h"
#import "BookMenuView.h"
#import "GCCycleScrollView.h"
#import "MBProgressHUD+XBK.h"
#import <MJRefresh.h>
#import "MiniBuKe-Swift.h"

@interface PictureBookView ()<UIScrollViewDelegate,GCCycleScrollViewDelegate>

//@property(nonatomic,strong) UIImageView *advertisingImageView;
@property(nonatomic,strong) UIView *centerView;
@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) NSMutableArray *classifyMenuViews;
@property(nonatomic,strong) UIScrollView *myScrollView;

@property(nonatomic,strong) SeriesOfBooks *seriesOfBooks;

@property(nonatomic,strong) NSArray *dataArray;
@property(nonatomic,strong) NSArray *advArray;
@property(nonatomic,strong) NSArray *mSeriesBookServiceArray;
@property(nonatomic,strong) BookMenuView *mBookMenuView;
@property(nonatomic,strong) GCCycleScrollView *cycleScroll;
@property(nonatomic,strong) PictureBookViewModule *mPictureBookViewModule;


@end

@implementation PictureBookView


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
    
    self.mPictureBookViewModule = [[PictureBookViewModule alloc] init];
    [self.mPictureBookViewModule initViewModuleWithScrollView:self.myScrollView view:self];
    
    [self loadData];
    
    return self;
}

-(void) loadData
{
//    self.isLoadOne = false;
//    self.isLoadTwo = false;
//    self.isLoadThree = false;
    
    [self onFetchBannerPicService];
    
}


-(void)onSeriesBookSeriesNameService
{  
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"SeriesBookSeriesNameService ==> OnSuccess");
        SeriesBookSeriesNameService *service = (SeriesBookSeriesNameService*)httpInterface;
        if (service.dataArray != nil && service.dataArray.count > 0) {
            
            self.isLoadOne = true;
            
            self.mSeriesBookServiceArray = service.dataArray;
            [self updateSeriesOfBooks:self.mSeriesBookServiceArray];
            
//            NSLog(@"self.mSeriesBookServiceArray ==> %i",self.mSeriesBookServiceArray.count);
//            [self updateSeriesOfBooks:self.mSeriesBookServiceArray];
            
            [self onBookCategoryService];
            
        }
        //        //NSLog(@"BookCategoryService ==> %i",service.array.count);
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"SeriesBookSeriesNameService ==> OnError");
        [MBProgressHUD showError:description];
        self.isLoadOne = false;
        
        [self.mPictureBookViewModule onServiceError];
    };
    
    SeriesBookSeriesNameService *service = [[SeriesBookSeriesNameService alloc] init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token setType:SeriesBookSeriesNameServiceType_Book];
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
            mSeriesOfBooks = [[SeriesOfBooks alloc]initWithFrame:rectSize setSeriesListObject:obj setType:SeriesBookServiceType_Book];
            
            [_myScrollView addSubview:mSeriesOfBooks];
        }
        
        //[self.seriesOfBooks updateData:array];
        
        _myScrollView.contentSize = CGSizeMake(self.frame.size.width,mSeriesOfBooks.frame.origin.y + mSeriesOfBooks.frame.size.height + 10);
        
    }
}

-(void)onFetchBannerPicService
{
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"FetchBannerPicService ==> OnSuccess");
        FetchBannerPicService *service = (FetchBannerPicService*)httpInterface;
        if (service.array != nil && service.array.count > 0) {
            
            self.isLoadTwo = true;
            
            self.advArray = service.array;
            [self updateADVImageView:self.advArray];
            
            [self onSeriesBookSeriesNameService];
        }
//        //NSLog(@"BookCategoryService ==> %i",service.array.count);
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"FetchBannerPicService ==> OnError");
        self.isLoadTwo = false;
        [MBProgressHUD showError:description];
        
        [self.mPictureBookViewModule onServiceError];
    };
    
    FetchBannerPicService *service = [[FetchBannerPicService alloc] init:OnSuccess setOnError:OnError setFetchBannerPicServiceType:FetchBannerPicServiceType_Book];
    [service start];
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

-(void)onBookCategoryService
{
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"BookCategoryService ==> OnSuccess");
        BookCategoryService *service = (BookCategoryService*)httpInterface;
        if (service.array != nil && service.array.count > 0) {
            
            self.isLoadThree = true;
            
            self.dataArray = service.array;
//            [self updateClassifyMenuView:service.array];
            NSLog(@"BookCategoryService Array => %i",self.dataArray.count);
            [self.mBookMenuView updateDataView:self.dataArray];
            
            [self.mPictureBookViewModule onServiceSuccess];
        }
        //NSLog(@"BookCategoryService ==> %i",service.array.count);
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"BookCategoryService ==> OnError");
        self.isLoadThree = false;
        [MBProgressHUD showError:description];
        
        [self.mPictureBookViewModule onServiceError];
    };
    
    
    
    BookCategoryService *service = [[BookCategoryService alloc] init:OnSuccess setOnError:OnError];
    [service start];
}

-(void) updateClassifyMenuView:(NSMutableArray *) array
{
//    for (int i = 0; i < 8; i++) {
//        BookCategoryObject *mBookCategoryObject = [[BookCategoryObject alloc]init];
//
//        mBookCategoryObject.categoryName = [NSString stringWithFormat:@"%@%i",@"发送到",i ];
//        [array addObject: mBookCategoryObject];
//    }
    
    for (int i = 0; i < 8; i ++) {
        
        if(i == 7){
            if (array.count >= 8) {
                ClassifyMenuView *mClassifyMenuView = (ClassifyMenuView *)[_classifyMenuViews objectAtIndex:i];
                mClassifyMenuView.dataArray = array;
                [mClassifyMenuView updateData:@"更多" setImageUrl:@"更多"];
                [mClassifyMenuView show];
            } else {
                ClassifyMenuView *mClassifyMenuView = (ClassifyMenuView *)[_classifyMenuViews objectAtIndex:i];
                [mClassifyMenuView hide];
            }
        } else {
            if (i < array.count) {
                BookCategoryObject *mBookCategoryObject = (BookCategoryObject *)[array objectAtIndex:i];
                ClassifyMenuView *mClassifyMenuView = (ClassifyMenuView *)[_classifyMenuViews objectAtIndex:i];
                
//                mClassifyMenuView.dataArray = array;
                mClassifyMenuView.mBookCategoryObject = mBookCategoryObject;
                
                [mClassifyMenuView show];
                [mClassifyMenuView updateData:mBookCategoryObject.categoryName setImageUrl:mBookCategoryObject.picUrl];
            } else {
                ClassifyMenuView *mClassifyMenuView = (ClassifyMenuView *)[_classifyMenuViews objectAtIndex:i];
                [mClassifyMenuView hide];
            }
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
    
    /*
    _advertisingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 180)];
    //[_advertisingImageView setImage:[UIImage imageNamed:@"bg_advertising"]];
    _advertisingImageView.userInteractionEnabled = YES;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 180)];
    [button addTarget:self action:@selector(advertisingImageViewClick:) forControlEvents:UIControlEventTouchUpInside];
    [_advertisingImageView addSubview:button];
    
    [_myScrollView addSubview:_advertisingImageView];
    */
    
    self.cycleScroll = [[GCCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 180)];
    self.cycleScroll.delegate = self;
    self.cycleScroll.autoScrollTimeInterval = 3.0;
    self.cycleScroll.backgroundColor = COLOR_STRING(@"#F4F4F4");
    self.cycleScroll.dotColor = [UIColor clearColor];
    self.cycleScroll.pageControlDotSize = CGSizeZero;
    [_myScrollView addSubview:self.cycleScroll];
    NSArray *images = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"place_kidbook_a"],nil];
    self.cycleScroll.localImageGroups = images;
    
//    [_advertisingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self);
//        make.width.equalTo(self);
//        make.height.mas_equalTo(150);
//    }];
    
    _centerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.cycleScroll.frame.size.height, self.frame.size.width, 120)];
    [_centerView setBackgroundColor: [UIColor whiteColor] ];
    [_myScrollView addSubview:_centerView];
    
//    [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_advertisingImageView.mas_bottom);
//        make.width.equalTo(self);
//        make.height.mas_equalTo(180);
//    }];
    
//    _bottomView = [[UIView alloc] init];
//    [_bottomView setBackgroundColor: [UIColor whiteColor] ];
//    [self addSubview:_bottomView];
    
//    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_centerView.mas_bottom).with.offset(10);
//        make.width.equalTo(self);
//        make.bottom.equalTo(self).with.offset(-10);
//    }];
    
    [self addCenterViewChild];
    
    self.seriesOfBooks = [[SeriesOfBooks alloc]initWithFrame:CGRectMake(0, _centerView.frame.origin.y + _centerView.frame.size.height + 10, self.frame.size.width, BookTableCell_kCellHeight + 37)];
    [_myScrollView addSubview:self.seriesOfBooks];
    
    _myScrollView.contentSize = CGSizeMake(self.frame.size.width,self.seriesOfBooks.frame.origin.y + self.seriesOfBooks.frame.size.height);
}

-(void)cycleScrollView:(GCCycleScrollView *)cycleScrollView didSelectItemAtRow:(NSInteger)row{
    NSLog(@"click => i% =%ld",(long)row);
    if (self.advArray != nil && self.advArray.count > 0) {
//       FetchBannerPicObjec *mFetchBannerPicObjec = [self.advArray objectAtIndex:row];
//        XBKWebViewController *mXBKWebViewController = [[XBKWebViewController alloc] init:mFetchBannerPicObjec.picURL];
//        [APP_DELEGATE.navigationController pushViewController:mXBKWebViewController animated:YES];
    }
    
}


-(void) addCenterViewChild{
    
    self.mBookMenuView = [BookMenuView xibView];
    self.mBookMenuView.frame = CGRectMake(0, 0,_myScrollView.frame.size.width, self.mBookMenuView.frame.size.height);
    [_centerView addSubview:self.mBookMenuView];
    
    /*
    _classifyMenuViews = [[NSMutableArray alloc] init];
    
    for(int i = 0;i < 8;i ++){
        if (i < 4) {
            ClassifyMenuView *classifyMenuView = [[ClassifyMenuView alloc]initWithFrame:CGRectMake((self.frame.size.width/4) * i +(self.frame.size.width/4) / 2 - 60/2, 180/4 - 80/2, 60, 80)];
            
            [_centerView addSubview:classifyMenuView];
            [_classifyMenuViews addObject:classifyMenuView];
            classifyMenuView.categoryType = CategoryBook;
            //[classifyMenuView updateData:@"绘本" setColor:COLOR_STRING(@"#1B9EEC")];
        } else {
            ClassifyMenuView *classifyMenuView = [[ClassifyMenuView alloc]initWithFrame:CGRectMake((self.frame.size.width/4) * (i - 4) +(self.frame.size.width/4) / 2 - 60/2, 180/2 + 180/4 - 80/2, 60, 80)];
            
            [_centerView addSubview:classifyMenuView];
            [_classifyMenuViews addObject:classifyMenuView];
            classifyMenuView.categoryType = CategoryBook;
            //[classifyMenuView updateData:@"绘本" setColor:COLOR_STRING(@"#1B9EEC")];
        }
    }
    */
    
//    if(true){
//        SeriesOfBooks *seriesOfBooks = [[SeriesOfBooks alloc]initWithFrame:CGRectMake(0, 132 , self.frame.size.width, 132)];
//        [_bottomView addSubview:seriesOfBooks];
//    }
    
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
