//
//  KBookPageObject.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/19.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "KBookPageObject.h"

@implementation KBookPageObject

+(KBookPageObject *)withObject:(NSDictionary *)dic
{
    KBookPageObject *pageObject = [[KBookPageObject alloc]init];
    if (dic != nil) {
        pageObject.picUrl = ![[dic objectForKey:@"picUrl"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"picUrl"] : @"";
        pageObject.content = ![[dic objectForKey:@"content"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"content"] : @"";
        pageObject.voiceUrl = ![[dic objectForKey:@"voiceUrl"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"voiceUrl"] : @"";
    }
    return pageObject;
}

@end
