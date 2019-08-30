//
//  TeachingResultService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/10/25.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "TeachingResultService.h"
#import "English_Header.h"
@implementation TeachingResultService
-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN Type:(NSInteger)type Time:(NSInteger)time;
{
    
    self = [super init];
    if (self) {
        self.delegate = self;
        //GET /teaching/result/{type}/{time}
        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,[NSString stringWithFormat:@"/teaching/result/%ld/%ld",type,time]];
        self.USER_TOKEN = USER_TOKEN;
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
    NSLog(@"TeachingResultService ==> %@",deserializedDictionary);
    id returnJsonId = [[deserializedDictionary objectForKey:@"data"] objectForKey:@"list"];
    if ([returnJsonId isKindOfClass:[NSArray class]]){
        self.dataArray = [TimeScore AnalyticDic_Aarry:(NSArray *)returnJsonId];


    }
}
@end
