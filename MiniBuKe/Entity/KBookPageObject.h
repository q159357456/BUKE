//
//  KBookPageObject.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/19.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KBookPageObject : NSObject

@property(nonatomic,copy) NSString *picUrl;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *voiceUrl;


+(KBookPageObject *) withObject:(NSDictionary *)dic;

@end
