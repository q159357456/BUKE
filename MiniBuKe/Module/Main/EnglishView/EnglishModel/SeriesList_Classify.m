//
//  SeriesList_Classify.m
//  MiniBuKe
//
//  Created by chenheng on 2018/9/17.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "SeriesList_Classify.h"
#import "English_Header.h"
#import "Series.h"
#import "EnglishDownCell.h"
@implementation SeriesList_Classify
+(NSArray *)getSeriesBookDtoList:(NSArray *)Aarray
{
    NSArray *data = [SeriesList_Classify AnalyticDic_Aarry:Aarray];
    for (SeriesList_Classify * obj in data) {
        obj.xbkSeriesBookDtoList = [Series AnalyticDic_Aarry:obj.xbkSeriesBookDtoList];
        obj.rowHeight = [EnglishDownCell EnglishDownCellRowHeight:obj];
    }
    
    return data;
    
}


@end
