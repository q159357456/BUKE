//
//  BuyToKnowViewController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/12/6.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BuyToKnowViewController.h"
#import "ToPayViewController.h"
#import "PayModeView.h"
@interface BuyToKnowViewController ()
@property(nonatomic,strong)PayModeView *payModeView;
@end

@implementation BuyToKnowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rightBtn.hidden =YES;
    [self.view addSubview:self.payModeView];
    self.webview.frame = CGRectMake(0, CGRectGetMaxY(self.payModeView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-kNavbarH - 60 - self.payModeView.frame.size.height);
//      NSLog(@"self.url===>%@",self.url);
    // Do any additional setup after loading the view.
}
-(UIView *)payModeView
{
    if (!_payModeView) {
        _payModeView = [[PayModeView alloc]initWithFrame:CGRectMake(0, kNavbarH, SCREEN_WIDTH, 30)];
        _payModeView.secondStepLabel.textColor = COLOR_STRING(@"#2F2F2F");
        
    }
    return _payModeView;
}
-(void)topay:(UIButton *)btn
{
//    [MobClick event:EVENT_Custom_105];
    ToPayViewController *vc = [[ToPayViewController alloc]init];
    vc.goodsModel = self.goodsModel;
    [self.navigationController pushViewController:vc animated:YES];
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
