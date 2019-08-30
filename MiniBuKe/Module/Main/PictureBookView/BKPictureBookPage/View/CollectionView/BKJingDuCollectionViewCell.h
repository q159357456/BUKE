//
//  BKJingDuCollectionViewCell.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/1.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class themeDataModel;

@interface BKJingDuCollectionViewCell : UICollectionViewCell

+ (instancetype)BKJingDuCollectionCellWithCollectionView:(UICollectionView *)collectionView andIndexPath:(NSIndexPath *)indexpath;
- (void)setModelWith:(themeDataModel*)model;
@end

NS_ASSUME_NONNULL_END
