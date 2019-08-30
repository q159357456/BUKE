//
//  BKPhoneAreaTableViewCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/23.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKPhoneAreaTableViewCell.h"

@interface BKPhoneAreaTableViewCell()

@property(nonatomic, strong) UILabel *leftTitleLabel;
@property(nonatomic, strong) UILabel *rightTitleLabel;
@property(nonatomic, strong) UIView *sepLineView;

@end

@implementation BKPhoneAreaTableViewCell

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

- (void)setModelWithTitle:(NSString*)title andSubTitle:(NSString*)subTitle{
    self.leftTitleLabel.text = title;
    self.rightTitleLabel.text = [NSString stringWithFormat:@"+%@",subTitle];
}

- (void)changeTheHighlightedUI:(BOOL)isHigh{
        if (isHigh) {
            self.contentView.backgroundColor = COLOR_STRING(@"#F7F9FB");
            self.rightTitleLabel.textColor = COLOR_STRING(@"#FA9A3A");
        }else{
            self.contentView.backgroundColor = COLOR_STRING(@"#FFFFFF");
            self.rightTitleLabel.textColor = COLOR_STRING(@"#999999");
        }
}

//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{//重写高亮函数
//    if (highlighted) {
//        self.contentView.backgroundColor = COLOR_STRING(@"#F7F9FB");
//        self.rightTitleLabel.textColor = COLOR_STRING(@"#FA9A3A");
//    }else{
//        self.contentView.backgroundColor = COLOR_STRING(@"#FFFFFF");
//        self.rightTitleLabel.textColor = COLOR_STRING(@"#999999");
//    }
//}

- (void)setupUI{
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.leftTitleLabel = [[UILabel alloc]init];
    self.leftTitleLabel.textColor = COLOR_STRING(@"#2F2F2F");
    self.leftTitleLabel.font = [UIFont systemFontOfSize:16.f weight:UIFontWeightRegular];
    self.leftTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_leftTitleLabel];
    
    self.rightTitleLabel = [[UILabel alloc]init];
    self.rightTitleLabel.textColor = COLOR_STRING(@"#999999");
    self.rightTitleLabel.font = [UIFont systemFontOfSize:16.f weight:UIFontWeightRegular];
    self.rightTitleLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_rightTitleLabel];
    
    self.sepLineView = [[UIView alloc]init];
    self.sepLineView.backgroundColor = COLOR_STRING(@"#EAEAEA");
    [self.contentView addSubview:_sepLineView];
    
    [self addConstraints];
}

- (void)addConstraints{
    [self.leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.contentView.mas_left).offset(14);
    }];
    [self.rightTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-14);
    }];
    [self.sepLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftTitleLabel.mas_left);
        make.right.mas_equalTo(self.rightTitleLabel.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(1.f);
    }];
}
@end
