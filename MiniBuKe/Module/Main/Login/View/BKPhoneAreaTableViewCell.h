//
//  BKPhoneAreaTableViewCell.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/23.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface BKPhoneAreaTableViewCell : BKBaseTableViewCell

- (void)setModelWithTitle:(NSString*)title andSubTitle:(NSString*)subTitle;

//改变高亮选中UI
- (void)changeTheHighlightedUI:(BOOL)isHigh;

@end

NS_ASSUME_NONNULL_END
