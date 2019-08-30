//
//  AboutInfo.m
//  MiniBuKe
//
//  Created by chenheng on 2018/5/7.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "AboutInfo.h"

@implementation AboutInfo

+(AboutInfo *) withObject:(NSDictionary *) dic
{
    AboutInfo *obj = nil;
    if (dic != nil) {
        obj = [[AboutInfo alloc] init];
        
        //"id": 3,
        //"infoName": "官方网站",
        //"showType": 2,
        //"infoValue": "http://www.oplushome.com",
        //"infoLink": "http://www.oplushome.com",
        //"sortNum": 1,
        //"isDelete": 0,
        //"createTime": 1523688000000,
        //"updateTime": 1523688000000,
        //"createBy": 1,
        //"updateBy": 1
        
        obj.mid = ![[dic objectForKey:@"id"] isKindOfClass:[NSNull class]] ? [[dic objectForKey:@"id"]stringValue] : @"";
        obj.infoName = ![[dic objectForKey:@"infoName"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"infoName"] : @"";
        obj.showType = ![[dic objectForKey:@"showType"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"showType"] : @"";
        obj.infoValue = ![[dic objectForKey:@"infoValue"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"infoValue"] : @"";
        obj.infoLink = ![[dic objectForKey:@"infoLink"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"infoLink"] : @"";
        obj.sortNum = ![[dic objectForKey:@"sortNum"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"sortNum"] : @"";
        obj.isDelete = ![[dic objectForKey:@"isDelete"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"isDelete"] : @"";
        obj.createTime = ![[dic objectForKey:@"createTime"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"createTime"] : @"";
        obj.updateTime = ![[dic objectForKey:@"updateTime"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"updateTime"] : @"";
        obj.createBy = ![[dic objectForKey:@"createBy"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"createBy"] : @"";
        obj.updateBy = ![[dic objectForKey:@"updateBy"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"updateBy"] : @"";
        
        NSLog(@"AboutInfo ==> mid = %@ || infoName = %@ ",obj.mid,obj.infoName);
    }
    
    return obj;
}

@end
