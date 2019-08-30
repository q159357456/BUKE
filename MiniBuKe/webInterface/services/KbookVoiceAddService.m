//
//  KbookVoiceAddService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/6/19.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "KbookVoiceAddService.h"


@interface KbookVoiceAddService()

@property(nonatomic,copy) NSDictionary *dic;

@end

@implementation KbookVoiceAddService

-(id)initWithOnSuccess:(OnSuccess)onSuccessBlock setOnError:(OnError)onErrorBlock setToken:(NSString *)token setDictionary:(NSDictionary *)dictionary setBookId:(NSString *)bookId
{
    self = [super init];
    if (self) {
        
        self.delegate = self;
        self.isPostRequestMethod = YES;
        self.isPostBody = YES;
        
        self.url = [NSString stringWithFormat:@"%@/%@/%@",SERVER_URL,@"book/voice/add",bookId];
        
        self.USER_TOKEN = token;
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
