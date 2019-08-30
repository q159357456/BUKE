//
//  TiemTotalView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/10/24.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "TiemTotalView.h"
#import "CommonUsePackaging.h"
@interface TiemTotalView()

@end
@implementation TiemTotalView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:self.bounds];
        imageview.image = [UIImage imageNamed:@"time_clock_bg"];
        [self addSubview:imageview];
        self.timeLable = [[UILabel alloc]init];
//        self.timeLable.text = @"8时40分";
        self.timeLable.textAlignment = NSTextAlignmentCenter;
        self.timeLable.textColor = [UIColor darkGrayColor];
        self.timeLable.font = [UIFont boldSystemFontOfSize:12];
        UILabel *lable = [[UILabel alloc]init];
        lable.text = @"学习总时长";
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.timeLable];
        [self addSubview:lable];
        
        [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(200, 40));
        }];
        
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.timeLable.mas_bottom).offset(8);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(80, 18));
            
        }];
        
    }
    return self;
}
-(void)setTime:(NSString *)time
{
    _time = time;
    NSString *str = [CommonUsePackaging Time_format:self.time];
    self.timeLable.attributedText = [CommonUsePackaging getAttributes:str Color:COLOR_STRING(@"#5AC357")];
}
-(NSMutableAttributedString *)getAttribute:(NSString *)string{
    NSString *str;
    
    
    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:str];
    //    //目的是想改变 ‘/’前面的字体的属性，所以找到目标的range
    //    NSRange range = [string rangeOfString:@"/"];
    //    NSRange pointRange = NSMakeRange(0, range.location);
    //    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //    dic[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    //    //赋值
    //    [attribut addAttributes:dic range:pointRange];
    
    NSRange range = [str rangeOfString:string];
    [attribut addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:40],NSFontAttributeName,[UIColor blackColor],NSForegroundColorAttributeName,nil] range:range];
    return attribut;
}
@end
