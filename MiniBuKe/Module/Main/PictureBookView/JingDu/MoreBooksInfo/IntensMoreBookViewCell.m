//
//  IntensMoreBookViewCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/2.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "IntensMoreBookViewCell.h"
#import "BookIntroduceCell.h"
@interface IntensMoreBookViewCell()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@end
@implementation IntensMoreBookViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(UITableView *)tableView
{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"BookIntroduceCell" bundle:nil] forCellReuseIdentifier:@"BookIntroduceCell"];
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
     
    }
    return _tableView;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.right.mas_equalTo(self.mas_right);
        }];
    }
    return self;
}

-(void)setUserfulList:(NSMutableArray *)userfulList
{
    _userfulList = userfulList;
    [self.tableView reloadData];
}
#pragma mark tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userfulList.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookIntroduceCell"];
    NSString *key = self.userfulTitle[indexPath.row];
    NSString *value = self.userfulList[indexPath.row];
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    cell.label1.text= key;
    cell.label2.text = value;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return BookIntroduceCell_Row ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return BookIntroduceCell_Row;
}
//-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"更多图书信息";
//}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, BookIntroduceCell_Row)];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, view.frame.size.width-15, view.frame.size.height)];
    lable.text = @"更多图书信息";
    lable.font = [UIFont boldSystemFontOfSize:17];
    lable.backgroundColor = [UIColor whiteColor];
    [view addSubview:lable];
    return view;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
