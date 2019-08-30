//
//  BKCallReocrdCell.h
//  MiniBuKe
//
//  Created by chenheng on 2019/5/5.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKBaseTableViewCell.h"
#import "BKSNCallRecordsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BKCallReocrdCell : BKBaseTableViewCell

- (void)setModelWith:(recordModel*)model;

@end

NS_ASSUME_NONNULL_END
