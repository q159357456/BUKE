//
//  MBProgressHUD+XBK.m
//  MiniBuKe
//
//  Created by chenheng on 2018/5/4.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "MBProgressHUD+XBK.h"

@implementation MBProgressHUD (XBK)

/**
 *  显示信息
 *
 *  @param text 信息内容
 *  @param icon 图标
 *  @param view 显示的视图
 */
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
//    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
//    if ([[[UIDevice currentDevice] systemVersion] integerValue] > 10) {
//        if (view == nil) view = [UIApplication sharedApplication].keyWindow;
//    }else{
//        if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
//    }
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    //修改样式，否则等待框背景色将为半透明
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor clearColor];
    
    //设置等待框背景色
    hud.bezelView.backgroundColor = COLOR_STRING(@"#262626");
    
    //设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    hud.label.text = text;
    //修改字体颜色
    hud.contentColor = [UIColor whiteColor];
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 2秒之后再消失
    [hud hideAnimated:YES afterDelay:2.0];
}

/**
 *  显示成功信息
 *
 *  @param success 信息内容
 */
+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

/**
 *  显示成功信息
 *
 *  @param success 信息内容
 *  @param view    显示信息的视图
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success" view:view];
}

/**
 *  显示错误信息
 *
 */
+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

/**
 *  显示错误信息
 *
 *  @param error 错误信息内容
 *  @param view  需要显示信息的视图
 */
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error" view:view];
}

/**
 *  显示一些信息
 *
 *  @param message 信息内容
 *
 *  @return 直接返回一个MBProgressHUD，需要手动关闭
 */
+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

/**
 *  显示一些信息
 *
 *  @param message 信息内容
 *  @param view    需要显示信息的视图
 *
 *  @return 直接返回一个MBProgressHUD，需要手动关闭
 */
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
//    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
//    if ([[[UIDevice currentDevice] systemVersion] integerValue] > 10) {
//        if (view == nil) view = [UIApplication sharedApplication].keyWindow;
//    }else{
//        if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
//    }
    
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    //修改样式，否则等待框背景色将为半透明
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    //设置等待框背景色
    hud.bezelView.backgroundColor = COLOR_STRING(@"#262626");

    hud.contentColor = [UIColor whiteColor];
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = YES;
    
    //设置菊花框为白色
    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:[NSArray arrayWithObjects:[MBProgressHUD class], nil]].color = [UIColor whiteColor];
    
    return hud;
}

/**
 *  快速显示一些信息
 *
 *  @param text 信息内容
 *
 *  @return 直接返回一个MBProgressHUD，自动关闭
 */
+(MBProgressHUD *)showText:(NSString *)text
{
    return [self showText:text toView:nil];
}

/**
 *  快速显示一些信息
 *
 *  @param text 信息内容
 *  @param view    需要显示信息的视图
 *
 *  @return 直接返回一个MBProgressHUD，自动关闭
 */
+(MBProgressHUD *)showText:(NSString *)text toView:(UIView *)view
{
//    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    
//    if ([[[UIDevice currentDevice] systemVersion] integerValue] > 10) {
//        if (view == nil) view = [UIApplication sharedApplication].keyWindow;
//    }else{
//        if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
//    }
    
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    
    //修改样式，否则等待框背景色将为半透明
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    //设置等待框背景色
    hud.bezelView.backgroundColor = COLOR_STRING(@"#262626");
    
    hud.label.text = text;
    hud.contentColor = [UIColor whiteColor];
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    [hud hideAnimated:YES afterDelay:2.5];
    
    return hud;
}

/**
 *  手动关闭MBProgressHUD
 */
+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

/**
 *  手动关闭MBProgressHUD
 *
 *  @param view    显示MBProgressHUD的视图
 */
+ (void)hideHUDForView:(UIView *)view
{
//    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
//    if ([[[UIDevice currentDevice] systemVersion] integerValue] > 10) {
//        if (view == nil) view = [UIApplication sharedApplication].keyWindow;
//    }else{
//        if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
//    }
    
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    
    [self hideHUDForView:view animated:YES];
}


@end
