//
//  IntroductionListCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/9/29.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "IntroductionListCell.h"
#import "UIImageView+WebCache.h"
#import "English_Header.h"
@interface IntroductionListCell()
@property(nonatomic,strong)NSMutableArray *scaleArray;
@end
@implementation IntroductionListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(NSMutableArray *)scaleArray
{
    if (!_scaleArray) {
        _scaleArray = [NSMutableArray array];
    }
    return _scaleArray;
}
-(void)setIntroductionList:(NSArray *)introductionList
{
   
    _introductionList = introductionList;
   
    if (!introductionList.count) {
        return;
    }
    
    dispatch_group_t group = dispatch_group_create();

    for (NSInteger i=0; i<introductionList.count; i++) {
        UIImageView *imageview = [[UIImageView alloc]init];
        imageview.tag = 100 + i;
        [self addSubview:imageview];
        dispatch_group_enter(group);
        [imageview sd_setImageWithURL:[NSURL URLWithString:introductionList[i]] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            dispatch_group_leave(group);
            CGSize size = image.size;
            CGFloat w = size.width;
            CGFloat H = size.height;
            CGFloat scale = H/w;
//            NSLog(@"scale====>%f",scale);
            [self.scaleArray addObject:[NSNumber numberWithFloat:scale]];
            
            
        }];
        
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        NSLog(@"主线程!!!!");
//        NSLog(@"self.scaleArray====>%@",self.scaleArray);
        [self addContraints];
    });
}
-(void)addContraints{
    
    CGFloat totalHeight = 0;
     for (NSInteger i=0; i<self.introductionList.count; i++) {
         CGFloat scale = [self.scaleArray[i] floatValue];
         CGFloat temp = SCREEN_WIDTH;
         CGFloat height = temp * scale;
         totalHeight = totalHeight + height;
         UIImageView *imageview = (UIImageView*)[self viewWithTag:i+100];
         UIImageView *imageview1 = nil;
         if (i>0) {
             imageview1= (UIImageView*)[self viewWithTag:i+99];
         }
         [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
             if (i == 0)
             {
                 make.top.mas_equalTo(self.mas_top);
             }else
             {
                 make.top.mas_equalTo(imageview1.mas_bottom);
             }
             make.left.mas_equalTo(self.mas_left);
             make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, height));
             
         }];
         
     }
     [self eventName:IntroductionListCell_Height_Event Params:[NSNumber numberWithFloat:totalHeight]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
