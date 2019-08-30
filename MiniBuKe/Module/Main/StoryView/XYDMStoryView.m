//
//  XYDMStoryView.m
//  MiniBuKe
//
//  Created by chenheng on 2019/3/15.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "XYDMStoryView.h"
#import <XYDMFramework/XYDMSDK.h>
#import "CommonUsePackaging.h"
@implementation XYDMStoryView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}
-(void)addXMLY
{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    activityIndicator.frame = CGRectMake(0, 0, 50, 50);
    activityIndicator.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addSubview:activityIndicator];
     [activityIndicator startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIViewController *controller = [XYDMSDK obtainXYDMSDKRootNavigationRootViewController];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:controller];
        UIViewController *parentController = [[CommonUsePackaging shareInstance] getCurrentVC];
        [parentController addChildViewController:nav];
        nav.view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, self.bounds.size.height-kStatusBarH);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addSubview:nav.view];
            [activityIndicator stopAnimating];
        });
    });
    
    
}
@end
