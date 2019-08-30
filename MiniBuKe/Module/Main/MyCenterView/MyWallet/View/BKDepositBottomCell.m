//
//  BKDepositBottomCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/12/3.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKDepositBottomCell.h"
@interface BKDepositBottomCell ()
@property (nonatomic, weak) IBOutlet UILabel *tipLabe1;
@property (nonatomic, weak) IBOutlet UILabel *tipLabe2;
@property (nonatomic, weak) IBOutlet UILabel *tipLabe3;

@end

@implementation BKDepositBottomCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"BKDepositBottomCell" owner:nil options:nil] lastObject];
        //纯代码布局cell内部控件
        [self setupUI];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"1.提现申请将在24小时内审批到账;如遇到高峰期,可能延迟到账,请耐心等待."];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    
    [str addAttribute:NSForegroundColorAttributeName value:COLOR_STRING(@"#2f2f2f") range:[[str string] rangeOfString:@"1.提现申请将在24小时内审批到账;如遇到高峰期,可能延迟到账,请耐心等待."]];
    NSRange range1 = [[str string] rangeOfString:@"24小时"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range1];
    self.tipLabe1.attributedText = str;

    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:@"2.提现到账查询:微信-我-钱包-零钱-零钱明细"];
    NSRange range2 = [[str2 string] rangeOfString:@"微信-我-钱包-零钱-零钱明细"];
    [str2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13 weight:UIFontWeightMedium] range:range2];
    [str2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13 weight:UIFontWeightRegular] range:NSMakeRange(0, range2.location)];
    self.tipLabe2.attributedText = str2;
    
    NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:@"3.每日最多可提现1次."];
    [str3 addAttribute:NSForegroundColorAttributeName value:COLOR_STRING(@"#2f2f2f") range:[[str3 string] rangeOfString:@"3.每日最多可提现1次."]];
    NSRange range3 = [[str3 string] rangeOfString:@"1"];
    [str3 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range3];
    self.tipLabe3.attributedText = str3;
}

- (void)setupUI{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (CGFloat)heightForCellWithObject:(id)obj{
    return 150.f;
}

@end
