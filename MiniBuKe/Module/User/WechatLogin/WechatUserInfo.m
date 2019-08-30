//
//  WechatUserInfo.m
//  MiniBuKe
//
//  Created by chenheng on 2018/5/22.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "WechatUserInfo.h"

@implementation WechatUserInfo

+(WechatUserInfo *)parseInfoByDictionary:(NSDictionary *)dic
{
    return [[self alloc] parseInfoByDictionary:dic];
}

-(WechatUserInfo *)parseInfoByDictionary:(NSDictionary *)dic
{
    WechatUserInfo *info = nil;
    
    if (dic != nil) {
        info = [[WechatUserInfo alloc] init];
        info.nickname = ![[dic objectForKey:@"nickname"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"nickname"] : @"";
        info.headimgurl = ![[dic objectForKey:@"headimgurl"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"headimgurl"] : @"";
        info.openid = ![[dic objectForKey:@"openid"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"openid"] : @"";
        info.unionid = ![[dic objectForKey:@"unionid"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"unionid"] : @"";
        info.city = ![[dic objectForKey:@"city"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"city"] : @"";
        info.country = ![[dic objectForKey:@"country"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"country"] : @"";
        info.province = ![[dic objectForKey:@"province"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"province"] : @"";
        info.sex = ![[dic objectForKey:@"sex"] isKindOfClass:[NSNull class]] ? [[dic objectForKey:@"sex"] integerValue] : 1;
    }
    
    return info;
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.headimgurl = [aDecoder decodeObjectForKey:@"headimgurl"];
        self.openid = [aDecoder decodeObjectForKey:@"openid"];
        self.unionid = [aDecoder decodeObjectForKey:@"unionid"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
        self.country = [aDecoder decodeObjectForKey:@"country"];
        self.province = [aDecoder decodeObjectForKey:@"province"];
        self.sex = [[aDecoder decodeObjectForKey:@"sex"] integerValue];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeObject:self.headimgurl forKey:@"headimgurl"];
    [aCoder encodeObject:self.openid forKey:@"openid"];
    [aCoder encodeObject:self.unionid forKey:@"unionid"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.country forKey:@"country"];
    [aCoder encodeObject:self.province forKey:@"province"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.sex] forKey:@"sex"];
}

@end
