//
//  BKDepositTopCell.h
//  MiniBuKe
//
//  Created by chenheng on 2018/12/3.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface BKDepositTopCell : BKBaseTableViewCell

@property (nonatomic, copy) void(^ClickMoneyBtn)(NSInteger selectIndex);

- (void)changeTheTipMoneyOver:(BOOL)ishide;
- (void)setMoneyWith:(CGFloat)money;

@end

NS_ASSUME_NONNULL_END
