//
//  PayModeView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/29.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "PayModeView.h"

@implementation PayModeView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_STRING(@"#F9F4EF");
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 30)];
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake( SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 30)];
        label1.text = @"第一步：确认宝宝信息";
        label2.text = @"第二步：支付购买";
        label1.font = [UIFont systemFontOfSize:13];
        label2.font = [UIFont systemFontOfSize:13];
        label1.textColor =COLOR_STRING(@"#999999");
        label2.textColor =COLOR_STRING(@"#999999");
        label1.textAlignment = NSTextAlignmentCenter;
        label2.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label1];
        [self addSubview:label2];
        self.fistStepLabel = label1;
        self.secondStepLabel = label2;
        
    }
    return self;
}

@end
