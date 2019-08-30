//
//  FetchUserSNService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/5/14.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "FetchUserSNService.h"

@implementation FetchUserSNService

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN
{
    self = [super init];
    if (self) {
        self.delegate = self;
        
        //self.isPostRequestMethod = YES;
        
        //@"http://120.77.206.31:8080/book/category";
        
        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,[NSString stringWithFormat:@"/user/fetchUserSN"]];
        
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
    return nil;
}

-(void)parseResponseResult:(NSString *)responseStr jsonObject:(id)responseJsonObject
{
    NSDictionary *deserializedDictionary = (NSDictionary *)responseJsonObject;
    NSLog(@"FetchUserSNService jsonObject ==> %@",responseStr);
    id returnJsonId = [deserializedDictionary objectForKey:@"data"];
    if ([returnJsonId isKindOfClass:[NSDictionary class]]){
        NSLog(@"FetchUserSNService returnJsonId ==> %@",returnJsonId);
        
        self.mSNString = ![[returnJsonId objectForKey:@"sn"] isKindOfClass:[NSNull class]] ? [returnJsonId objectForKey:@"sn"] : @"";
        
        self.mRobotVersion = ![[returnJsonId objectForKey:@"version"] isKindOfClass:[NSNull class]] ? [returnJsonId objectForKey:@"version"] : @"";
        
        NSNumber *bindTime = ![[returnJsonId objectForKey:@"bindTime"] isKindOfClass:[NSNull class]] ? [returnJsonId objectForKey:@"bindTime"] : @0;
        
        self.mBindTime = [NSString stringWithFormat:@"%lld",[bindTime longLongValue]];
        self.type = ![[returnJsonId objectForKey:@"type"] isKindOfClass:[NSNull class]] ? [returnJsonId objectForKey:@"type"] : @"";
//        self.mBindTime = ![[returnJsonId objectForKey:@"bindTime"] isKindOfClass:[NSNull class]] ? [returnJsonId objectForKey:@"bindTime"] : @"";
        
        NSLog(@"self.mRobotVersion ==> %@",self.mRobotVersion);
    }
}
@end