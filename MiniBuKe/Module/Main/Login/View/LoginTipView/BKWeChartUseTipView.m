//
//  BKWeChartUseTipView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/12/7.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKWeChartUseTipView.h"
@interface BKWeChartUseTipView()

@property (nonatomic, weak) IBOutlet UILabel *titleLable;

@end

@implementation BKWeChartUseTipView

- (instancetype)init{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"BKWeChartUseTipView" owner:nil options:nil] lastObject];
        self.frame = CGRectMake(0, 0, 300, 248);
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = 24.f;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
}

- (IBAction)btnClick:(id)sender{
    if (_okBtnClick) {
        _okBtnClick();
    }
}

- (void)setTitleWithNumber:(NSString*)number{
    if (number.length == 0) return;
    NSString *tip = @"该微信绑定过账号:";
    NSString *numberStr;
    if (number.length == 11 || number.length == 10) {
        numberStr = [number stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }else{
        numberStr = [number stringByReplacingCharactersInRange:NSMakeRange(3, 3) withString:@"***"];
    }
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",tip,numberStr]];
    NSRange range2 = [[str2 string] rangeOfString:numberStr];
    NSRange range3 = [[str2 string] rangeOfString:[NSString stringWithFormat:@"%@%@",tip,numberStr]];

    [str2 addAttribute:NSForegroundColorAttributeName value:COLOR_STRING(@"2f2f2f") range:range3];
    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range2];
    self.titleLable.attributedText = str2;
}


@end
