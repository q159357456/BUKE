//
//  TimeStyleChooseView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/10/19.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "TimeStyleChooseView.h"
#import "English_Header.h"
@interface TimeStyleChooseView()
@property(nonatomic,strong)UIView  *linview;
@property(nonatomic,assign)NSInteger selectIndex;
@end
@implementation TimeStyleChooseView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor redColor];
        self.backgroundColor = COLOR_STRING(@"#F0F3F7");
         [self inintSubViews];
    }
    return self;
}
-(void)inintSubViews{
    NSArray *titles = @[@"日",@"周",@"月",@"总"];
    CGFloat with = SCALE(20);
    CGFloat height = 30;
    CGFloat colum = (self.frame.size.width - with*titles.count)/(titles.count+1);
    for (NSInteger i = 0; i<titles.count; i++) {
        
        CGFloat x = colum + (colum+with)*i;
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(x,self.frame.size.height -37, with, height)];
        lable.font = [UIFont systemFontOfSize:14];
        lable.text = titles[i];
        lable.textColor = [UIColor blackColor];
        lable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lable];
        
//        linview.layer.cornerRadius =1.5;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickLable:)];
        lable.userInteractionEnabled = YES;
        [lable addGestureRecognizer:tap];
        lable.tag = 100 +i;
        
        if (i == 0) {

            self.linview = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height -4, with, 3)];
            self.linview.layer.cornerRadius = 1.5;
            self.linview.backgroundColor = COLOR_STRING(@"#58DB67");
            [self addSubview:self.linview];
            [self clickLable:tap];
        }
    }
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1, SCREEN_WIDTH, 1)];
    bottomView.backgroundColor = COLOR_STRING(@"#EAEAEA");
    [self addSubview:bottomView];
  
   
}

-(void)clickLable:(UITapGestureRecognizer*)tap{

    if (tap.view.tag == self.selectIndex)
    {
        return;
    }else
    {

        UILabel *lable = (UILabel*)tap.view;
        
        CGFloat w = SCALE(20);
        CGFloat c = (self.frame.size.width - w*4)/5;
        lable.textColor = COLOR_STRING(@"#58DB67");
        [UIView animateWithDuration:0.4 animations:^{
            self.linview.frame = CGRectMake(c + (c + w)*(lable.tag - 100), self.linview.frame.origin.y, w, 2);
            
        }];
        if (self.selectIndex) {
            UILabel *old =(UILabel*) [self viewWithTag:self.selectIndex];
            old.textColor = [UIColor blackColor];
            
        }
     
        self.selectIndex = tap.view.tag;
        
        [self eventName:TimeStyleChooseView_Event Params:[NSNumber numberWithInteger:self.selectIndex - 100]];
        
    }

}

- (void)rese
{
    CGFloat w = SCALE(20);
    CGFloat c = (self.frame.size.width - w*4)/5;
    UILabel *lable = (UILabel*)[self viewWithTag:100];
    lable.textColor = COLOR_STRING(@"#58DB67");
    [UIView animateWithDuration:0.4 animations:^{
        self.linview.frame = CGRectMake(c + (c + w)*(lable.tag - 100), self.linview.frame.origin.y, w, 2);
        
    }];
    if (self.selectIndex) {
        UILabel *old =(UILabel*) [self viewWithTag:self.selectIndex];
        old.textColor = [UIColor blackColor];
        
    }
    
    self.selectIndex = lable.tag;
    
}

-(void)moveTo:(NSInteger)index
{
    CGFloat w = SCALE(20);
    CGFloat c = (self.frame.size.width - w*4)/5;
    UILabel *lable = (UILabel*)[self viewWithTag:100+index];
    lable.textColor = COLOR_STRING(@"#58DB67");
    [UIView animateWithDuration:0.4 animations:^{
        self.linview.frame = CGRectMake(c + (c + w)*index, self.linview.frame.origin.y, w, 2);
        
    }];
    if (self.selectIndex) {
        UILabel *old =(UILabel*) [self viewWithTag:self.selectIndex];
        old.textColor = [UIColor blackColor];
        
    }
    
    self.selectIndex = lable.tag;
}
@end
