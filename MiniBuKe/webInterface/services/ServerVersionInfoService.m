//
//  ServerVersionInfoService.m
//  IOSAirPurifierProject
//
//  Created by Stone on 13-10-31.
//  Copyright (c) 2013年 IOSAirPurifierProject. All rights reserved.
//

#import "ServerVersionInfoService.h"

static const NSString *PLATFORM = @"ios";

@interface ServerVersionInfoService()<HttpInterfaceDelegate>

@end

@implementation ServerVersionInfoService

-(id)init:(OnSuccess)onSuccessBlock setOnError:(OnError)onErrorBlock
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.url = @"http://wx.139icq.com/jtnet.aspx?cty=iphver";
        onSuccess = onSuccessBlock;
        onError = onErrorBlock;
    }
    return self;
}

-(void)parseResponseResult:(NSString *)responseStr jsonObject:(id)responseJsonObject
{
    NSDictionary *deserializedDictionary = (NSDictionary *)responseJsonObject;
    
    id returnJsonId = [deserializedDictionary objectForKey:@"result"];
    if ([returnJsonId isKindOfClass:[NSDictionary class]]){
        NSDictionary *returnJsonDictionary = (NSDictionary *)returnJsonId;
        id userId = [returnJsonDictionary objectForKey:@"ver"];
        
        if (userId && [userId isKindOfClass:[NSDictionary class]]){
            NSDictionary *userDictionary = (NSDictionary *)userId;
//            self.versionInfo = [SystemVersionInfo systemVersionInfoWithDictionay:userDictionary];
        }
    }
}

-(NSMutableDictionary *)buildRequestParams
{
    return nil;
}

@end
