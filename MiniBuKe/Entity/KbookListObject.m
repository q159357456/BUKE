//
//  KbookListObject.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/16.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "KbookListObject.h"

@implementation KbookListObject

+(KbookListObject *) withObject:(NSDictionary *) dic
{
    KbookListObject *obj = nil;
    if (dic != nil) {
        obj = [[KbookListObject alloc] init];

        obj.mid = ![[dic objectForKey:@"id"] isKindOfClass:[NSNull class]] ? [[dic objectForKey:@"id"]stringValue] : @"";
        obj.picUrl = ![[dic objectForKey:@"picUrl"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"picUrl"] : @"";
        obj.bookName = ![[dic objectForKey:@"bookName"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"bookName"] : @"";
        obj.userId = ![[dic objectForKey:@"userId"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"userId"] : @"";
        obj.familyName = ![[dic objectForKey:@"familyName"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"familyName"] : @"";
        
        NSLog(@"KbookListObject ==> sort = %@ || bookName = %@ || userId = %@",obj.mid,obj.picUrl,obj.bookName);
    }
    
    return obj;
}
@end
