//
//  PushDeviceTokenService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/8/8.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "PushDeviceTokenService.h"


@interface  PushDeviceTokenService()

@property(nonatomic,copy) NSDictionary *dic;

@end

@implementation PushDeviceTokenService


-(id)initWithOnSuccess:(OnSuccess)onSuccessBlock setOnError:(OnError)onErrorBlock setDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        self.delegate = self;
        self.isPostRequestMethod = YES;
        self.isPostBody = YES;
        
        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,@"/push/registerDeviceToken"];
        NSLog(@"PushDeviceTokenService===>url:%@",self.url);
        
        
        self.dic = dictionary;
        
        onSuccess = onSuccessBlock;
        onError = onErrorBlock;
        
    }
    
    return self;
}

-(NSMutableDictionary *)buildRequestParams
{
    return [NSMutableDictionary dictionaryWithDictionary:self.dic];
}

-(void)parseResponseResult:(NSString *)responseStr jsonObject:(id)responseJsonObject
{
    
}


@end
