//
//  SeriesBookCoverNoneCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/9/26.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "SeriesBookCoverNoneCell.h"
#import "UIImageView+WebCache.h"
#import "English_Header.h"
@implementation SeriesBookCoverNoneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cover_Top.constant = SCALE(14);
    self.cover_With.constant = SCALE(98);
    self.cover_Leading.constant = SCALE(20);
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
    
 
    
    
}
-(void)setTeaching_namelabel:(UILabel *)teaching_namelabel
{
    _teaching_namelabel = teaching_namelabel;
    _teaching_namelabel.font = [UIFont systemFontOfSize:SCALE(14) weight:UIFontWeightMedium];
}
-(void)setTeaching_authorlabel:(UILabel *)teaching_authorlabel
{
    _teaching_authorlabel = teaching_authorlabel;
    _teaching_authorlabel.font = [UIFont systemFontOfSize:SCALE(11) weight:UIFontWeightMedium];
}
-(void)setTeaching_nationlable:(UILabel *)teaching_nationlable
{
    _teaching_nationlable = teaching_nationlable;
    _teaching_nationlable.font = [UIFont systemFontOfSize:SCALE(11) weight:UIFontWeightMedium];
}
-(void)setTeaching_publiclabel:(UILabel *)teaching_publiclabel
{
    _teaching_publiclabel = teaching_publiclabel;
    _teaching_publiclabel.font = [UIFont systemFontOfSize:SCALE(11) weight:UIFontWeightMedium];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
