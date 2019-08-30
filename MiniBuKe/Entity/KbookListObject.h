//
//  KbookListObject.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/16.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KbookListObject : NSObject

@property(nonatomic,copy) NSString *mid;
@property(nonatomic,copy) NSString *picUrl;
@property(nonatomic,copy) NSString *bookName;
@property(nonatomic,copy) NSString *userId;
@property(nonatomic,copy) NSString *familyName;
@property(nonatomic,copy) NSString *groupId;

+(KbookListObject *) withObject:(NSDictionary *) dic;

@end
