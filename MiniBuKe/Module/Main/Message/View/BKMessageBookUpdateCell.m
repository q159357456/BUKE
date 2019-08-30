//
//  BKMessageBookUpdateCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/12/27.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKMessageBookUpdateCell.h"

@interface BKMessageBookUpdateCell()
@property(nonatomic, weak) IBOutlet UIView *bottomView;
@property(nonatomic, weak) IBOutlet UIImageView *iconImage;
@property(nonatomic, weak) IBOutlet UILabel *titleLabel;
@property(nonatomic, weak) IBOutlet UILabel *timeLabel;
@property(nonatomic, weak) IBOutlet UIView *iconTip;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *widthConstraint;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *offConstraint;
@end

@implementation BKMessageBookUpdateCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"BKMessageBookUpdateCell" owner:nil options:nil] lastObject];
        //纯代码布局cell内部控件
        [self setupUI];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bottomView.layer.cornerRadius = 9.f;
    self.bottomView.clipsToBounds = YES;
    self.iconTip.layer.cornerRadius = 4.f;
    self.iconTip.clipsToBounds = YES;
    self.iconImage.layer.cornerRadius = 5.f;
    self.iconImage.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)heightForCellWithObject:(id)obj{
    return 153.f;
}

- (void)setupUI{
    //初始化UI
}

//转换时间戳为特殊样式字符串
- (NSString*)changeTimeStyleWithtimestamp:(NSString*)timeStr{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *confromTimesp =[dateFormat dateFromString:timeStr];
//    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    return  [confromTimesp DateTransformTimeStr];
}

- (void)setDataModel:(XG_NoticeModel*)model{
    if (model.content.length) {
        self.titleLabel.text = model.content;
    }
    if ([model.msgPic hasPrefix:@"http"]) {
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.msgPic] placeholderImage:nil options:SDWebImageRetryFailed];
    }
    if (model.pushStartTime.length) {
        if (model.receiveTime.length) {
            self.timeLabel.text = [self changeTimeStyleWithtimestamp:model.receiveTime];
        }else{
            self.timeLabel.text = [self changeTimeStyleWithtimestamp:model.pushStartTime];
        }
    }
    if (model.isRead) {
            self.widthConstraint.constant = 0.f;
            self.offConstraint.constant = 0.f;
    }else{
            self.widthConstraint.constant = 8.f;
            self.offConstraint.constant = 5.f;
    }
}

@end
