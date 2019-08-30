//
//  BookReportController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/27.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BookReportController.h"
#import "MyCenterCenterView.h"
#import "MyCenterView.h"
@interface BookReportController ()
@property (nonatomic,strong) MyCenterCenterView *mMyCenterCenterView;
@property(nonatomic,strong) UIScrollView *myScrollView;
@property(nonatomic,strong)MyCenterView *mycenterView;
@end

@implementation BookReportController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleLabel.text = @"阅读报告";
    self.mycenterView = [[MyCenterView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.topView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.topView.frame))];
    [self.view addSubview:self.mycenterView];

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
