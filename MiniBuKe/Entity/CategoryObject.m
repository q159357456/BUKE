//
//  CategoryObject.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/10.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "CategoryObject.h"

@implementation CategoryObject

+(CategoryObject *) withObject:(NSDictionary *) dic
{
    CategoryObject *obj = nil;
    if (dic != nil) {
        obj = [[CategoryObject alloc] init];
//        @property (nonatomic,strong) NSString *picUrl;
//        @property (nonatomic,strong) NSString *cid;
//        @property (nonatomic,strong) NSString *name;
        obj.picUrl = ![[dic objectForKey:@"picUrl"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"picUrl"] : @"";
        obj.cid = ![[dic objectForKey:@"id"] isKindOfClass:[NSNull class]] ? [[dic objectForKey:@"id"]stringValue] : @"";
        obj.name = ![[dic objectForKey:@"name"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"name"] : @"";
        //?x-oss-process=image/resize,h_100
        NSLog(@"CategoryObject ==> obj.picUrl = %@ || obj.cid = %@ || obj.name = %@",obj.picUrl,obj.cid,obj.name);
    }
    
    return obj;
}

@end
