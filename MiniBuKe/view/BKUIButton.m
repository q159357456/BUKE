//
//  BKUIButton.m
//  MiniBuKe
//
//  Created by zhangchunzhe on 2018/3/25.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKUIButton.h"

@implementation BKUIButton


-(instancetype)init{
    self  = [super init];
    if(self){
        [self initView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self  = [super initWithFrame:frame];
    if(self){
        [self initView];
    }
    return self;
}

-(void)initView{
   
    [self setBackgroundImage:[BKUtils createImageWithColor:COLOR_STRING(@"#FF8C30")] forState:UIControlStateNormal];
    [self setBackgroundImage:[BKUtils createImageWithColor:COLOR_STRING(@"#EBEBEB")] forState:UIControlStateDisabled];
}

-(void)setTitle:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];

}

-(void)setColors:(UIColor *)colors{
    [self setTitleColor:colors forState:UIControlStateNormal];
}

-(void)setTextColors:(UIColor *)colors{
    [self.titleLabel setTextColor:colors];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
