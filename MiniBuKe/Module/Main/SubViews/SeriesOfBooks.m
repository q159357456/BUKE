//
//  SeriesOfBooks.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/8.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "SeriesOfBooks.h"
#import "BookTableCell.h"
#import "SeriesBookObject.h"
#import "SeriesListObject.h"
#import "SeriesBookService.h"

@interface SeriesOfBooks ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UILabel *groupLabel;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) SeriesListObject *mSeriesListObject;
@property (nonatomic) SeriesBookServiceType mSeriesBookServiceType;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation SeriesOfBooks


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


-(instancetype)initWithFrame:(CGRect)frame setSeriesListObject:(SeriesListObject *) mSeriesListObject setType:(SeriesBookServiceType) mSeriesBookServiceType{
    
    if(self = [super initWithFrame:frame]){
        self.mSeriesListObject = mSeriesListObject;
        self.mSeriesBookServiceType = mSeriesBookServiceType;
        //self.dataArray = [[NSMutableArray alloc] init];
        //[self initView];
        [self onSeriesBookService];
    }
    return  self;
}

-(void)onSeriesBookService
{
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"SeriesBookService ==> OnSuccess");
        SeriesBookService *service = (SeriesBookService*)httpInterface;
        if (service.dataArray != nil && service.dataArray.count > 0) {
            
            self.dataArray = service.dataArray;
//            NSLog(@"self.mSeriesBookServiceArray ==> %i",self.mSeriesBookServiceArray.count);
//            [self updateSeriesOfBooks:self.mSeriesBookServiceArray];
            [self initView];
            //            [self updateADVImageView:self.advArray];
            
        }
        //        //NSLog(@"BookCategoryService ==> %i",service.array.count);
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"SeriesBookService ==> OnError");
    };
    
    SeriesBookService *service = [[SeriesBookService alloc] init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token setPage:@"1" setPageNum:@"10" setType:self.mSeriesBookServiceType setSeriesType:self.mSeriesListObject.seriesType];
    [service start];
}

-(void)initView{
    [self setBackgroundColor: COLOR_STRING(@"#FFFFFF")];
    
    UIView *groupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - BookTableCell_kCellHeight)];
    _groupLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.frame.size.width, self.frame.size.height - BookTableCell_kCellHeight)];
    _groupLabel.textAlignment = NSTextAlignmentLeft;
    
    if (self.mSeriesListObject != nil) {
        _groupLabel.text = self.mSeriesListObject.seriesName;
    } else {
        _groupLabel.text = @"系列丛书";
    }
    
    _groupLabel.font = MY_FONT(15);
    [groupView addSubview: _groupLabel];
    
    UIImageView *moveImageview = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 10 - 10, 15, 10, 12)];
    [moveImageview setImage:[UIImage imageNamed:@"系列_丛书_箭头" ]];
    [self addSubview:moveImageview];
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8/2, 3, self.frame.size.height - BookTableCell_kCellHeight  - 8)];
    [imageview setBackgroundColor:COLOR_STRING(@"#FF5001")];
    [self addSubview:imageview];
    [self addSubview:groupView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    //[tableView setBackgroundColor:COLOR_STRING(@"#FFF011")];
    tableView.bounds = CGRectMake(0, 0, BookTableCell_kCellHeight,self.frame.size.width);
    tableView.center = CGPointMake(CGRectGetMidX(self.frame),38 + BookTableCell_kCellHeight / 2);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:tableView];
}

#pragma mark - UITableviewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return BookTableCell_kCellWidth;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UILabel *label = [cell.contentView viewWithTag:1];
    label.text = [@(indexPath.row + 1) stringValue];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"====> numberOfRowsInSection <==== %i",self.dataArray.count);
    return self.dataArray.count;
}

-(void) updateData:(NSArray *) dataArray
{
    self.dataArray = dataArray;
    NSLog(@"self.mSeriesBookServiceArray.dataArray ==> %d",self.dataArray.count);
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"BookTableCell";
    BookTableCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [BookTableCell xibTableViewCell];
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
        
    }
    SeriesBookObject *mSeriesBookObject = [self.dataArray objectAtIndex:indexPath.row];
    
    [cell updateData:mSeriesBookObject];
    return cell;
}


@end
