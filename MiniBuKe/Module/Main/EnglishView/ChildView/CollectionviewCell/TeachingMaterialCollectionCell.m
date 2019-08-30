//
//  TeachingMaterialCollectionCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/9/18.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "TeachingMaterialCollectionCell.h"

@implementation TeachingMaterialCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setImageview:(UIImageView *)imageview
{
    _imageview = imageview;
    
}

-(void)setTeaching_Catagory:(Teaching_Catagory *)teaching_Catagory
{
    _teaching_Catagory = teaching_Catagory;
    if (!teaching_Catagory.teachingId) {
        self.imageview.image = [UIImage imageNamed:teaching_Catagory.logo];
    }else
    {
        [self.imageview sd_setImageWithURL:[NSURL URLWithString:[teaching_Catagory.logo stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"首页_丛书系列_图片默认"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            NSLog(@"sd_setImageWithURL ===> %@",error);
            if (image) {
                [self.imageview setImage:image];
            }
        }];
    }
   
    
    self.label.text = [NSString stringWithFormat:@"%@",teaching_Catagory.categoryName.length?teaching_Catagory.categoryName:@""];
    
}
@end
