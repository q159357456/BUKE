//
//  BKSelectConfigNetCell.m
//  MiniBuKe
//
//  Created by chenheng on 2019/1/29.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKSelectConfigNetCell.h"

@interface BKSelectConfigNetCell()
@property (nonatomic, weak) IBOutlet UIImageView *iconImage;
@property (nonatomic, weak) IBOutlet UILabel *title;
@end

@implementation BKSelectConfigNetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"BKSelectConfigNetCell" owner:nil options:nil] lastObject];
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
}
+ (CGFloat)heightForCellWithObject:(id)obj{
    return (SCREEN_WIDTH-15)*(260.f/345.f);
}

- (void)setModelWithFlag:(NSInteger)index{
    if (index == 0) {
        self.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"newConfig_selectNetModel_%ld",index]];
        self.title.text = @"wifi联网";
    }else if (index == 1){
        self.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"newConfig_selectNetModel_%ld",index]];
        self.title.text = @"4G联网";
    }
}

@end
