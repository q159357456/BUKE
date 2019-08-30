//
//  GuidanceViewController.m
//  MiniBuKe
//
//  Created by chenheng on 2019/5/16.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "GuidanceViewController.h"

@interface GuidanceViewController ()

@end

@implementation GuidanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"使用说明";
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imagev = [[UIImageView alloc]initWithFrame:CGRectMake(SCALE(25), kNavbarH+26, SCALE(325), SCALE(522.6))];
    [self.view addSubview:imagev];
    imagev.image = [UIImage imageNamed:@"ar_instructions"];
    [self.view addSubview:imagev];
    // Do any additional setup after loading the view.
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
