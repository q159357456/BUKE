//
//  BKMessageActivityCell.h
//  MiniBuKe
//
//  Created by chenheng on 2018/12/27.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKBaseTableViewCell.h"
#import "XG_NoticeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BKMessageActivityCell : BKBaseTableViewCell

- (void)setDataModel:(XG_NoticeModel*)model;

@end

NS_ASSUME_NONNULL_END
