//
//  ScoreBootomSubView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/10/22.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "ScoreBootomSubView.h"
#import "English_Header.h"
@implementation ScoreBootomSubView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.dataLabel = [[UILabel alloc]init];
        self.dataLabel.text=@"00";
        self.dataLabel.textColor =COLOR_STRING(@"#2F2F2F");
        self.dataLabel.font = [UIFont boldSystemFontOfSize:SCALE(17)];
        self.imageview = [[UIImageView alloc]init];
        self.dataLabel.textAlignment = NSTextAlignmentRight;
//        self.imageview.backgroundColor = [UIColor redColor];
        self.label = [[UILabel alloc]init];
        self.label.font = [UIFont systemFontOfSize:SCALE(12) weight:UIFontWeightRegular];
//        self.label.backgroundColor = [UIColor redColor];
        //
        [self addSubview:self.dataLabel];
        [self addSubview:self.imageview];
        [self addSubview:self.label];
        
        //
        [self.imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCALE(20), SCALE(20)));
            make.left.mas_equalTo(self.mas_left);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCALE(51), SCALE(30)));
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(self.imageview.mas_right).offset(SCALE(10));
        }];
        
        [self.dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCALE(50), SCALE(30)));
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(self.label.mas_right);
        }];
        
        
        
    }
    return self;
}

@end
