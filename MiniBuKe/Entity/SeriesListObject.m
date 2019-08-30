//
//  SeriesListObject.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/18.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "SeriesListObject.h"

@implementation SeriesListObject

+(SeriesListObject *) withObject:(NSDictionary *) dic
{
//    @property (nonatomic,strong) NSString *seriesName;
//    @property (nonatomic,strong) NSString *seriesType;
    SeriesListObject *obj = nil;
    if (dic != nil) {
        obj = [[SeriesListObject alloc] init];
        obj.seriesName = ![[dic objectForKey:@"seriesName"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"seriesName"] : @"";
        obj.seriesType = ![[dic objectForKey:@"seriesType"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"seriesType"] : @"";
        
        NSLog(@"SeriesListObject ==> seriesName = %@ || seriesType = %@ ",obj.seriesName,obj.seriesType);
    }
    
    return obj;
}

@end
