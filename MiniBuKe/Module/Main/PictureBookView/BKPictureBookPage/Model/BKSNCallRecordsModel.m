//
//  BKSNCallRecordsModel.m
//  MiniBuKe
//
//  Created by chenheng on 2019/5/8.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKSNCallRecordsModel.h"

@implementation BKSNCallRecordsModel

@end

@implementation CallRecordData

+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"list" : @"recordModel"
             };
}

@end

@implementation recordModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"recordId":@"id"
             };
}

@end
