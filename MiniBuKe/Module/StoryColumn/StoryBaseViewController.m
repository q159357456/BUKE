//
//  StoryBaseViewController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/16.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "StoryBaseViewController.h"

@interface StoryBaseViewController ()

//@property(nonatomic,strong)UILabel *titleLabel;

@end

@implementation StoryBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.frame = [[UIScreen mainScreen]bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    // 导航栏左侧按钮
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 0, 40, 40);
    _leftButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftButton];
    
    // 导航栏右侧按钮
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(0, 0, 40, 40);
    _rightButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    
    // 自定义导航栏的titleView
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width*0.6, 44)];
    titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    titleView.autoresizesSubviews = YES;
    titleView.backgroundColor = [UIColor clearColor];
    titleView.center = CGPointMake(self.navigationController.navigationBar.frame.size.width / 2.0, self.navigationController.navigationBar.frame.size.height / 2.0);
    titleView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.navigationItem.titleView = titleView;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleView.frame.size.width/2 - 75, 0, 150, 44)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = MY_FONT(18);
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:_titleLabel];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    [self setDefault];
//    [self initNaviBar];
    
}

-(void)setDefault
{
    self.backgroundColor = COLOR_STRING(@"#FF5001");
    
    self.titleFont = MY_FONT(18);
    self.titleColor = COLOR_STRING(@"#FFFFFF");
    _backImage = [UIImage imageNamed:@"ic_back"];
}

-(void)initNaviBar
{
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 73)];
    [self.headView setBackgroundColor:self.backgroundColor];
    [self.view addSubview:self.headView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 40, 40)];
    [backButton setBackgroundImage:_backImage forState:UIControlStateNormal];
    [backButton setBackgroundImage:_backImage forState:UIControlStateSelected];
    [backButton.titleLabel setFont:MY_FONT(18)];
    [backButton setAdjustsImageWhenHighlighted:NO];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,25,self.view.frame.size.width,48)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.text = self.titleString;
//    titleLabel.font = self.titleFont;
//    titleLabel.textColor = COLOR_STRING(self.titleColor);
    titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel = titleLabel;
    [self.headView addSubview: titleLabel];
    
}

-(void)setTitleString:(NSString *)titleString
{
    _titleString = titleString;
    self.titleLabel.text = titleString;
}

-(void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

-(void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    self.titleLabel.font = titleFont;
}

-(void)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    CGFloat y = -(Height_StatusBar);
    UIView *statusView = [[UIView alloc]initWithFrame:CGRectMake(0, y, self.view.bounds.size.width, Height_StatusBar)];
    self.statusView = statusView;
    [self.navigationController.navigationBar addSubview:statusView];
    
//    [self hideBarStyle];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self showBarStyle];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.statusView removeFromSuperview];
}

-(void)showBarStyle
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = NO;
}

-(void)hideBarStyle
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
