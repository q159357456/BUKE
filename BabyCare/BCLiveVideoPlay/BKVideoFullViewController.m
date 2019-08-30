//
//  BKVideoFullViewController.m
//  babycaretest
//
//  Created by Don on 2019/4/24.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKVideoFullViewController.h"

@interface BKVideoFullViewController ()

@end

@implementation BKVideoFullViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //屏幕常量
    [UIApplication sharedApplication].idleTimerDisabled =YES;
    [UIApplication sharedApplication].statusBarHidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [UIApplication sharedApplication].statusBarHidden = NO;
    //取消屏幕常量
    [UIApplication sharedApplication].idleTimerDisabled =NO;
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 监听设备旋转方向

- (void)listeningRotating{
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    
}

//设备方向改变
- (void)onDeviceOrientationChange{
    
    UIDeviceOrientation orientation             = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    
    [self transformScreenDirection:interfaceOrientation];
}


-(void)transformScreenDirection:(UIInterfaceOrientation)direction
{
    
    if (direction == UIInterfaceOrientationPortrait ) {
        //        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
        
    }else if(direction == UIInterfaceOrientationLandscapeRight)
    {
        [UIView animateWithDuration:0.5 animations:^{
            
            self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
        }];
        
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    }else if(direction == UIInterfaceOrientationLandscapeLeft)
    {
        [UIView animateWithDuration:0.5 animations:^{
            
            self.view.transform = CGAffineTransformMakeRotation(-M_PI_2);
        }];
        
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    }
    
}

- (void)releaseNotific{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)addNotific{
    [self listeningRotating];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

- (BOOL)shouldAutorotate{
    return NO;
}


@end
