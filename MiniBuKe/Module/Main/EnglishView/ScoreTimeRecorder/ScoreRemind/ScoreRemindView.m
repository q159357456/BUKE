//
//  ScoreRemindView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/10/24.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "ScoreRemindView.h"
#import "English_Header.h"
@implementation ScoreRemindView

-(instancetype)initWithFrame:(CGRect)frame Title:(NSString*)title Info:(NSString*)info ImageName:(NSString*)imageName Block:(void(^)(void))block
{
    if (self = [super initWithFrame:frame]) {
        self.KownBlock = block;
        self.backgroundColor = PXH_RGBA_COLOR(47/255.0, 47/255.0, 47/255.0, 0.7);
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 24;
        view.layer.masksToBounds = YES;
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
        UILabel *lable= [[UILabel alloc]init];
        lable.font = [UIFont boldSystemFontOfSize:SCALE(16)];
        lable.text = title;
        lable.textAlignment = NSTextAlignmentCenter;
        UILabel *lable1 = [[UILabel alloc]init];
        lable1.numberOfLines = 0;
        lable1.numberOfLines = 0;
        lable1.textAlignment = NSTextAlignmentCenter;
        lable1.font = [UIFont systemFontOfSize:SCALE(13)];
        lable1.text = info;
        CGSize size = [lable1 sizeThatFits:CGSizeMake(SCALE(251), MAXFLOAT)];
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"我知道了" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(kown) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = COLOR_STRING(@"#EAEAEA");
        [view addSubview:lable];
        [view addSubview:lable1];
        [view addSubview:button];
        [view addSubview:imageView];
         [self addSubview:view];
       
        CGFloat height = 25 + SCALE(102) + 25 + SCALE(17) +15 +size.height +30 +42;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(SCALE(300), height));
            
        }];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCALE(102), SCALE(102)));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(view.mas_top).offset(25);
            
        }];
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCALE(300), SCALE(17)));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(imageView.mas_bottom).offset(25);
        }];
        
        [lable1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCALE(251), size.height));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(lable.mas_bottom).offset(15);
        }];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lable1.mas_bottom).offset(30);
            make.size.mas_equalTo(CGSizeMake(SCALE(300), SCALE(42)));
            make.left.mas_equalTo(view.mas_left);
        }];
        
        
        
    }
    return self;
}
-(void)kown{
    
    if (self.KownBlock) {
        self.KownBlock();
    }
    [self removeFromSuperview];
    
}
@end
