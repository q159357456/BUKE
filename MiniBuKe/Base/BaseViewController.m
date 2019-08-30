//
//  BaseViewController.m
//  MiniBuKe
//
//  Created by zhangchunzhe on 2017/12/26.
//  Copyright © 2017年 深圳偶家科技有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD+XBK.h"

@interface BaseViewController ()

@end

@implementation BaseViewController{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setNavigationStyle];
    [self setCustomBackNavigation];
}
#pragma mark - 导航栏的默认样式
-(void)setNavigationStyle{
    
    NSDictionary *dictionary = @{
                                 NSForegroundColorAttributeName:COLOR_STRING(@"#1F1F1F"),
                                 NSFontAttributeName:[UIFont fontWithName:@"Heiti TC" size:17.f]};
    [self.navigationController.navigationBar setTitleTextAttributes:dictionary];
    // 去掉底部的黑色线
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    // 去掉背景颜色
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //设置默认的背景颜色
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
}

-(void)printFontTest{
    NSArray *arrays = [UIFont familyNames];
    for (NSString *str in arrays) {
        NSLog(@"%@",str);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self checkNavigationHiddle];
}


#pragma mark - 检查当前页面是否需要隐藏导航栏
-(void)checkNavigationHiddle{
    AppDelegate *delegate =(AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSString * controllerString = NSStringFromClass([self class]);
    if([delegate.navigationControllers containsObject:controllerString]){
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

#pragma mark - 添加当前页面到隐藏导航栏列表
-(void)registerHiddenNavigation:(UIViewController *)controller{
    AppDelegate *delegate =(AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSString * controllerString = NSStringFromClass([controller class]);
    if(![delegate.navigationControllers containsObject:controllerString]){
        [delegate.navigationControllers addObject:controllerString];
    }
}


#pragma mark - 移除当前页面到隐藏导航栏列表
-(void)unregisterHiddenNavigation:(UIViewController *)controller{
    AppDelegate *delegate =(AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSString * controllerString = NSStringFromClass([controller class]);
    if([delegate.navigationControllers containsObject:controllerString]){
        [delegate.navigationControllers removeObject:controllerString];
    }
}

-(void)showHUDLoadProgress:(UIView*)attachView doSomething:(void (^)(void))doInBackgroud{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:attachView animated:YES];
//    hud.mode = MBProgressHUDModeAnnularDeterminate;
//    hud.label.text = @"请耐心等待";
    [MBProgressHUD showMessage:@"请耐心等待"];

    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        doInBackgroud();
        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUDForView:attachView animated:YES];
            [MBProgressHUD hideHUD];
        });
    });
}

-(void)showHUDToast:(UIView *)attachView text:(NSString *)tips{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:attachView animated:YES];
//    [hud setMode:MBProgressHUDModeText];
//    [hud.label setText:tips];
//    hud.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-60);
//    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC));
//    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//        [MBProgressHUD hideHUDForView:attachView animated:YES];
//        [MBProgressHUD hideHUD];
//    });
    
    [MBProgressHUD showText:tips];
}

-(void)showError{
    [self showHUDToast:self.view text:@"请求数据发生错误"];
    
}

-(void)showError:(NSString *)errorString{
     NSLog(@"===>errorString =>%@ ===>%i",errorString,[errorString rangeOfString:@"Error Domain"].location);
    if ([errorString rangeOfString:@"Error Domain"].location != 0) {
        [self showHUDToast:self.view text:errorString];
    }
}



-(void)goTo:(UIViewController *)toController{
    
    [self.navigationController pushViewController:toController animated:YES];
}

//
- (void)backTo:(UIViewController *)toController{
    for (UIViewController *backController in self.navigationController.viewControllers) {
        if ([backController isKindOfClass:[toController class]]) {
            [self.navigationController popToViewController:toController animated:YES];
        }
    }
}



-(void)setCustomBackNavigation{
    [self setCustomBackNavigation:[UIImage imageNamed:@"back_icon"]];
}


-(void)setCustomBackNavigation:(UIImage *)image{

    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(16, (44 - 17.5 ) / 2, 26, 17.5)];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateHighlighted];
    [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [button addTarget:self action:@selector(backNavi) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
}

-(void)hiddleBackNavigation{
    self.navigationItem.leftBarButtonItem = nil;
}

-(void)backNavi{
    [self.navigationController popViewControllerAnimated:YES];
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
