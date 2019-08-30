//
//  BKHomeBookCategoryModel.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/5.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKHomeBookCategoryModel.h"

@implementation BKHomeBookCategoryModel

@end

@implementation CategoryData
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"bookCategoryList":@"bookCategory"
             };
}
+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"bookCategoryList" : @"bookCategoryDataModel"
             };
}

@end

@implementation bookCategoryDataModel

@end
