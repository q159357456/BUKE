//
//  EnglishScore.m
//  MiniBuKe
//
//  Created by chenheng on 2018/10/10.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "EnglishScore.h"
#import "English_Header.h"
@implementation EnglishScore
-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN
{
    self = [super init];
    if (self) {
        self.delegate = self;
        //GET /teaching/english/score
        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,[NSString stringWithFormat:@"/teaching/english/score"]];
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
    id returnJsonId = [[deserializedDictionary objectForKey:@"data"] objectForKey:@"teachingScore"];
    NSLog(@"EnglishScore==>%@",returnJsonId);
    if ([returnJsonId isKindOfClass:[NSDictionary class]]){
        self.score =(Score*)[Score AnalyticDic_Obj:(NSDictionary*)returnJsonId];

    }
}
@end
