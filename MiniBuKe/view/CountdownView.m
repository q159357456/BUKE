//
//  CountdownView.m
//  MiniBuKe
//
//  Created by zhangchunzhe on 2018/3/29.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "CountdownView.h"

@implementation CountdownView{
    
    NSTimer *timer;
}

-(instancetype)init{
    self  = [super init];
    if(self){
       
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self  = [super initWithFrame:frame];
    if(self){
       
    }
    return self;
}

-(void)setTime:(NSInteger)time{
    _time = time;

    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(update:) userInfo:nil repeats:YES];
}

-(void)update:(id)sender{
    _time--;
    //[self setEnabled:NO];
    
    [self setTitle:[NSString stringWithFormat:@"%lds",(long)_time] forState:UIControlStateNormal];
   
    if( _time <= 0){
        [timer invalidate];
        timer = nil;
        self.userInteractionEnabled = YES;
        //[self setEnabled:YES];
        [self setTitle:@"重发验证码" forState:UIControlStateNormal];
        [self setBackgroundImage:[BKUtils createImageWithColor:COLOR_STRING(@"#9B9B9B")] forState:UIControlStateNormal];
        [self.layer setBorderColor:COLOR_STRING(@"#9B9B9B").CGColor];
        [self.layer setBorderWidth:1.0f];
        [self.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
        //边框宽度
        [self.layer setBorderWidth:1.0];
        [self.layer setMasksToBounds:YES];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
