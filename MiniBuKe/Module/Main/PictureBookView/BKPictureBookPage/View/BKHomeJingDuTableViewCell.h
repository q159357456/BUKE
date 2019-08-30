//
//  BKHomeJingDuTableViewCell.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/1.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKBaseTableViewCell.h"
#import "InstensiveDetailModel.h"
@class themeData;

NS_ASSUME_NONNULL_BEGIN

@protocol BKHomeJingDuCellDelegate <NSObject>

-(void)BKHomeJingDuClickWith:(NSString*)bookid;

@end
@interface BKHomeJingDuTableViewCell : BKBaseTableViewCell

@property(nonatomic, strong) UICollectionView *myCollectionView;

- (void)setModelWith:(themeData*)data;

@property(nonatomic, assign) id <BKHomeJingDuCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
