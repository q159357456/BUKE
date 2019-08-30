//
//  NSMutableDictionary+Order.m
//  ZHONGHUILAOWU
//
//  Created by 秦根 on 2018/4/24.
//  Copyright © 2018年 gongbo. All rights reserved.
//

#import "NSMutableDictionary+Order.h"
#import <objc/runtime.h>
@implementation NSMutableDictionary (Order)
static const char* orderArrayKey="orderArray";
-(NSMutableArray *)orderArray
{
   return  objc_getAssociatedObject(self, orderArrayKey);
}

-(void)setOrderArray:(NSMutableArray *)orderArray
{
    return objc_setAssociatedObject(self, orderArrayKey, orderArray, OBJC_ASSOCIATION_RETAIN);
}


-(void)orderSetObject:(id)object forKey:(id)key
{
    if (!self.orderArray) {
        self.orderArray=[NSMutableArray array];
    }
    [self.orderArray addObject:key];
    [self setObject:object forKey:key];
}
@end
