//
//  WechatUserInfo.h
//  MiniBuKe
//
//  Created by chenheng on 2018/5/22.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WechatUserInfo : NSObject<NSCoding>


@property(nonatomic,copy) NSString *nickname;
@property(nonatomic,copy) NSString *headimgurl;
@property(nonatomic,copy) NSString *openid;
@property(nonatomic,copy) NSString *unionid;
@property(nonatomic,copy) NSString *city;
@property(nonatomic,copy) NSString *province;
@property(nonatomic,copy) NSString *country;
@property(nonatomic,assign) NSUInteger sex;//1:男

+(WechatUserInfo *)parseInfoByDictionary:(NSDictionary *)dic;

@end
