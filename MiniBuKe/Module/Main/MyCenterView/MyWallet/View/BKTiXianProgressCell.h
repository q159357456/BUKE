//
//  BKTiXianProgressCell.h
//  MiniBuKe
//
//  Created by chenheng on 2018/12/4.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface BKTiXianProgressCell : BKBaseTableViewCell

- (void)setProgressStateWithtype:(NSInteger)applyType andTime:(NSString*)timeStr;

@end

NS_ASSUME_NONNULL_END
