//
//  StaticIndexObject.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/20.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "StaticIndexObject.h"

@implementation StaticIndexObject

+(StaticIndexObject *) withObject:(NSDictionary *) dic
{
    StaticIndexObject *obj = nil;
    if (dic != nil) {
        obj = [[StaticIndexObject alloc] init];
        obj.kbook = ![[dic objectForKey:@"kbook"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"kbook"] : @"";
        obj.book = ![[dic objectForKey:@"book"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"book"] : @"";
        obj.story = ![[dic objectForKey:@"story"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"story"] : @"";
        obj.recentlyPlay = @"0";
        
        NSLog(@"StaticIndexObject ==> kbook = %@ || book = %@ || story = %@ ",obj.kbook,obj.book,obj.story);
    }
    
    return obj;
}
@end
