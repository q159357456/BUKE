//
//  MyCenterCenterView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/20.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "MyCenterCenterView.h"
#import "BookHistoryReadInfo.h"
#import "BookHistoryDayService.h"
#import "BookTableCell.h"
#import "SeriesBookObject.h"
#import "DateHistoryView.h"

@interface MyCenterCenterView ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIImageView *mImageView;
@property (weak, nonatomic) IBOutlet UILabel *mImageViewTip;

@property (weak, nonatomic) IBOutlet UIImageView *icImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *icImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *icImageView3;
@property (weak, nonatomic) IBOutlet UIImageView *icImageView4;
@property (weak, nonatomic) IBOutlet UIImageView *icImageView5;
@property (weak, nonatomic) IBOutlet UIImageView *icImageView6;
@property (weak, nonatomic) IBOutlet UIImageView *icImageView7;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel1;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel2;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel3;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel4;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel5;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel6;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel7;

@property (weak, nonatomic) IBOutlet UILabel *yueduLabel;
@property (weak, nonatomic) IBOutlet UILabel *yueduTimeLabel;
@property (nonatomic,strong) IBOutlet UITableView *tableView;

@property (nonatomic) NSInteger index;

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic) float mHeight;
@property (nonatomic,strong) id<MyCenterCenterViewDelegate> delegate;
@property (nonatomic) CGSize mSize;

@end

@implementation MyCenterCenterView

+(instancetype)xibView {
    return [[[NSBundle mainBundle] loadNibNamed:@"MyCenterCenterView" owner:nil options:nil] lastObject];
}

-(void) updateDataView:(CGSize ) size setBookHistoryReadInfo:(BookHistoryReadInfo *) mBookHistoryReadInfo setDelegate:(id<MyCenterCenterViewDelegate>) delegate
{
    self.mSize = size;
    self.delegate = delegate;
    self.view1.frame = CGRectMake(size.width / 2 - self.view1.frame.size.width/2, self.view1.frame.origin.y, self.view1.frame.size.width, self.view1.frame.size.height);
    self.view2.frame = CGRectMake(size.width / 2 - self.view2.frame.size.width/2, self.view2.frame.origin.y, self.view2.frame.size.width, self.view2.frame.size.height);
    self.view3.frame = CGRectMake(size.width / 2 - self.view3.frame.size.width/2, self.view3.frame.origin.y, self.view3.frame.size.width, self.view3.frame.size.height);
    [self.view3 setBackgroundColor: COLOR_STRING(@"#E9E9E9")];
    
    if (size.width > 375) {
        self.view3.frame = CGRectMake(0, self.view3.frame.origin.y, size.width, self.view3.frame.size.height);
        self.mImageView.frame = CGRectMake(size.width/2 - self.mImageView.frame.size.width/2, self.mImageView.frame.origin.y, self.mImageView.frame.size.width, self.mImageView.frame.size.height);
    }
    
    
    if (self.tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        //[self.tableView setBackgroundColor:COLOR_STRING(@"#FFF011")];
        
        self.tableView.bounds = CGRectMake(0, 0, BookTableCell_kCellHeight,self.view3.frame.size.width);
        self.tableView.center = CGPointMake(CGRectGetMidX(self.view3.frame), BookTableCell_kCellHeight / 2);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view3 addSubview:self.tableView];
        self.tableView.hidden = YES;
    }
    
    self.index = 0;
    
    [self selectTimeButton:self.index];
    
    if (mBookHistoryReadInfo != nil) {
//        @property (weak, nonatomic) IBOutlet UILabel *yueduLabel;
//        @property (weak, nonatomic) IBOutlet UILabel *yueduTimeLabel;
        self.yueduLabel.text = [NSString stringWithFormat:@"%@册",mBookHistoryReadInfo.readBookNum];
        
        float totalSeconds = mBookHistoryReadInfo.longTime.floatValue;
        NSLog(@"totalSeconds ==> %f",totalSeconds);
//        double seconds = totalSeconds % 60.0;
//        float minutes = ((float)totalSeconds / 60.0f) % 60.0f;
        float hours = totalSeconds / 3600.0f;
        
        self.yueduTimeLabel.text = [NSString stringWithFormat:@"%0.1f小时",hours];
    }
    
    [self updateTimeLabel];
    
    
    
    [self onBookHistoryDayService:@"1"];
    
    //[self updateHistoryViewChild];
    
}

-(float) getHeight
{
    return self.mHeight;
}

-(void) arrangeBookList
{
    if(self.dataArray != nil && self.dataArray.count > 0){
        NSLog(@"arrangeBookList ==> %i",self.dataArray.count);
        NSMutableArray *mTempArray = [[NSMutableArray alloc] init];
        NSMutableArray *mMutableArray;
        for (int i = 0; i < self.dataArray.count; i ++) {
            
            NSLog(@"mKBookListArray ==> %i",(i % 3));
            SeriesBookObject *mSeriesBookObject = [self.dataArray objectAtIndex:i];
            if (i % 3 == 0) {
                mMutableArray = [[NSMutableArray alloc] init];
                [mTempArray addObject:mMutableArray];
                [mMutableArray addObject:mSeriesBookObject];
            } else if (i % 2 == 0){
                [mMutableArray addObject:mSeriesBookObject];
            } else {
                [mMutableArray addObject:mSeriesBookObject];
            }
        }
        self.dataArray = mTempArray;
    }
}

-(void) updateHistoryViewChild
{
    self.mHeight = 427;
    NSLog(@"self.mHeight 1 ===> %f",self.mHeight);
    self.mImageView.hidden = YES;
    self.mImageViewTip.hidden = YES;
    [self.view3.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    NSLog(@"self.dataArrayupdateHistoryViewChild ==> %i",self.dataArray.count);
    if (self.dataArray != nil && self.dataArray.count > 0) {
        NSLog(@"self.mImageView.hidden 111 ===>");
        for (int i = 0; i < self.dataArray.count; i++) {
            NSArray *objects = [self.dataArray objectAtIndex:i];
            
            DateHistoryView *mDateHistoryView = [DateHistoryView xibView];
            [self.view3 addSubview:mDateHistoryView];
            
            if (self.mSize.width > 375) {
                mDateHistoryView.frame = CGRectMake(self.mSize.width/2 - mDateHistoryView.frame.size.width/2, i * mDateHistoryView.frame.size.height, mDateHistoryView.frame.size.width, mDateHistoryView.frame.size.height);
            } else {
                mDateHistoryView.frame = CGRectMake(0, i * mDateHistoryView.frame.size.height, mDateHistoryView.frame.size.width, mDateHistoryView.frame.size.height);
            }
            
            
            [mDateHistoryView updateDataView:CGSizeMake(0, 0) setSeriesBookObjects:objects];
            
            
            if (i >= 2) {
                self.mHeight = (i + 2) * mDateHistoryView.frame.size.height;
            }
            
            NSLog(@"mDateHistoryView ===> %f",mDateHistoryView.frame.size.height);
        }
    } else {
        NSLog(@"self.mImageView.hidden 222 ===>");
        self.mImageView.hidden = NO;
        self.mImageViewTip.hidden = NO;
    }
    
    NSLog(@"self.mHeight 2 ===> %f",self.mHeight);
    
    if (self.mHeight > 427) {
        self.view3.frame = CGRectMake(self.view3.frame.origin.x, self.view3.frame.origin.y, self.view3.frame.size.width, self.mHeight - self.frame.size.height + self.view3.frame.size.height + 20);
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.mHeight + 20);
        
        NSLog(@"111 ====> self.view3.frame <====");
    } else {
//        self.view3.frame = CGRectMake(self.view3.frame.origin.x, 149, self.view3.frame.size.width, 278);
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 427);
        
        NSLog(@"222 ====> self.view3.frame <====");
    }
    
    if (self.delegate != nil) {
        [self.delegate onViewFrameChange];
    }
}

-(void) resetHistoryViewChild
{
    [self.view3.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.mImageView.hidden = NO;
    self.mImageViewTip.hidden = NO;
    self.view3.frame = CGRectMake(self.view3.frame.origin.x, self.view3.frame.origin.y, self.view3.frame.size.width, 278);
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 427);
    if (self.delegate != nil) {
        [self.delegate onViewFrameChange];
    }
}

-(void) updateTimeLabel
{
    NSLog(@" time ====> %@ = %@",[self getCurrentTime],[self GetTomorrowDay:[self dateFromString: [self getCurrentTime]] setThreshold:2]);
    
    self.timeLabel1.text = @"今天";
    self.timeLabel2.text = @"昨天";
    self.timeLabel3.text = @"前天";
    
    self.timeLabel4.text = [self GetTomorrowDay:[self dateFromString: [self getCurrentTime]] setThreshold:3];
    self.timeLabel5.text = [self GetTomorrowDay:[self dateFromString: [self getCurrentTime]] setThreshold:4];
    self.timeLabel6.text = [self GetTomorrowDay:[self dateFromString: [self getCurrentTime]] setThreshold:5];
    self.timeLabel7.text = [self GetTomorrowDay:[self dateFromString: [self getCurrentTime]] setThreshold:6];
    
}

-(void) selectTimeButton:(NSUInteger) index
{
    [self.icImageView1 setImage:[UIImage imageNamed:@"我的_中间_时间_暗"]];
    [self.icImageView2 setImage:[UIImage imageNamed:@"我的_中间_时间_暗"]];
    [self.icImageView3 setImage:[UIImage imageNamed:@"我的_中间_时间_暗"]];
    [self.icImageView4 setImage:[UIImage imageNamed:@"我的_中间_时间_暗"]];
    [self.icImageView5 setImage:[UIImage imageNamed:@"我的_中间_时间_暗"]];
    [self.icImageView6 setImage:[UIImage imageNamed:@"我的_中间_时间_暗"]];
    [self.icImageView7 setImage:[UIImage imageNamed:@"我的_中间_时间_暗"]];
    
    if (index == 0) {
        [self.icImageView1 setImage:[UIImage imageNamed:@"我的_中间_时间_亮"]];
    } else if (index == 1){
        [self.icImageView2 setImage:[UIImage imageNamed:@"我的_中间_时间_亮"]];
    } else if (index == 2){
        [self.icImageView3 setImage:[UIImage imageNamed:@"我的_中间_时间_亮"]];
    } else if (index == 3){
        [self.icImageView4 setImage:[UIImage imageNamed:@"我的_中间_时间_亮"]];
    } else if (index == 4){
        [self.icImageView5 setImage:[UIImage imageNamed:@"我的_中间_时间_亮"]];
    } else if (index == 5){
        [self.icImageView6 setImage:[UIImage imageNamed:@"我的_中间_时间_亮"]];
    } else if (index == 6){
        [self.icImageView7 setImage:[UIImage imageNamed:@"我的_中间_时间_亮"]];
    }
}

//获取当地时间
- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}
//将字符串转成NSDate类型
- (NSDate *)dateFromString:(NSString *)dateString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}
//传入今天的时间，返回明天的时间
- (NSString *)GetTomorrowDay:(NSDate *)aDate setThreshold:(int) value{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
    [components setDay:([components day]-value)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"MM-dd"];
    return [dateday stringFromDate:beginningOfWeek];
}

-(void)onBookHistoryDayService:(NSString *) day
{
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"BookHistoryDayService ==> OnSuccess");
        BookHistoryDayService *service = (BookHistoryDayService*)httpInterface;
        if (service.dataArray != nil && service.dataArray.count > 0) {
            self.dataArray = service.dataArray;
            [self arrangeBookList];
            [self updateHistoryViewChild];
        } else {
            NSLog(@"====> BookHistoryDayService service.dataArray == nil <====");
            
            [self resetHistoryViewChild];
        }
        
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"BookHistoryDayService ==> OnError");
        
        [self resetHistoryViewChild];
    };
    
    BookHistoryDayService *service = [[BookHistoryDayService alloc] init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token setDay:day setPage:@"1" setPageNum:@"20"];
    [service start];
}

-(IBAction) onClickButton1:(id)sender
{
    NSLog(@"onClickButton1");
    self.index = 0;
    [self selectTimeButton:self.index];
    
    [self onBookHistoryDayService:@"1"];
}

-(IBAction) onClickButton2:(id)sender
{
    NSLog(@"onClickButton2");
    self.index = 1;
    [self selectTimeButton:self.index];
    
    [self onBookHistoryDayService:@"2"];
}

-(IBAction) onClickButton3:(id)sender
{
    NSLog(@"onClickButton3");
    self.index = 2;
    [self selectTimeButton:self.index];
    
    [self onBookHistoryDayService:@"3"];
}

-(IBAction) onClickButton4:(id)sender
{
    NSLog(@"onClickButton4");
    self.index = 3;
    [self selectTimeButton:self.index];
    
    [self onBookHistoryDayService:@"4"];
}

-(IBAction) onClickButton5:(id)sender
{
    NSLog(@"onClickButton5");
    self.index = 4;
    [self selectTimeButton:self.index];
    
    [self onBookHistoryDayService:@"5"];
}

-(IBAction) onClickButton6:(id)sender
{
    NSLog(@"onClickButton6");
    self.index = 5;
    [self selectTimeButton:self.index];
    
    [self onBookHistoryDayService:@"6"];
}

-(IBAction) onClickButton7:(id)sender
{
    NSLog(@"onClickButton6");
    self.index = 6;
    [self selectTimeButton:self.index];
    
    [self onBookHistoryDayService:@"7"];
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
    NSLog(@"====> numberOfRowsInSection <==== %lu",(unsigned long)self.dataArray.count);
    return self.dataArray.count;
}

-(void) updateData:(NSArray *) dataArray
{
    self.dataArray = dataArray;
    NSLog(@"self.mSeriesBookServiceArray.dataArray ==> %lu",(unsigned long)self.dataArray.count);
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
