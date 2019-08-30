//
//  FetchBannerPicObjec.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/16.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "FetchBannerPicObjec.h"

@implementation FetchBannerPicObjec

+(FetchBannerPicObjec *) withObject:(NSDictionary *) dic
{
    FetchBannerPicObjec *obj = nil;
    if (dic != nil) {
        obj = [[FetchBannerPicObjec alloc] init];
//        @property (nonatomic,strong) NSString *mid;
//        @property (nonatomic,strong) NSString *picURL;
//        @property (nonatomic,strong) NSString *categoryId;
//        @property (nonatomic,strong) NSString *version;
//        @property (nonatomic,strong) NSString *sortNum;
        obj.mid = ![[dic objectForKey:@"id"] isKindOfClass:[NSNull class]] ? [[dic objectForKey:@"id"] stringValue] : @"";
        obj.picURL = ![[dic objectForKey:@"picURL"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"picURL"] : @"";
        obj.categoryId = ![[dic objectForKey:@"categoryId"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"categoryId"] : @"";
        obj.version = ![[dic objectForKey:@"version"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"version"] : @"";
        obj.sortNum = ![[dic objectForKey:@"sortNum"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"sortNum"] : @"";
        
        NSLog(@"FetchBannerPicObjec ==> id = %@ || picURL = %@ || categoryId = %@",obj.mid,obj.picURL,obj.version);
    }
    
    return obj;
}

@end
