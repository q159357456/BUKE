//
//  Teaching_Age_View.m
//  MiniBuKe
//
//  Created by chenheng on 2018/9/18.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "Teaching_Age_View.h"
#import "EnglishService.h"
#import "English_Header.h"
@interface Teaching_Age_View()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger selectIndex;
}
@property(nonatomic,strong)UITableView *tableview1;
@property(nonatomic,strong)UITableView *tableview2;
@property(nonatomic,strong)NSMutableArray *data1;
@property(nonatomic,strong)NSMutableArray *data2;
@end
@implementation Teaching_Age_View
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        UIColor.init(white: 0.8, alpha: 0.5)
        self.backgroundColor = A_COLOR_STRING(0x2F2F2F, 0.7f);
        
        [self get_textbook];
     
    }
    return self;
    
}

-(void)initSubView
{
    self.tableview1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width *0.5, 0) style:UITableViewStylePlain];
    self.tableview2 = [[UITableView alloc]initWithFrame:CGRectMake(self.frame.size.width *0.5, 0, self.frame.size.width *0.5, 0) style:UITableViewStylePlain];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.tableview1.frame =CGRectMake(0, 0, self.frame.size.width *0.5, self.data1.count *50);
        self.tableview2.frame =CGRectMake(self.frame.size.width *0.5, 0, self.frame.size.width *0.5, self.data1.count *50) ;
    }];

    [self addSubview:self.tableview1];
    [self addSubview:self.tableview2];
    
    self.tableview1.delegate = self;
    self.tableview2.delegate = self;
    self.tableview1.dataSource = self;
    self.tableview2.dataSource = self;
    
    [self.tableview1 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.tableview2 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.tableview1.tableFooterView = [UIView new];
    self.tableview2.tableFooterView = [UIView new];
    self.tableview2.backgroundColor = COLOR_STRING(@"#F7F9FB");
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    if (tableView == self.tableview1)
    {
        return self.data1.count;
    }else
    {
        return self.data2.count;
    }
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (tableView == self.tableview1)
    {
        Teaching_Catagory *model = self.data1[indexPath.row];
        if (model.isSelected) {
            cell.backgroundColor = COLOR_STRING(@"#F7F9FB");
            cell.textLabel.textColor = COLOR_STRING(@"#54BB51");
        }else
        {
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textColor = [UIColor blackColor];
        }
        cell.textLabel.font= [UIFont systemFontOfSize:16];
        cell.textLabel.text = model.categoryName;
    }else
    {
        cell.backgroundColor = COLOR_STRING(@"#F7F9FB");
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        TeachingAge *model = self.data2 [indexPath.row];
        
        cell.textLabel.text = model.age;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.tableview1)
    {
        
        Teaching_Catagory *model = self.data1[indexPath.row];
        
        if (model.isSelected == NO) {
            model.isSelected = YES;
            [self teaching_age:model.teachingId];
            
            if (selectIndex) {
                Teaching_Catagory *ac = self.data1[selectIndex -1 ];
                ac.isSelected = NO;
            }
            selectIndex = indexPath.row +1 ;
            
        }else
            return;

    }else
    {
        UITableViewCell *cell = (UITableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = [UIColor greenColor];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            cell.textLabel.textColor = [UIColor blackColor];
            TeachingAge *model = self.data2 [indexPath.row];
            Teaching_Catagory *catagory = self.data1 [selectIndex -1 ];
            NSDictionary *dic = @{@"Teaching_Catagory":catagory,
                                  @"TeachingAge":model
                                  };
            [self eventName:TeachingAgeView_Event Params:dic];
            [self disappear];
//        });
     
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self eventName:TeachingAgeView_Event Params:nil];
}
-(NSMutableArray *)data1
{
    if (!_data1) {
        _data1 = [NSMutableArray array];
    }
    return _data1;
}
#pragma mark - 获取教材分类
-(void)get_textbook{
    
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"获取教材 ==> OnSuccess");
        EnglishService *severce = (EnglishService*)httpInterface;
//        self.data1 = severce.dataArray;
        Teaching_Catagory *model = [[Teaching_Catagory alloc]init];
        model.categoryName = @"全部";
        model.teachingId = @"0";
        [severce.dataArray addObject:model];
        [self.data1 addObjectsFromArray:severce.dataArray];
        //选中项
        NSInteger  index = 0;
        for (Teaching_Catagory *ca in self.data1) {
            if (ca.teachingId.intValue == self.teachingid.intValue) {
                break;
            }
            index ++;
        }
        [self initSubView];
        [self tableView:self.tableview1 didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        
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
-(NSMutableArray *)data2
{
    if (!_data2) {
        _data2 = [NSMutableArray array];
    }
    return _data2;
}
#pragma mark - 获取教材年龄
-(void)teaching_age: (NSString*)teaching_id{
    
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"获取教材 ==> OnSuccess");
        TeachingAgeService *severce = (TeachingAgeService*)httpInterface;
        [self.data2 removeAllObjects];
        TeachingAge  *Allage = [[TeachingAge alloc]init];
        Allage.age=@"全部";
        Allage.ageId = @"0";
        [severce.dataArray addObject:Allage];
        [self.data2 addObjectsFromArray:severce.dataArray];
        
        NSLog(@"self.data2=====>%@",self.data2);
        [self.tableview2 reloadData];
        [self.tableview1 reloadData];
        
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        
        NSLog(@"LoginService ==> OnError");
        [MBProgressHUD hideHUD];
        [MBProgressHUD showText:description];
    };
    
    TeachingAgeService *service = [[TeachingAgeService alloc] init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token TeachingId:teaching_id];
    [service start];
}


-(void)show
{
    [self.tableview1 removeFromSuperview];
    [self.tableview2 removeFromSuperview];
    self.tableview1.frame = CGRectMake(0, 0, self.frame.size.width *0.5, 0);
    self.tableview2.frame =CGRectMake(self.frame.size.width *0.5, 0, self.frame.size.width *0.5, 0) ;
   
    [UIView animateWithDuration:0.3 animations:^{
        self.tableview1.frame =CGRectMake(0, 0, self.frame.size.width *0.5, self.data1.count *50);
        self.tableview2.frame =CGRectMake(self.frame.size.width *0.5, 0, self.frame.size.width *0.5, self.data1.count *50) ;
    }];
   
    [self addSubview:self.tableview1];
    [self addSubview:self.tableview2];
  
}
-(void)disappear
{
    

    [UIView animateWithDuration:0.3 animations:^{
        self.tableview1.frame =CGRectMake(0, 0, self.frame.size.width *0.5, 0);
        self.tableview2.frame =CGRectMake(self.frame.size.width *0.5, 0, self.frame.size.width *0.5,0) ;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
