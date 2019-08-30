//
//  QRCodeViewController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/9.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "QRCodeViewController.h"
#import <CoreImage/CoreImage.h>
#import "AppDelegate.h"
#import "QRCodePromptView.h"
#import "NSString+DES.h"
#import "FetchUserSNService.h"
#import "MBProgressHUD+XBK.h"
#import <GCCycleScrollView.h>
#import "TencentIMManager.h"
#import "BKDeviceManagnerCtr.h"
#import "BKRobotBindTipCtr.h"
#import "BKBabyCareMainCtr.h"

typedef NS_ENUM(NSInteger, AlertType){
    AlertTypeQuit = 1,//退出警告
    AlertTypeCountdown,//倒计时完毕警告
};

@interface QRCodeViewController ()<GCCycleScrollViewDelegate>

@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIView *middleView;
@property(nonatomic,strong) UIView *bottomView;

@property(nonatomic,strong) UIImageView *qrcodeImage;

@property(nonatomic,strong) QRCodePromptView *mQRCodePromptView;
@property(nonatomic,strong) UIView *maskView;

@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,strong) NSTimer *labelTimer;
@property(nonatomic,assign) NSInteger timeNum;
@property(nonatomic,strong) UILabel *tipLabel;

@property(nonatomic,strong) NSTimer *countDownTimer;
@property(nonatomic,strong) UILabel *countDownLabel;
@property(nonatomic,assign) NSInteger countDownNum;

@property(nonatomic) int timerRunCount;
@property(nonatomic) CGFloat value;

@property(nonatomic,strong) UIView *alertMask;
@property(nonatomic,strong) UIView *helpMask;

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor: [UIColor whiteColor] ];
    
    [self initView];
    [self initMaskView];
    NSString *userIdStr = [NSString stringWithFormat:@"%@",APP_DELEGATE.mLoginResult.userId];
    NSString *userId = [NSString des:userIdStr key: @"rnApzdA8PouJIAZKjX5JCEy1kQPqhx"];
    NSLog(@"%@",userId);
    [self createQRcode: userId wifiAccount:self.wifiAccount wifiPassword: self.wifiPassword];
}

-(void)initMaskView
{
    if (self.maskView == nil) {
        self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.maskView.backgroundColor = [UIColor colorWithHexStr:@"#202020" alpha:0.7];
        [self.view addSubview:self.maskView];
        
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(15, (SCREEN_HEIGHT - SCREEN_HEIGHT*(470.f/640.f))*0.5, SCREEN_WIDTH - 15*2, SCREEN_HEIGHT*(470.f/640.f));
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 24.f;
        view.layer.masksToBounds = YES;
        [self.maskView addSubview:view];
        
        GCCycleScrollView *cycleScroll = [[GCCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 290)];
        cycleScroll.delegate = self;
        if(self.robotType == XBK_RobotType_Q1_A33){
            self.robotType = XBK_RobotType_Q1;
        }
        NSArray *imageArray = [[NSArray alloc] initWithObjects:[UIImage imageNamed:[NSString stringWithFormat:@"newConfig_scrollimage_%ld_1",self.robotType]],[UIImage imageNamed:[NSString stringWithFormat:@"newConfig_scrollimage_%ld_2",self.robotType]], nil];
        cycleScroll.localImageGroups = imageArray;
        cycleScroll.autoScrollTimeInterval = 3.5;
        cycleScroll.dotColor = COLOR_STRING(@"#C0914E");
        cycleScroll.pageControlAliment = GCCycleScrollPageControlAlimentRight;
        [view addSubview:cycleScroll];
        
        NSInteger fontSize = 14;
        UILabel *label = [[UILabel alloc] init ];
        if (is_IPhone5) {
            label.frame = CGRectMake(0, cycleScroll.frame.origin.y + cycleScroll.frame.size.height + 20, view.frame.size.width, 17);
//            fontSize = 12;
        }else{
            label.frame = CGRectMake(0, cycleScroll.frame.origin.y + cycleScroll.frame.size.height + 29, view.frame.size.width, 20);
//            fontSize = 14;
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = COLOR_STRING(@"#666666");
        label.font = MY_FONT(fontSize);
        self.tipLabel = label;
        [view addSubview:label];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (is_IPhone5) {
            button.frame = CGRectMake((view.frame.size.width - 174)*0.5, view.frame.size.height - 35 - 25, 174, 35);
        }else{
            button.frame = CGRectMake((view.frame.size.width - 174)*0.5, view.frame.size.height - 43 - 55, 174, 43);
        }
        
        [button setTitle:@"准备好啦" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:COLOR_STRING(@"#F6942F")];
        [button addTarget:self action:@selector(clickHideMask:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = button.frame.size.height * 0.5;
        button.layer.masksToBounds = YES;
        [view addSubview:button];
        
        self.timeNum = 0;
        self.labelTimer = [NSTimer scheduledTimerWithTimeInterval:3.5 target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
        [self.labelTimer fire];
    }else{
        self.maskView.hidden = NO;
    }
}

-(void)updateLabel
{
    if (self.timeNum % 2 == 0) {
        if (self.robotType == XBK_RobotType_babycare) {
            self.tipLabel.text = @"请将二维码对准小布壳摄像头面前，距离10cm";
            
        }else if (self.robotType == XBK_RobotType_chill){
            
            self.tipLabel.text = @"请将手机斜放在机器人面前，距离约10cm";
        }
        else{
            self.tipLabel.text = @"请将手机斜放在小布壳面前,离小布壳约5cm";
        }

    }else{
        self.tipLabel.text = @"若未听到提示语音,请适当调整手机再试一遍";
    }
    
    self.timeNum++;
}

-(void)clickHideMask:(UIButton *)sender
{
    self.maskView.hidden = YES;
//    [self.maskView removeFromSuperview];
    
    //3.5s轮播图定时器
    self.timeNum = 0;
    [self.labelTimer invalidate];
    self.labelTimer = nil;
    
    //绑定模式下
    if (!self.isConfigNet) {
        //90s开始倒计时
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(coutDownTime) userInfo:nil repeats:YES];
        [self.countDownTimer fire];
    }
}

-(void)coutDownTime
{
    self.countDownLabel.text = [NSString stringWithFormat:@"%lds",self.countDownNum];
    
    self.countDownNum--;
    if (self.countDownNum < 0) {
        self.countDownNum = 0;
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
        
        //弹出提示框
        [self showAlertWithTag:AlertTypeCountdown];
    }
}

-(void)showAlertWithTag:(NSInteger)alertType
{
    self.alertMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.alertMask.backgroundColor = [UIColor colorWithHexStr:@"#202020" alpha:0.7];
    [self.view addSubview:self.alertMask];
    
    UIView *view = [[UIView alloc] init];
    if (alertType == AlertTypeCountdown) {
        view.frame = CGRectMake(36, (SCREEN_HEIGHT - 165)*0.5,SCREEN_WIDTH - 36*2, 165);
    }else if(alertType == AlertTypeQuit){
        view.frame = CGRectMake(36, (SCREEN_HEIGHT - 143)*0.5,SCREEN_WIDTH - 36*2, 143);
    }
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 24.f;
    view.layer.masksToBounds = YES;
    [self.alertMask addSubview:view];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 28, view.frame.size.width, 16);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = COLOR_STRING(@"#2f2f2f");
    titleLabel.font = [UIFont systemFontOfSize:16.f weight:UIFontWeightMedium];//加粗
    if (alertType == AlertTypeCountdown) {
        titleLabel.text = @"添加过程中出了点小问题";
    }else if (alertType == AlertTypeQuit){
        titleLabel.text = @"提示";
    }
    
    [view addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    if (alertType == AlertTypeCountdown) {
        contentLabel.frame = CGRectMake(25, titleLabel.frame.origin.y + titleLabel.frame.size.height + 15, view.frame.size.width - 25*2, 20*2);
        contentLabel.text = @"机器人连接的wifi网络可能有问题,请重新选择网络,再试一次吧";
    }else if (alertType == AlertTypeQuit){
        contentLabel.frame = CGRectMake(0, titleLabel.frame.origin.y + titleLabel.frame.size.height + 15, view.frame.size.width, 20);
        contentLabel.text = @"是否取消绑定机器人?";
    }
    
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.textColor = COLOR_STRING(@"#999999");
    contentLabel.font = MY_FONT(16);
    contentLabel.numberOfLines = 0;
    [view addSubview:contentLabel];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, view.frame.size.height - 43, (view.frame.size.width - 1)*0.5, 43);
    leftBtn.backgroundColor = COLOR_STRING(@"#E5E5E5");
    [leftBtn setTitleColor:COLOR_STRING(@"#2f2f2f") forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(clickLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.tag = alertType;
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [view addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake((view.frame.size.width + 1)*0.5, leftBtn.frame.origin.y, leftBtn.frame.size.width, 43);
    rightBtn.backgroundColor = COLOR_STRING(@"#E5E5E5");
    [rightBtn setTitleColor:COLOR_STRING(@"#2f2f2f") forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.tag = alertType + 10000;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [view addSubview:rightBtn];
    
    if (alertType == AlertTypeCountdown) {
        [leftBtn setTitle:@"以后再说" forState:UIControlStateNormal];
        [rightBtn setTitle:@"重新绑定" forState:UIControlStateNormal];
    }else if (alertType == AlertTypeQuit){
        [leftBtn setTitle:@"退出" forState:UIControlStateNormal];
        [rightBtn setTitle:@"继续等待" forState:UIControlStateNormal];
    }
}

-(void)clickLeftBtn:(UIButton *)sender
{
//    self.alertMask.hidden = YES;
    [self.alertMask removeFromSuperview];
    //退出
    if([self findTheControllerWith:NSStringFromClass([BKRobotBindTipCtr class])] != -1){
        NSInteger index = [self findTheControllerWith:NSStringFromClass([BKRobotBindTipCtr class])];
        [self.navigationController popToViewController:self.navigationController.viewControllers[index-1] animated:YES];
    }else{
        [APP_DELEGATE.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    }
    
}

-(void)clickRightBtn:(UIButton *)sender
{
//    self.alertMask.hidden = YES;
    [self.alertMask removeFromSuperview];
    
    if (sender.tag == 10000 + AlertTypeCountdown) {
        //重新绑定,返回上一页
        [self backButtonClick:sender];
    }else if (sender.tag == 10000 + AlertTypeQuit){
        //继续等待
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(coutDownTime) userInfo:nil repeats:YES];
        [self.countDownTimer fire];
    }
}

-(void) initPromptView
{
    UIView *shelterLayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [shelterLayer setBackgroundColor: [UIColor blackColor] ];
//    shelterLayer.alpha = 0.5f;
    shelterLayer.backgroundColor = [shelterLayer.backgroundColor colorWithAlphaComponent:0.5];
    self.mQRCodePromptView = [QRCodePromptView xibView];
    self.mQRCodePromptView.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2);
    
    self.mQRCodePromptView.layer.cornerRadius = self.mQRCodePromptView.frame.size.width / 9.9;
    self.mQRCodePromptView.layer.masksToBounds = YES;
    
    [shelterLayer addSubview: self.mQRCodePromptView];
    [self.view addSubview: shelterLayer];
}

- (void)initView{
    _topView = [[UIView alloc] init];
    [_topView setBackgroundColor:COLOR_STRING(@"#FFFFFF")];
    [self.view addSubview:_topView];
    
    _bottomView = [[UIView alloc] init];
    [self.view addSubview:_bottomView];
    
    _middleView = [[UIView alloc] init];
    _middleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_middleView];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 73));
        make.top.equalTo(self.view);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 0));
        make.top.equalTo(self.view).with.offset(self.view.frame.size.height - 0);
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
}

-(void) createMiddleViewChild
{
    NSInteger fontSize;
    if (is_IPhone5) {
        fontSize = 14;
    }else{
        fontSize = 16;
    }
    
    CGFloat setX = (80/360.0) * SCREEN_WIDTH;
    CGFloat setY = 115 - 73;
    CGFloat width = SCREEN_WIDTH - 2*setX;
    CGFloat height = width;
    
    _qrcodeImage = [[UIImageView alloc] init];
    _qrcodeImage.frame = CGRectMake(setX, setY, width, height);
    [_middleView addSubview: _qrcodeImage];
    
    UILabel *label1 = [[UILabel alloc] init];
    if (is_IPhone5) {
        label1.frame = CGRectMake(0, _qrcodeImage.frame.origin.y + _qrcodeImage.frame.size.height + 20, SCREEN_WIDTH, 17);
    }else{
        label1.frame = CGRectMake(0, _qrcodeImage.frame.origin.y + _qrcodeImage.frame.size.height + 37, SCREEN_WIDTH, 20);
    }
    
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = COLOR_STRING(@"#666666");
    label1.font = MY_FONT(fontSize);
    [_middleView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] init];
    if (is_IPhone5) {
        label2.frame = CGRectMake(0, label1.frame.origin.y + label1.frame.size.height + 3, SCREEN_WIDTH, 17);
    }else{
        label2.frame = CGRectMake(0, label1.frame.origin.y + label1.frame.size.height + 5, SCREEN_WIDTH, 20);
    }
    
    label2.textColor = COLOR_STRING(@"#666666");
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = MY_FONT(fontSize);
    self.countDownLabel = label2;
    [_middleView addSubview:label2];
    
    
    if (!self.isConfigNet) {
        
        label1.text = @"等待机器人接收网络配置信息,";
        label2.text = @"预计用时90s";
        
        UIImageView *imageView = [[UIImageView alloc] init];
        if (is_IPhone5) {
            imageView.frame = CGRectMake((SCREEN_WIDTH - 138)*0.5, label2.frame.origin.y + label2.frame.size.height + 20, 138, 138);
        }else{
            imageView.frame = CGRectMake((SCREEN_WIDTH - 138)*0.5, label2.frame.origin.y + label2.frame.size.height + 38, 138, 138);
        }
        imageView.image = [UIImage imageNamed:@"bingbing_timeRound"];
        [_middleView addSubview:imageView];
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.frame = CGRectMake(0, (imageView.frame.size.height - 25)*0.5, imageView.frame.size.width, 25);
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.textColor = COLOR_STRING(@"#F77628");
        timeLabel.font = MY_FONT(30);
        self.countDownNum = 90;//
        timeLabel.text = [NSString stringWithFormat:@"%lds",self.countDownNum];
        self.countDownLabel = timeLabel;
        [imageView addSubview:timeLabel];
        
    }else{
        
        label1.text = @"请将手机斜放在机器面前";
        if(self.robotType == XBK_RobotType_chill){
            label2.text = @"距离机器约10cm";

        }else if (self.robotType == XBK_RobotType_babycare){
            label2.text = @"距离机器约10cm";
            
        }else{
            label2.text = @"距离机器约5cm";
        }
    }
    
    UIView *helpView = [[UIView alloc]init];
    if (is_IPhone5) {
        helpView.frame = CGRectMake((SCREEN_WIDTH - 85)*0.5, SCREEN_HEIGHT - 25 - 20, 85, 25);
    }else{
        helpView.frame = CGRectMake((SCREEN_WIDTH - 85)*0.5, SCREEN_HEIGHT - 25 - 35, 85, 25);
    }
    
    helpView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:helpView];
    
    UIImageView *helpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (helpView.frame.size.height - 16)*0.5, 16, 16)];
    helpImageView.image = [UIImage imageNamed:@"bingbing_help"];
    [helpView addSubview:helpImageView];
    
    UILabel *helpLabel = [[UILabel alloc] initWithFrame:CGRectMake(helpImageView.frame.origin.x + helpImageView.frame.size.width + 5, 0, helpView.frame.size.width - helpImageView.frame.origin.x - helpImageView.frame.size.width - 5, helpView.frame.size.height)];
    helpLabel.textColor = COLOR_STRING(@"#666666");
    helpLabel.font = MY_FONT(14);
    
    NSMutableAttributedString *helpString = [[NSMutableAttributedString alloc] initWithString:@"查看帮助"];
    NSRange range = {0,[helpString length]};
    [helpString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
    [helpLabel setAttributedText:helpString];
    
    [helpView addSubview:helpLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHelp)];
    helpView.userInteractionEnabled = YES;
    [helpView addGestureRecognizer:tap];
}

//{"userToken":"123123123123","ssid":"123124","pwd":"123124"}
-(void) createQRcode:(NSString *) userToken wifiAccount:(NSString *) wifiAccount wifiPassword:(NSString *) wifiPassword{
    // 1. 创建一个二维码滤镜实例(CIFilter)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];
    // 2. 给滤镜添加数据
    //Tita区分绑定和配网 不同type: bind / network_connect, Q1不区分
    NSString *str ;
    if (self.robotType == XBK_RobotType_chill || self.robotType == XBK_RobotType_Q1 || self.robotType == XBK_RobotType_Q1_A33) {
        str = [NSString stringWithFormat:@"{\"type\":\"wifi\",\"wifi\":{\"userId\":\"%@\n\",\"ssid\":\"%@\",\"pwd\":\"%@\"}}",userToken,wifiAccount,wifiPassword];
    }else if (self.robotType == XBK_RobotType_super){
        if(self.isConfigNet){
            
//            str = self.configMold == WifiConfigNet?[NSString stringWithFormat:@"{\"type\":\"network_connect\",\"wifi\":{\"userId\":\"%@\n\",\"ssid\":\"%@\",\"pwd\":\"%@\"}}",userToken,wifiAccount,wifiPassword]:[NSString stringWithFormat:@"{\"type\":\"network_connect\",\"userId\":\"%@\"}",userToken];
             str = self.configMold == WifiConfigNet?[NSString stringWithFormat:@"{\"type\":\"network_connect\",\"wifi\":{\"userId\":\"%@\n\",\"ssid\":\"%@\",\"pwd\":\"%@\"}}",userToken,wifiAccount,wifiPassword]:[NSString stringWithFormat:@"{\"type\":\"network_connect\",\"wifi\":{\"userId\":\"%@\n\"}}",userToken];
        }else{
//            str = self.configMold == WifiConfigNet? [NSString stringWithFormat:@"{\"type\":\"bind\",\"wifi\":{\"userId\":\"%@\n\",\"ssid\":\"%@\",\"pwd\":\"%@\"}}",userToken,wifiAccount,wifiPassword]:[NSString stringWithFormat:@"{\"type\":\"bind\",\"userId\":\"%@\"}",userToken];
               str = self.configMold == WifiConfigNet? [NSString stringWithFormat:@"{\"type\":\"bind\",\"wifi\":{\"userId\":\"%@\n\",\"ssid\":\"%@\",\"pwd\":\"%@\"}}",userToken,wifiAccount,wifiPassword]:[NSString stringWithFormat:@"{\"type\":\"bind\",\"wifi\":{\"userId\":\"%@\n\"}}",userToken];
        }
    }else if (self.robotType == XBK_RobotType_babycare){//babycare
        str = [NSString stringWithFormat:@"pairedInfo:%02ld%@%02ld%@%02ld%@",(long)wifiAccount.length,wifiAccount,(NSInteger)wifiPassword.length,wifiPassword,(NSInteger)userToken.length,userToken];
    }
    
    NSLog(@"createQRcode => %@",str);
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    // 使用KVC的方式给filter赋值
    [filter setValue:data forKeyPath:@"inputMessage"];
//    [filter setValue:@"L" forKey:@"inputCorrectionLevel"];
    // 3. 生成二维码
    CIImage *image = [filter outputImage];
    // 4. 显示二维码
    self.qrcodeImage.image = [self createNonInterpolatedUIImageFormCIImage:image withSize:self.view.frame.size.width - 100];
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

-(void) createTopViewChild {
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 40, 40)];
    //[_moveButton setBackgroundColor:[UIColor whiteColor]];
    
    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateSelected];
    [backButton.titleLabel setFont:MY_FONT(18)];
    [backButton setAdjustsImageWhenHighlighted:NO];
    
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,25,self.view.frame.size.width,48)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"二维码连接";
    titleLabel.font = MY_FONT(18);
    titleLabel.textColor = COLOR_STRING(@"#2f2f2f");
    [_topView addSubview: titleLabel];
    
//    if (!self.isConfigNet) {
        UIButton *quitButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 50, 30, 40, 40)];
        //[_moveButton setBackgroundColor:[UIColor whiteColor]];
        [quitButton setTitle:@"退出" forState:UIControlStateNormal];
        [quitButton setTitleColor:COLOR_STRING(@"#2f2f2f") forState:UIControlStateNormal];
        [quitButton setFont:MY_FONT(16)];
        [quitButton addTarget:self action:@selector(clickQuit:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview: quitButton];
//    }
}

-(void)showHelpAlert
{
    if (self.helpMask == nil) {
        NSInteger fontSize;
        if (is_IPhone5) {
            fontSize = 12;
        }else{
            fontSize = 14;
        }
        
        self.helpMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.helpMask.backgroundColor = [UIColor colorWithHexStr:@"#202020" alpha:0.7];
        [self.view addSubview:self.helpMask];
        
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(36, (SCREEN_HEIGHT - 331)*0.5, SCREEN_WIDTH - 36*2, 331);
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 24;
        view.layer.masksToBounds = YES;
        [self.helpMask addSubview:view];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(0, 41, view.frame.size.width, 20);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = COLOR_STRING(@"#2f2f2f");
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        titleLabel.text = @"联网需要注意的问题";
        [view addSubview:titleLabel];
        
        UILabel *label1 = [[UILabel alloc] init];
        if (is_IPhone5) {
            label1.frame = CGRectMake(15, titleLabel.frame.origin.y + titleLabel.frame.size.height + 19, view.frame.size.width - 15*2, 35);
        }else{
            label1.frame = CGRectMake(23, titleLabel.frame.origin.y + titleLabel.frame.size.height + 19, view.frame.size.width - 23*2, 35);
        }
        
        label1.numberOfLines = 0;
        label1.textColor = COLOR_STRING(@"#999999");
        label1.font = MY_FONT(fontSize);
        if (self.robotType == XBK_RobotType_babycare) {
            label1.text = @"1、请将二维码对准小布壳摄像头面前 距离小布壳10cm";
        }else if (self.robotType == XBK_RobotType_chill){
            label1.text = @"1、请将手机斜放在机器人面前,距离机器人约10cm。";
        }
        else{
            label1.text = @"1、请将手机斜放在小布壳面前,距离小布壳约5cm。";
        }
        [view addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] init];
        label2.frame = CGRectMake(label1.frame.origin.x, label1.frame.origin.y + label1.frame.size.height + 10, label1.frame.size.width, label1.frame.size.height);
        label2.textColor = COLOR_STRING(@"#999999");
        label2.font = MY_FONT(fontSize);
        label2.numberOfLines = 0;
        label2.text = @"2、请查看WiFi的密码是否填写正确,注意区分大小写。";
        [view addSubview:label2];
        
        UILabel *label3 = [[UILabel alloc] init];
//        label3.frame = CGRectMake(label1.frame.origin.x, label2.frame.origin.y + label2.frame.size.height + 10, label1.frame.size.width, 20);
        label3.textColor = COLOR_STRING(@"#999999");
        label3.font = MY_FONT(fontSize);
        [view addSubview:label3];
        
        if (!self.isConfigNet) {
            label3.frame = CGRectMake(label1.frame.origin.x, label2.frame.origin.y + label2.frame.size.height + 10, label1.frame.size.width, 20);
            label3.numberOfLines = 1;
            label3.text = @"3、如果问题仍未解决,请您联系我们:";
            
            UILabel *phoneLabel = [[UILabel alloc] init];
            phoneLabel.frame = CGRectMake(label1.frame.origin.x, label3.frame.origin.y + label3.frame.size.height, label1.frame.size.width, label3.frame.size.height);
            phoneLabel.textColor = COLOR_STRING(@"#999999");
            phoneLabel.font = MY_FONT(fontSize);
            phoneLabel.text = @"客服电话: 0755-83732284";
            [view addSubview:phoneLabel];
            
            UILabel *wechatLabel = [[UILabel alloc] init];
            wechatLabel.frame = CGRectMake(label1.frame.origin.x, phoneLabel.frame.origin.y + phoneLabel.frame.size.height, label1.frame.size.width, label3.frame.size.height);
            wechatLabel.textColor = COLOR_STRING(@"#999999");
            wechatLabel.font = MY_FONT(fontSize);
            wechatLabel.text = @"客服微信: 16675384127";
            [view addSubview:wechatLabel];
            
        }else{
            label3.frame = CGRectMake(label1.frame.origin.x, label2.frame.origin.y + label2.frame.size.height + 10, label1.frame.size.width, 40);
            label3.numberOfLines = 0;
            label3.text = @"3、请查看路由器是否把机器人加入了黑名单";
        }
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (is_IPhone5) {
            button.frame = CGRectMake((view.frame.size.width - 174)*0.5, view.frame.size.height - 25 - 35, 174, 35);
        }else{
            button.frame = CGRectMake((view.frame.size.width - 174)*0.5, view.frame.size.height - 33 - 43, 174, 46);
        }
        button.layer.cornerRadius = button.frame.size.height*0.5;
        button.layer.masksToBounds = YES;
        button.backgroundColor = COLOR_STRING(@"#F6942F");
        [button setTitle:@"知道啦" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickHideHelpMask:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
    }else{
        self.helpMask.hidden = NO;
    }
}

-(void)clickQuit:(UIButton *)sender
{
    if (!self.isConfigNet) {
        //倒计时定时器停止
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
        
        //提示框
        [self showAlertWithTag:AlertTypeQuit];
    }else{
        [self.alertMask removeFromSuperview];
        //配网退出
        
        if ([self findTheControllerWith:NSStringFromClass([BKDeviceManagnerCtr class])] != -1) {
            NSInteger index = [self findTheControllerWith:NSStringFromClass([BKDeviceManagnerCtr class])];
            [self.navigationController popToViewController:self.navigationController.viewControllers[index] animated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)clickHelp
{
    [self showHelpAlert];
}

-(void)clickHideHelpMask:(UIButton *)sender
{
    self.helpMask.hidden = YES;
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
    
    self.timerRunCount = 1;
    
    if (!self.isConfigNet) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(onFetchUserSNService:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    
    self.value = [UIScreen mainScreen].brightness;
    
    [[UIScreen mainScreen] setBrightness: 1];
    
}

- (void)hideBarStyle {
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = YES;
    
    //self.view.backgroundColor = [UIColor redColor];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[self showBarStyle];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = NO;
    
    [[UIScreen mainScreen] setBrightness: self.value];
    
    [self.timer invalidate];
}

#pragma mark - request
-(void)onFetchUserSNService:(NSTimer *)timer
{
    kWeakSelf(weakSelf);
    [XBKNetWorkManager requestUserFetchSNAndAndFinish:^(BKUserSNFetchModel * _Nonnull model, NSError * _Nonnull error) {
        if (error == nil && 1 == model.code) {
            if (model.data!= nil && model.data.sn.length) {
                //更改本地保存的SN
                APP_DELEGATE.mLoginResult.SN = model.data.sn;
                [APP_DELEGATE saveLoginSuccessWithModel];

                //保存当前时间戳
                NSString *timestamp = [weakSelf getCurrentTimestamp];
                
                if (timestamp != nil) {
                    [[NSUserDefaults standardUserDefaults] setObject:timestamp forKey:@"Banding_Timestamp"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                //更改sn信息
                APP_DELEGATE.snData = model.data;
                [APP_DELEGATE saveSNInfoWithModel];
                
                [weakSelf.timer invalidate];
                weakSelf.timer = nil;
                [MBProgressHUD showSuccess:@"绑定成功"];
                [weakSelf bindSuccessWithToJump];
            }
        }
    }];
}


-(NSString*)getCurrentTimestamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval interval = [date timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%0.f", interval];//转为字符型
    
    NSLog(@"绑定当前时间:%@",timeString);
    return timeString;
}

#pragma mark - GCCycleScrollViewDelegate
- (void)cycleScrollView:(GCCycleScrollView *)cycleScrollView didSelectItemAtRow:(NSInteger)row {
    
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
    
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    
}

#pragma mark - 绑定成功 跳转设备管理

- (void)bindSuccessWithToJump{
    
    if (4 == [APP_DELEGATE.snData.type integerValue]) {//babycare
        BKBabyCareMainCtr *babyCareCtr = [[BKBabyCareMainCtr alloc]init];
        babyCareCtr.isNeedPopMore = YES;
        [self.navigationController pushViewController:babyCareCtr animated:YES];
        
    }else{
        
        NSInteger index = [self findTheControllerWith:NSStringFromClass([BKDeviceManagnerCtr class])];
        if (index == -1) {
            
            BKDeviceManagnerCtr *ctr = [[BKDeviceManagnerCtr alloc]init];
            [self.navigationController pushViewController:ctr animated:YES];
            
        }else{
            
            [ self.navigationController popToViewController:self.navigationController.viewControllers[index] animated:YES];
        }
    }
    
}

- (NSInteger)findTheControllerWith:(NSString*)name{
    
    for (NSInteger i = self.navigationController.viewControllers.count-1; i>=0; i--) {
        UIViewController *ctr = [self.navigationController.viewControllers objectAtIndex:i];
        NSString *str = NSStringFromClass([ctr class]);
        if ([str isEqualToString:name]) {
            return i;
        }
    }
    //    NSString *CnStr=[NSString stringWithUTF8String:object_getClassName(ctr)];
    return -1;
}

@end
