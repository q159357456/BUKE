//
//  BkWalletInfoModel.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/30.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WalletData;

NS_ASSUME_NONNULL_BEGIN

@interface BkWalletInfoModel : NSObject

@property (nonatomic, assign) NSInteger code;
@property (copy, nonatomic) NSString *msg;
@property (strong, nonatomic) WalletData *data;

@end

@interface WalletData : NSObject

@property (assign, nonatomic) CGFloat money;
@property (assign, nonatomic) CGFloat totalMoney;
@property (nonatomic, assign) NSInteger registerCount;
@property (nonatomic, assign) NSInteger transactionCount;

@end

NS_ASSUME_NONNULL_END
