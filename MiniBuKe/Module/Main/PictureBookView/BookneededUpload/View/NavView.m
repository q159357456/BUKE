//
//  NavView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/14.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "NavView.h"

@interface NavView()
@property(nonatomic, strong) UIButton *rightItem;

@end

@implementation NavView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createNavViewTitle:WPhoto_Center_Text];
        
    }
    return self;
}
#pragma mark 创建nav
-(void)createNavViewTitle:(NSString *)title {
    UIView *nav = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SelfView_W, navView_H)];
    nav.backgroundColor = WPhoto_TopView_Color;
    nav.alpha = 0.97;
    [self addSubview:nav];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, kStatusBarH, 80, navView_H-kStatusBarH)];
    titleLab.text = title;
    titleLab.font = [UIFont systemFontOfSize:36/2];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = WPhoto_TopText_Color;
    [nav addSubview:titleLab];
    
    titleLab.center = CGPointMake(nav.center.x, (navView_H-kStatusBarH)/2+kStatusBarH);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame= CGRectMake(10, 0, 45, 25);
    [btn addTarget:self action:@selector(btnClickBack) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[WPhoto_Btn_Back imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [nav addSubview:btn];
    btn.center = CGPointMake(25, titleLab.center.y);
    
    self.rightItem = [[UIButton alloc]init];
    _rightItem.frame= CGRectMake(SelfView_W-65-15, 0, 65, 22);
    _rightItem.center = CGPointMake(SelfView_W-65*0.5-15, titleLab.center.y);
    [_rightItem addTarget:self action:@selector(quitChoose)forControlEvents:UIControlEventTouchUpInside];
    _rightItem.titleLabel.font = [UIFont systemFontOfSize:13];
    _rightItem.backgroundColor = COLOR_STRING(@"#d7d7d7");
    [_rightItem setTitle:WPhoto_Right_Text forState:UIControlStateNormal];
    [_rightItem setTitleColor:COLOR_STRING(@"#ffffff") forState:UIControlStateNormal];
    _rightItem.layer.cornerRadius = 11;
    [nav addSubview:_rightItem];
}

-(void)btnClickBack
{
    _navViewBack();
}

-(void)quitChoose
{
    if (![_rightItem.titleLabel.text isEqualToString:WPhoto_Right_Text]) {
        _quitDoneBack();
    }
}

-(void)changeBtnWithNumber:(NSInteger)number{
    if (number == 0) {
        _rightItem.backgroundColor = COLOR_STRING(@"#d7d7d7");
        [_rightItem setTitle:WPhoto_Right_Text forState:UIControlStateNormal];
        [_rightItem setTitleColor:COLOR_STRING(@"#ffffff") forState:UIControlStateNormal];
    }else{
        [_rightItem setTitle:[NSString stringWithFormat:@"%@(%ld)",WPhoto_Right_Text,(long)number] forState:UIControlStateNormal];
        _rightItem.backgroundColor = COLOR_STRING(@"#FA9A3A");
        [_rightItem setTitleColor:COLOR_STRING(@"#ffffff") forState:UIControlStateNormal];
    }
}


@end
