//
//  TeachingProperties.m
//  MiniBuKe
//
//  Created by chenheng on 2018/9/20.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "TeachingProperties.h"

@implementation TeachingProperties
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.mid = value;
    }
}

@end
