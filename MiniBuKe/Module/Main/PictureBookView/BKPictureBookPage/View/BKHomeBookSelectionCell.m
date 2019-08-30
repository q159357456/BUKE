//
//  BKHomeBookSelectionCell.m
//  MiniBuKe
//
//  Created by chenheng on 2019/1/21.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKHomeBookSelectionCell.h"

@interface BKHomeBookSelectionCell()
@property (nonatomic, weak) IBOutlet UIImageView *backImage;
@property (nonatomic, weak) IBOutlet UIImageView *topArrow;
@property (nonatomic, weak) IBOutlet UIImageView *bottomArrow;
@property (nonatomic, weak) IBOutlet UIImageView *topCover;
@property (nonatomic, weak) IBOutlet UIImageView *midCover;
@property (nonatomic, weak) IBOutlet UIImageView *bottomCover;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UILabel *authorLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentoffset;

@end

@implementation BKHomeBookSelectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"BKHomeBookSelectionCell" owner:nil options:nil] lastObject];
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.topCover.layer.cornerRadius = 4.f;
    self.topCover.clipsToBounds = YES;
    self.midCover.layer.cornerRadius = 4.f;
    self.midCover.clipsToBounds = YES;
    self.bottomCover.layer.cornerRadius = 4.f;
    self.bottomCover.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupUI{
    
}

+ (CGFloat)heightForCellWithObject:(id)obj{
    return SCREEN_WIDTH*(120.f/375.f)+8;
}

- (void)setImageWithIndex:(NSInteger)index andModel:(recommendBookModel*)model{

    if (index<=2) {
        
        self.bottomArrow.image = [UIImage imageNamed:[NSString stringWithFormat:@"home_BookSelection_arrowbottom_%ld",index+1]];
        self.topArrow.image = [UIImage imageNamed:[NSString stringWithFormat:@"home_BookSelection_arrowtop_%ld",index+1]];
        self.backImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"home_BookSelection_back_%ld",index+1]];
    }else{
        
        self.bottomArrow.image = [UIImage imageNamed:[NSString stringWithFormat:@"home_BookSelection_arrowbottom_%@",@"1"]];
        self.topArrow.image = [UIImage imageNamed:[NSString stringWithFormat:@"home_BookSelection_arrowtop_%@",@"1"]];
        self.backImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"home_BookSelection_back_%@",@"1"]];
    }
    
    
    NSString *content = model.saying;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 2;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:self.contentLabel.font,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    self.contentLabel.attributedText = [[NSAttributedString alloc] initWithString:content attributes:attributes];
    self.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [self changeNSLayoutConstraintWith:self.contentLabel.text];
    
    self.titleLabel.text = model.recommendName;
    self.authorLabel.text = [NSString stringWithFormat:@"——%@",model.sayingAuthor];
    
     NSArray *picArray = [model.recommendCover componentsSeparatedByString:@","];
    
    CGFloat height = (([BKHomeBookSelectionCell heightForCellWithObject:nil]-34)*[UIScreen mainScreen].scale);
    NSString *picurl1 = [NSString stringWithFormat:@"%@?x-oss-process=image/resize,h_%d",picArray.firstObject,(int)height];
    NSString *picurl2 = [NSString stringWithFormat:@"%@?x-oss-process=image/resize,h_%d",picArray[1],(int)height];
    NSString *picurl3 = [NSString stringWithFormat:@"%@?x-oss-process=image/resize,h_%d",picArray.lastObject,(int)height];

    [self.topCover sd_setImageWithURL:[NSURL URLWithString:picurl1] placeholderImage:[UIImage imageNamed:@"home_BookSelection_coverdefaul"]];
    [self.midCover sd_setImageWithURL:[NSURL URLWithString:picurl2] placeholderImage:[UIImage imageNamed:@"home_BookSelection_coverdefaul"]];
    [self.bottomCover sd_setImageWithURL:[NSURL URLWithString:picurl3] placeholderImage:[UIImage imageNamed:@"home_BookSelection_coverdefaul"]];
}

- (CGFloat)contentLabeMaxWidth{
    return SCREEN_WIDTH-((SCREEN_WIDTH*(120.f/375.f)+8-34.f)*(70.f/94.f)+30.f+16.f+29.f+70.f);
}

- (void)changeNSLayoutConstraintWith:(NSString*)text{
    CGFloat conentlinHeight = [self.contentLabel.font lineHeight];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary * attributes = @{
                                  NSFontAttributeName:self.contentLabel.font,
                                  NSParagraphStyleAttributeName: paragraphStyle
                                  };
    CGSize textRect = CGSizeMake([self contentLabeMaxWidth], MAXFLOAT);
    CGFloat textHeight = [text boundingRectWithSize: textRect
                                           options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                        attributes:attributes
                                           context:nil].size.height;
    if (textHeight > conentlinHeight) {
        self.contentoffset.constant = -8.f;
    }else{
        self.contentoffset.constant = 0.f;
    }
}

@end
