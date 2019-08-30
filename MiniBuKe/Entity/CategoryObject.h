//
//  CategoryObject.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/10.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryObject : NSObject

@property (nonatomic,strong) NSString *picUrl;
@property (nonatomic,strong) NSString *cid;
@property (nonatomic,strong) NSString *name;

+(CategoryObject *) withObject:(NSDictionary *) dic;

@end
