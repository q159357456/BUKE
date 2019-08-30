//
//  SeriesBookCoverCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/9/19.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "SeriesBookCoverCell.h"
#import "UIImageView+WebCache.h"
#import "English_Header.h"
@implementation SeriesBookCoverCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cover_Top.constant = SCALE(14);
    self.cover_With.constant = SCALE(98);
    self.cover_Leading.constant = SCALE(25);
    self.view_Top.constant = SCALE(160);
    self.x_view.layer.cornerRadius = 1;
    self.x_view_Leading.constant = SCALE(28);
//    self.cover_imageview.backgroundColor = [UIColor redColor];
   
    // Initialization code
}
-(void)setTeaching_detail:(TeachingDetail *)teaching_detail
{
    _teaching_detail = teaching_detail;
    self.teaching_namelabel.text = teaching_detail.teachingName;
    self.teaching_authorlabel.text = [NSString stringWithFormat:@"作者:  %@",teaching_detail.author];
    self.teaching_publiclabel.text = [NSString stringWithFormat:@"出版社: %@",teaching_detail.publisher];
    self.teaching_nationlable.text = [NSString stringWithFormat:@"国籍: %@",teaching_detail.country];
    [self.cover_imageview sd_setImageWithURL:[NSURL URLWithString:[teaching_detail.cover stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"首页_丛书系列_图片默认"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"sd_setImageWithURL ===> %@",error);
        if (image) {
            [self.cover_imageview setImage:image];
        }
    }];
    
    
    [self creat_realation_viewWith:teaching_detail.otherTeachingList];
    
    
}
-(void)creat_realation_viewWith:(NSArray*)data{

    NSArray *colorlist = @[@"#FA6573",@"#51CBC2",@"#EFBE1E"];
    for (NSInteger i=0; i<data.count; i++) {
        Teaching_Catagory *model = data[i];
        UILabel *lable= [[UILabel alloc]init];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.text = model.categoryName;
        lable.textColor = [UIColor whiteColor];
        lable.font = [UIFont systemFontOfSize:SCALE(11)];
        lable.layer.cornerRadius = 11;
        lable.layer.masksToBounds =YES;
        lable.tag = i + 100;
        lable.backgroundColor = COLOR_STRING(colorlist[i]);
        [self.teaching_relationview addSubview:lable];
//    NSLog(@"self.teaching_relationview====>%f",self.teaching_relationview.frame.size.width);
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SCALE(110)*i);
            make.width.mas_equalTo(SCALE(90));
            make.height.mas_equalTo(SCALE(20));
            make.centerY.mas_equalTo(self.teaching_relationview.mas_centerY);
            
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(relation:)];
        lable.userInteractionEnabled = YES;
        [lable addGestureRecognizer:tap];
      
    }
    
}
-(void)layoutSubviews
{
    
}
-(void)relation:(UITapGestureRecognizer*)tap{
    
    Teaching_Catagory *model = self.teaching_detail.otherTeachingList[tap.view.tag - 100];
    [self eventName:SeriesBookCoverCell_Event Params:model];
    
    
    
    
}


-(void)setTeaching_namelabel:(UILabel *)teaching_namelabel
{
    _teaching_namelabel = teaching_namelabel;
    _teaching_namelabel.font = [UIFont systemFontOfSize:SCALE(14) weight:UIFontWeightMedium];
}
-(void)setTeaching_authorlabel:(UILabel *)teaching_authorlabel
{
    _teaching_authorlabel = teaching_authorlabel;
    _teaching_authorlabel.font = [UIFont systemFontOfSize:SCALE(11) weight:UIFontWeightRegular];
}
-(void)setTeaching_nationlable:(UILabel *)teaching_nationlable
{
    _teaching_nationlable = teaching_nationlable;
    _teaching_nationlable.font = [UIFont systemFontOfSize:SCALE(11) weight:UIFontWeightRegular];
}
-(void)setTeaching_publiclabel:(UILabel *)teaching_publiclabel
{
    _teaching_publiclabel = teaching_publiclabel;
    _teaching_publiclabel.font = [UIFont systemFontOfSize:SCALE(11) weight:UIFontWeightRegular];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
