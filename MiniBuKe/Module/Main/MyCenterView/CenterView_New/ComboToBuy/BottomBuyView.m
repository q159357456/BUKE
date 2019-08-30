//
//  BottomBuyView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/29.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BottomBuyView.h"

@implementation BottomBuyView

-(instancetype)init
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60);
        self.backgroundColor = COLOR_STRING(@"#F7F9FB");
        self.label1 = [[UILabel alloc]initWithFrame:CGRectMake(15,16,SCALE(160)-15-5,16)];
        self.label2 = [[UILabel alloc]initWithFrame:CGRectMake(15,35,SCALE(160)-15-5,11)];
        self.label1.textColor = COLOR_STRING(@"#2F2F2F");
        self.label1.font = [UIFont boldSystemFontOfSize:16];
        self.label2.textColor = COLOR_STRING(@"#999999");
        self.label2.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.label1];
        [self addSubview:self.label2];
        CGSize size = [self.label2 sizeThatFits:CGSizeZero];
        UIView *linview = [[UIView alloc]initWithFrame:CGRectMake(16, 40, size.width, 1)];
        linview.backgroundColor = COLOR_STRING(@"#F04348");
        [self addSubview:linview];
        self.lineView = linview;
       
        self.btn = [[UIButton alloc]initWithFrame:CGRectMake(SCALE(160), 9, SCALE(200), 44)];
        self.btn.layer.cornerRadius = 22;
        self.btn.layer.masksToBounds = YES;
        [self.btn setTitle:@"立即购买" forState:UIControlStateNormal];
        self.btn.backgroundColor= COLOR_STRING(@"#F6922D");
        [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];;
        [self addSubview:self.btn];
    
    }
    return self;
}
-(void)reSizeLineWith
{
    CGSize size = [self.label2 sizeThatFits:CGSizeZero];
    self.lineView.frame = CGRectMake(self.lineView.frame.origin.x, self.lineView.frame.origin.y, size.width, self.lineView.frame.size.height);
}
@end
