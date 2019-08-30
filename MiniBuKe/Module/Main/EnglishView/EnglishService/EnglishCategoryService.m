//
//  EnglishCategoryService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/9/14.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "EnglishCategoryService.h"
#import "English_Header.h"
@implementation EnglishCategoryService
-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN
{
    self = [super init];
    if (self) {
        self.delegate = self;
        
        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,[NSString stringWithFormat:@"/series/book/seriesName/4"]];
        self.USER_TOKEN = USER_TOKEN;
        NSLog(@"url ==> %@",self.url);
        onSuccess = onSuccessBlock;
        onError = onErrorBlock;
    }
    return self;
}


-(NSMutableDictionary *)buildRequestParams
{
    return nil;
}

-(void)parseResponseResult:(NSString *)responseStr jsonObject:(id)responseJsonObject
{
    
    NSDictionary *deserializedDictionary = (NSDictionary *)responseJsonObject;
//    NSLog(@"AboutService jsonObject ==> %@",responseStr);
//    NSLog(@"EnglishCategoryService ==> %@",deserializedDictionary);
        id returnJsonId = [deserializedDictionary objectForKey:@"data"][@"seriesList"];
        if ([returnJsonId isKindOfClass:[NSArray class]]){
            NSLog(@"returnJsonId ==> %@",returnJsonId);
            self.dataArray = [SeriesList_Classify AnalyticDic_Aarry:(NSArray*)returnJsonId];
    
        }
}

@end
