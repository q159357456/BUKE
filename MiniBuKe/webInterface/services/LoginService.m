//
//  LoginService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/7/10.
//  Copyright © 2018年 lucky. All rights reserved.
//

#import "LoginService.h"

@interface LoginService ()

@property (nonatomic,strong) NSString *account;
@property (nonatomic,strong) NSString *password;

@end

@implementation LoginService

-(id) init:(OnSuccess) onSuccessBlock setOnError:(OnError) onErrorBlock setAccount:(NSString *)account setPassword:(NSString *) password
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.account = account;
        self.password = password;
        
        self.isPostRequestMethod = YES;
        self.isPostBody = YES;
        
        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,[NSString stringWithFormat:@"/user/login"]];
        
        
//        self.USER_TOKEN = USER_TOKEN;
        NSLog(@"url ==> %@",self.url);
        onSuccess = onSuccessBlock;
        onError = onErrorBlock;
    }
    return self;
}

-(NSMutableDictionary *)buildRequestParams
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:self.account forKey:@"userName"];
    [dictionary setValue:self.password forKey:@"passWord"];
    [dictionary setValue:@"123123" forKey:@"deviceId"];
    [dictionary setValue:@"2" forKey:@"deviceType"];
    [dictionary setValue:[UIDevice currentDevice].systemVersion forKey:@"osVer"];
    [dictionary setValue:[BKUtils iphoneType] forKey:@"phone"];
    return dictionary;
}

-(void)parseResponseResult:(NSString *)responseStr jsonObject:(id)responseJsonObject
{
    NSDictionary *deserializedDictionary = (NSDictionary *)responseJsonObject;
    NSLog(@"LoginService jsonObject ==> %@",responseStr);
    id returnJsonId = [deserializedDictionary objectForKey:@"data"];
    if ([returnJsonId isKindOfClass:[NSDictionary class]]){
        NSLog(@"LoginService returnJsonId ==> %@",returnJsonId);
        self.mLoginResult = [LoginResult withLoginResultJson:returnJsonId];
    }
}
@end
