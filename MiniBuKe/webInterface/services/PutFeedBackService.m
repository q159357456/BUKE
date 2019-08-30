//
//  PutFeedBackService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/5/21.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "PutFeedBackService.h"

@interface PutFeedBackService ()

@property (nonatomic,strong) NSString *infoContent;
@property (nonatomic,strong) NSString *infoType;

@end

@implementation PutFeedBackService

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN
setInfoContent:(NSString *) infoContent
setInfoType:(NSString *) infoType
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.infoContent = infoContent;
        self.infoType = infoType;
        
        self.isPostRequestMethod = YES;
        self.isPostBody = YES;
        
        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,[NSString stringWithFormat:@"/pub/putFeedbackInfo"]];
        
        //@"http://120.77.206.31:8080/book/category";
//        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,[NSString stringWithFormat:@"/pub/putFeedbackInfo?infoContent=%@&infoType=%@",infoContent,infoType]];
//
//        self.url = [self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        self.USER_TOKEN = USER_TOKEN;
        NSLog(@"url ==> %@",self.url);
        onSuccess = onSuccessBlock;
        onError = onErrorBlock;
    }
    return self;
}

-(NSMutableDictionary *)buildRequestParams
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:self.infoContent forKey:@"infoContent"];
    [dictionary setValue:self.infoType forKey:@"infoType"];
    return dictionary;
}

-(void)parseResponseResult:(NSString *)responseStr jsonObject:(id)responseJsonObject
{
    NSDictionary *deserializedDictionary = (NSDictionary *)responseJsonObject;
    NSLog(@"PutFeedBackService jsonObject ==> %@",responseStr);
    //    id returnJsonId = [deserializedDictionary objectForKey:@"data"];
    //    if ([returnJsonId isKindOfClass:[NSDictionary class]]){
    //        NSLog(@"returnJsonId ==> %@",returnJsonId);
    //
    //        self.mSNString = ![[returnJsonId objectForKey:@"sn"] isKindOfClass:[NSNull class]] ? [returnJsonId objectForKey:@"sn"] : @"";
    //    }
}
@end
