//
//  AboutViewCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/5/7.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "AboutViewCell.h"

@interface AboutViewCell()

@property(nonatomic,strong) UILabel *leftLabel;


@end

@implementation AboutViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60);
        
        UILabel *leftLabel = [[UILabel alloc]init];
        leftLabel.frame = CGRectMake(16, (self.frame.size.height - 20)*0.5, 80, 20);
        leftLabel.font = MY_FONT(14);
        leftLabel.textColor = COLOR_STRING(@"#666666");
        self.leftLabel = leftLabel;
        [self addSubview:leftLabel];
        
        UIImageView *upgradeImgView = [[UIImageView alloc] init];
        upgradeImgView.frame = CGRectMake(leftLabel.frame.origin.x + leftLabel.frame.size.width, (self.frame.size.height - 25)*0.5, 20, 25);
        upgradeImgView.image = [UIImage imageNamed:@"About_upgrade"];
        upgradeImgView.hidden = YES;
        self.upgradeImgView = upgradeImgView;
        [self addSubview:upgradeImgView];
        
        UILabel *rightLabel = [[UILabel alloc]init];
        rightLabel.textColor = COLOR_STRING(@"#9D9D9D");
        rightLabel.font = MY_FONT(12);
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
    [self.leftLabel sizeToFit];
    
    self.upgradeImgView.frame = CGRectMake(self.leftLabel.frame.origin.x + self.leftLabel.frame.size.width + 5, (self.frame.size.height - 25)*0.5, 20, 25);
}

//-(void)setRightString:(NSString *)rightString
//{
//    _rightString = rightString;
//    self.rightLabel.text = rightString;
//}


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
