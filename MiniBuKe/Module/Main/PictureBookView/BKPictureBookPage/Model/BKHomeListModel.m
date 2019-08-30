//
//  BKHomeListModel.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/5.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKHomeListModel.h"

@implementation BKHomeListModel


@end

@implementation HomeListData

+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"seriesBookList":@"seriesBookDataModel"
             };
}

@end

@implementation themeData

+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"xbkThemeList":@"themeDataModel"
             };
}

@end

@implementation themeDataModel

@end

@implementation seriesBookDataModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"bookList":@"xbkSeriesBookDtoList"
             };
}
+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"bookList" : @"homeSeriesBookModel",
             };
}

@end

@implementation homeSeriesBookModel

@end

@implementation recommendData
+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"recommendBookList" : @"recommendBookModel",
             };
}
@end

@implementation recommendBookModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"recommendId":@"id"
             };
}

@end

@implementation LineLessonsData

+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"onlineCourseList" : @"LineLessonsModel",
             };
}

@end

@implementation LineLessonsModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"lessonId":@"id"
             };
}

@end
