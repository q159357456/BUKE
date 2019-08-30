//
//  PropertiesaTbleViewCell.h
//  MiniBuKe
//
//  Created by chenheng on 2018/9/20.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#define JianGe SCALE(5)
#define size_w (SCREEN_WIDTH - JianGe*3 -SCALE(18))/3.00
#define Property_Size_Height  size_w * 140.00 / 105.00 + 36.00
#define PropertiesaTbleViewCell_Event @"PropertiesaTbleViewCell_Event"
@interface PropertiesaTbleViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;
@property(nonatomic,strong)NSArray *property_list;
@end
