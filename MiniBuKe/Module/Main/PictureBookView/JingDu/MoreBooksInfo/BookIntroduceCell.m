//
//  BookIntroduceCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/2.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BookIntroduceCell.h"

@implementation BookIntroduceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.label1.textColor = COLOR_STRING(@"#999999");
    self.label2.textColor = COLOR_STRING(@"#2F2F2F");
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
