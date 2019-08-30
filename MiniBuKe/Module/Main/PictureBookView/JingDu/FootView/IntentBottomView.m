//
//  IntentBottomView.m
//  MiniBuKe
//
//  Created by chenheng on 2019/1/22.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "IntentBottomView.h"
#import "UIResponder+Event.h"
@implementation IntentBottomView

+(instancetype)IntenBuyBottomView
{
    IntentBottomView *bottom = [[IntentBottomView alloc]init];
    return bottom;
}
-(instancetype)init
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50);
        UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCALE(144), self.frame.size.height)];
//        [btn1 setImage:[UIImage imageNamed:@"kbook_icon"] forState:UIControlStateNormal];
//        [btn1 setTitle:@"K绘本" forState:UIControlStateNormal];
//        [btn1 setTitleColor:COLOR_STRING(@"#2F2F2F") forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(k_picturebook) forControlEvents:UIControlEventTouchUpInside];
        btn1.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc]init];
        label.text = @"K绘本";
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = COLOR_STRING(@"#2F2F2F");
        UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kbook_icon_new"]];
        [btn1 addSubview:label];
        [btn1 addSubview:imageview];
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCALE(19), SCALE(19)));
            make.centerY.mas_equalTo(btn1.mas_centerY);
            make.left.mas_equalTo(btn1.mas_left).offset(SCALE(37));
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(btn1.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(42, 16));
            make.left.mas_equalTo(btn1.mas_left).offset(SCALE(61));
        }];
        
        UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(SCALE(144), 0, self.frame.size.width - SCALE(144), self.frame.size.height)];
        btn2.backgroundColor = COLOR_STRING(@"#D7D7D7");
        [btn2 setImage:[UIImage imageNamed:@"shop_icon_none"] forState:UIControlStateNormal];
        [btn2 setTitle:@"购买" forState:UIControlStateNormal];
        btn2.enabled = NO;
        [btn2 addTarget:self action:@selector(toJinDong_buy) forControlEvents:UIControlEventTouchUpInside];
        btn2.titleLabel.font = [UIFont systemFontOfSize:15];
        self.buyBtn = btn2;
        
        [self addSubview:btn1];
        [self addSubview:btn2];
        
    }
    return self;
}

-(void)k_picturebook{
    
    [self eventName:IntentBottomView_Event Params:@0];
}
-(void)toJinDong_buy{
    
    [self eventName:IntentBottomView_Event Params:@1];
    
}
@end
