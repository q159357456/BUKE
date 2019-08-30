//
//  XbkKeySecret.h
//  MiniBuKe
//
//  Created by chenheng on 2018/6/13.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XbkKeySecret : NSObject

@property (nonatomic,strong) NSString *appId;
@property (nonatomic,strong) NSString *appKey;
@property (nonatomic,strong) NSString *appSecret;
@property (nonatomic,strong) NSString *mid;

+(XbkKeySecret *) withObject:(NSDictionary *) dic;

@end
