//
//  BabyInfoViewCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/5/31.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BabyInfoViewCell.h"

@interface BabyInfoViewCell()

@property(nonatomic,strong) UILabel *leftLabel;


@end

@implementation BabyInfoViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60);
        
        UILabel *leftLabel = [[UILabel alloc]init];
        leftLabel.frame = CGRectMake(16, (self.frame.size.height - 40)*0.5, 80, 40);
        leftLabel.font = MY_FONT(14);
        leftLabel.textColor = COLOR_STRING(@"#666666");
        self.leftLabel = leftLabel;
        [self addSubview:leftLabel];
        
        UITextField *rightField = [[UITextField alloc] init];
        rightField.textAlignment = NSTextAlignmentRight;
        rightField.font = MY_FONT(14);
        rightField.textColor = COLOR_STRING(@"#666666");
        rightField.hidden = YES;
        [self addSubview:rightField];
        [rightField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-16);
            make.top.equalTo(leftLabel);
            make.height.equalTo(leftLabel);
            make.left.equalTo(leftLabel.mas_right).offset(15);
        }];
        self.rightField = rightField;
        
        UILabel *rightLabel = [[UILabel alloc]init];
        rightLabel.textColor = COLOR_STRING(@"#666666");
        rightLabel.font = MY_FONT(14);
        rightLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:rightLabel];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-16);
            make.top.equalTo(leftLabel);
            make.height.equalTo(leftLabel);
        }];
        
        self.rightLabel = rightLabel;
        
        UIView *line  = [[UIView alloc] init];
        line.frame = CGRectMake(15, self.frame.size.height - 1, self.frame.size.width - 15*2, 1);
        line.backgroundColor = COLOR_STRING(@"#F4F4F4");
        self.line = line;
        [self addSubview:line];
    }
    
    return self;
}

-(void)setLeftString:(NSString *)leftString
{
    _leftString = leftString;
    self.leftLabel.text = leftString;
    
//    [self.leftLabel sizeToFit];

}

-(void)setFrame:(CGRect)frame
{
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    [super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
