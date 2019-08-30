//
//  ScoreBottomView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/10/22.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "ScoreBottomView.h"
#import "English_Header.h"
@implementation ScoreBottomView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:self.bounds];
        imageview.image = [UIImage imageNamed:@"test_panel"];
        [self addSubview:imageview];
        self.bookView = [[ScoreBootomSubView alloc]init];
        self.wordView = [[ScoreBootomSubView alloc]init];
        self.bookView.label.text= @"阅读本数";
        self.wordView.label.text = @"词汇量";
        self.bookView.imageview.image =  [UIImage imageNamed:@"test_book_icon"];
        self.wordView.imageview.image =  [UIImage imageNamed:@"test_word_icon"];
        [self addSubview:self.bookView];
        [self addSubview:self.wordView];
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor =COLOR_STRING(@"#DAE6F0");
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(1, SCALE(17)));
        }];
        
        [self.bookView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(SCALE(121), SCALE(40)));
            make.right.mas_equalTo(self.mas_centerX).offset(SCALE(-20));
        }];
        
        [self.wordView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(SCALE(121), SCALE(40)));
            make.left.mas_equalTo(self.self.mas_centerX).offset(SCALE(20));
            
        }];
        
    }
    return self;
}


@end


