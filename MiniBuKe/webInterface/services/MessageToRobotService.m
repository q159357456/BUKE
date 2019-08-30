//
//  MessageToRobotService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/5/2.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "MessageToRobotService.h"

@implementation MessageToRobotService


-(id)initWithUerToken:(NSString *)token setContent:(NSString *)content setImtype:(NSString *)imtype setTime:(NSInteger)time setOnSuccess:(OnSuccess)onSuccessBlock setOnError:(OnError)onErrorBlock
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.isPostRequestMethod = YES;
        self.USER_TOKEN = token;
        NSString *headStr = [NSString stringWithFormat:@"%@%@",SERVER_URL,@"/rongyun/v1/sendMessageToRobot?"];
        NSString *paraStr = [NSString stringWithFormat:@"content=%@&time=%ld&imtype=%@",[content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],time,[imtype stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        self.url = [NSString stringWithFormat:@"%@%@",headStr,paraStr];
        
        onSuccess = onSuccessBlock;
        onError = onErrorBlock;
        
        NSLog(@"发送消息给机器人URL:%@",self.url);
    }
    
    return self;
}

-(void)parseResponseResult:(NSString *)responseStr jsonObject:(id)responseJsonObject
{
    
}

-(NSMutableDictionary *)buildRequestParams
{
    return nil;
}

@end
