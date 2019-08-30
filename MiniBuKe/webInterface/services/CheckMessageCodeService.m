//
//  checkMessageCodeService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/9/18.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "CheckMessageCodeService.h"

@interface CheckMessageCodeService ()

@property (nonatomic,strong) NSString *smsCode;

@end

@implementation CheckMessageCodeService

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUserToken:(NSString *) USER_TOKEN
setSMSCode:(NSString *) smsCode
{
    self = [super init];
    if (self) {
        self.delegate = self;
//        self.isPostRequestMethod = YES;
        
//        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,[NSString stringWithFormat:@"/user/checkMessageCode"]];
        
        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,[NSString stringWithFormat:@"/user/checkMessageCode?smsCode=%@&userToken=%@",smsCode,USER_TOKEN]];
        
        NSLog(@"url ==> %@",self.url);
        
//        self.smsCode = smsCode;
//        self.USER_TOKEN = USER_TOKEN;
        
        onSuccess = onSuccessBlock;
        onError = onErrorBlock;
    }
    return self;
}

- (NSMutableDictionary *)buildRequestParams {
//    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
//    [dictionary setValue:self.smsCode forKey:@"smsCode"];
    return nil;
}

- (void)parseResponseResult:(NSString *)responseStr jsonObject:(id)responseJsonObject {
    NSDictionary *deserializedDictionary = (NSDictionary *)responseJsonObject;
    NSLog(@"CheckMessageCodeService ==> %@",responseStr);
    id returnJsonId = [deserializedDictionary objectForKey:@"data"];
    if ([returnJsonId isKindOfClass:[NSDictionary class]]){
        NSLog(@"returnJsonId ==> %@",returnJsonId);
        
        
        NSDictionary *returnJsonDictionary = (NSDictionary *)returnJsonId;
        self.userToken = ![[returnJsonDictionary objectForKey:@"userToken"] isKindOfClass:[NSNull class]] ? [returnJsonDictionary objectForKey:@"userToken"] : @"";
        
    }
}

@end
