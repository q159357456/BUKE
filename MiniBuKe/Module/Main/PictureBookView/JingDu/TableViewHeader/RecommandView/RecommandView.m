//
//  RecommandView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/2.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "RecommandView.h"
@interface RecommandView()
@property(nonatomic,strong)UILabel *titleLabel;
@end
@implementation RecommandView

-(instancetype)initWithFrame:(CGRect)frame Title:(NSString*)title
{
    if (self = [super initWithFrame:frame]) {
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height/2-10, SCALE(50), 20)];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:SCALE(10)];
        self.titleLabel.text = title;
        [self addSubview:self.titleLabel];
    }
    return self;
}
-(void)setStarCount:(NSInteger)starCount
{
    _starCount = starCount;
    CGFloat y = self.frame.size.height/2-5;
    for (NSInteger i = 0; i<5; i++) {
        CGFloat x = CGRectGetMaxX(self.titleLabel.frame) + i*(SCALE(2 + 10));
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, SCALE(10), SCALE(10))];
        
        [self addSubview:imageview];
        if (i<starCount) {
            imageview.image = [UIImage imageNamed:@"star"];
        }else
        {
            imageview.image = [UIImage imageNamed:@"t_star"];
        }
        
    }
}
@end
