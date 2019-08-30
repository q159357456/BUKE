//
//  BKBaseTableViewCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/1.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKBaseTableViewCell.h"

@implementation BKBaseTableViewCell

+ (instancetype)BKBaseTableViewCellWithTableView:(UITableView *)tableView{
    NSString * identify = NSStringFromClass([self class]);
    return [tableView dequeueReusableCellWithIdentifier:identify];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //纯代码布局cell内部控件
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma mark -  子类重新
+ (CGFloat)heightForCellWithObject:(id __nullable)obj{
    return 0;
}

- (void)setupUI{
    //初始化UI
}

@end
