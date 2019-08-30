//
//  VersionListObject.m
//  MiniBuKe
//
//  Created by chenheng on 2018/6/26.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "VersionListObject.h"

@implementation VersionListObject

+(VersionListObject *) withObject:(NSDictionary *) dic
{
    VersionListObject *obj = nil;
    if (dic != nil) {
        obj = [[VersionListObject alloc] init];
        
        obj.version = ![[dic objectForKey:@"version"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"version"] : @"";
        obj.value = ![[dic objectForKey:@"value"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"value"] : @"";
        obj.checked = ![[dic objectForKey:@"selected"] isKindOfClass:[NSNull class]] ? [[dic objectForKey:@"selected"] boolValue] : false;
        
        
        NSLog(@"VersionListObject ==> version = %@ || value = %@ ",obj.version,obj.value);
    }
    return obj;
}

@end
