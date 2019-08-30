//
//  KBookContentCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/19.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "KBookContentCell.h"

@interface KBookContentCell()

@property(nonatomic,strong) UILabel *contentLabel;

@end

@implementation KBookContentCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 25);
        
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:self.frame];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.textColor = COLOR_STRING(@"#202020");
        contentLabel.font = MY_FONT(18);
        contentLabel.text = @"文字说明随上图左右翻页变换";
        self.contentLabel = contentLabel;
        
        [self addSubview:contentLabel];
    }
    return self;
}

-(void)setContent:(NSString *)content
{
    _content = content;
    self.contentLabel.text = content;
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
