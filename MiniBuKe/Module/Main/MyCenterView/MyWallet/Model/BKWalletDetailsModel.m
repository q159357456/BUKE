//
//  BKWalletDetailsModel.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/30.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKWalletDetailsModel.h"

@implementation BKWalletDetailsModel

@end

@implementation BKWalletDetailsData

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"contentList":@"content"
             };
}

+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"contentList" : @"WalletDealData"
             };
}

@end

@implementation WalletDealData

@end
