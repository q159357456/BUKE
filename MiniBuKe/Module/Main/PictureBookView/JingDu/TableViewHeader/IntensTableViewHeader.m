//
//  IntensTableViewHeader.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/2.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "IntensTableViewHeader.h"
#import "English_Header.h"
@interface IntensTableViewHeader()
{
    NSInteger slectIndex;
    BOOL isfirst;
}
@property(nonatomic,strong)UIView *linview;
@end
@implementation IntensTableViewHeader

-(instancetype)initWithFrame:(CGRect)frame Intensive:(Intensive_Style)intensive
{
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor greenColor];
        self.intensive_Style = intensive;
       
    }
    return self;
}

-(void)initSubview{
    
    if (!isfirst) {
        if (self.intensive_Style == Intensive_Mode)
        {
            UIButton *btn1 =[[UIButton alloc]initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH/2, IntensTableViewHeader_Height -5)];
            UIButton *btn2 =[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 1, SCREEN_WIDTH/2, IntensTableViewHeader_Height-5)];
            UIView *linview =[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4 - 15, IntensTableViewHeader_Height-4,30, 3)];
            linview.layer.cornerRadius =1.5;
            linview.backgroundColor = COLOR_STRING(@"#54BB51");
            UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(0, IntensTableViewHeader_Height - 1, SCREEN_WIDTH, 1)];
            UIView *top = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
            top.backgroundColor = [UIColor whiteColor];
            bottom.backgroundColor = [UIColor groupTableViewBackgroundColor];
            
            
            [self addSubview:btn1];
            [self addSubview:btn2];
            [self addSubview:linview];
            [self addSubview:bottom];
            [self addSubview:top];
            
            [btn1 setTitle:@"专家导读" forState:UIControlStateNormal];
            [btn2 setTitle:@"介绍" forState:UIControlStateNormal];
            [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn1.titleLabel.font = [UIFont systemFontOfSize:SCALE(18) weight:UIFontWeightRegular];
            btn2.titleLabel.font = [UIFont systemFontOfSize:SCALE(18) weight:UIFontWeightRegular];
            [btn1 addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
            [btn2 addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
            btn1.tag =1;
            btn2.tag =2;
            self.linview = linview;
            slectIndex =1;
            btn1.selected = YES;//        [self change:btn1];
            
        }else
        {
            UIButton *button = [[UIButton alloc]initWithFrame:self.bounds];
            [self addSubview:button];
            [button setTitle:@"介绍" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(comme) forControlEvents:UIControlEventTouchUpInside];
        }
        isfirst = YES;
    }
}

-(void)comme{
    
    
    
}
-(void)change:(UIButton*)btn{
    
    if (btn.selected) {
        
        return;
    }
    
    btn.selected = YES;
    if (slectIndex) {
        UIButton *butt = [self viewWithTag:slectIndex];
        butt.selected = NO;
        
    }
    [UIView animateWithDuration:0.4 animations:^{
        if (btn.tag == 2) {
            
            self.linview.transform = CGAffineTransformMakeTranslation(SCREEN_WIDTH/2, 0);
            
        }else
        {

            self.linview.transform = CGAffineTransformIdentity;
        }
        
    }];
    slectIndex = btn.tag;
    
    [self eventName:IntensTableViewHeader_Event Params:[NSNumber numberWithInteger:btn.tag -1]];
    
    
    
    
    
}

-(void)layoutSubviews
{
     [self initSubview];
}
-(void)animationTo:(NSInteger)index{
//    NSLog(@"index=====>%ld",index);
    UIButton *butt = [self viewWithTag:slectIndex];
    butt.selected = NO;
    UIButton *butt_s = [self viewWithTag:index+1];
    butt_s.selected = YES;
    [UIView animateWithDuration:0.4 animations:^{
        if (index == 1) {
            self.linview.transform = CGAffineTransformMakeTranslation(SCREEN_WIDTH/2, 0);
        }else
        {
            self.linview.transform = CGAffineTransformIdentity;
        }
        
    }];
    slectIndex =index+1;
    
}

@end
