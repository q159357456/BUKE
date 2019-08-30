//
//  FetchBabyInfoService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/5/31.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "FetchBabyInfoService.h"

@implementation FetchBabyInfoService

-(id)init:(OnSuccess)onSuccessBlock setOnError:(OnError)onErrorBlock setUSER_TOKEN:(NSString *)USER_TOKEN
{
    self = [super init];
    if (self) {
        self.delegate = self;
        
        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,[NSString stringWithFormat:@"/user/fetchBabyInfo"]];
        
        self.USER_TOKEN = USER_TOKEN;
        NSLog(@"fetchBabyInfo ==> %@",self.url);
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
    NSLog(@"AboutService jsonObject ==> %@",responseStr);
    id returnJsonId = [deserializedDictionary objectForKey:@"data"];
    if ([returnJsonId isKindOfClass:[NSDictionary class]]){
        
        NSDictionary *dataDic = (NSDictionary *)returnJsonId;
        id returnData = [dataDic objectForKey:@"baby"];
        if ([returnData isKindOfClass:[NSDictionary class]]) {
            NSDictionary *babyDic = (NSDictionary *)returnData;
            
            self.babyDic = babyDic;
        }
        
    }
}

@end
