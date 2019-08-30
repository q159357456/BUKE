//
//  OJBabyInfoUpLoadService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/10/31.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "OJBabyInfoUpLoadService.h"
@interface OJBabyInfoUpLoadService()
@property (nonatomic,strong) NSDictionary *dic;
@end
@implementation OJBabyInfoUpLoadService
-(id)initWithOnSuccess:(OnSuccess)onSuccessBlock setOnError:(OnError)onErrorBlock setToken:(NSString *)token setDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.isPostRequestMethod = YES;
        self.isPostBody = YES;
        
        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,@"/user/uploadBabyInfo"];
        
        NSLog(@"uploadBabyInfo--->%@",self.url);
        self.USER_TOKEN = token;
        self.dic = dictionary;
        onSuccess = onSuccessBlock;
        onError = onErrorBlock;
        
    }
    
    return self;
}


-(NSMutableDictionary *)buildRequestParams
{
    NSLog(@"发送参数:%@",self.dic);
    return [NSMutableDictionary dictionaryWithDictionary:self.dic];
}

-(void)parseResponseResult:(NSString *)responseStr jsonObject:(id)responseJsonObject
{
    
}
@end
