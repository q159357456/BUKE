//
//  BKMoreNewBookListModel.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/7.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKMoreNewBookListModel.h"

@implementation BKMoreNewBookListModel

@end

@implementation NewListData
+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"booklist" : @"BKNewBookData"
             };
}

@end

@implementation BKNewBookData
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"bookId":@"id"
             };
}

@end
