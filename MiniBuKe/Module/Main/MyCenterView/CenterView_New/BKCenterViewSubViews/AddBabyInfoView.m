//
//  AddBabyInfoView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/23.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "AddBabyInfoView.h"

@implementation AddBabyInfoView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
//        UIImageView *backGroungImagView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"baby_panel"]];
//        backGroungImagView.frame = self.bounds;
//        [self addSubview:backGroungImagView];
        self.topLabel = [[UILabel alloc]init];
        self.downLabel = [[UILabel alloc]init];
        self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.addButton setBackgroundImage:[UIImage imageNamed:@"add_icon"] forState:UIControlStateNormal];
        self.addButton.userInteractionEnabled = NO;
//        self.editImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pencil_icon"]];
//        [self addSubview:self.editImageView];
//        self.editImageView.hidden = YES;
//         self.topLabel.backgroundColor = [UIColor lightGrayColor];
//         self.downLabel.backgroundColor = [UIColor lightGrayColor];
        UIImageView *rightImageView = [[UIImageView alloc]init];
        rightImageView.image = [UIImage imageNamed:@"next_my"];
        [self addSubview:rightImageView];
        self.topLabel.text = @"点击此处添加宝宝";
        self.downLabel.text =@"推荐宝宝年龄适读绘本";
        self.topLabel.font = [UIFont systemFontOfSize:SCALE(14)];
        self.downLabel.font = [UIFont systemFontOfSize:SCALE(13)];
        self.downLabel.textColor = COLOR_STRING(@"#999999");
        [self addSubview:self.addButton];
        [self addSubview:self.topLabel];
        [self addSubview:self.downLabel];
        [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(SCALE(27), SCALE(27)));
            make.left.mas_equalTo(self.mas_left).offset(15);
        }];
        CGSize size = [self.downLabel sizeThatFits:CGSizeZero];
        [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.addButton.mas_right).offset(10);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(size.width, 25));
        }];
        [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(6, 11));
            make.right.mas_equalTo(self).offset(-15);
        }];
//         CGSize size = [self.downLabel sizeThatFits:CGSizeZero];
        [self.downLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.topLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.mas_equalTo(25);
            make.right.mas_equalTo(rightImageView.mas_left).offset(-10);
        }];
        
        self.addButton.layer.cornerRadius =SCALE(27)/2;
        self.addButton.layer.masksToBounds = YES;
        

        [self.addButton addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    
    }
    return self;
    
}

#pragma mark - action
-(void)add{
    
    
    
}
@end
