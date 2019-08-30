//
//  TeachingAgeService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/9/18.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "TeachingAgeService.h"
#import "English_Header.h"
@implementation TeachingAgeService
-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN TeachingId:(NSString*)teachingId
{
    self = [super init];
    if (self) {
        self.delegate = self;
        //GET /teaching/age/list/{teachingId}
        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,[NSString stringWithFormat:@"/teaching/age/list/%@",teachingId]];
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
    id returnJsonId = [[deserializedDictionary objectForKey:@"data"] objectForKey:@"ageList"];
    NSLog(@"TeachingAge===>%@",returnJsonId);
    if ([returnJsonId isKindOfClass:[NSArray class]]){
        self.dataArray = [NSMutableArray arrayWithArray:[TeachingAge AnalyticDic_Aarry:(NSArray *)returnJsonId]];
        
        
    }
}
@end
