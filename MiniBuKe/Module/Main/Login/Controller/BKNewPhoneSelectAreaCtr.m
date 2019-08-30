//
//  BKNewPhoneSelectAreaCtr.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/23.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKNewPhoneSelectAreaCtr.h"
#import "BKPhoneAreaTableViewCell.h"

@interface BKNewPhoneSelectAreaCtr ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UIButton *backBtn;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UITableView *mytableView;
@property(nonatomic, strong) NSArray *areaNameArray;
@property(nonatomic, strong) NSArray *areaphoneArray;

@end

@implementation BKNewPhoneSelectAreaCtr

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.areaNameArray = [NSArray arrayWithObjects:@"中国",@"中国香港",@"中国澳门",@"中国台湾",nil];
    self.areaphoneArray = [NSArray arrayWithObjects:@"86",@"852",@"853",@"886",nil];
    [self setUI];
    [self registerCustomTableViewCell];
}

- (void)registerCustomTableViewCell{
    [self.mytableView registerClass:[BKPhoneAreaTableViewCell class] forCellReuseIdentifier:NSStringFromClass([BKPhoneAreaTableViewCell class])];
}

- (void)setUI{
    self.view.backgroundColor = COLOR_STRING(@"#FFFFFF");

    self.backBtn = [[UIButton alloc]init];
    [_backBtn setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateNormal];
    [_backBtn setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateSelected];
    [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.text = @"选择地区";
    _titleLabel.textColor = COLOR_STRING(@"#2F2F2F");
    _titleLabel.font = [UIFont systemFontOfSize:25.f weight:UIFontWeightMedium];
    [self.view addSubview:_titleLabel];
    
    self.mytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _mytableView.delegate = self;
    _mytableView.dataSource = self;
    _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        _mytableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        
    }
    _mytableView.estimatedRowHeight = 0;
    _mytableView.estimatedSectionFooterHeight = 0;
    _mytableView.estimatedSectionHeaderHeight = 0;
    _mytableView.backgroundColor = COLOR_STRING(@"#FFFFFF");
    _mytableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_mytableView];
    
    [self addConstraints];

}

- (void)addConstraints{
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.top.mas_equalTo(self.view.mas_top).offset(kStatusBarH);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(14);
        make.top.mas_equalTo(self.backBtn.mas_bottom).offset(25.f);
    }];
    [self.mytableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(30);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
    }];
}

- (void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- tableViewdelegate&dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _areaNameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BKPhoneAreaTableViewCell *cell = [BKPhoneAreaTableViewCell BKBaseTableViewCellWithTableView:tableView];
    [cell setModelWithTitle:_areaNameArray[indexPath.row] andSubTitle:_areaphoneArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [BKPhoneAreaTableViewCell heightForCellWithObject:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self selectCompletionOverWith:_areaphoneArray[indexPath.row]];
    });
}

- (void)selectCompletionOverWith:(NSString*)str{
    if (_selectAreaPhoneCompletion) {
        _selectAreaPhoneCompletion(str);
    }
    [self backBtnClick];
}
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    BKPhoneAreaTableViewCell *cell = (BKPhoneAreaTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell changeTheHighlightedUI:YES];
   
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BKPhoneAreaTableViewCell *cell = (BKPhoneAreaTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        [cell changeTheHighlightedUI:NO];
    });
    
}
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

@end
