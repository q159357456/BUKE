//
//  BKBabyCareMenuPopView.m
//  MiniBuKe
//
//  Created by chenheng on 2019/4/29.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKBabyCareMenuPopView.h"

@interface BKBabyCareMenuPopView()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, assign) CGPoint point;

@end

@implementation BKBabyCareMenuPopView
- (instancetype)initWithPopLocation:(CGPoint)point{
    if (self = [super init]) {
        self.point = point;
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithRed:47/255.0 green:47/255.0 blue:47/255.0 alpha:0];
    self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 12, 6)];
    self.icon.center = _point;
    self.icon.image = [UIImage imageNamed:@"bc_menu_bottom"];
    [self addSubview:self.icon];
    
    self.menuView = [[UIView alloc]init];
    self.menuView.backgroundColor = [UIColor whiteColor];
    self.menuView.frame = CGRectMake(_point.x +12+5,CGRectGetMaxY(self.icon.frame), 0, 0);
    self.menuView.layer.cornerRadius = 6.f;
    self.menuView.clipsToBounds = YES;
    
    UIButton *btn0 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 140, 50)];
    btn0.tag = 0;
    [btn0 setImage:[UIImage imageNamed:@"bc_menu_item0"] forState:UIControlStateNormal];
    [btn0 setTitle:@"家庭成员" forState:UIControlStateNormal];
    [btn0 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn0.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.menuView addSubview:btn0];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 50, 140, 50)];
    btn1.tag = 1;
    [btn1 setImage:[UIImage imageNamed:@"bc_menu_item1"] forState:UIControlStateNormal];
    [btn1 setTitle:@"通话记录" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.menuView addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 100, 140, 50)];
    btn2.tag = 2;
    [btn2 setImage:[UIImage imageNamed:@"bc_menu_item2"] forState:UIControlStateNormal];
    [btn2 setTitle:@"设备管理" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.menuView addSubview:btn2];
    
    [btn0 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn0.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    btn1.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    btn2.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);

    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
    self.icon.hidden = YES;

    [self addSubview:self.menuView];
}

- (void)tapAction:(UITapGestureRecognizer*)tap{
    [self stopAnimation];
}

- (void)startAnimation{
    [UIView animateWithDuration:0.25 animations:^{
        self.menuView.frame =CGRectMake(_point.x - 140 +12+5,CGRectGetMaxY(self.icon.frame), 140, 150);
        self.backgroundColor = [UIColor colorWithRed:47/255.0 green:47/255.0 blue:47/255.0 alpha:0.5];

    }completion:^(BOOL finished) {
        self.icon.hidden = NO;
        
    }];
}

- (void)stopAnimation{
    [UIView animateWithDuration:0.25 animations:^{
        self.menuView.frame = CGRectMake(_point.x,CGRectGetMaxY(self.icon.frame), 0, 0);
        self.backgroundColor = [UIColor colorWithRed:47/255.0 green:47/255.0 blue:47/255.0 alpha:0];
        self.icon.hidden = YES;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)btnClick:(UIButton*)btn{
    [self stopAnimation];
    if (self.delegate && [self.delegate respondsToSelector:@selector(BCMenuPopBtnClick:)]) {
        [self.delegate BCMenuPopBtnClick:btn.tag];
    }
}

@end
