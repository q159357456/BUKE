//
//  BooklistObjet.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/17.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BooklistObjet.h"

@implementation BooklistObjet

+(BooklistObjet *) withObject:(NSDictionary *) dic
{
    BooklistObjet *obj = nil;
    if (dic != nil) {
        obj = [[BooklistObjet alloc] init];
        
        obj.coverPic = ![[dic objectForKey:@"coverPic"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"coverPic"] : @"";
        if (obj.coverPic != nil && obj.coverPic.length > 0) {
            obj.coverPic = [NSString stringWithFormat:@"%@%@",obj.coverPic, @"?x-oss-process=image/resize,h_300"];
        }
        obj.author = ![[dic objectForKey:@"author"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"author"] : @"";
        obj.mid = ![[dic objectForKey:@"id"] isKindOfClass:[NSNull class]] ? [[dic objectForKey:@"id"] stringValue] : @"";
        obj.name = ![[dic objectForKey:@"name"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"name"] : @"";
        obj.groupId = ![[dic objectForKey:@"groupId"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"groupId"] : @"0";
        
    }
    
    return obj;
}

@end
