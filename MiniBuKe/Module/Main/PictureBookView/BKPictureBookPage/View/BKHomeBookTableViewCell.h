//
//  BKHomeBookTableViewCell.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/1.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKBaseTableViewCell.h"
@class seriesBookDataModel;
NS_ASSUME_NONNULL_BEGIN
@protocol BKHomeBookCellDelegate <NSObject>

-(void)BKHomeBookClickWith:(NSString*)bookid;

@end
@interface BKHomeBookTableViewCell : BKBaseTableViewCell

@property(nonatomic, strong) UICollectionView *myCollectionView;

- (void)setModelWith:(seriesBookDataModel*)data;

@property(nonatomic, assign) id <BKHomeBookCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
