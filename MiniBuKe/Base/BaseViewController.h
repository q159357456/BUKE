//
//  BaseViewController.h
//  MiniBuKe
//
//  Created by zhangchunzhe on 2017/12/26.
//  Copyright © 2017年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileImportHeader.pch"


@interface BaseViewController : UIViewController

////设置导航栏的颜色
//-(void)controlNavigationBackgroud:(UIColor*)color;

-(void)registerHiddenNavigation:(UIViewController*)controller;

-(void)unregisterHiddenNavigation:(UIViewController*)controller;

//
-(void)showHUDLoadProgress:(UIView*)attachView doSomething:(void (^)(void))doInBackgroud;
// 
-(void)showHUDToast:(UIView*)attachView text:(NSString*)tips;

-(void)showError;

-(void)showError:(NSString*)errorString;

-(void)goTo:(UIViewController*)toController;

-(void)backTo:(UIViewController *)toController;

-(void)backNavi;

-(void)setCustomBackNavigation;

-(void)setCustomBackNavigation:(UIImage *)image;

-(void)hiddleBackNavigation;
@end
