//
//  BKSearchImagineCell.m
//  MiniBuKe
//
//  Created by chenheng on 2019/1/9.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKSearchImagineCell.h"

@interface BKSearchImagineCell()

@property(nonatomic, strong) UIImageView *iconView;
@property(nonatomic, strong) UILabel *TitleLabel;
@property(nonatomic, strong) UIView *sepLineView;

@end

@implementation BKSearchImagineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModelWithTitle:(NSString*)title andHightTitle:(NSString*)hightTitle{
    
    if (title.length && hightTitle.length) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:title];
        [str addAttribute:NSForegroundColorAttributeName value:COLOR_STRING(@"#2f2f2f") range:[[str string] rangeOfString:title]];
        NSRange range1 = [[str string] rangeOfString:hightTitle];
        [str addAttribute:NSForegroundColorAttributeName value:COLOR_STRING(@"#FA9A3A") range:range1];
        self.TitleLabel.attributedText = str;
    }else{
        self.TitleLabel.text = title;
    }
}

+ (CGFloat)heightForCellWithObject:(id)obj{
    return 50.f;
}

- (void)changeTheHighlightedUI:(BOOL)isHigh{
    if (isHigh) {
        self.contentView.backgroundColor = COLOR_STRING(@"#F7F9FB");
    }else{
        self.contentView.backgroundColor = COLOR_STRING(@"#FFFFFF");
    }
}

- (void)setupUI{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.iconView = [[UIImageView alloc]init];
    self.iconView.image = [UIImage imageNamed:@"home_search_big_icon"];
    [self.contentView addSubview:self.iconView];

    self.TitleLabel = [[UILabel alloc]init];
    self.TitleLabel.textColor = COLOR_STRING(@"#2F2F2F");
    self.TitleLabel.font = [UIFont systemFontOfSize:16.f weight:UIFontWeightRegular];
    self.TitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.TitleLabel];

    self.sepLineView = [[UIView alloc]init];
    self.sepLineView.backgroundColor = COLOR_STRING(@"#EAEAEA");
    [self.contentView addSubview:_sepLineView];
    
    [self addConstraints];
}

- (void)addConstraints{
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.height.mas_equalTo(16);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
    }];
    
    [self.TitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.iconView.mas_right).offset(10);
        make.right.mas_greaterThanOrEqualTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.sepLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(1.f);
    }];
}

@end
