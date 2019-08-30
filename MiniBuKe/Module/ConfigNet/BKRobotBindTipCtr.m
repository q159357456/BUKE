//
//  BKRobotBindTipCtr.m
//  MiniBuKe
//
//  Created by chenheng on 2019/1/29.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKRobotBindTipCtr.h"
#import "BKMessageNODataBackView.h"
#import "BKSelectRobotModelCtr.h"

@interface BKRobotBindTipCtr ()
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *backBtn;
@end

@implementation BKRobotBindTipCtr
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = NO;
}
- (void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTopBarView];
    [self setUI];
}
- (void)initTopBarView{
    self.topView = [[UIView alloc]init];
    _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH,kNavbarH);
    _topView.backgroundColor = COLOR_STRING(@"#ffffff");
    [self.view addSubview:_topView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80,kStatusBarH,SCREEN_WIDTH-160,44)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    _titleLabel.textColor = COLOR_STRING(@"#2f2f2f");
    _titleLabel.text = @"绑定说明";
    [_topView addSubview: _titleLabel];
    
    self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, kStatusBarH, 40, 44)];
    [self.backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.backBtn setImage:[UIImage imageNamed:@"mate_back"]
                  forState:UIControlStateNormal];
    [self.backBtn setImage:[UIImage imageNamed:@"mate_back"]
                  forState:UIControlStateSelected];
    [_topView addSubview:self.backBtn];
}

- (void)setUI{
    CGRect imageBound = CGRectMake(0, 0, 375, 200);
    UIImage *backImage = [UIImage imageNamed:@"talkPlacehoder"];
    NSString *title = @"哎呀，这个功能需要\n绑定小布壳机器人才能使用哦!";
    BKMessageNODataBackView *backView = [[BKMessageNODataBackView alloc]initWithImageBound:imageBound WithImage:backImage WithTitle:title andPicOffset:-100 andLableOffset:-15];
    backView.frame = CGRectMake(0, kNavbarH, SCREEN_WIDTH, SCREEN_HEIGHT-kNavbarH);
    backView.backgroundColor = COLOR_STRING(@"#F7F9FB");
    backView.titlefont = [UIFont systemFontOfSize:13.f];
    backView.titlefontColor = COLOR_STRING(@"#999999");
    [self.view addSubview:backView];
    
    UIButton *buton = [[UIButton alloc] initWithFrame:CGRectMake(SCALE(88), self.view.frame.size.height-92, SCALE(200), 44)];
    buton.backgroundColor = COLOR_STRING(@"#F6922D");
    buton.layer.cornerRadius=22;
    buton.layer.masksToBounds=YES;
    [buton setTitle:@"绑定设备" forState:UIControlStateNormal];
    [buton addTarget:self action:@selector(bindMachain) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview : buton];
}

- (void)bindMachain{
    BKSelectRobotModelCtr *ctr = [[BKSelectRobotModelCtr alloc]init];
    [self.navigationController pushViewController:ctr animated:YES];

}

@end
