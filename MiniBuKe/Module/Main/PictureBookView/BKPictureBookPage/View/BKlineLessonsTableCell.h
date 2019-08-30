//
//  BKlineLessonsTableCell.h
//  MiniBuKe
//
//  Created by chenheng on 2019/7/23.
//  Copyright © 2019 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKBaseTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN
@class LineLessonsData;
@interface BKlineLessonsTableCell : BKBaseTableViewCell
- (void)setModelWith:(LineLessonsData*)data;
@property(nonatomic, strong) UICollectionView *myCollectionView;
@end

NS_ASSUME_NONNULL_END
