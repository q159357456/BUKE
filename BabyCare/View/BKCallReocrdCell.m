//
//  BKCallReocrdCell.m
//  MiniBuKe
//
//  Created by chenheng on 2019/5/5.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKCallReocrdCell.h"
#import "NSDate+XBK.h"
//bc_callRecord_in
@interface BKCallReocrdCell()

@property (nonatomic, weak) IBOutlet UIImageView *iconView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

@end

@implementation BKCallReocrdCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"BKCallReocrdCell" owner:nil options:nil] lastObject];
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupUI{
    
}

+ (CGFloat)heightForCellWithObject:(id)obj{
    return 72.f;
}

//转换时间戳为特殊样式字符串
//- (NSString*)changeTimeStyleWithtimestamp:(NSString*)timeStr{
//    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
//    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *confromTimesp =[dateFormat dateFromString:timeStr];
//    //    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
//    return  [confromTimesp DateTransformTimeStr];
//}

- (void)setModelWith:(recordModel*)model{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[model.createTime integerValue]];
    self.timeLabel.text = [confromTimesp DateTransformTimeStr];

    if (0 == [model.whoStart integerValue]) {
        self.titleLabel.text = [NSString stringWithFormat:@"宝贝呼叫了%@",model.relationship];
        self.iconView.image = [UIImage imageNamed:@"bc_callRecord_out"];
    }else if (1 == [model.whoStart integerValue]){
        self.titleLabel.text = [NSString stringWithFormat:@"%@呼叫了宝贝",model.relationship];
        self.iconView.image = [UIImage imageNamed:@"bc_callRecord_in"];
    }
    
    if (0 == [model.state integerValue]) {
        self.subtitleLabel.text = @"未接通";
        self.titleLabel.textColor = COLOR_STRING(@"#F04348");
        self.subtitleLabel.textColor = COLOR_STRING(@"#F04348");
        self.iconView.hidden = YES;
    }else if (1 == [model.state integerValue]){
        self.subtitleLabel.text = @"已接听";
        self.titleLabel.textColor = COLOR_STRING(@"#2F2F2F");
        self.subtitleLabel.textColor = COLOR_STRING(@"#999999");
        self.iconView.hidden = NO;

    }else if (2 == [model.state integerValue]){
        self.iconView.hidden = NO;
        self.subtitleLabel.text = @"已挂断";
        self.titleLabel.textColor = COLOR_STRING(@"#2F2F2F");
        self.subtitleLabel.textColor = COLOR_STRING(@"#999999");
    }
}

@end
