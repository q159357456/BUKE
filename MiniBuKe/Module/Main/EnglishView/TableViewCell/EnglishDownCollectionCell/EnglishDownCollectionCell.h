//
//  EnglishDownCollectionCell.h
//  MiniBuKe
//
//  Created by chenheng on 2018/9/12.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Series.h"
#import "TeachingProperties.h"
@interface EnglishDownCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property(nonatomic,strong)Series *series;
@property(nonatomic,strong)TeachingProperties *teachingProperties;
@end
