//
//  EnglishView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/9/12.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "EnglishView.h"
#import "EnglishTableView.h"
#import "EnglishTableHeader.h"
#import "English_Header.h"
#import "EnglishService.h"
#import "EnglishCategoryService.h"
#import "MiniBuKe-Swift.h"
#import "TeachingMaterialViewController.h"
#import "EnglishSeriesBookService.h"
#import "SeriesList_Book_Detail_VC.h"
#import "BooklistObjet.h"
#import "TeachingProperties.h"
#import "Series.h"
#import "BookDetailViewController.h"
#import "MJRefresh.h"
#import "IntensiveReadingController.h"
#import "BookneededScanningCodeVC.h"
#import "EasyarViewController.h"
#import "CommonUsePackaging.h"
#import "ARManager.h"
#define BOTTOM_HEIGHT ([UIApplication sharedApplication].statusBarFrame.size.height>=44?84:50)
BooklistObjet* getBook_objct(Series *pro){
    
    BooklistObjet *obj = [[BooklistObjet alloc]init];
    obj.author = pro.bookName;
    obj.coverPic = pro.bookPath;
    obj.name = pro.bookName;
    obj.mid = pro.bookId;
    return obj;
    
}
@interface EnglishView()
@property(nonatomic,strong)EnglishTableView *tableview;
@property(nonatomic,strong)EnglishTableHeader *tableHeader;
@property(nonatomic,strong)UIView *topWhiteView;
@property(nonatomic,strong)EasyarViewController * vc;
@end

@implementation EnglishView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
//        [self initSubView];
//        [self get_textbook];
//        [self series_book_list];
//        //监听宝贝信息变化
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(babyinfoChanged) name:BabyInfo_HasChanged_Notifaction object:nil];
        //easyAR
        [ARManager configEasyAR];
        EasyarViewController *vc = [[EasyarViewController alloc]init];
        APP_DELEGATE.ARviewCtr = vc;
        UIViewController *parentController = [[CommonUsePackaging shareInstance] getCurrentVC];
        vc.view.frame =  CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-BOTTOM_HEIGHT);
        [parentController addChildViewController:vc];
        [self addSubview:vc.view];
//        self.backgroundColor = [UIColor redColor];
        self.vc = vc;
        
    }
    return self;
}
-(void)restart{
    
    [self.vc restart];
}
-(UIView *)topWhiteView
{
    if (!_topWhiteView) {
        _topWhiteView = [[UIView alloc]initWithFrame:CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kStatusBarH)];
        _topWhiteView.backgroundColor = [UIColor whiteColor];
    }
    return _topWhiteView;
}
//BabyInfo_HasChanged_Notifaction_action
-(void)babyinfoChanged{
     [self series_book_list];
     [self.tableHeader reloadData];
}
-(EnglishTableHeader *)tableHeader
{
    if(!_tableHeader)
    {
        _tableHeader = [EnglishTableHeader table_headerWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCALE(250))];
    }
    return _tableHeader;
        
}

-(void) addRefreshHeaderView
{
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing:)];
}

-(void)headerRefreshing:(id)sender
{
//    NSLog(@"refreshing ...");
    [self get_textbook];
    [self series_book_list];
    [self.tableHeader reloadData];
}

-(void)initSubView{
    self.backgroundColor = COLOR_STRING(@"#6FD06C");
    if (kStatusBarH == 44) {
        _tableview = [[EnglishTableView alloc]initWithFrame:CGRectMake(0,50, SCREEN_WIDTH, SCREEN_HEIGHT - 50 -  ([UIApplication sharedApplication].statusBarFrame.size.height>=44?84:50) + 20) style:UITableViewStylePlain];
    } else {
        // Fallback on earlier versions
        
        _tableview = [[EnglishTableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        
    }
   
    _tableview.tableHeaderView = self.tableHeader;
    _tableview.showsVerticalScrollIndicator = NO;
    [self addSubview:_tableview];
    [self addRefreshHeaderView];
    
}

-(void)eventName:(NSString *)eventname Params:(id)params
{
    if ([eventname isEqualToString:EnglishUpCell_Event]) {
        if (!params) {
            TeachingMaterialViewController *mTeachingMaterialViewController = [[TeachingMaterialViewController alloc] init];
            [APP_DELEGATE.navigationController pushViewController:mTeachingMaterialViewController animated:YES];
        }else
        {
            [EnglishSettingManager shareInstance].backToWhatPage = BACK_TO_FIST_PAGE;
            Teaching_Catagory *model = (Teaching_Catagory*)params;
            SeriesList_Book_Detail_VC *vc= [[SeriesList_Book_Detail_VC alloc]init];
            vc.teachingid = model.teachingId;
            vc.title_text = model.categoryName;
            [EnglishSettingManager shareInstance].AGE_TO_ALL = NO;
            [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
        }
    }else if ([eventname isEqualToString:EnglishDownCell_Event]){
       
        Series *model = (Series*)params;
        IntensiveReadingController *vc = [[IntensiveReadingController alloc]init];
        vc.bookid = model.bookId;
        [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
    }else if ([eventname isEqualToString:EnglishTableView_Event]){
        
        UIScrollView *scrollView = (UIScrollView*)params;
        
        if (scrollView.contentOffset.y<=10)
        {
          
            [self.topWhiteView removeFromSuperview];
            
            
        }else
        {
            
            [self addSubview:self.topWhiteView];
            [self bringSubviewToFront:self.topWhiteView];
            
        }
        
        
    }
}

#pragma mark - 获取教材
-(void)get_textbook{
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"获取教材 ==> OnSuccess");
        EnglishService *severce = (EnglishService*)httpInterface;
        self.tableview.Teaching_Catagory_List = severce.dataArray;
       
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"LoginService ==> OnError");
        [MBProgressHUD hideHUD];
        [MBProgressHUD showText:description];
    };
    
    EnglishService *service = [[EnglishService alloc] init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token];
    [service start];
}
#pragma mark - 获取分类
-(void)get_classify{
    
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"获取分类 ==> OnSuccess");
        EnglishCategoryService *service =(EnglishCategoryService * )httpInterface;
        NSLog(@"===>%@",service.dataArray);
        self.tableview.SeriesList = service.dataArray;
 
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"LoginService ==> OnError");
        [MBProgressHUD hideHUD];
        [MBProgressHUD showText:description];
    };
    
    EnglishCategoryService *service = [[EnglishCategoryService alloc] init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token];
    [service start];
    
}

#pragma mark - 分页获取系列丛书分类及列表
-(void)series_book_list{
    
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"获取分类 ==> OnSuccess");
        EnglishSeriesBookService *service =(EnglishSeriesBookService * )httpInterface;
        NSLog(@"===>%@",service.dataArray);
        self.tableview.SeriesList = service.dataArray;
        [self.tableview.mj_header endRefreshing];
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"LoginService ==> OnError");
        [MBProgressHUD hideHUD];
        [MBProgressHUD showText:description];
        [self.tableview.mj_header endRefreshing];
    };
    
    EnglishSeriesBookService *service = [[EnglishSeriesBookService alloc] init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token];
    [service start];
}


@end
