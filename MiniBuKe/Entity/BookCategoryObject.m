//
//  BookCategoryObject.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/10.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BookCategoryObject.h"
#import "CategoryObject.h"

@implementation BookCategoryObject

-(id)init{
    if (self=[super init]) {
        // Initialize self.
        self.categoryId = 0;
    }
    return self;
}

+(BookCategoryObject *) withObject:(NSDictionary *) dic
{
    BookCategoryObject *obj = nil;
    if (dic != nil) {
        obj = [[BookCategoryObject alloc] init];
//        @property (nonatomic,strong) NSString *categoryName;
//        @property (nonatomic,strong) NSString *picUrl;
        obj.categoryId = ![[dic objectForKey:@"categoryId"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"categoryId"] : @"";
        obj.categoryName = ![[dic objectForKey:@"categoryName"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"categoryName"] : @"";
        obj.picUrl = ![[dic objectForKey:@"picUrl"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"picUrl"] : @"";
        if (obj.picUrl != nil && obj.picUrl.length > 0) {
            obj.picUrl = [NSString stringWithFormat:@"%@%@",obj.picUrl, @"?x-oss-process=image/resize,h_50"];
        }
        id categoryLists = [dic objectForKey:@"categoryLists"];
        
        if ([categoryLists isKindOfClass:[NSArray class]]) {
            NSArray *categoryArray = (NSArray *)categoryLists;
            NSMutableArray *categoryMutableArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < categoryArray.count; i ++) {
                NSDictionary *categoryDic = (NSDictionary *)[categoryArray objectAtIndex:i];
                //array addObject:(nonnull id)
                CategoryObject *mCategoryObject = [CategoryObject withObject:categoryDic];
                [categoryMutableArray addObject:mCategoryObject];
            }
            obj.categoryLists = categoryMutableArray;
        }
//        ?x-oss-process=image/resize,h_100
        NSLog(@"BookCategoryObject ==> categoryName = %@ || picUrl = %@ || categoryLists = %@ categoryLists = %i",obj.categoryName,obj.picUrl,categoryLists,obj.categoryLists.count);
    }
    
    return obj;
}

@end
