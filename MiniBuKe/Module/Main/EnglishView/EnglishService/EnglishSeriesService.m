//
//  EnglishSeriesService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/9/14.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "EnglishSeriesService.h"
#import "English_Header.h"
@implementation EnglishSeriesService
-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN SeriesType:(NSString*)seriesType
{
    self = [super init];
    if (self) {
        self.delegate = self;
        //GET /series/book/list/{page}/{pageNum}/{type}/{seriesType}
        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,[NSString stringWithFormat:@"/series/book/list/1/20/4/%@",seriesType]];
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
    NSLog(@"EnglishSeriesService. ==> %@",deserializedDictionary);
    id returnJsonId = [deserializedDictionary objectForKey:@"data"][@"seriesBookList"];
    if ([returnJsonId isKindOfClass:[NSArray class]]){
        NSLog(@"returnJsonId ==> %@",returnJsonId);
        self.dataArray = [Series AnalyticDic_Aarry:(NSArray*)returnJsonId];

    }
}
@end
