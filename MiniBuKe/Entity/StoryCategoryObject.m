//
//  StoryCategoryObject.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/17.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "StoryCategoryObject.h"

@implementation StoryCategoryObject

+(StoryCategoryObject *)withObject:(NSDictionary *)dic
{
    StoryCategoryObject *storyObject = nil;
    if (dic != nil) {
        storyObject = [[StoryCategoryObject alloc] init];
       
//        storyObject.storyId = ![[dic objectForKey:@"id"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"id"] : @"";
        storyObject.storyId = ![[dic objectForKey:@"id"] isKindOfClass:[NSNull class]] ? [[dic objectForKey:@"id"]stringValue] : @"";
        storyObject.categoryName = ![[dic objectForKey:@"categoryName"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"categoryName"] : @"";
        storyObject.picUrl = ![[dic objectForKey:@"picUrl"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"picUrl"] : @"";
    
    }
    
    return storyObject;
}


@end
