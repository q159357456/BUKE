//
//  SeriesChangeView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/9/19.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "SeriesChangeView.h"
#import "English_Header.h"
@interface SeriesChangeView()
{
    NSInteger slectIndex;
}

@property(nonatomic,strong)UIView *linview;

@end
@implementation SeriesChangeView

+(instancetype)sectionView
{
    SeriesChangeView *view = [[SeriesChangeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Section_Height)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor redColor];
        [self initSubview];
    }
    return self;
}

-(void)initSubview{
    
    
    UIButton *btn1 =[[UIButton alloc]initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH/2, Section_Height -5)];
    UIButton *btn2 =[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 1, SCREEN_WIDTH/2, Section_Height-5)];
    UIView *linview =[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4 - 15, Section_Height-4,30, 3)];
    linview.layer.cornerRadius =1.5;
    linview.backgroundColor = COLOR_STRING(@"#54BB51");
    UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(0, Section_Height - 1, SCREEN_WIDTH, 1)];
    UIView *top = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    top.backgroundColor = [UIColor whiteColor];
    bottom.backgroundColor = [UIColor groupTableViewBackgroundColor];

    
    [self addSubview:btn1];
    [self addSubview:btn2];
    [self addSubview:linview];
    [self addSubview:bottom];
    [self addSubview:top];
    
    [btn1 setTitle:@"介绍" forState:UIControlStateNormal];
    [btn2 setTitle:@"目录" forState:UIControlStateNormal];
//    [btn1 setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btn2 setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:SCALE(18) weight:UIFontWeightRegular];
    btn2.titleLabel.font = [UIFont systemFontOfSize:SCALE(18) weight:UIFontWeightRegular];
    [btn1 addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    btn1.tag =1;
    btn2.tag =2;
    self.linview = linview;
    if ([EnglishSettingManager shareInstance].AGE_TO_ALL) {
        
         [self change:btn2];
    }else
    {
        
        [self change:btn1];
        
    }
   


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
    
    [self eventName:SeriesChangeView_Event Params:[NSNumber numberWithInteger:btn.tag -1]];
    
    

    
    
}

@end
