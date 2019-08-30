//
//  BKWalletDetailsModel.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/30.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BKWalletDetailsData;

NS_ASSUME_NONNULL_BEGIN

@interface BKWalletDetailsModel : NSObject
@property (nonatomic, assign) NSInteger code;
@property (copy, nonatomic) NSString *msg;
@property (strong, nonatomic) BKWalletDetailsData *data;
@end

@interface BKWalletDetailsData : NSObject

@property (strong, nonatomic) NSMutableArray *contentList;
@property (nonatomic, assign) BOOL last;

@end

@interface WalletDealData : NSObject

@property (copy, nonatomic) NSString *createTime;
@property (copy, nonatomic) NSString *transactionDescribe;
@property (copy, nonatomic) NSString *transactionId;
@property (copy, nonatomic) NSString *transactionMoney;
@property (assign, nonatomic) NSInteger transactionType;//交易类型(1.推荐购买 2.提现)

@end

NS_ASSUME_NONNULL_END
