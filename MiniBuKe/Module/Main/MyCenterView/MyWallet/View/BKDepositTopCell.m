//
//  BKDepositTopCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/12/3.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKDepositTopCell.h"

@interface BKDepositTopCell()
@property (nonatomic, strong)IBOutlet UIButton *selectBtn1;
@property (nonatomic, strong)IBOutlet UIButton *selectBtn2;
@property (nonatomic, strong)IBOutlet UIButton *selectBtn3;
@property (nonatomic, strong)IBOutlet UILabel *moneyLabel1;
@property (nonatomic, strong)IBOutlet UILabel *moneyLabel2;
@property (nonatomic, assign) NSInteger selectindex;
@property (nonatomic, strong)IBOutlet UILabel *tipLabel;

@end

@implementation BKDepositTopCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"BKDepositTopCell" owner:nil options:nil] lastObject];
        //纯代码布局cell内部控件
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectBtn1.layer.cornerRadius = 8.f;
    self.selectBtn1.layer.borderWidth = 1;
    self.selectBtn1.layer.borderColor = COLOR_STRING(@"#E5E5E5").CGColor;
    self.selectBtn2.layer.cornerRadius = 8.f;
    self.selectBtn2.layer.borderWidth = 1;
    self.selectBtn2.layer.borderColor = COLOR_STRING(@"#E5E5E5").CGColor;
    self.selectBtn3.layer.cornerRadius = 8.f;
    self.selectBtn3.layer.borderWidth = 1;
    self.selectBtn3.layer.borderColor = COLOR_STRING(@"#E5E5E5").CGColor;
    self.selectBtn1.tag = 1;
    self.selectBtn2.tag = 2;
    self.selectBtn3.tag = 3;
    
    self.selectindex = 0;
    self.tipLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupUI{
    
}

+ (CGFloat)heightForCellWithObject:(id)obj{
    return 375.f-15.f;
}

- (IBAction)btnClickSelect:(UIButton*)sender{
    sender.selected = !sender.selected;
    if (sender.tag == 1) {
        self.selectBtn2.selected = NO;
        self.selectBtn3.selected = NO;

    }else if (sender.tag == 2) {
        self.selectBtn1.selected = NO;
        self.selectBtn3.selected = NO;
    }
    else if (sender.tag == 3) {
        self.selectBtn1.selected = NO;
        self.selectBtn2.selected = NO;
    }
    [self selectBtnChange:self.selectBtn1];
    [self selectBtnChange:self.selectBtn2];
    [self selectBtnChange:self.selectBtn3];
}

- (void)selectBtnChange:(UIButton*)btn{
    if (btn.selected) {
        btn.layer.borderColor = COLOR_STRING(@"#FA9A3A").CGColor;
        btn.backgroundColor = COLOR_STRING(@"#FFFDFB");
        self.selectindex = btn.tag;
        if (_ClickMoneyBtn) {
            _ClickMoneyBtn(self.selectindex);
        }
    }else{
        btn.layer.borderColor = COLOR_STRING(@"#E5E5E5").CGColor;
        btn.backgroundColor = COLOR_STRING(@"#FFFFFF");
        if (btn.tag == self.selectindex) {
            self.selectindex = 0;
            if (_ClickMoneyBtn) {
                _ClickMoneyBtn(self.selectindex);
            }
        }
    }
}

- (void)changeTheTipMoneyOver:(BOOL)ishide{
    self.tipLabel.hidden = ishide;
}
- (void)setMoneyWith:(CGFloat)money{
    self.moneyLabel1.text = [NSString stringWithFormat:@"¥%ld",(NSInteger)floorf(money)];
    CGFloat xiaoshu = money - floorf(money);
    NSString *str = [NSString stringWithFormat:@"%.2f",xiaoshu];
    self.moneyLabel2.text = [str substringFromIndex:1];
}

@end
