//
//  StoryCategoryObject.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/17.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoryCategoryObject : NSObject

@property (nonatomic,strong) NSString  *storyId;
@property (nonatomic,strong) NSString *categoryName;
@property (nonatomic,strong) NSString *picUrl;
//@property (nonatomic,strong) NSArray *categoryLists;//一级分类取消


+(StoryCategoryObject *) withObject:(NSDictionary *) dic;

@end
