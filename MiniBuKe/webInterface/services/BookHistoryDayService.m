//
//  BookHistoryDayService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/23.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BookHistoryDayService.h"
#import "SeriesBookObject.h"

@implementation BookHistoryDayService

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN
    setDay:(NSString *) day
   setPage:(NSString *) page
setPageNum:(NSString *) pageNum
{
    self = [super init];
    if (self) {
        self.delegate = self;
        
        //self.isPostRequestMethod = YES;
        
        //@"http://120.77.206.31:8080/book/category";
        
        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,[NSString stringWithFormat:@"/book/history/%@/%@/%@",day,page,pageNum]];
        
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
    //NSLog(@"StaticIndexService jsonObject ==> %@",responseStr);
    id returnJsonId = [deserializedDictionary objectForKey:@"data"];
    if ([returnJsonId isKindOfClass:[NSDictionary class]]){
        NSLog(@"returnJsonId ==> %@",returnJsonId);
        
        NSDictionary *returnJsonDictionary = (NSDictionary *)returnJsonId;
        
        id bookCategoryId = [returnJsonDictionary objectForKey:@"historyBookList"];
        
        if ([bookCategoryId isKindOfClass:[NSArray class]]) {
            NSArray *mArray = (NSArray *)bookCategoryId;
            
            self.dataArray = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < mArray.count; i ++) {
                NSDictionary *mDic = [mArray objectAtIndex:i];
                
                SeriesBookObject *obj = [SeriesBookObject withObject:mDic];
                obj.bookType = @"1";
                [self.dataArray addObject:obj];
            }
            
            
        }
    }
}

@end
