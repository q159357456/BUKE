//
//  EnglishUpCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/9/12.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "EnglishUpCell.h"
#import "MiniBuKe-Swift.h"
#import "UIImageView+WebCache.h"
@interface EnglishUpCell()<ClickImageLableDelegate>
@end
@implementation EnglishUpCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        
    }
    return self;
}
-(void)setTeaching_Catagory_List:(NSArray *)Teaching_Catagory_List
{
    _Teaching_Catagory_List = Teaching_Catagory_List;
    [self initsubview];
}

-(void)initsubview
{
    CGFloat line=SCALE(22.1);
    CGFloat colum= 10;
    CGFloat x=0;
    CGFloat y=0;
    CGFloat w=SCALE((375 -4*line)/ 3);
    CGFloat h=SCALE(100);
    for (NSInteger i =0; i<6; i++) {
        
        x = line + (w + line)*(i%3);
        y = colum + (colum + h)*(i/3);
        Image_lable_view *view = [[Image_lable_view alloc]initWithFrame:CGRectMake(x, y, w, h)];
        view.tag = i +100;
        view.delegate = self;
        [self addSubview:view];
        view.label.font = [UIFont systemFontOfSize:SCALE(13) weight:UIFontWeightRegular];
        view.label.textColor = COLOR_STRING(@"#232323");
        if (i< 5) {
            Teaching_Catagory *model = self.Teaching_Catagory_List[i];
            view.label.text = model.categoryName;
            [view.imageview sd_setImageWithURL:[NSURL URLWithString:[model.logo stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"首页_丛书系列_图片默认"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSLog(@"sd_setImageWithURL ===> %@",error);
                if (image) {
                    [view.imageview setImage:image];
                }
            }];
        }else
        {
            //english_more@2x
            view.label.text = @"查看更多";
            view.imageview.image = [UIImage imageNamed:@"english_more"];
        }
        
    }
    
}

-(void)ClickImageLableWithImage_lable:(Image_lable_view *)image_lable
{
    if (image_lable.tag == 105) {
         [self eventName:EnglishUpCell_Event Params:nil];
    }else
    {
        Teaching_Catagory *model = self.Teaching_Catagory_List[image_lable.tag - 100];
         [self eventName:EnglishUpCell_Event Params:model];
    }
    
   
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
