//
//  BKHomeBookCollectionViewCell.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/1.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstensiveDetailModel.h"
@class homeSeriesBookModel;

NS_ASSUME_NONNULL_BEGIN

@interface BKHomeBookCollectionViewCell : UICollectionViewCell

+ (instancetype)BKHomeBookCollectionViewCellWithCollectionView:(UICollectionView *)collectionView andIndexPath:(NSIndexPath *)indexpath;

-(void)setModelWith:(homeSeriesBookModel*)bookmodel;
@property(nonatomic,strong)IntensiveBookModel *intensiveBookModel;

- (void)setReadingNumberWith:(NSInteger)number;
@end

NS_ASSUME_NONNULL_END
