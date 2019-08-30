//
//  BookCategoryService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/10.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BookCategoryService.h"
#import "BookCategoryObject.h"
#import "CategoryObject.h"

@implementation BookCategoryService
-(id)init:(OnSuccess)onSuccessBlock setOnError:(OnError)onErrorBlock
{
    self = [super init];
    if (self) {
        self.delegate = self;
        
        //@"http://120.77.206.31:8080/book/category";
        
        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,@"/book/category"];
        
        onSuccess = onSuccessBlock;
        onError = onErrorBlock;
    }
    return self;
}

-(void)parseResponseResult:(NSString *)responseStr jsonObject:(id)responseJsonObject
{
    NSDictionary *deserializedDictionary = (NSDictionary *)responseJsonObject;
    
    id returnJsonId = [deserializedDictionary objectForKey:@"data"];
    if ([returnJsonId isKindOfClass:[NSDictionary class]]){
        NSLog(@"returnJsonId ==> %@",returnJsonId);
        
        
        NSDictionary *returnJsonDictionary = (NSDictionary *)returnJsonId;
        id bookCategoryId = [returnJsonDictionary objectForKey:@"bookCategory"];
        
        if ([bookCategoryId isKindOfClass:[NSArray class]]) {
            NSArray *bookCategoryArray = (NSArray *)bookCategoryId;
            self.array = [[NSMutableArray alloc] init];
            for (int i = 0; i < bookCategoryArray.count; i ++) {
                NSDictionary *dictionary = (NSDictionary *)[bookCategoryArray objectAtIndex:i];

                BookCategoryObject *mBookCategoryObject = [BookCategoryObject withObject:dictionary];
                
//                CategoryObject *mCategoryObject = (CategoryObject *)[mBookCategoryObject.categoryLists objectAtIndex:i];
//                tempBCO.categoryId = mBookCategoryObject.categoryId;
//                tempBCO.categoryName = mBookCategoryObject.categoryId;
//                tempBCO.picUrl = mBookCategoryObject.picUrl;
                
                [self.array addObject:mBookCategoryObject];
                
//                if (mBookCategoryObject.categoryLists != nil && mBookCategoryObject.categoryLists.count > 0) {
//                    for (int i = 0; i < mBookCategoryObject.categoryLists.count; i ++) {
//                        BookCategoryObject *tempBCO = [[BookCategoryObject alloc] init];
//
//                        CategoryObject *mCategoryObject = (CategoryObject *)[mBookCategoryObject.categoryLists objectAtIndex:i];
//                        tempBCO.categoryId = mCategoryObject.cid;
//                        tempBCO.categoryName = mCategoryObject.name;
//                        tempBCO.picUrl = mCategoryObject.picUrl;
//
//                        [self.array addObject:tempBCO];
//                    }
//                }
                
                
            }
        }
        
        
        
    }
}

-(NSMutableDictionary *)buildRequestParams
{
    return nil;
}

@end
