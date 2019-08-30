//
//  PrepareConfigNetViewController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/9.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "PrepareConfigNetViewController.h"
#import "WifiImportViewController.h"

@interface PrepareConfigNetViewController ()

@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIView *middleView;
@property(nonatomic,strong) UIView *bottomView;

@property(nonatomic,strong) UIView *tipMaskView;

@property(nonatomic, strong) NSArray *contentArray;
@end

@implementation PrepareConfigNetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(self.robotType == XBK_RobotType_Q1 || self.robotType == XBK_RobotType_Q1_A33){//Q1
        self.contentArray = [NSArray arrayWithObjects:@"1.请打开小布壳开关",@"2.同时按住小布壳的两只眼睛",@"3.等待提示音:请打开小布壳APP",@"为设备配置网络", nil];
    }else if (self.robotType == XBK_RobotType_super){//Titan
        self.contentArray = [NSArray arrayWithObjects:@"1.请打开小布壳开关",@"2.双手同时按住小布壳儿童故事",@"及绘本阅读功能键",@"3.等待小布壳配网指示和语音提示", nil];
    }else if (self.robotType == XBK_RobotType_babycare){//babyCare
        self.contentArray = [NSArray arrayWithObjects:@"1.请打开小布壳开关",@"2.双手同时按住小布壳菜单键",@"及循环播放键",@"3.等待小布壳配网指示和语音提示", nil];
    }else if (self.robotType == XBK_RobotType_chill){
        self.contentArray = [NSArray arrayWithObjects:@"1.请打开机器人开关",@"2.同时按住绘本按钮和机器人肚子",@"或对机器人说“我要联网”",@"3.等待配网语音提示", nil];
    }
    self.view.backgroundColor = COLOR_STRING(@"#F7F9FB");
    [self initView];
}

- (void)initView{
    _topView = [[UIView alloc] init];
    [_topView setBackgroundColor:COLOR_STRING(@"#FFFFFF")];
    [self.view addSubview:_topView];
    
    _middleView = [[UIView alloc] init];
    [_middleView setBackgroundColor:COLOR_STRING(@"#F7F9FB")];
    [self.view addSubview:_middleView];

    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, kNavbarH));
        make.top.equalTo(self.view);
    }];
    
    [_middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self createTopViewChild];
    [self createMiddleViewChild];

}

-(void) createMiddleViewChild {
    
    NSInteger fontSize = 14.f;
    
    UILabel *label1 = [[UILabel alloc] init];
    if (is_IPhone5) {
        label1.frame = CGRectMake(0, 20, self.view.frame.size.width,15);
    }else{
        label1.frame = CGRectMake(0, 48, self.view.frame.size.width,15);
    }
    
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = self.contentArray[0];
    label1.textColor = COLOR_STRING(@"#666666");
    label1.font = MY_FONT(fontSize);
    [_middleView addSubview: label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, label1.frame.origin.y + label1.frame.size.height + 10, self.view.frame.size.width,15)];
    label2.textAlignment = NSTextAlignmentLeft;
    label2.text = self.contentArray[1];
    label2.font = MY_FONT(fontSize);
    label2.textColor = COLOR_STRING(@"#666666");
    label2.textAlignment = NSTextAlignmentCenter;
    [_middleView addSubview: label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, label2.frame.origin.y + label2.frame.size.height + 10, self.view.frame.size.width,15)];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.text = self.contentArray[2];
    label3.textColor = COLOR_STRING(@"#666666");
    label3.font = MY_FONT(fontSize);
    [_middleView addSubview: label3];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, label3.frame.origin.y + label3.frame.size.height + 10, self.view.frame.size.width, 15)];
    label4.textAlignment = NSTextAlignmentCenter;
    label4.textColor = COLOR_STRING(@"#666666");
    label4.font = MY_FONT(fontSize);
    label4.text = self.contentArray[3];
    [_middleView addSubview:label4];
   
    UIImageView *imageView = [[UIImageView alloc]  initWithFrame:CGRectMake(0, CGRectGetMaxY(label4.frame)+20, SCREEN_WIDTH, SCREEN_WIDTH*(260.f/375.f))];
    if (self.robotType == XBK_RobotType_Q1_A33) {
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"newConfig_bing_%d",1]]];
    }else{
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"newConfig_bing_%ld",self.robotType]]];
    }
    [_middleView addSubview:imageView];
    
    UIButton *downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat downy = 77;
    if(is_IPhone5){
        downy = 35;
    }
    downButton.frame = CGRectMake(40, SCREEN_HEIGHT - downy-46, SCREEN_WIDTH - 40*2, 46);
    [downButton setBackgroundColor:COLOR_STRING(@"#F6922D")];
    [downButton setTitle:@"已经听到提示音" forState:UIControlStateNormal];
    [downButton.titleLabel setFont:[UIFont systemFontOfSize:18.f weight:UIFontWeightMedium]];
    downButton.titleLabel.textColor = COLOR_STRING(@"#ffffff");
    downButton.layer.cornerRadius = 23.f;
    downButton.layer.masksToBounds = YES;
    [downButton addTarget:self action:@selector(downButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downButton];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-108)*0.5, CGRectGetMaxY(downButton.frame) + 10, 108, 20)];
    tipLabel.textColor = COLOR_STRING(@"#666666");
    tipLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = @"没有听到提示音?";
    [self.view addSubview:tipLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 19, CGRectGetWidth(tipLabel.frame), 1)];
    line.backgroundColor = COLOR_STRING(@"#2f2f2f");
    [tipLabel addSubview:line];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTip)];
    tipLabel.userInteractionEnabled = YES;
    [tipLabel addGestureRecognizer:tap];
}

-(IBAction)downButtonClick:(id)sender{
    NSLog(@"下一步");
    if (self.configMold == WifiConfigNet) {
        WifiImportViewController *wifiVC = [[WifiImportViewController alloc] init];
        wifiVC.robotType = self.robotType;
        [self.navigationController pushViewController:wifiVC animated:YES];
        
    }else
    {
        QRCodeViewController *mQRCodeViewController = [[QRCodeViewController alloc] init];
        mQRCodeViewController.robotType = self.robotType;
        mQRCodeViewController.configMold = FourthGConfigNet;
        [self.navigationController pushViewController:mQRCodeViewController animated:YES];
    }
   
}

-(void) createTopViewChild {
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, kStatusBarH, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateSelected];
    [backButton.titleLabel setFont:MY_FONT(18)];
    [backButton setAdjustsImageWhenHighlighted:NO];
    
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40,kStatusBarH,self.view.frame.size.width-80,40)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.text = @"准备绑定小布壳";
    titleLabel.text = @"设备绑定";
    titleLabel.font = [UIFont systemFontOfSize:18.f weight:UIFontWeightMedium];
    titleLabel.textColor = COLOR_STRING(@"#2f2f2f");
    [_topView addSubview: titleLabel];
}

-(void)clickTip
{
    NSLog(@"点击提示");
    
    if (self.tipMaskView == nil) {
        self.tipMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.tipMaskView.backgroundColor = [UIColor colorWithHexStr:@"#202020" alpha:0.7];
        [self.view addSubview:self.tipMaskView];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(8, 39, SCREEN_WIDTH - 8*2, SCREEN_HEIGHT - 39 - 8)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 8;
        view.layer.masksToBounds = YES;
        [self.tipMaskView addSubview:view];
        
        NSInteger fontSize;
        NSInteger labelHeight;
        if (is_IPhone5) {
            fontSize = 13;
            labelHeight = 17;
        }else{
            fontSize = 15;
            labelHeight = 20;
        }
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(view.frame.size.width - 50, 0, 50, 50);
        [closeBtn addTarget:self action:@selector(clickClose:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:closeBtn];
        
        UIImageView *closeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width - 22 - 10, 10, 22, 22)];
        closeImageView.image = [UIImage imageNamed:@"binding_q2_closeBtn"];
        [view addSubview:closeImageView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        if (is_IPhone5) {
            titleLabel.frame = CGRectMake(0, 30, view.frame.size.width, 20);
        }else{
            titleLabel.frame = CGRectMake(0, 52, view.frame.size.width, 20);
        }
        
        titleLabel.textColor = COLOR_STRING(@"#1D1D1D");
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:19];//粗体
        titleLabel.text = @"没有听到提示音?";
        [view addSubview:titleLabel];
        
        UILabel *line = [[UILabel alloc] init];
        if (is_IPhone5) {
            line.frame = CGRectMake(15, titleLabel.frame.origin.y + titleLabel.frame.size.height + 5, view.frame.size.width - 15*2, 1);
        }else{
            line.frame = CGRectMake(30, titleLabel.frame.origin.y + titleLabel.frame.size.height + 5, view.frame.size.width - 30*2, 1);
        }
        
        line.backgroundColor = COLOR_STRING(@"#1D1D1D");
        [view addSubview:line];
        
        UILabel *label1 = [[UILabel alloc] init];
        if (is_IPhone5) {
            label1.frame = CGRectMake(17, line.frame.origin.y + line.frame.size.height + 14, view.frame.size.width - 17*2, labelHeight);
        }else{
            label1.frame = CGRectMake(30, line.frame.origin.y + line.frame.size.height + 34, view.frame.size.width - 30*2, labelHeight);
        }
        
        label1.textColor = COLOR_STRING(@"1D1D1D");
        label1.font = MY_FONT(fontSize);
        if(self.robotType == XBK_RobotType_chill){
            label1.text = @"1、请检查机器人是否有电并开机";
        }else{
            label1.text = @"1、请检查小布壳机器人是否有电并开机";
        }
        [view addSubview:label1];
        
        UIImageView *imagView1 = [[UIImageView alloc] initWithFrame:CGRectMake((view.frame.size.width - 206)*0.5, label1.frame.origin.y + label1.frame.size.height + 10, 206, 125)];
        if (self.robotType == XBK_RobotType_Q1_A33) {
            imagView1.image = [UIImage imageNamed:[NSString stringWithFormat:@"newConfig_bing_%ld_0",1]];
        }else{
            imagView1.image = [UIImage imageNamed:[NSString stringWithFormat:@"newConfig_bing_%ld_0",self.robotType]];
        }
        [view addSubview:imagView1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(label1.frame.origin.x, imagView1.frame.origin.y + imagView1.frame.size.height + 15, label1.frame.size.width+15, label1.frame.size.height)];
        label2.textColor = COLOR_STRING(@"#1D1D1D");
        label2.font = MY_FONT(fontSize);
        if (self.robotType == XBK_RobotType_chill) {
            label2.text = @"2、顺时针旋转尾巴增大音量,直到听到提示音";
        }else{
            label2.text = @"2、请调节小布壳的音量键,直到听到提示音";
        }
        [view addSubview:label2];
        
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake((view.frame.size.width - 206)*0.5, label2.frame.origin.y + label2.frame.size.height + 10, 206, 125)];
        if (self.robotType == XBK_RobotType_Q1_A33) {
            imageView2.image = [UIImage imageNamed:[NSString stringWithFormat:@"newConfig_bing_%d_1",1]];
        }else{
            imageView2.image = [UIImage imageNamed:[NSString stringWithFormat:@"newConfig_bing_%ld_1",self.robotType]];
        }
        [view addSubview:imageView2];
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(label1.frame.origin.x, imageView2.frame.origin.y + imageView2.frame.size.height + 15, label1.frame.size.width, 40)];
        label3.numberOfLines = 0;
        label3.textColor = COLOR_STRING(@"#1D1D1D");
        label3.font = MY_FONT(fontSize);
        label3.text = @"3、点击\"已经听到了声音\"按钮,进入下一步继续走完连续步骤,看看是否可以连接网络。";
        [view addSubview:label3];
        
        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(label1.frame.origin.x, label3.frame.origin.y + label3.frame.size.height + 10, label1.frame.size.width, labelHeight)];
        label4.textColor = COLOR_STRING(@"#1D1D1D");
        label4.font = MY_FONT(fontSize);
        label4.text = @"4、如果问题仍未解决,请联系我们:";
        [view addSubview:label4];
        
        UILabel *servicePhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(label1.frame.origin.x, label4.frame.origin.y + label4.frame.size.height, label1.frame.size.width, labelHeight)];
        servicePhoneLabel.textColor = COLOR_STRING(@"1D1D1D");
        servicePhoneLabel.font = MY_FONT(fontSize);
        servicePhoneLabel.text = @"客服电话: 0755-83732284";
        [view addSubview:servicePhoneLabel];
        
        UILabel *wechatLabel = [[UILabel alloc] initWithFrame:CGRectMake(label1.frame.origin.x, servicePhoneLabel.frame.origin.y + servicePhoneLabel.frame.size.height, label1.frame.size.width, labelHeight)];
        wechatLabel.textColor = COLOR_STRING(@"#1D1D1D");
        wechatLabel.font = MY_FONT(fontSize);
        wechatLabel.text = @"客服微信: 16675384127";
        [view addSubview:wechatLabel];
    }else{
        self.tipMaskView.hidden = NO;
    }
}

-(void)clickClose:(UIButton *)sender
{
    self.tipMaskView.hidden = YES;
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
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = YES;
    
    //self.view.backgroundColor = [UIColor redColor];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;

    //[self showBarStyle];
}

@end
