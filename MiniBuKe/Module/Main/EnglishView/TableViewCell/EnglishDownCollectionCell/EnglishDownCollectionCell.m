//
//  EnglishDownCollectionCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/9/12.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "EnglishDownCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "English_Header.h"
@interface EnglishDownCollectionCell()
@property (weak, nonatomic) IBOutlet UIView *blackeView;
@property (weak, nonatomic) IBOutlet UIView *heightLview;
@end
@implementation EnglishDownCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.blackeView.backgroundColor = A_COLOR_STRING(0x070707, 0.1);
    self.heightLview.backgroundColor = A_COLOR_STRING(0xFFFFFF, 0.1);

  
    
    // Initialization code
}

-(void)setLabel:(UILabel *)label
{
    _label = label;
    label.font = [UIFont systemFontOfSize:SCALE(12.5) weight:UIFontWeightRegular];
    label.textColor = [UIColor colorWithRed:47/255.0 green:47/255.0 blue:47/255.0 alpha:1];
}
-(void)setSeries:(Series *)series
{
    _series = series;
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:[series.bookPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"首页_丛书系列_图片默认"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"sd_setImageWithURL ===> %@",error);
        if (image) {
            [self.imageview setImage:image];
        }
    }];
    self.label.text = _series.bookName;
}

-(void)setTeachingProperties:(TeachingProperties *)teachingProperties
{
    _teachingProperties = teachingProperties;
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:[teachingProperties.coverPic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"首页_丛书系列_图片默认"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"sd_setImageWithURL ===> %@",error);
        if (image) {
            [self.imageview setImage:image];
        }
    }];
    self.label.text = teachingProperties.name;
    
}
@end
