//
//  KBookDeleteService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/6/27.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "KBookDeleteService.h"

@implementation KBookDeleteService

-(id)initWithOnSuccess:(OnSuccess)onSuccessBlock setOnError:(OnError)onErrorBlock setToken:(NSString *)token setBookId:(NSInteger )bookId
{
    self = [super init];
    if (self) {
        
        self.delegate = self;
        self.isPostRequestMethod = YES;
        
        self.url = [NSString stringWithFormat:@"%@/%@/%ld",SERVER_URL,@"book/kbook/voice/del",bookId];
        
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
    
}


@end
