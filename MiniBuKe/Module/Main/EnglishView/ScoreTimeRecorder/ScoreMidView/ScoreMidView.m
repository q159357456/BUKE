//
//  ScoreMidView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/10/22.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "ScoreMidView.h"
#import "English_Header.h"
@implementation ScoreMidView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
       
        [self initSubviews];
    }
    return self;
}
-(void)initSubviews{
    
    self.timeLable = [[UILabel alloc]init];
    self.wordRepeatLable = [[UILabel alloc]init];
    self.voiceLable = [[UILabel alloc]init];
    self.fluencyLable = [[UILabel alloc]init];
    //
    UILabel *wordBottom = [[UILabel alloc]init];
    UILabel *voiceBottom = [[UILabel alloc]init];
    UILabel *fluenceBottom = [[UILabel alloc]init];
    
    
    
    //
    [self addSubview:self.timeLable];
    [self addSubview:self.wordRepeatLable];
    [self addSubview:self.voiceLable];
    [self addSubview:self.fluencyLable];
    [self addSubview:wordBottom];
    [self addSubview:voiceBottom];
    [self addSubview:fluenceBottom];
    //
    self.timeLable.font = [UIFont systemFontOfSize:SCALE(12)];
    self.timeLable.textColor =  COLOR_STRING(@"#999999");
    self.timeLable.attributedText = [self getAttribute:@"00"];
    
    self.wordRepeatLable.text = @"00";
    self.wordRepeatLable.font = [UIFont boldSystemFontOfSize:SCALE(18)];
    self.voiceLable.text = @"00";
    self.voiceLable.font = [UIFont boldSystemFontOfSize:SCALE(18)];
    self.fluencyLable.text = @"00";
    self.fluencyLable.font =[UIFont boldSystemFontOfSize:SCALE(18)];
    wordBottom.text = @"单词重音";
    wordBottom.font = [UIFont systemFontOfSize:SCALE(12)];
    wordBottom.textColor = COLOR_STRING(@"#999999");
    voiceBottom.text = @"音素发音";
    voiceBottom.font = [UIFont systemFontOfSize:SCALE(12)];
    voiceBottom.textColor = COLOR_STRING(@"#999999");
    fluenceBottom.text = @"流利度得分";
    fluenceBottom.font = [UIFont systemFontOfSize:SCALE(12)];
    fluenceBottom.textColor = COLOR_STRING(@"#999999");
    //
    self.timeLable.textAlignment = NSTextAlignmentCenter;
    self.wordRepeatLable.textAlignment = NSTextAlignmentCenter;
    self.voiceLable.textAlignment = NSTextAlignmentCenter;
    self.fluencyLable.textAlignment = NSTextAlignmentCenter;
    wordBottom.textAlignment = NSTextAlignmentCenter;
    voiceBottom.textAlignment = NSTextAlignmentCenter;
    fluenceBottom.textAlignment = NSTextAlignmentCenter;
//    
//    self.timeLable.backgroundColor = [UIColor redColor];
//    self.wordRepeatLable.backgroundColor = [UIColor redColor];
//    self.voiceLable.backgroundColor = [UIColor redColor];
//    self.fluencyLable.backgroundColor = [UIColor redColor];
//    wordBottom.backgroundColor = [UIColor redColor];
//    voiceBottom.backgroundColor = [UIColor redColor];
//    fluenceBottom.backgroundColor = [UIColor redColor];
    
    [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 40));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(40);
    }];
    
    [self.voiceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(80, 25));
        make.top.mas_equalTo(self.timeLable.mas_bottom).offset(30);

    }];
//
    [voiceBottom mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(80, 20));
        make.top.mas_equalTo(self.voiceLable.mas_bottom).offset(5);
    }];
//
    [self.wordRepeatLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(80, 25));
        make.top.mas_equalTo(self.timeLable.mas_bottom).offset(30);
    }];
//
    [wordBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(80, 20));
        make.top.mas_equalTo(self.wordRepeatLable.mas_bottom).offset(5);
    }];

    [self.fluencyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-20);
        make.size.mas_equalTo(CGSizeMake(80, 25));
        make.top.mas_equalTo(self.timeLable.mas_bottom).offset(30);
    }];

    [fluenceBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-20);
        make.size.mas_equalTo(CGSizeMake(80, 20));
        make.top.mas_equalTo(self.fluencyLable.mas_bottom).offset(5);
    }];
//
//
    
    
    
    
    
}

-(NSMutableAttributedString *)getAttribute:(NSString *)string{
    
    NSString *str = [NSString stringWithFormat:@"%@分钟",string];
    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:str];
    //    //目的是想改变 ‘/’前面的字体的属性，所以找到目标的range
    //    NSRange range = [string rangeOfString:@"/"];
    //    NSRange pointRange = NSMakeRange(0, range.location);
    //    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //    dic[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    //    //赋值
    //    [attribut addAttributes:dic range:pointRange];
    
    NSRange range = [str rangeOfString:string];
    [attribut addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:50],NSFontAttributeName,[UIColor blackColor],NSForegroundColorAttributeName,nil] range:range];
    return attribut;
}

@end
