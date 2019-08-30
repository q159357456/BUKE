//
//  BKBannerDataModel.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/5.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKBannerDataModel.h"

@implementation BKBannerDataModel

@end

@implementation BannerData

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"BannerList":@"pics"
             };
}

+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"BannerList" : @"BannerDataDetail"
             };
}

@end

@implementation BannerDataDetail

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"bannerId":@"id"
             };
}


@end
