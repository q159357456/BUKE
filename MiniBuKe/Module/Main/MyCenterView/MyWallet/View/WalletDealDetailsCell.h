//
//  WalletDealDetailsCell.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/30.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKBaseTableViewCell.h"
#import "BKWalletDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletDealDetailsCell : BKBaseTableViewCell

- (void)setUIModelWith:(WalletDealData*)model;

@property (nonatomic, copy) void(^ClickDetailBtnClick)(NSString*transactionId);

@end

NS_ASSUME_NONNULL_END
