//
//  MBProgressHUD+XBK.h
//  MiniBuKe
//
//  Created by chenheng on 2018/5/4.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (XBK)

+ (void)showSuccess:(NSString *)success;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (MBProgressHUD *)showText:(NSString *)text;
+ (MBProgressHUD *)showText:(NSString *)text toView:(UIView *)view;

+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;

@end
