//
//  StaticIndexObject.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/20.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaticIndexObject : NSObject

@property (nonatomic,strong) NSString *kbook;
@property (nonatomic,strong) NSString *book;
@property (nonatomic,strong) NSString *story;
@property (nonatomic,strong) NSString *recentlyPlay;

+(StaticIndexObject *) withObject:(NSDictionary *) dic;

@end
