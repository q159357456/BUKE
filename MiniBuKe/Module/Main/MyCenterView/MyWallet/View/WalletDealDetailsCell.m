//
//  WalletDealDetailsCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/30.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "WalletDealDetailsCell.h"

@interface WalletDealDetailsCell()
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *moneyLabel;
@property (nonatomic, weak) IBOutlet UIButton *moreBtn;
@property (nonatomic, copy)  NSString *transactionId;

@end

@implementation WalletDealDetailsCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       self = [[[NSBundle mainBundle] loadNibNamed:@"WalletDealDetailsCell" owner:nil options:nil] lastObject];
        //纯代码布局cell内部控件
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupUI{
    
}

- (void)setUIModelWith:(WalletDealData*)model{
    self.timeLabel.text = model.createTime;
    self.titleLabel.text = model.transactionDescribe;
    //交易类型(1.推荐购买 2.提现)
    self.moreBtn.hidden = model.transactionType == 2 ? NO:YES;
//    CGFloat money = [model.transactionMoney floatValue];
//    if (model.transactionType == 1) {
//        self.moneyLabel.text = [NSString stringWithFormat:@"+%.2f",money];
//    }else if (model.transactionType == 2){
//        self.moneyLabel.text = [NSString stringWithFormat:@"-%.2f",money];
//    }
    self.moneyLabel.text = model.transactionMoney;
    self.transactionId = model.transactionId;
}

- (IBAction)btnClick:(id)sender{
    if (_ClickDetailBtnClick) {
        _ClickDetailBtnClick(self.transactionId);
    }
}
+ (CGFloat)heightForCellWithObject:(id)obj{
    return 55.f;
}

@end
