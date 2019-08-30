//
//  TeachingMaterialCollectionCell.h
//  MiniBuKe
//
//  Created by chenheng on 2018/9/18.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Teaching_Catagory.h"
@interface TeachingMaterialCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property(nonatomic,strong)Teaching_Catagory *teaching_Catagory;
@end
