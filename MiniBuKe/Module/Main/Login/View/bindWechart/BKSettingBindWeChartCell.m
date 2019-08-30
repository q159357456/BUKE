//
//  BKSettingBindWeChartCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/28.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKSettingBindWeChartCell.h"

@interface BKSettingBindWeChartCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *iconWeChart;
@property (nonatomic, strong) UIImageView *iconArrow;

@end

@implementation BKSettingBindWeChartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)heightForCellWithObject:(id)obj{
    return 50.f;
}

- (void)setupUI{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.text = @"微信绑定";
    self.titleLabel.textColor = COLOR_STRING(@"#2F2F2F");
    self.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.titleLabel];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.text = @"去绑定";
    self.nameLabel.textColor = COLOR_STRING(@"#999999");
    self.nameLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    self.nameLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.nameLabel];
    
    self.iconWeChart = [[UIImageView alloc]init];
    self.iconWeChart.image = [UIImage imageNamed:@"bindwechart_norl"];
    [self.contentView addSubview:self.iconWeChart];
    
    self.iconArrow = [[UIImageView alloc]init];
    self.iconArrow.image = [UIImage imageNamed:@"bindwechart_arrow"];
    [self.contentView addSubview:self.iconArrow];
    
    [self addConstraints];
}

- (void)addConstraints{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15.f);
    }];
    [self.iconArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(14);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
    }];
    [self.iconWeChart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.iconArrow.mas_left).offset(-15);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.iconWeChart.mas_left).offset(-5.f);
    }];
    
}

- (void)setNameTitle:(NSString*)namestr and:(BOOL)isBind{
    self.nameLabel.text = namestr;
    if (isBind) {
        self.iconWeChart.image = [UIImage imageNamed:@"bindwechart_select"];
    }else{
        self.iconWeChart.image = [UIImage imageNamed:@"bindwechart_norl"];
    }
}

@end
