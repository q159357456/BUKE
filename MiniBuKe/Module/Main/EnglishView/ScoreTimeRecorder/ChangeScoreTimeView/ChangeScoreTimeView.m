//
//  ChangeScoreTimeView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/10/25.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "ChangeScoreTimeView.h"
#import "English_Header.h"
@interface ChangeScoreTimeView()
@property(nonatomic,strong)UIButton *button1;
@property(nonatomic,strong)UIButton *button2;
@end
@implementation ChangeScoreTimeView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = self.backgroundColor = PXH_RGBA_COLOR(47/255.0, 47/255.0, 47/255.0, 0.7);
        UIView* changeModeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        changeModeView.backgroundColor = COLOR_STRING(@"#F0F3F7");
        UIButton *button1 =[[UIButton alloc]initWithFrame:CGRectMake(15, 10, SCALE(64), 30)];
        UIButton *button2 =[[UIButton alloc]initWithFrame:CGRectMake(15+SCALE(64)+15, 10, SCALE(64), 30)];
        [button1 setTitle:@"学习成绩" forState:UIControlStateNormal];
        button1.titleLabel.font =[UIFont systemFontOfSize:14];
        [button2 setTitle:@"学习时长" forState:UIControlStateNormal];
        button2.titleLabel.font =[UIFont systemFontOfSize:14];
        [button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [button2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        button1.selected = YES;
        [changeModeView addSubview:button1];
        [changeModeView addSubview:button2];
        [self addSubview:changeModeView];
        [button1 addTarget:self action:@selector(score:) forControlEvents:UIControlEventTouchUpInside];
        [button2 addTarget:self action:@selector(times:) forControlEvents:UIControlEventTouchUpInside];
        self.button1 = button1;
        self.button2 = button2;
    }
    return self;
}


-(void)score:(UIButton*)sender{
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    self.button2.selected = NO;
    [self eventName:ChangeScoreTimeView_Event Params:@0];
    [self removeFromSuperview];
}
-(void)times:(UIButton*)sender{
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    self.button1.selected = NO;
    [self eventName:ChangeScoreTimeView_Event Params:@1];
    [self removeFromSuperview];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self eventName:ChangeScoreTimeView_Event Params:@2];
    [self removeFromSuperview];
    
}
@end
