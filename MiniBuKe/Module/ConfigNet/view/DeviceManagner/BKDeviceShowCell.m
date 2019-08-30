//
//  BKDeviceShowCell.m
//  MiniBuKe
//
//  Created by chenheng on 2019/1/29.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKDeviceShowCell.h"

@interface BKDeviceShowCell()
@property (nonatomic, weak) IBOutlet UILabel *SNLabel;
@property (nonatomic, weak) IBOutlet UILabel *SysinfoLabel;

@end

@implementation BKDeviceShowCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"BKDeviceShowCell" owner:nil options:nil] lastObject];
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
+ (CGFloat)heightForCellWithObject:(id)obj{

    return 112.f;
}
- (void)setModelWithSN:(NSString*)sninfo andSysInfo:(NSString*)sysinfo{
    if (sninfo.length) {
        
        self.SNLabel.text = sninfo;
        self.SysinfoLabel.text = sysinfo;
    }else{
        self.SNLabel.text = @"";
        self.SysinfoLabel.text = @"";
    }
}

-(IBAction)click:(id)sender{
    
}
@end
