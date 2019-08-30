//
//  SeriesBookService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/16.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "SeriesBookService.h"
#import "SeriesBookObject.h"

@implementation SeriesBookService

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN
   setPage:(NSString *)page
setPageNum:(NSString *)pageNum
   setType:(SeriesBookServiceType)type
setSeriesType:(NSString *)seriesType
{
    self = [super init];
    if (self) {
        self.delegate = self;
        
        //@"http://120.77.206.31:8080/book/category";
        
        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,[NSString stringWithFormat:@"/series/book/list/%@/%@/%i/%@",page,pageNum,type,seriesType]];
        self.USER_TOKEN = USER_TOKEN;
        NSLog(@"url ==> %@",self.url);
        onSuccess = onSuccessBlock;
        onError = onErrorBlock;
    }
    return self;
}

-(void)parseResponseResult:(NSString *)responseStr jsonObject:(id)responseJsonObject
{
    NSDictionary *deserializedDictionary = (NSDictionary *)responseJsonObject;
    NSLog(@"SeriesBookService jsonObject ==> %@",responseStr);
    id returnJsonId = [deserializedDictionary objectForKey:@"data"];
    if ([returnJsonId isKindOfClass:[NSDictionary class]]){
        NSLog(@"returnJsonId ==> %@",returnJsonId);
        
        
        NSDictionary *returnJsonDictionary = (NSDictionary *)returnJsonId;
        id bookCategoryId = [returnJsonDictionary objectForKey:@"seriesBookList"];
        
        if ([bookCategoryId isKindOfClass:[NSArray class]]) {
            NSArray *bookCategoryArray = (NSArray *)bookCategoryId;
            self.dataArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < bookCategoryArray.count; i ++) {
                NSDictionary *dictionary = (NSDictionary *)[bookCategoryArray objectAtIndex:i];

                SeriesBookObject *mSeriesBookObject = [SeriesBookObject withObject:dictionary];
                [self.dataArray addObject:mSeriesBookObject];

                //[self.scssxstjObjects addObject:obj];
            }
        }
    }
}

-(NSMutableDictionary *)buildRequestParams
{
    return nil;
}

@end
