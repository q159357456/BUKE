//
//  StoryCategoryService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/11.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "StoryCategoryService.h"
//#import "BookCategoryObject.h"
#import "StoryCategoryObject.h"

@implementation StoryCategoryService

-(id)init:(OnSuccess)onSuccessBlock setOnError:(OnError)onErrorBlock
{
    self = [super init];
    if (self) {
        self.delegate = self;
        
        //@"http://120.77.206.31:8080/book/category";
        
        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,@"/story/category"];
        NSLog(@"url ==> %@",self.url);
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
        id bookCategoryId = [returnJsonDictionary objectForKey:@"StoryCategory"];
        
        if ([bookCategoryId isKindOfClass:[NSArray class]]) {
            NSArray *bookCategoryArray = (NSArray *)bookCategoryId;
            self.array = [[NSMutableArray alloc] init];
            for (int i = 0; i < bookCategoryArray.count; i ++) {
                NSDictionary *dictionary = (NSDictionary *)[bookCategoryArray objectAtIndex:i];
                
//                BookCategoryObject *mBookCategoryObject = [BookCategoryObject withObject:dictionary];
                StoryCategoryObject *storyCategoryObject = [StoryCategoryObject withObject:dictionary];
                [self.array addObject:storyCategoryObject];
//                [self.array addObject:mBookCategoryObject];
                
                //[self.scssxstjObjects addObject:obj];
            }
            
            
        }
        
        //        if (userId && [userId isKindOfClass:[NSDictionary class]]){
        //            NSDictionary *userDictionary = (NSDictionary *)userId;
        //            //            self.versionInfo = [SystemVersionInfo systemVersionInfoWithDictionay:userDictionary];
        //        }
        
        
    }
}

-(NSMutableDictionary *)buildRequestParams
{
    return nil;
}

@end
