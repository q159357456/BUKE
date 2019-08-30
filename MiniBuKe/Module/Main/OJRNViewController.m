//
//  OJRNViewController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/10/8.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "OJRNViewController.h"
//#import <React/RCTBundleURLProvider.h>
//#import <React/RCTRootView.h>
//#import "CodePush.h"

@interface OJRNViewController ()

@end

@implementation OJRNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSURL *jsCodeLocation;
//#ifdef DEBUG
//    jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"react-native-src/index.ios" fallbackResource:nil];
//#else
////    jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"index.ios"withExtension:@"jsbundle"];
////    jsCodeLocation = [CodePush bundleURL];
//#endif
//    RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
//                                                        moduleName:@"MiniBuKe"
//                                                 initialProperties:nil
//                                                     launchOptions:nil];
//    self.view = rootView;
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
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)hideBarStyle {
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.hidden = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
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
