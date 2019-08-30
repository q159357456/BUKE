//
//  BookHistoryReadInfo.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/23.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BookHistoryReadInfo.h"

@implementation BookHistoryReadInfo

+(BookHistoryReadInfo *) withObject:(NSDictionary *) dic
{
    BookHistoryReadInfo *obj = nil;
    if (dic != nil) {
        obj = [[BookHistoryReadInfo alloc] init];
        
//        @property (nonatomic,strong) NSString *readBookNum;
//        @property (nonatomic,strong) NSString *longTime;
        
        obj.readBookNum = ![[dic objectForKey:@"readBookNum"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"readBookNum"] : @"";
        obj.longTime = ![[dic objectForKey:@"longTime"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"longTime"] : @"";
        
        NSLog(@"BookHistoryReadInfo ==> readBookNum = %@ || longTime = %@ ",obj.readBookNum,obj.longTime);
    }
    
    return obj;
}

@end
