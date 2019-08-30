//
//  BKWalletTopView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/30.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKWalletTopView.h"
@interface BKWalletTopView()

@property (nonatomic ,strong) UILabel *MoneyShowOne;
@property (nonatomic ,strong) UILabel *MoneyShowTwo;
@property (nonatomic ,strong) UILabel *tixianMoneyShowOne;
@property (nonatomic ,strong) UILabel *tixianMoneyShowTwo;
@property (nonatomic ,strong) UILabel *titleMoneytip;
@property (nonatomic ,strong) UIImageView *imageIcon;

@end

@implementation BKWalletTopView
- (instancetype)init{
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];

    }
    return self;
}

- (void)setupUI{
    self.imageIcon = [[UIImageView alloc]init];
    self.imageIcon.image = [UIImage imageNamed:@"wallet_top_icon"];
    [self addSubview:_imageIcon];
    
    self.titleMoneytip = [[UILabel alloc] init];
    _titleMoneytip.text = @"可提现金额";
    _titleMoneytip.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    _titleMoneytip.textColor = COLOR_STRING(@"#999999");
    [self addSubview: _titleMoneytip];
    
    self.MoneyShowOne = [[UILabel alloc] init];
    _MoneyShowOne.text = @"¥ 0";
    _MoneyShowOne.font = [UIFont systemFontOfSize:38 weight:UIFontWeightBold];
    _MoneyShowOne.textColor = COLOR_STRING(@"#FFFFFF");
    [self addSubview: _MoneyShowOne];
    
    self.MoneyShowTwo = [[UILabel alloc] init];
    _MoneyShowTwo.text = @".00";
    _MoneyShowTwo.font = [UIFont systemFontOfSize:22 weight:UIFontWeightBold];
    _MoneyShowTwo.textColor = COLOR_STRING(@"#FFFFFF");
    [self addSubview: _MoneyShowTwo];
    
    self.tixianMoneyShowOne = [[UILabel alloc] init];
    _tixianMoneyShowOne.text = @"累计收益¥0";
    _tixianMoneyShowOne.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    _tixianMoneyShowOne.textColor = COLOR_STRING(@"#999999");
    [self addSubview: _tixianMoneyShowOne];
    
    self.tixianMoneyShowTwo = [[UILabel alloc] init];
    _tixianMoneyShowTwo.text = @".00";
    _tixianMoneyShowTwo.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
    _tixianMoneyShowTwo.textColor = COLOR_STRING(@"#999999");
    [self addSubview: _tixianMoneyShowTwo];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.imageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(self);
    }];
    [self.titleMoneytip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(30);
        make.left.mas_equalTo(self.mas_left).offset(15);
    }];
    [self.MoneyShowOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleMoneytip.mas_bottom).offset(13);
        make.left.mas_equalTo(self.mas_left).offset(15);
    }];
    [self.MoneyShowTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.MoneyShowOne.mas_right).offset(0);
        make.bottom.mas_equalTo(self.MoneyShowOne.mas_bottom).offset(-4);
    }];
    [self.tixianMoneyShowOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.top.mas_equalTo(self.MoneyShowOne.mas_bottom).offset(28);
    }];
    [self.tixianMoneyShowTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tixianMoneyShowOne.mas_right).offset(0);
        make.bottom.mas_equalTo(self.tixianMoneyShowOne.mas_bottom).offset(-1);
    }];
}

- (void)reloadContentWithEnableMoney:(CGFloat)enabelMoney andAllMoney:(CGFloat)allMoney{
    
    NSString *str0 = [NSString stringWithFormat:@"%ld",(NSInteger)floorf(enabelMoney)];
    CGFloat xiaoshu1 = enabelMoney - floorf(enabelMoney);
    NSString *str1 = [[NSString stringWithFormat:@"%.2f",xiaoshu1]
                      substringFromIndex:1];
    self.MoneyShowOne.text = [NSString stringWithFormat:@"¥ %@",str0];
    self.MoneyShowTwo.text = [NSString stringWithFormat:@"%@",str1];
    
    NSString *str3 = [NSString stringWithFormat:@"%ld",(NSInteger)floorf(allMoney)];
    CGFloat xiaoshu2 = allMoney - floorf(allMoney);
    NSString *str4 = [[NSString stringWithFormat:@"%.2f",xiaoshu2]
                      substringFromIndex:1];
    self.tixianMoneyShowOne.text = [NSString stringWithFormat:@"累计收益¥%@",str3];
    self.tixianMoneyShowTwo.text = [NSString stringWithFormat:@"%@",str4];
}

@end
