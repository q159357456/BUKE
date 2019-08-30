//
//  BatteryView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/27.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BatteryView.h"

@implementation BatteryView



-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 10)];
        view.layer.borderWidth = 1;
        view.layer.borderColor = COLOR_STRING(@"#D7D7D7").CGColor;
        view.layer.cornerRadius = 2;
        view.layer.masksToBounds =YES;
        view.backgroundColor = [UIColor whiteColor];
        UIImageView *rightImagView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mycenter_bg"]];
        rightImagView.frame = CGRectMake(CGRectGetMaxX(view.frame)+1, 2, 3, 6);
        [self addSubview:view];
        [self addSubview:rightImagView];
        self.batteryView = [[UIView alloc]initWithFrame:CGRectMake(2, 1.5, self.electricQuantity*16/100, 7)];
        [view addSubview:self.batteryView];
    }
    return self;
}
-(void)setElectricQuantity:(CGFloat)electricQuantity
{
    _electricQuantity = electricQuantity;
    if (self.electricQuantity) {
        if (self.electricQuantity<=20)
        {
            
             self.batteryView.backgroundColor = [UIColor redColor];
        }else
        {
            
             self.batteryView.backgroundColor = [UIColor greenColor];
        }
        if (self.batteryView) {
            self.batteryView.frame =  CGRectMake(2, 1.5, self.electricQuantity*16/100, 7);
         
        }
     

    }
   
}
@end
