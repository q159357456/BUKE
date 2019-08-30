//
//  EnglishTableView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/9/12.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "EnglishTableView.h"
#import "EnglishUpCell.h"
#import "EnglishDownCell.h"
#import "SeriesList_Classify.h"
@interface EnglishTableView ()<UITableViewDelegate,UITableViewDataSource>
@end

@implementation EnglishTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
//        [self registerClass:[EnglishUpCell class] forCellReuseIdentifier:@"EnglishUpCell"];
        [self registerNib:[UINib nibWithNibName:@"EnglishDownCell" bundle:nil] forCellReuseIdentifier:@"EnglishDownCell"];
        self.tableFooterView = [UIView new];
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor =  COLOR_STRING(@"#F6F7FA");
        
    }
    return self;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else
    {
        return self.SeriesList.count;
    }

}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        EnglishUpCell *cell = [[EnglishUpCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        if (self.Teaching_Catagory_List.count) {
        cell.Teaching_Catagory_List = self.Teaching_Catagory_List;
        }
        return cell;
    }else
    {
        EnglishDownCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EnglishDownCell"];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        SeriesList_Classify *model = self.SeriesList[indexPath.row];
        cell.titleLabel.text = model.seriesName;
        cell.seriesList_Classify = model;
        
        return cell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return SCALE(230);
    }else
    {
        
        SeriesList_Classify *model = self.SeriesList[indexPath.row];
        return model.rowHeight;
        
    }
        
   
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (kStatusBarH == 20) {
        [self eventName:EnglishTableView_Event Params:scrollView];
    }
    
}
-(void)setTeaching_Catagory_List:(NSArray *)Teaching_Catagory_List
{
    _Teaching_Catagory_List = Teaching_Catagory_List;
    NSIndexSet *set = [[NSIndexSet alloc]initWithIndex:0];;
    [self reloadSections:set withRowAnimation:NO];

}
-(void)setSeriesList:(NSArray *)SeriesList
{
    _SeriesList = SeriesList;
    NSIndexSet *set = [[NSIndexSet alloc]initWithIndex:1];;
    [self reloadSections:set withRowAnimation:NO];
}


@end
