//
//  BookListChildView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/12.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BookListChildView.h"
#import "BookListViewCell.h"
#import "KBookListService.h"
#import "BookListCategoryIdService.h"
#import "BookCategoryObject.h"
#import <MJRefresh/MJRefresh.h>

@interface BookListChildView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *mKBookListArray;
@property (nonatomic,strong) BookCategoryObject *mBookCategoryObject;

@property (nonatomic) int mPage;

@end

@implementation BookListChildView

-(instancetype)initWithFrame:(CGRect)frame setBookCategoryObject:(BookCategoryObject *) mBookCategoryObject
{
    
    if(self = [super initWithFrame:frame]){
        
        self.mBookCategoryObject = mBookCategoryObject;
        self.mPage = 1;
        [self onBookListCategoryIdService:self.mPage];
        [BKLoadAnimationView ShowHitOn:self Frame:self.frame];
    }
    return  self;
}

-(void)onBookListCategoryIdService:(int) page
{
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        
        NSLog(@"BookListCategoryIdService ==> OnSuccess");
        [BKLoadAnimationView HiddenFrom:self];
        
        BookListCategoryIdService *service = (BookListCategoryIdService*)httpInterface;
        
        if (service.dataArray != nil && service.dataArray.count > 0) {
            [self arrangeBookList:service.dataArray];
            if (self.tableView == nil) {
                [self initView];
            } else {
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            }
            
            //NSLog(@"self.mKBookListArray ==> %i",self.mSeriesBookServiceArray.count);
            //[self updateSeriesOfBooks:self.mSeriesBookServiceArray];
            //[self updateADVImageView:self.advArray];
        } else {
            if (self.tableView != nil) {
                if (self.mPage > 1) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.tableView.mj_footer endRefreshing];
                }
                
            }
        }
        
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"BookListCategoryIdService ==> OnError");
        if (self.tableView != nil) {
            [self.tableView.mj_footer endRefreshing];
        }
        if (self.mPage == 1) {
            [self addNetError];
        }
    };
    BookListCategoryIdService *service = [[BookListCategoryIdService alloc] init:OnSuccess setOnError:OnError setCid:self.mBookCategoryObject.categoryId setPage:[NSString stringWithFormat:@"%i",page] setPageNum:@"10"];
    [service start];
}

-(void) arrangeBookList:(NSArray *) dataArray
{
    if (self.mKBookListArray == nil) {
        self.mKBookListArray = [[NSMutableArray alloc] init];
    }
    if(dataArray != nil && dataArray.count > 0){
        NSMutableArray *mMutableArray;
        for (int i = 0; i < dataArray.count; i ++) {
            
            NSLog(@"mKBookListArray ==> %i",(i % 2));
            BooklistObjet *mBooklistObjet = [dataArray objectAtIndex:i];
            if (i % 2 == 0) {
                mMutableArray = [[NSMutableArray alloc] init];
                [self.mKBookListArray addObject:mMutableArray];
                [mMutableArray addObject:mBooklistObjet];
            } else {
                [mMutableArray addObject:mBooklistObjet];
            }
        }
    }
}

-(void)updateKBookListService:(NSArray *) array
{
    NSLog(@"updateKBookListService ==> %ld",array.count);
    if(array != nil && array.count > 0){
        
    }
}

-(void)initView
{
    [self setBackgroundColor:[UIColor redColor] ];
    NSLog(@"frame ==> %f : %f",self.frame.size.width,self.frame.size.height);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,self.frame.size.height) style:UITableViewStylePlain];
    //[tableView setBackgroundColor:COLOR_STRING(@"#FFF011")];
//    self.tableView.bounds = CGRectMake(0, 0, self.frame.size.width,self.frame.size.height);
//    self.tableView.center = CGPointMake(self.frame.size.width/2,self.frame.size.height/2);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    //self.tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [footer setTitle:MJRefreshStateIdle_Str forState:MJRefreshStateIdle];
    [footer setTitle:MJRefreshStatePulling_Str forState:MJRefreshStatePulling];
    [footer setTitle:MJRefreshStateRefreshing_Str forState:MJRefreshStateRefreshing];
    [footer setTitle:MJRefreshStateWillRefresh_Str forState:MJRefreshStateWillRefresh];
    [footer setTitle:MJRefreshStateNoMoreData_Str forState:MJRefreshStateNoMoreData];

    self.tableView.mj_footer = footer;
}

-(void)footerRereshing
{
    self.mPage++;
    NSLog(@"loading ...");
    
    [self onBookListCategoryIdService:self.mPage];
//    if (self.sourceType == StoryPlaySourceType_PlayList) {
//
//        [self getMoreDataWithPage:self.page PageNum:PAGE_NUM];
//    }else if (self.sourceType == StoryPlaySourceType_Collect){
//        [self getMoreCollectListDataWithPage:self.page PageNum:PAGE_NUM];
//    }else if (self.sourceType == StoryPlaySourceType_Recent){
//
//    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return BookListViewCell_height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UILabel *label = [cell.contentView viewWithTag:1];
    label.text = [@(indexPath.row + 1) stringValue];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mKBookListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"BookListViewCell";
    BookListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [BookListViewCell xibTableViewCell];
//        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
        
    }
//    [cell updateData:CGSizeMake(tableView.frame.size.width, 0)];
    NSArray *mBooklistObjets = [self.mKBookListArray objectAtIndex:indexPath.row];
    
    NSLog(@"NSArray *mBooklistObjets ===> %lu",(unsigned long)mBooklistObjets.count);
    
    [cell updateData:CGSizeMake(tableView.frame.size.width, 0) setArrayBooklistObjet:mBooklistObjets ];
    return cell;
}

#pragma mark - netError
- (void)addNetError{
    BKNetWorkErrorBackView *backView = [BKNetWorkErrorBackView showOn:self WithFrame:self.frame];
    kWeakSelf(weakSelf);
    [backView setTryAgainAction:^{
        [weakSelf reloadAgain];
    }];
}
-(void)reloadAgain{
    //loading
    [BKLoadAnimationView ShowHitOn:self Frame:self.frame];
    self.mPage = 1;
    [self onBookListCategoryIdService:self.mPage];
}
@end
