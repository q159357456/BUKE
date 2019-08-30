//
//  ScoreTotalView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/10/24.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "ScoreTotalView.h"
@interface ScoreTotalView()
@property(nonatomic,strong)UILabel *scoreLable;
@end
@implementation ScoreTotalView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:self.bounds];
        imageview.image = [UIImage imageNamed:@"score_bg"];
        [self addSubview:imageview];
        self.scoreLable = [[UILabel alloc]init];
        self.scoreLable.text = @"00";
        self.scoreLable.textColor = COLOR_STRING(@"#F3930D");
        self.scoreLable.textAlignment = NSTextAlignmentCenter;
        self.scoreLable.font =  [UIFont boldSystemFontOfSize:50];
        UILabel *lable = [[UILabel alloc]init];
        lable.text = @"学习时长";
        [self addSubview:self.self.scoreLable];
        [self addSubview:lable];
        
        [self.scoreLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(80, 40));
        }];
        
    }
    return self;
}

-(void)setScore:(NSString *)score
{
    _score = score;
    self.scoreLable.text = score;
}
@end
