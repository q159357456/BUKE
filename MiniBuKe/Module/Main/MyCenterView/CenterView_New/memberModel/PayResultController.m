//
//  PayResultController.m
//  MiniBuKe
//
//  Created by chenheng on 2019/7/15.
//  Copyright © 2019 深圳偶家科技有限公司. All rights reserved.
//

#import "PayResultController.h"
#import "WeChatManager.h"
#import "CommonUsePackaging.h"
@interface PayResultController ()

@end

@implementation PayResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    //#FF55BA79
    self.titleLabel.text = @"支付";
    UIImageView * imageView = [[UIImageView alloc]init];
    UILabel * label1 = [[UILabel alloc]init];
    UILabel * label2 = [[UILabel alloc]init];
    [self.view addSubview:imageView];
    [self.view addSubview:label1];
    [self.view addSubview:label2];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(SCALE(195));
        make.size.mas_equalTo(CGSizeMake(SCALE(110), SCALE(103)));
    }];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(imageView.mas_bottom).offset(SCALE(30));
        make.size.mas_equalTo(CGSizeMake(SCALE(180), SCALE(20)));
    }];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.mas_equalTo(self.view);
         make.top.mas_equalTo(label1.mas_bottom).offset(SCALE(19));
         make.size.mas_equalTo(CGSizeMake(SCALE(180), SCALE(20)));
        
    }];
    label1.textAlignment = NSTextAlignmentCenter;
    label2.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont boldSystemFontOfSize:SCALE(20)];
    label2.font = [UIFont systemFontOfSize:SCALE(16) weight:UIFontWeightMedium];
    label2.textColor = COLOR_STRING(@"#999999");
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(label1.mas_bottom).offset(SCALE(90));
        make.size.mas_equalTo(CGSizeMake(SCALE(200), SCALE(44)));
    }];
    btn.layer.borderColor = [COLOR_STRING(@"#55BA79") CGColor];
    btn.layer.borderWidth = 1;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = SCALE(22);
    [btn setTitleColor:COLOR_STRING(@"#55BA79") forState:UIControlStateNormal];
    if (self.isSuccess) {
        imageView.image = [UIImage imageNamed:@"pay_yes_icon"];
        label1.text = @"支付成功";
        label2.text = self.SuccessTxt;
        label1.textColor = COLOR_STRING(@"#55BA79");
        [btn setTitle:@"完成" forState:UIControlStateNormal];
    }else
    {
        imageView.image = [UIImage imageNamed:@"pay_no_icon"];
        label1.text = @"支付失败";
        label2.text = @"请重新支付";
        [btn setTitle:@"重新支付" forState:UIControlStateNormal];
    }
    
    [btn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
   
    
    
    // Do any additional setup after loading the view.
}
-(void)btnEvent:(UIButton*)btn{
    if (self.isSuccess) {
        [self backButtonClick];
    }else
    {
        if (![WXApi isWXAppInstalled]) {
            [CommonUsePackaging showSystemHint:@"您还没有安装微信!"];
            return;
        }
        if (![WeChatManager sharedManager].unfinishedResult || ![WeChatManager sharedManager].unfinishedResult.length) {
            
            return;
        }
        NSString * orderType ;
        if ([WeChatManager sharedManager].payContent == Pay_Member) {
            orderType = @"4";
        }else if ([WeChatManager sharedManager].payContent == Pay_Course)
        {
            orderType = @"3";
        }
        NSDictionary * dic = @{@"activityId":@"",@"goodsId":[WeChatManager sharedManager].unfinishedResult,@"openid":@"",@"orderType":orderType,@"payType":@"2",@"userDisId":@""};
        [MBProgressHUD showMessage:@"请等待" toView:self.view];
        [XBKNetWorkManager wxOrderWithDic:dic Finish:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            if (!error) {
                NSLog(@"responseObj==>%@",responseObj);
                [WeChatManager weiXinPayWithDic:(NSDictionary*)responseObj];
                [MBProgressHUD hideHUDForView:self.view];
            }
        }];
    }
}
-(void)backButtonClick
{
    [APP_DELEGATE.navigationController popToRootViewControllerAnimated:YES];
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
