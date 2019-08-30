//
//  EnglishService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/9/14.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "EnglishService.h"
#import "English_Header.h"
@implementation EnglishService
-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN
{
    self = [super init];
    if (self) {
        self.delegate = self;
        
        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,[NSString stringWithFormat:@"/teaching/category"]];
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
    id returnJsonId = [[deserializedDictionary objectForKey:@"data"] objectForKey:@"teachingList"];
//    NSLog(@"returnJsonId ===>%@",returnJsonId);
    if ([returnJsonId isKindOfClass:[NSArray class]]){
        self.dataArray = [NSMutableArray arrayWithArray:[Teaching_Catagory AnalyticDic_Aarry:(NSArray*)returnJsonId]];
//         NSLog(@"severce.dataArray===>%@",self.dataArray);
    }
}
@end
