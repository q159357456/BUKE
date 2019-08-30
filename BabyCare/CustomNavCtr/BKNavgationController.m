//
//  BKNavgationController.m
//  babycaretest
//
//  Created by Don on 2019/4/24.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKNavgationController.h"

@interface BKNavgationController ()

@end

@implementation BKNavgationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)shouldAutorotate
{
    return [[self.viewControllers lastObject] shouldAutorotate];
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
