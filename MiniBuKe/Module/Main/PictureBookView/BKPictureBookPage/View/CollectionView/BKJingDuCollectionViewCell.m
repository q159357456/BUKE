//
//  BKJingDuCollectionViewCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/1.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKJingDuCollectionViewCell.h"
#import "BKHomeListModel.h"

@interface BKJingDuCollectionViewCell()

@property(nonatomic, weak) IBOutlet UILabel *updateTimeLabeltext;

@property(nonatomic, weak) IBOutlet UILabel *updateTimeLabel;
@property(nonatomic, weak) IBOutlet UIButton *tipBtn1;
@property(nonatomic, weak) IBOutlet UIButton *tipBtn2;
@property(nonatomic, weak) IBOutlet UIButton *tipBtn3;

@property(nonatomic, weak) IBOutlet UILabel *title;
@property(nonatomic, weak) IBOutlet UILabel *subTitle;
@property(nonatomic, weak) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIView *blackeView;
@property (weak, nonatomic) IBOutlet UIView *heightLview;
@end

@implementation BKJingDuCollectionViewCell

+ (instancetype)BKJingDuCollectionCellWithCollectionView:(UICollectionView *)collectionView andIndexPath:(NSIndexPath *)indexpath{
    NSString * identify = NSStringFromClass([self class]);
    return [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexpath];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.blackeView.backgroundColor = A_COLOR_STRING(0x070707, 0.1);
    self.heightLview.backgroundColor = A_COLOR_STRING(0xFFFFFF, 0.1);
    
    self.backgroundColor = COLOR_STRING(@"#F7F9FB");
    self.layer.cornerRadius = 9;
    self.layer.borderWidth = 1;
    self.layer.borderColor = COLOR_STRING(@"#EAEAEA").CGColor;
    
    UIBezierPath *maskPath= [UIBezierPath bezierPathWithRoundedRect:self.updateTimeLabel.bounds
                                                    byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight
                                                          cornerRadii:CGSizeMake(9,9)];
    CAShapeLayer*maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.updateTimeLabel.bounds;
    maskLayer.path = maskPath.CGPath;
    self.updateTimeLabel.layer.mask = maskLayer;
    
    UIBezierPath *maskPath1= [UIBezierPath bezierPathWithRoundedRect:self.imageView.bounds
                                                  byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight
                                                        cornerRadii:CGSizeMake(9,9)];
    CAShapeLayer*maskLayer1 = [[CAShapeLayer alloc]init];
    maskLayer1.frame = self.imageView.bounds;
    maskLayer1.path = maskPath1.CGPath;
    self.imageView.layer.mask = maskLayer1;
    
    self.tipBtn1.layer.borderWidth =0.5;
    self.tipBtn1.layer.borderColor = COLOR_STRING(@"#66C85E").CGColor;
    self.tipBtn1.layer.cornerRadius = 5;
    self.tipBtn2.layer.borderWidth =0.5;
    self.tipBtn2.layer.borderColor = COLOR_STRING(@"#66C85E").CGColor;
    self.tipBtn2.layer.cornerRadius = 5;
    self.tipBtn3.layer.borderWidth =0.5;
    self.tipBtn3.layer.borderColor = COLOR_STRING(@"#66C85E").CGColor;
    self.tipBtn3.layer.cornerRadius = 5;
    self.tipBtn1.hidden = YES;
    self.tipBtn2.hidden = YES;
    self.tipBtn3.hidden = YES;
    self.updateTimeLabel.hidden = YES;
    self.updateTimeLabeltext.hidden = YES;
}

- (void)setModelWith:(themeDataModel*)model{
    
    self.title.text = [NSString stringWithFormat:@"《%@》",model.bookName];
    self.subTitle.text = model.themeTitle;

    CGFloat width = (74*[UIScreen mainScreen].scale);
    NSString *picurl = [NSString stringWithFormat:@"%@?x-oss-process=image/resize,w_%d",model.cover,(int)width];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:picurl] placeholderImage:nil options:SDWebImageRetryFailed];
    if (model.forAge.length) {
        [self.tipBtn1 setTitle:[NSString stringWithFormat:@"%@",model.forAge] forState:UIControlStateNormal];
        self.tipBtn1.hidden = NO;
    }
    if (model.categoryTag.length) {
        
        [self.tipBtn2 setTitle:[NSString stringWithFormat:@"%@",model.categoryTag] forState:UIControlStateNormal];
        self.tipBtn2.hidden = NO;

    }
    if (model.themeTag.length) {
        
        [self.tipBtn3 setTitle:[NSString stringWithFormat:@"%@",model.themeTag] forState:UIControlStateNormal];
        self.tipBtn3.hidden = NO;
    }
    
    self.updateTimeLabel.hidden = NO;
    self.updateTimeLabeltext.hidden = NO;
    self.updateTimeLabeltext.text = [self getTimeWithSamp:model.updateTime/1000];
    self.updateTimeLabel.text = [self getTimeWithSamp:model.updateTime/1000];

}

-(NSString*)getTimeWithSamp:(NSInteger)timeSamp{
    NSTimeInterval time = timeSamp;
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日更新"];
    NSString * currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}
@end
