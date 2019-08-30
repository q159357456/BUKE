//
//  BluetoothViewController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/9.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BluetoothViewController.h"

@interface BluetoothViewController ()

@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIView *middleView;
@property(nonatomic,strong) UIView *bottomView;

@property(nonatomic,strong) UIImageView *qrcodeImage;

@end

@implementation BluetoothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor: [UIColor whiteColor] ];
    
    [self initView];
    
}

- (void)initView{
    _topView = [[UIView alloc] init];
    [_topView setBackgroundColor:COLOR_STRING(@"#FFFFFF")];
    [self.view addSubview:_topView];
    
    _bottomView = [[UIView alloc] init];
    //[_bottomView setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:_bottomView];
    
    _middleView = [[UIView alloc] init];
    //[_middleView setBackgroundColor:COLOR_STRING(@"#F21212")];
    [self.view addSubview:_middleView];
    
    
    NSLog(@" %f == %f",self.view.frame.size.height,self.view.frame.size.width);
    
    //_topView.frame = CGRectMake(0, 0, self.view.frame.size.width, 110);
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 73));
        make.top.equalTo(self.view);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 40));
        make.top.equalTo(self.view).with.offset(self.view.frame.size.height - 40);
        make.bottom.equalTo(self.view);
    }];
    [_middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(_bottomView.mas_top);
        //make.top.equalTo(_topView.mas_height);
    }];
    
    [self createTopViewChild];
    [self createMiddleViewChild];
    //[self createBottomViewChild];
    
}

-(void) createMiddleViewChild {
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width,30)];
        label1.textAlignment = NSTextAlignmentLeft;
        label1.text = @"蓝牙连接";
        label1.font = MY_FONT(17);
        [_middleView addSubview: label1];
}


-(IBAction)downButtonClick:(id)sender{
    NSLog(@"下一步");
    //    WifiImportViewController *wifiVC = [[WifiImportViewController alloc] init];
    //    [self.navigationController pushViewController:wifiVC animated:YES];
}

-(void) createTopViewChild {
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 40, 40)];
    //[_moveButton setBackgroundColor:[UIColor whiteColor]];
    
    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateSelected];
    //[_moveButton setTitle:@"故事" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:MY_FONT(18)];
    [backButton setAdjustsImageWhenHighlighted:NO];
    //[_moveButton setTitleColor:COLOR_STRING(@"#FFD1C7") forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,25,self.view.frame.size.width,48)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"蓝牙连接";
    titleLabel.font = MY_FONT(19);
    titleLabel.textColor = COLOR_STRING(@"#2f2f2f");
    [_topView addSubview: titleLabel];
}

-(IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideBarStyle];
}

- (void)hideBarStyle {
    //[UIApplication sharedApplication]. = UIStatusBarStyleDefault;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = YES;
    
    //self.view.backgroundColor = [UIColor redColor];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[self showBarStyle];
}

@end
