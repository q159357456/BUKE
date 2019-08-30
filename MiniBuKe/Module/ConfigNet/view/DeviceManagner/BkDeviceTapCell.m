//
//  BkDeviceTapCell.m
//  MiniBuKe
//
//  Created by chenheng on 2019/1/29.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "BkDeviceTapCell.h"

@interface BkDeviceTapCell()
@property (nonatomic, weak) IBOutlet UILabel *title;

@end
@implementation BkDeviceTapCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"BkDeviceTapCell" owner:nil options:nil] lastObject];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)heightForCellWithObject:(id)obj{
    if ( obj != nil && [obj integerValue] == 0) {
        return 75.f;
    }
    return 50.f;
}

- (void)setModelWithtitle:(NSString*)title{
    self.title.text = title;
}

@end
