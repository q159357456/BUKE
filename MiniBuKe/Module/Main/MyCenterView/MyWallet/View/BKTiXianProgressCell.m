//
//  BKTiXianProgressCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/12/4.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKTiXianProgressCell.h"

@interface BKTiXianProgressCell()
@property (nonatomic, weak) IBOutlet UIView *progressBottomView;
@property (nonatomic, weak) IBOutlet UIView *progressView;
@property (nonatomic, weak) IBOutlet UILabel *showTitle;
@property (nonatomic, weak) IBOutlet UILabel *timeTitle;
@property (nonatomic, weak) IBOutlet UIImageView *moneyIcon;

@end

@implementation BKTiXianProgressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"BKTiXianProgressCell" owner:nil options:nil] lastObject];
        //纯代码布局cell内部控件
        [self setupUI];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
- (void)setupUI{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (CGFloat)heightForCellWithObject:(id)obj{
    return 377.f;
}

- (void)setProgressStateWithtype:(NSInteger)applyType andTime:(NSString*)timeStr{
    if (applyType == 1) {//已经提现完成
        self.progressBottomView.backgroundColor = COLOR_STRING(@"#FA9A3A");
        self.moneyIcon.image = [UIImage imageNamed:@"wallet_prgress_moneySel"];
        self.showTitle.text = @"已到账";
        self.timeTitle.text = timeStr;
    }else{
        self.progressBottomView.backgroundColor = COLOR_STRING(@"#D7D7D7");
        self.moneyIcon.image = [UIImage imageNamed:@"wallet_progress_moneyNorl"];
        self.showTitle.text = @"等待到账";
        self.timeTitle.text = @"客服小姐姐会加紧处理的，请耐心等待呦";
    }
}

@end
