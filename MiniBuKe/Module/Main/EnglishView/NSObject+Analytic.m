//
//  NSObject+Analytic.m
//  MiniBuKe
//
//  Created by 秦根 on 2018/9/16.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "NSObject+Analytic.h"

@implementation NSObject (Analytic)
+(NSObject*)AnalyticDic_Obj:(NSDictionary*)dic
{
    NSObject *obj = [[[self class] alloc]init];
    [obj setValuesForKeysWithDictionary:dic];
    return  obj;
}

+(NSMutableArray*)AnalyticDic_Aarry:(NSArray*)array
{
    NSMutableArray *data = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        NSObject *obj = [[[self class] alloc]init];
        [obj setValuesForKeysWithDictionary:dic];
        [data addObject:obj];
    }
    
    return data;
    
}


-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
//    if (value == [NSNull null]) {
//        value = @"";
//    }
}

-(void)setNilValueForKey:(NSString *)key
{
    [self setValue:@"" forKey:key];
}


@end
