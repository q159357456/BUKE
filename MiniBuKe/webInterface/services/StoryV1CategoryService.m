//
//  StoryV1CategoryService.m
//  MiniBuKe
//
//  Created by Jim Wang on 2018/8/28.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "StoryV1CategoryService.h"
#import "StoryCategoryObject.h"

@implementation StoryV1CategoryService

-(id)init:(OnSuccess)onSuccessBlock setOnError:(OnError)onErrorBlock
{
    self = [super init];
    if (self) {
        self.delegate = self;
        
        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,@"/story/v1/category"];
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
                
                StoryCategoryObject *storyCategoryObject = [StoryCategoryObject withObject:dictionary];
                [self.array addObject:storyCategoryObject];
              
            }
        }
  
    }
}

-(NSMutableDictionary *)buildRequestParams
{
    return nil;
}

@end
