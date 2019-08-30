//
//  OJBillViewController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/12/5.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "OJBillViewController.h"

@interface OJBillViewController ()

@end

@implementation OJBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)backButtonClick
{
    if ([self.webview canGoBack]) {
        [self.webview goBack];
    }else
    {
         [self.navigationController popToRootViewControllerAnimated:YES];
    }
   
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
