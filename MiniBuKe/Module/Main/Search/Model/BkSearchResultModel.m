//
//  BkSearchResultModel.m
//  MiniBuKe
//
//  Created by chenheng on 2019/1/11.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "BkSearchResultModel.h"

@implementation BkSearchResultModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"resultId":@"id"
             };
}

@end
