//
//  UserRegisterAgreementView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/5/18.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "UserRegisterAgreementView.h"
#import "XBKWebViewController.h"
#import "RequestApiHeader.h"

@implementation UserRegisterAgreementView

+(instancetype)xibView {
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"UserRegisterAgreementView" owner:nil options:nil] lastObject];
    return view;
}
//http://www.xiaobuke.com/agreement.html
-(IBAction) onClick:(id)sender
{
    NSLog(@"==> UserRegisterAgreementView <==");
    XBKWebViewController *mXBKWebViewController = [[XBKWebViewController alloc] init: USER_REGISTER_AGREEMENT_URL];
    [APP_DELEGATE.navigationController pushViewController:mXBKWebViewController animated:YES];
}

@end
