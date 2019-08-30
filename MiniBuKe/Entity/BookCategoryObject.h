//
//  BookCategoryObject.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/10.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookCategoryObject : NSObject

@property (nonatomic,copy) NSString *categoryId;
@property (nonatomic,copy) NSString *categoryName;
@property (nonatomic,copy) NSString *picUrl;
@property (nonatomic,copy) NSArray *categoryLists;

- (id)init;

+(BookCategoryObject *) withObject:(NSDictionary *) dic;

@end
