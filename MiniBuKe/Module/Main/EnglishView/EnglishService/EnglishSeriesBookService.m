//
//  EnglishSeriesBookService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/9/18.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "EnglishSeriesBookService.h"

@implementation EnglishSeriesBookService
-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN
{
    self = [super init];
    if (self) {
        self.delegate = self;
        //GET /series/book/list/{page}/{pageNum}/{type}
        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,[NSString stringWithFormat:@"/series/book/list/1/20/4"]];
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
        NSLog(@"EnglishSeriesBookService ==> %@",deserializedDictionary);
    id returnJsonId = [[deserializedDictionary objectForKey:@"data"] objectForKey:@"seriesBookList"];
    if ([returnJsonId isKindOfClass:[NSArray class]]){
        self.dataArray = [NSMutableArray arrayWithArray:[SeriesList_Classify getSeriesBookDtoList:(NSArray *)returnJsonId]];
       

    }
}
@end
