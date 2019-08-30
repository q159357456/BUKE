//
//  KBookVoiceService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/6/5.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "KBookVoiceService.h"
#import "KBookVoiceInfo.h"

@implementation KBookVoiceService


-(id)init:(OnSuccess)onSuccessBlock setOnError:(OnError)onErrorBlock setBookId:(NSString *)bookId setToken:(NSString *)token
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.isPostRequestMethod = NO;
        
        self.url = [NSString stringWithFormat:@"%@%@%@",SERVER_URL,@"/book/kbook/voice/info/",bookId];
        
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
    NSDictionary *deserializedDictionary = (NSDictionary *)responseJsonObject;
    NSLog(@"KBookVoiceService jsonObject ==> %@",responseStr);
    id returnJsonId = [deserializedDictionary objectForKey:@"data"];
    if ([returnJsonId isKindOfClass:[NSDictionary class]]){
        NSLog(@"returnJsonId ==> %@",returnJsonId);
        
        
        NSDictionary *returnJsonDictionary = (NSDictionary *)returnJsonId;
        id bookCategoryId = [returnJsonDictionary objectForKey:@"kBooks"];
        
        if ([bookCategoryId isKindOfClass:[NSArray class]]) {
            
            NSArray *kbookAarray = (NSArray *)bookCategoryId;
            NSMutableArray *mutableArray = [NSMutableArray array];
            for (NSDictionary *dic in kbookAarray) {
                
                if (dic != nil) {
                    KBookVoiceInfo *voiceInfo = [KBookVoiceInfo parseDataByDictionary:dic];
                    
                    [mutableArray addObject:voiceInfo];
                }
                
            }
            
            self.kbookArray = [NSArray arrayWithArray:mutableArray];
        }
    }
}

@end
