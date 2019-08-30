//
//  NSMutableDictionary+Order.h
//  ZHONGHUILAOWU
//
//  Created by 秦根 on 2018/4/24.
//  Copyright © 2018年 gongbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Order)
@property(nonatomic,strong)NSMutableArray *orderArray;
-(void)orderSetObject:(id)object forKey:(id)key;
@end
