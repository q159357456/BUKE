//
//  IntensFootViewCell.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/2.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstensiveDetailModel.h"
#define IntensFootViewCell_Event @"IntensFootViewCell_Event"
NS_ASSUME_NONNULL_BEGIN

@interface IntensFootViewCell : UITableViewCell
@property(nonatomic, strong) UICollectionView *myCollectionView;
@property(nonatomic,strong)InstensiveDetailModel *instensiveDetailModel;
+ (CGFloat)heightForCellWithObject:(id)obj;
@end

NS_ASSUME_NONNULL_END
