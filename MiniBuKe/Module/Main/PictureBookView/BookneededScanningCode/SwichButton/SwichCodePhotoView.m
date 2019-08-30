//
//  SwichCodePhotoView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/13.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "SwichCodePhotoView.h"
#import "UIResponder+Event.h"
@implementation SwichCodePhotoView
{
    NSInteger selectIndex;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = A_COLOR_STRING(0x000000, 0.7);
    }
    return self;
}
-(void)layoutSubviews
{
    [self initSubViews];
}
-(void)initSubViews{
    
    UIButton *button1= [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setImage:[UIImage imageNamed:@"scan_icon"] forState:UIControlStateNormal];
    [button1 setImage:[UIImage imageNamed:@"scan_pressed"] forState:UIControlStateSelected];
    //camera_pressed
    [button1 addTarget:self action:@selector(swichmode:) forControlEvents:UIControlEventTouchUpInside];
    button1.tag = 1;
  
    UIButton *button2= [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setImage:[UIImage imageNamed:@"camera_icon"] forState:UIControlStateNormal];
    [button2 setImage:[UIImage imageNamed:@"camera_pressed"] forState:UIControlStateSelected];
    //scan_pressed
    [button2 addTarget:self action:@selector(swichmode:) forControlEvents:UIControlEventTouchUpInside];
    button2.tag = 2;
    UILabel *lable1 = [[UILabel alloc]init];
    lable1.font = [UIFont systemFontOfSize:14];
    UILabel *lable2 = [[UILabel alloc]init];
    lable2.font = [UIFont systemFontOfSize:14];
    lable1.textAlignment = NSTextAlignmentCenter;
    lable1.tag = button1.tag + 10;
    lable1.text = @"扫一扫";
    lable2.text = @"拍照";
    lable1.textColor = [UIColor whiteColor];
    lable2.textAlignment = NSTextAlignmentCenter;
    lable2.textColor = [UIColor whiteColor];
    lable2.tag = button2.tag + 10;
    
    [self addSubview:lable1];
    [self addSubview:lable2];
    [self addSubview:button1];
    [self addSubview:button2];
    [self swichmode:button1];
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.mas_left).offset(74);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.centerY.mas_equalTo(self.mas_centerY).offset(-10);
        
    }];
    
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(self.mas_right).offset(-74);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.centerY.mas_equalTo(self.mas_centerY).offset(-10);
    }];
    
    [lable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.mas_left).offset(74);
        make.size.mas_equalTo(CGSizeMake(50, 18));
        make.top.mas_equalTo(button1.mas_bottom);
    }];
    
    [lable2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(self.mas_right).offset(-74);
        make.size.mas_equalTo(CGSizeMake(50, 18));
        make.top.mas_equalTo(button2.mas_bottom);
    }];
    
    
}


#pragma mark - action
-(void)swichmode:(UIButton*)btn{
    
    if (btn.selected) {
        return ;
    }
    
    btn.selected = YES;
    UILabel *lable = (UILabel*)[self viewWithTag:btn.tag+10];
    lable.textColor = COLOR_STRING(@"#66C85E");
    if (selectIndex) {
        UIButton *oldbtn = (UIButton*)[self viewWithTag:selectIndex];
        oldbtn.selected = NO;
        UILabel *lable = (UILabel*)[self viewWithTag:selectIndex+10];
        lable.textColor = [UIColor whiteColor];
    }
    selectIndex = btn.tag;
    
    [self eventName:SwichCodePhotoView_Event Params:[NSNumber numberWithInteger:btn.tag]];
    
}
@end
