//
//  StoryCollectService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/17.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "StoryCollectService.h"

@implementation StoryCollectService

-(id)initWithUerToken:(NSString *)token setStoryId:(NSString *)storyIds setType:(NSInteger)type setOnSuccess:(OnSuccess)onSuccessBock setOnError:(OnError)onErrorBock
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.isPostRequestMethod = YES;
        
        self.url = [NSString stringWithFormat:@"%@%@%ld/%@",SERVER_URL,@"/story/management/",type,storyIds];
        
        NSLog(@"故事收藏地址:%@",self.url);
        self.USER_TOKEN = token;
        
        NSLog(@"故事收藏token%@",token);
        onSuccess = onSuccessBock;
        onError = onErrorBock;
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
