//
//  RobotIsOnlineService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/5/17.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "RobotIsOnlineService.h"

@implementation RobotIsOnlineService

-(id)initWithDeviceId:(NSString *)deviceId setToken:(NSString *)token setOnSuccess:(OnSuccess)onSuccessBlock setOnError:(OnError)onErrorBlock
{
    self = [super init];
    if (self) {
        
        self.delegate = self;
        self.url = [NSString stringWithFormat:@"%@%@deviceId=%@",SERVER_URL,@"/robot/isOnline?",deviceId];
        
        NSLog(@"检查机器人是否在线url-->%@",self.url);
        self.USER_TOKEN = token;
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
    NSDictionary *responseDictinary = (NSDictionary *)responseJsonObject;
    id dataObject = [responseDictinary objectForKey:@"data"];
    
    if ([dataObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dataDic = (NSDictionary *)dataObject;
        id online = [dataDic objectForKey:@"online"];
        if ([online isKindOfClass:[NSNumber class]]) {
            self.isOnline = [online boolValue];
        }
    }
    
}


@end
