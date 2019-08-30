//
//  SeriesBookSeriesNameService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/18.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "SeriesBookSeriesNameService.h"
#import "SeriesListObject.h"

@implementation SeriesBookSeriesNameService

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN
   setType:(SeriesBookSeriesNameServiceType ) type
{
    self = [super init];
    if (self) {
        self.delegate = self;
        
        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,[NSString stringWithFormat:@"/series/book/seriesName/%i",type]];
        
        self.USER_TOKEN = USER_TOKEN;
        NSLog(@"url ==> %@",self.url);
        onSuccess = onSuccessBlock;
        onError = onErrorBlock;
    }
    return self;
}

-(NSMutableDictionary *)buildRequestParams
{
    //    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    //    [dictionary setValue:self.page forKey:@"page"];
    //    [dictionary setValue:self.pageNum forKey:@"pageNum"];
    //    return dictionary;
    return nil;
}

-(void)parseResponseResult:(NSString *)responseStr jsonObject:(id)responseJsonObject
{
    NSDictionary *deserializedDictionary = (NSDictionary *)responseJsonObject;
    NSLog(@"SeriesListObject jsonObject ==> %@",responseStr);
    id returnJsonId = [deserializedDictionary objectForKey:@"data"];
    if ([returnJsonId isKindOfClass:[NSDictionary class]]){
        NSLog(@"returnJsonId ==> %@",returnJsonId);
        
        NSDictionary *returnJsonDictionary = (NSDictionary *)returnJsonId;
        
        id bookCategoryId = [returnJsonDictionary objectForKey:@"seriesList"];
        
        if ([bookCategoryId isKindOfClass:[NSArray class]]) {
            NSArray *bookCategoryArray = (NSArray *)bookCategoryId;
            self.dataArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < bookCategoryArray.count; i ++) {
                NSDictionary *dictionary = (NSDictionary *)[bookCategoryArray objectAtIndex:i];
                
                    SeriesListObject *mSeriesListObject = [SeriesListObject withObject:dictionary];
                    [self.dataArray addObject:mSeriesListObject];
                
            }
        }
    }
}

@end
