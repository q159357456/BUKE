//
//  FetchUserInfoService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/9/19.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "FetchUserInfoService.h"
#import "FetchUserInfo.h"

@implementation FetchUserInfoService

-(id) init:(OnSuccess) onSuccessBlock
  setOnError:(OnError) onErrorBlock
setUserToken:(NSString *) userToken
{
    if(self = [super init]){
        self.delegate = self;
        onSuccess = onSuccessBlock;
        onError = onErrorBlock;
        NSString *actionString = [NSString stringWithFormat:@"/user/fetchUserInfo",@""];
        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,actionString];
        
        self.USER_TOKEN = userToken;
        
    }
    return self;
}

-(NSMutableDictionary *) buildRequestParams
{
    return nil;
}

- (void)parseResponseResult:(NSString *)responseStr jsonObject:(id)responseJsonObject
{
    NSDictionary *deserializedDictionary = (NSDictionary *)responseJsonObject;
    NSLog(@"FetchUserInfoService jsonObject ==> %@",responseStr);
    id returnJsonId = [deserializedDictionary objectForKey:@"data"];
    if ([returnJsonId isKindOfClass:[NSDictionary class]]){
        NSLog(@"returnJsonId ==> %@",returnJsonId);
        
        
        NSDictionary *returnJsonDictionary = (NSDictionary *)returnJsonId;
        id userID = [returnJsonDictionary objectForKey:@"user"];
        
        if ([userID isKindOfClass:[NSDictionary class]]) {
            NSDictionary *userDic = (NSDictionary *)userID;
            self.mFetchUserInfo = [FetchUserInfo objectWithDic:userDic];
        }
    }
}

@end
