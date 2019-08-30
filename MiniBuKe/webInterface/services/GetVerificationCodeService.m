//
//  GetVerificationCodeService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/8/3.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "GetVerificationCodeService.h"

@implementation GetVerificationCodeService


-(id)initWithOnSuccess:(OnSuccess)onSuccessBlock setOnError:(OnError)onErrorBlock setPhoneNum:(NSString *)phoneNum
{
    self = [super init];
    if (self) {
        
        self.delegate = self;
        
        self.url = [NSString stringWithFormat:@"%@%@?phone=%@",SERVER_URL,@"/user/getVerificationCode",phoneNum];
        NSLog(@"GetVerificationCodeService===>url:%@",self.url);
        
        onSuccess = onSuccessBlock;
        onError = onErrorBlock;
        
    }
    
    return self;
}

-(void)parseResponseResult:(NSString *)responseStr jsonObject:(id)responseJsonObject
{
    NSDictionary *deserializedDictionary = (NSDictionary *)responseJsonObject;
    NSLog(@"GetVerificationCodeService jsonObject ==> %@",responseStr);
//    id returnJsonId = [deserializedDictionary objectForKey:@"data"];
//    if ([returnJsonId isKindOfClass:[NSDictionary class]]){
//        NSLog(@"returnJsonId ==> %@",returnJsonId);
//
//
//
//
//    }
}

-(NSMutableDictionary *)buildRequestParams
{
    return nil;
}

@end
