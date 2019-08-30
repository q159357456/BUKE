//
//  XbkKeySecret.m
//  MiniBuKe
//
//  Created by chenheng on 2018/6/13.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "XbkKeySecret.h"
#import "NSString+DES.h"

@implementation XbkKeySecret

+(XbkKeySecret *) withObject:(NSDictionary *) dic
{
//    @property (nonatomic,strong) NSString *appId;
//    @property (nonatomic,strong) NSString *appKey;
//    @property (nonatomic,strong) NSString *appSecret;
//    @property (nonatomic,strong) NSString *mid;
    XbkKeySecret *obj = nil;
    if (dic != nil) {
        obj = [[XbkKeySecret alloc] init];
        
        obj.appId = ![[dic objectForKey:@"appId"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"appId"] : @"";
        obj.appKey = ![[dic objectForKey:@"appKey"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"appKey"] : @"";
        obj.appSecret = ![[dic objectForKey:@"appSecret"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"appSecret"] : @"";
        obj.mid = ![[dic objectForKey:@"id"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"id"] : @"";
        
        NSLog(@"XbkKeySecret1 ==> appKey = %@ || appSecret = %@ ",obj.appKey,obj.appSecret);
        
//        NSString *appKeystr = [NSString stringWithFormat:@"%@",obj.appKey];
        obj.appKey = [NSString decryptDes:obj.appKey key: @"rnApzdA8PouJIAZKjX5JCEy1kQPqhx"];
        
//        NSString *appSecretstr = [NSString stringWithFormat:@"%@",obj.appSecret];
        obj.appSecret = [NSString decryptDes:obj.appSecret key: @"rnApzdA8PouJIAZKjX5JCEy1kQPqhx"];
        
        NSLog(@"XbkKeySecret2 ==> appKey = %@ || appSecret = %@ ",obj.appKey,obj.appSecret);
    }
    
    return obj;
}
@end
