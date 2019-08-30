//
//  ObserveArrayObject.m
//  MiniBuKe
//
//  Created by chenheng on 2018/7/17.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "ObserveArrayObject.h"

@implementation ObserveArrayObject

-(id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}


@end
