//
//  BKRecordedLessonCell.m
//  MiniBuKe
//
//  Created by chenheng on 2019/7/22.
//  Copyright © 2019 深圳偶家科技有限公司. All rights reserved.
//

#import "BKRecordedLessonCell.h"
#define  Angle(x) (M_PI * (x) / 180.0)
@class LineLessonsTip;
@interface BKRecordedLessonCell()
@property(nonatomic,strong)UIImageView * titleImg;
@property(nonatomic,strong)UILabel * title;
@property(nonatomic,strong)UIView * topTipsView;
@property(nonatomic,strong)UIView * bottomTipsView;
@property(nonatomic,strong)UILabel * price;
@property(nonatomic,strong)UIImageView * topTagView;
@end
@implementation BKRecordedLessonCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
-(void)setUI{

    UIView * backView = [[UIView alloc]init];
    [self addSubview:backView];
    backView.layer.cornerRadius  = SCALE(9);
    backView.layer.masksToBounds = NO;
    backView.backgroundColor = [UIColor whiteColor];
    backView .layer.shadowColor = COLOR_STRING(@"#eaeaea").CGColor;
        // 阴影偏移量 默认为(0,3)
    backView .layer.shadowOffset = CGSizeMake(0, 3);
        // 阴影透明度
    backView .layer.shadowOpacity = 1;
    backView.layer.shadowRadius  = SCALE(9);

    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0  ));
    }];
    self.titleImg = [[UIImageView alloc]init];
    self.title = [[UILabel alloc]init];
    self.price = [[UILabel alloc]init];
//    self.topTipsView = [[UIView alloc]init];
    self.bottomTipsView = [[UIView alloc]init];
    self.topTagView = [[UIImageView alloc]init];
    
    self.topTagView.frame = CGRectMake(SCALE(243 - 51), 0, SCALE(41),SCALE(21));
//    self.topTipsView.frame = CGRectMake(0, 0, SCALE(234),SCALE(21));
    self.titleImg.frame = CGRectMake(0, 0, SCALE(243), SCALE(137));
    self.title.frame = CGRectMake(10, CGRectGetMaxY(self.titleImg.frame)+SCALE(15),SCALE(243)-20 , SCALE(15));
    self.bottomTipsView.frame = CGRectMake(10, CGRectGetMaxY(self.title.frame)+SCALE(9), SCALE(243)-20, SCALE(15));
    self.price.frame = CGRectMake(10, CGRectGetMaxY(self.bottomTipsView.frame)+SCALE(15), SCALE(243)-20, SCALE(15));
    [self addSubview:self.titleImg];
    [self addSubview:self.title];
    [self addSubview:self.bottomTipsView];
    [self addSubview:self.price];
    [self addSubview:self.topTagView];
    self.price.textColor = COLOR_STRING(@"#FF630A");
    self.price.font = [UIFont boldSystemFontOfSize:SCALE(18)];
    self.title.font = [UIFont boldSystemFontOfSize:SCALE(17)];
    
//    self.topTagView.backgroundColor = [UIColor redColor];
    
}
-(void)setModelWith:(LineLessonsModel *)model
{
    
    NSLog(@"model.tags==>%@",model.tags);
    [self.titleImg sd_setImageWithURL:[NSURL URLWithString:model.smallPic] placeholderImage:nil options:SDWebImageRetryFailed];
    self.title.text = model.courseName;
    self.price.text = [NSString stringWithFormat:@"%@讲/￥%@",model.courseNum,model.price];
    switch (model.tags.integerValue) {
        case 1:
            
            break;
        case 2:
        
            break;
        case 3:
           
            break;
        case 4:
            self.topTagView.image = [UIImage imageNamed:@"video_new_icon"];
            break;
        case 5:
            self.topTagView.image = [UIImage imageNamed:@"video_update_icon"];
            break;
        case 6:
            self.topTagView.image = [UIImage imageNamed:@"video_end_icon"];
            break;

        default:
            break;
    }
    
    for (UIView * view in self.bottomTipsView.subviews) {
        [view removeFromSuperview];
    }
    NSString * str1 = model.courseType;
    NSString * str2 = [NSString stringWithFormat:@"%@-%@岁",model.startAge,model.endAge];
    LineLessonsTip * label1 = [[LineLessonsTip alloc]init];
    LineLessonsTip * label2 = [[LineLessonsTip alloc]init];
    label1.font = [UIFont systemFontOfSize:SCALE(10)];
    label2.font = [UIFont systemFontOfSize:SCALE(10)];
    label1.backgroundColor = COLOR_STRING(@"F8FFFB");
    label2.backgroundColor = COLOR_STRING(@"F8FFFB");
    label1.textColor = COLOR_STRING(@"4FD37E");
    label2.textColor = COLOR_STRING(@"4FD37E");
    label1.text = str1;
    label2.text = str2;
    label1.textAlignment = NSTextAlignmentCenter;
    label2.textAlignment = NSTextAlignmentCenter;
    CGSize size1 = [label1 sizeThatFits:CGSizeZero];
    CGSize size2 = [label2 sizeThatFits:CGSizeZero];
    label1.frame = CGRectMake(0, 0, size1.width+12, self.bottomTipsView.frame.size.height);
    label2.frame = CGRectMake(CGRectGetMaxX(label1.frame)+5, 0, size2.width+12, self.bottomTipsView.frame.size.height);
    [self.bottomTipsView addSubview:label1];
    [self.bottomTipsView addSubview:label2];
    self.bottomTipsView.backgroundColor = [UIColor whiteColor];
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    // 阴影颜色
  
}
@end

@implementation LineLessonsTip

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    CGFloat r = SCALE(8);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);
    CGContextSetStrokeColorWithColor(context, COLOR_STRING(@"4FD37E").CGColor);
    CGContextMoveToPoint(context, 0, h);
    CGContextAddArcToPoint(context, w, h, w, h-r, r);
    CGContextAddLineToPoint(context, w, 0);
    CGContextAddArcToPoint(context, 0, 0, 0, r, r);
    CGContextAddLineToPoint(context, 0, h);
    CGContextDrawPath(context, kCGPathStroke);
}


@end
