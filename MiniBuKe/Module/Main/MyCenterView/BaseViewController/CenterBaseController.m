//
//  CenterBaseController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/27.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "CenterBaseController.h"

@interface CenterBaseController ()

@end

@implementation CenterBaseController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
//-(void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO];
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initBarView];
    // Do any additional setup after loading the view.
}
-(void)initBarView{
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kNavbarH)];
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.topView.bounds.size.width/2 - 100,kStatusBarH==44?44:30, 200, 20)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView setBackgroundColor:COLOR_STRING(@"#FFFFFF")];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(8, kStatusBarH==44?32:18 , 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.topView addSubview:backButton];
    [self.topView addSubview:self.titleLabel];
    [self.view addSubview:self.topView];
}

#pragma mark - action
-(void)backButtonClick{
    
    [APP_DELEGATE.navigationController popViewControllerAnimated:YES];
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
