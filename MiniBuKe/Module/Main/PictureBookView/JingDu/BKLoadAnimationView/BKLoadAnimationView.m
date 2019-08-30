//
//  BKLoadAnimationView.m
//  MiniBuKe
//
//  Created by chenheng on 2019/2/18.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKLoadAnimationView.h"

@implementation BKLoadAnimationView
+(instancetype)singleton{
    
    static BKLoadAnimationView *loadView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loadView = [[BKLoadAnimationView alloc]init];
    });
    return loadView;
}
-(instancetype)init
{
    if (self=[super init]) {
        self.frame = APP_DELEGATE.window.bounds;
        self.backgroundColor = [UIColor clearColor];
        UIImageView *imageview =[[UIImageView alloc]init];
//        imageview.backgroundColor =[UIColor whiteColor];
        [self addSubview:imageview];
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        NSMutableArray *imageArray = [NSMutableArray array];
        for (NSInteger i=0; i<7; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loding_%ld",i]];
            [imageArray addObject:image];
        }
        imageview.animationImages = imageArray;
        imageview.animationDuration = 1;
        imageview.animationRepeatCount = 0;
    
        [imageview startAnimating];
    
        
    }
    return self;
}
+(void)ShowHit
{
    BKLoadAnimationView *loadView = [BKLoadAnimationView singleton];
    
    [APP_DELEGATE.window addSubview:loadView];
}
+(void)Hidden
{
     BKLoadAnimationView *loadView = [BKLoadAnimationView singleton];
     [loadView removeFromSuperview];
}
+(void)ShowHitOn:(UIView *)view
{
    BKLoadAnimationView *loadView = [[BKLoadAnimationView alloc]init];
    [view addSubview:loadView];
    [loadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0 ));
    }];
}
+(void)ShowHitOn:(UIView *)view Frame:(CGRect)rect
{
    BKLoadAnimationView *loadView = [[BKLoadAnimationView alloc]init];
    loadView.frame = rect;
    [view addSubview:loadView];
}
+(void)HiddenFrom:(UIView *)view
{
    for (UIView *obj in view.subviews) {
        
        if ([obj isKindOfClass:[BKLoadAnimationView class]]) {
            [obj removeFromSuperview];
            break;
        }
    }
}

@end
