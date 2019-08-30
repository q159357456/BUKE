//
//  AR_FAQ_View.m
//  MiniBuKe
//
//  Created by chenheng on 2019/5/13.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "AR_FAQ_View.h"
#import "GuidanceViewController.h"
#import "BookneededScanningCodeVC.h"
#import "FeedbackViewController.h"
#import "BKLoginCodeTip.h"
@interface AR_FAQ_View()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIView *contentView;
@property(nonatomic,copy)NSArray *dataSources;
@property(nonatomic,strong)UIView *tableHeadView;
@end
@implementation AR_FAQ_View

+(void)showFAQ
{
    AR_FAQ_View *faq = [[AR_FAQ_View alloc]init];

    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
         faq.contentView.frame = CGRectMake(0, SCREEN_HEIGHT-515,SCREEN_WIDTH, 515);
    } completion:^(BOOL finished) {
        
    }];
    
}
-(instancetype)init
{
    if (self = [super init]) {
        self.frame = APP_DELEGATE.window.bounds;
        [APP_DELEGATE.window addSubview:self];
        self.backgroundColor = A_COLOR_STRING(0x191919, 0.8f);
        UIView *contenView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 515)];
        self.contentView = contenView;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentView];
        //圆角
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(14, 14)];
        CAShapeLayer *rLayer = [CAShapeLayer layer];
        rLayer.frame = self.bounds;
        rLayer.path = path.CGPath;
        self.contentView.layer.mask = rLayer;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.backgroundColor = COLOR_STRING(@"#F7F7F7");
        UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.contentView.frame.size.height-94) style:UITableViewStylePlain];
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.rowHeight = 90;
        [tableview registerClass:[GuidanceVewCell class] forCellReuseIdentifier:@"GuidanceVewCell"];
        tableview.tableHeaderView = self.tableHeadView;
        tableview.tableFooterView = [UIView new];
        tableview.scrollEnabled = NO;
        tableview.backgroundColor = COLOR_STRING(@"#F7F7F7");
        [self.contentView addSubview:tableview];
        
        UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(SCREEN_WIDTH/2 - 100, self.contentView.frame.size.height-25-44, 200, 44);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelBtn.backgroundColor = [UIColor whiteColor];
        cancelBtn.layer.cornerRadius = 22;
        cancelBtn.layer.masksToBounds = YES;
        [self.contentView addSubview:cancelBtn];
        
        
        
        [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}
-(void)dismiss{
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
         self.contentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 515);
    } completion:^(BOOL finished) {
    
        [self removeFromSuperview];
        
    }];
}
-(NSArray *)dataSources
{
    if (!_dataSources) {
        _dataSources = @[
                         @{@"img":@"ar_faq_2",@"txt":@"这本书读不了"},
                         @{@"img":@"ar_faq_3",@"txt":@"配音与图片内容不一致"},
                         @{@"img":@"ar_faq_1",@"txt":@"使用说明"},
                         @{@"img":@"ar_faq_4",@"txt":@"其他问题"}
                         ];
    }
    return _dataSources;
}
-(UIView *)tableHeadView
{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 54)];
    view.backgroundColor = [UIColor whiteColor];
    UIView * touchView = [[UIView alloc]init];
    [view addSubview:touchView];
    
    UIImageView *imageV = [[UIImageView alloc]init];
    UILabel *label = [[UILabel alloc]init];
    label.text = @"常见问题";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:17];
    imageV.backgroundColor = COLOR_STRING(@"#EAEAEA");
    imageV.layer.cornerRadius = 2.5;
    imageV.layer.masksToBounds = YES;
    
    [touchView addSubview:imageV];
    [touchView addSubview:label];
    
    [touchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(view);
        make.size.mas_equalTo(CGSizeMake(70, 54));
    }];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(touchView);
        make.top.mas_equalTo(touchView.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(27, 5));
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view);
        make.size.mas_equalTo(CGSizeMake(70, 14));
         make.top.mas_equalTo(touchView.mas_top).offset(25);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    touchView.userInteractionEnabled = YES;
    [touchView addGestureRecognizer:tap];
    return view;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSources.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GuidanceVewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GuidanceVewCell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *dic = self.dataSources[indexPath.row];
    cell.headImgV.image = [UIImage imageNamed:dic[@"img"]];
    cell.label.text = dic[@"txt"];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismiss];
    switch (indexPath.row) {
        case 0:
        {
            //扫一扫
         BookneededScanningCodeVC *vc = [[BookneededScanningCodeVC alloc]init];
         [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 1:
        {
//            [MBProgressHUD showSuccess:@"反馈成功"];
            [[[BKLoginCodeTip alloc]init] AddFeedbackOkTip:APP_DELEGATE.window];
        }
            break;
        case 2:
        {
//             NSArray *array = @[[UIImage imageNamed:@"ar_instructions_iamge01"], [UIImage imageNamed:@"ar_instructions_iamge02"]];
//            [GuidanceVew showGuidInfo:array Describ:@""];
            GuidanceViewController *vc = [[GuidanceViewController alloc]init];
            [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            FeedbackViewController *mFeedbackViewController = [[FeedbackViewController alloc] init];
            [APP_DELEGATE.navigationController pushViewController:mFeedbackViewController animated:YES];
        }
            break;
            
        default:
            break;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}
@end

@implementation GuidanceVewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = COLOR_STRING(@"#F7F7F7");
        self.headImgV = [[UIImageView alloc]init];
        self.label = [[UILabel alloc]init];
        [self.contentView addSubview:self.headImgV];
        [self.contentView addSubview:self.label];
        [self.headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(28, 24));
            make.left.mas_equalTo(self.contentView.mas_left).offset(35);
        }];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.height.mas_equalTo(17);
            make.right.mas_equalTo(self.contentView);
            make.left.mas_equalTo(self.headImgV.mas_right).offset(24);
        }];
        
        
    }
    return self;
}


@end
