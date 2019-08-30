//
//  BKHomeBookSelectionCell.h
//  MiniBuKe
//
//  Created by chenheng on 2019/1/21.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKBaseTableViewCell.h"
#import "BKHomeListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BKHomeBookSelectionCell : BKBaseTableViewCell

- (void)setImageWithIndex:(NSInteger)index andModel:(recommendBookModel*)model;

@end

NS_ASSUME_NONNULL_END
