//
//  RCIMTokenService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/11.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "RCIMTokenService.h"

@interface RCIMTokenService()

@property(nonatomic, copy)NSString *usrId;
@property(nonatomic, copy)NSString *usrName;
@property(nonatomic, copy)NSString *usrAvatar;

@end

@implementation RCIMTokenService

-(id)init:(NSString *)usrid setUserName:(NSString *)usrName setUserAvatar:(NSString *)usrAvatar setOnSuccess:(OnSuccess)onSuccessBlock setOnError:(OnError)onErrorBlock
{
    self = [super init];
    if (self) {
        self.delegate = self;
        
        NSString *encodeAvatar = [self URLEncodedString:usrAvatar];
        NSLog(@"encodeAvatar---->%@",encodeAvatar);
        
        NSString *headStr = [NSString stringWithFormat:@"%@%@",SERVER_URL,@"/rongyun/token?"];
        NSString *paraStr = [NSString stringWithFormat:@"userId=%@&username=%@&userAvatar=%@",usrid,usrName,encodeAvatar];
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",headStr,paraStr];
        
        self.url = urlStr;
        
        NSLog(@"self.url======>>>>%@",self.url);
        
        onSuccess = onSuccessBlock;
        onError = onErrorBlock;
    }
    
    return self;
}

-(NSString *)URLEncodedString:(NSString *)str
{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    
    return encodedString;
}

#pragma mark - HttpInterfaceDelegate
- (void)parseResponseResult:(NSString *)responseStr jsonObject:(id)responseJsonObject
{
    NSDictionary *deserializedDictionary = (NSDictionary *)responseJsonObject;
    
    id returnJsonId = [deserializedDictionary objectForKey:@"data"];
    if ([returnJsonId isKindOfClass:[NSDictionary class]]){
        
        NSDictionary *returnJsonDictionary = (NSDictionary *)returnJsonId;
        id RCIMTokenId = [returnJsonDictionary objectForKey:@"token"];
        
        if ([RCIMTokenId isKindOfClass:[NSDictionary class]]) {
            NSDictionary *RCIMTokenDictionary = (NSDictionary *)RCIMTokenId;
            self.RCtoken = ![[RCIMTokenDictionary objectForKey:@"token"] isKindOfClass:[NSNull class]] ? [RCIMTokenDictionary objectForKey:@"token"] : @"";
//            self.RCtoken = [RCIMTokenDictionary objectForKey:@"token"];
        }
    }
}
- (NSMutableDictionary *)buildRequestParams
{
//    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
//
//    [dictionary setValue:self.usrId forKey:@"userId"];
//    [dictionary setValue:self.usrName forKey:@"username"];
//    [dictionary setValue:self.usrAvatar forKey:@"userAvatar"];
    
//    return dictionary;
    return nil;
}

@end
