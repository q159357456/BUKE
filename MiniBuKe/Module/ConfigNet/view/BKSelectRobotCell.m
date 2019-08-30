//
//  BKSelectRobotCell.m
//  MiniBuKe
//
//  Created by chenheng on 2019/1/29.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKSelectRobotCell.h"

@interface BKSelectRobotCell()

@property (nonatomic, weak) IBOutlet UIImageView *iconImage;
@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UIView *bottomView;

@end

@implementation BKSelectRobotCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"BKSelectRobotCell" owner:nil options:nil] lastObject];
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bottomView.layer.cornerRadius = 9.f;
    self.bottomView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupUI{
    
}

+ (CGFloat)heightForCellWithObject:(id)obj{
    return SCREEN_WIDTH*(120.f/375.f)+5+8;
}

- (void)setModelWithRobotFlag:(NSInteger)index{
    if (index == 0) {
        self.iconImage.image = [UIImage imageNamed:@"binging_select_robot4"];
        self.title.text = @"Chill";
    }else if (index == 1){
        self.iconImage.image = [UIImage imageNamed:@"binging_select_robot1"];
        self.title.text = @"小布壳Q1";
    }else if (index == 2){
        self.iconImage.image = [UIImage imageNamed:@"binging_select_robot2"];
        self.title.text = @"小布壳Super";
    }else if (index == 3){
        self.iconImage.image = [UIImage imageNamed:@"binging_select_robot3"];
        self.title.text = @"小布壳 Baby Care";
    }
}

@end
