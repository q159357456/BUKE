//
//  AboutViewController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/5/7.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "AboutViewController.h"
#import "AboutViewCell.h"
#import "AboutService.h"
#import "AboutInfo.h"
#import "UserLoginViewController.h"
#import "XBKWebViewController.h"
#import "MBProgressHUD+XBK.h"

#define bottomView_height 55

@interface AboutViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIView *middleView;
@property(nonatomic,strong) UIView *bottomView;

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) NSArray *dataArray;

@end

@implementation AboutViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
    
    [self getAboutData];
    
//    [MobClick event:EVENT_ABUOT_12];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideBarStyle];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self showBarStyle];
}

- (void)showBarStyle {
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = NO;
    
//    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)hideBarStyle {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = YES;
    
//    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)initView{
    
    self.view.backgroundColor = COLOR_STRING(@"#E9E9E9");
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 73)];
    [_topView setBackgroundColor:COLOR_STRING(@"#FFFFFF")];
    [self.view addSubview:_topView];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - bottomView_height, self.view.frame.size.width, bottomView_height)];
    _bottomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_bottomView];
    
    _middleView = [[UIView alloc] initWithFrame:CGRectMake(0, _topView.frame.origin.y + _topView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _topView.frame.size.height - _bottomView.frame.size.height)];
    _middleView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_middleView];
    
    NSLog(@" %f == %f",self.view.frame.size.height,self.view.frame.size.width);
    
    [self createTopViewChild];
    [self createMiddleViewChild];
    [self creatbottomViewChild];
}

-(void) createMiddleViewChild
{
    UIView *iconView = [[UIView alloc]init];
    iconView.frame = CGRectMake(0, 0, _middleView.frame.size.width, 37 + 80 + 51);
    iconView.backgroundColor = [UIColor whiteColor];
    [_middleView addSubview:iconView];
    
    UIImageView *iconImageView = [[UIImageView alloc]init];
    iconImageView.frame = CGRectMake((iconView.frame.size.width - 80)*0.5, 37, 80, 80);
    iconImageView.image = [UIImage imageNamed:@"login_toplogon_icon"];
    [iconView addSubview:iconImageView];
    iconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconImageViewClick:)];
    touch.numberOfTapsRequired = 2;
    [iconImageView addGestureRecognizer:touch];
    
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.frame = CGRectMake(0, iconImageView.frame.origin.y + iconImageView.frame.size.height + 10, iconView.frame.size.width, 20);
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.font = MY_FONT(12);
    versionLabel.textColor = COLOR_STRING(@"#666666");
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

    versionLabel.text = [NSString stringWithFormat:@"v%@",version];
    [iconView addSubview:versionLabel];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(15, iconView.frame.size.height - 1, iconView.frame.size.width - 15*2, 1)];
    line.backgroundColor = COLOR_STRING(@"#F4F4F4");
    [iconView addSubview:line];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, iconView.frame.origin.y + iconView.frame.size.height, _middleView.frame.size.width, _middleView.frame.size.height - iconView.frame.origin.y - iconView.frame.size.height) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.sectionHeaderHeight = 0.01;
    tableView.sectionFooterHeight = 0.01;
    self.tableView = tableView;
    [_middleView addSubview:tableView];
    
//    NSLog(@"_middleView.H===>%f",_middleView.frame.size.height);
//    NSLog(@"iconView.H===>%f",iconView.frame.size.height);
//    NSLog(@"tableView.H===>%f",tableView.frame.size.height);
    
//    CGFloat H = 40;
//    for (int i = 0; i < 4; i++) {
//        UILabel *leftLabel = [[UILabel alloc]init];
//        leftLabel.frame = CGRectMake(9, iconImageView.frame.origin.y + iconImageView.frame.size.height + 48 + H*i, 60, 20);
//        leftLabel.font = MY_FONT(10);
//        leftLabel.textColor = COLOR_STRING(@"#FF212121");
//        leftLabel.text = @"123445677";
//        [_middleView addSubview:leftLabel];
//
//        UILabel *rightLabel = [[UILabel alloc]init];
//        rightLabel.textColor = COLOR_STRING(@"#FF909090");
//        rightLabel.font = MY_FONT(9);
//        rightLabel.textAlignment = NSTextAlignmentRight;
//        rightLabel.text = @"585898390";
//        [_middleView addSubview:rightLabel];
//        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.view).offset(-13);
//            make.top.equalTo(leftLabel);
//            make.height.equalTo(leftLabel);
//        }];
//
//        UIView *line  = [[UIView alloc] init];
//        line.frame = CGRectMake(9, leftLabel.frame.origin.y + leftLabel.frame.size.height + 5, _middleView.frame.size.width - 9 - 13, 1);
//        line.backgroundColor = COLOR_STRING(@"#FFD3D3D3");
//        [_middleView addSubview:line];
//
//        switch (i) {
//            case 0:
//                leftLabel.text = @"官方网站";
//                rightLabel.text = @"www.xiaobuke.com";
//                break;
//            case 1:
//                leftLabel.text = @"客服电话";
//                rightLabel.text = @"400-666-555";
//                break;
//            case 2:
//                leftLabel.text = @"微信公众号";
//                rightLabel.text = @"小布壳";
//                break;
//            case 3:
//                leftLabel.text = @"当前版本";
//                rightLabel.text = @"V1.0.0.0545";
//                break;
//
//            default:
//                break;
//        }
        
//        [rightLabel sizeToFit];
//    }
    
}

-(void)iconImageViewClick:(UIGestureRecognizer*) recognizer
{
    NSLog(@"====> iconImageViewClick <====");
    [MBProgressHUD showText:[NSString stringWithFormat:@"%@",SERVER_URL ]];
}

-(void)creatbottomViewChild
{
    /**
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15, 0, _bottomView.frame.size.width - 15*2, 40);
    [button setTitle:@"退出登录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:COLOR_STRING(@"#FF5001")];
    [button addTarget:self action:@selector(quitLogin) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 4;
    button.layer.borderColor = COLOR_STRING(@"#FF5001").CGColor;
    button.layer.borderWidth = 1;
    button.layer.masksToBounds = YES;
    [_bottomView addSubview:button];
     
    */
    
    UILabel *copyLabel = [[UILabel alloc]init];
    copyLabel.frame = CGRectMake(0, 0, _bottomView.frame.size.width, 20);
    copyLabel.textAlignment = NSTextAlignmentCenter;
    copyLabel.textColor = COLOR_STRING(@"#808080");
    copyLabel.font = MY_FONT(13);
    copyLabel.text = @"Copyright @2016-2020";
    copyLabel.backgroundColor = [UIColor clearColor];
    [_bottomView addSubview:copyLabel];
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, copyLabel.frame.origin.y + copyLabel.frame.size.height, _bottomView.frame.size.width, 20);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = COLOR_STRING(@"#808080");
    label.font = MY_FONT(13);
    label.text = @"偶家科技 版权所有";
    label.backgroundColor = [UIColor clearColor];
    [_bottomView addSubview:label];
}


-(void) createTopViewChild {
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 40, 40)];
    
    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateSelected];
    [backButton.titleLabel setFont:MY_FONT(18)];
    [backButton setAdjustsImageWhenHighlighted:NO];
    
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,25,self.view.frame.size.width,48)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"关于小布壳";
    titleLabel.font = MY_FONT(19);
    titleLabel.textColor = COLOR_STRING(@"#2f2f2f");
    [_topView addSubview: titleLabel];
}

-(void)getAboutData
{
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        AboutService *service = (AboutService *)httpInterface;
        
        NSArray *temArray = service.dataArray;
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:temArray];
        for (AboutInfo *info in mutableArray) {
            if ([info.infoName isEqualToString:@"在线购买"]) {
                [mutableArray removeObject:info];
                AboutInfo *lastInfo = [[AboutInfo alloc]init];
//                lastInfo.infoName = @"当前版本";
//                NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
//                lastInfo.infoValue = [NSString stringWithFormat:@"V%@",version];
                
                lastInfo.infoName = @"版本更新";
                lastInfo.infoValue = @"点击升级";
                
                [mutableArray addObject:lastInfo];
            }
        }
        
        self.dataArray = [NSArray arrayWithArray:mutableArray];
        [self.tableView reloadData];
    };
    
    void (^OnError) (NSInteger,NSString *) = ^(NSInteger httpInterface,NSString *description){
        
    };
    
    AboutService *service = [[AboutService alloc]init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token];
    [service start];
}

#pragma mark - tableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.dataArray.count;
    }else{
        return 1;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    AboutViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AboutViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (indexPath.section == 0) {
        AboutInfo *info = self.dataArray[indexPath.row];
        cell.leftString = info.infoName;
//        cell.rightString = info.infoValue;
        cell.rightLabel.text = info.infoValue;
        if ([info.infoName isEqualToString:@"官方网站"]) {
            cell.line.hidden = NO;
        }
        
        if ([info.infoName isEqualToString:@"微信公众号"]) {
            cell.userInteractionEnabled = NO;
        }
        
        if ([info.infoName isEqualToString:@"版本更新"]) {
            cell.line.hidden = YES;
            
            if (APP_DELEGATE.mVersionInfo == nil) {
                cell.userInteractionEnabled = NO;
                cell.upgradeImgView.hidden = YES;
                cell.rightLabel.text = @"已经是最新版本";
                
            }else{
                cell.userInteractionEnabled = YES;
                
                cell.upgradeImgView.hidden = NO;
                cell.rightLabel.textColor = COLOR_STRING(@"#FF721C");
            }
            
        }
    }else{
//        cell.leftString = @"在线购买";
        cell.line.hidden = YES;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }else{
        return 10;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60;
    }else{
        return 0.01;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        AboutInfo *info = self.dataArray[indexPath.row];
        if ([info.infoName isEqualToString:@"官方网站"]) {
            NSString *urlStr = [info.infoValue stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            XBKWebViewController *webVC = [[XBKWebViewController alloc]init:urlStr];
            [self.navigationController pushViewController:webVC animated:YES];
        }
        
        if ([info.infoName isEqualToString:@"客服电话"]) {
            NSString *phoneNum = [NSString stringWithFormat:@"tel:%@",info.infoValue];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNum]];
        }
        
        if ([info.infoName isEqualToString:@"版本更新"]) {
            if (APP_DELEGATE.mVersionInfo != nil) {
                NSString *path = APP_DELEGATE.mVersionInfo.path;
                NSURL *url = [NSURL URLWithString:path];
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
}

-(IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
