//
//  BookVoiceChooseVersion.m
//  MiniBuKe
//
//  Created by chenheng on 2018/6/26.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BookVoiceChooseVersion.h"

@implementation BookVoiceChooseVersion

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN
 setBookId:(NSString *) bookId
{
    self = [super init];
    if (self) {
        self.delegate = self;
        
        //        self.isPostRequestMethod = YES;
        //        self.isPostBody = YES;
        
        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,[NSString stringWithFormat:@"/book/voice/choose/version/%@",bookId]];
        
        
        self.USER_TOKEN = USER_TOKEN;
        NSLog(@"url ==> %@",self.url);
        onSuccess = onSuccessBlock;
        onError = onErrorBlock;
    }
    return self;
}

-(NSMutableDictionary *)buildRequestParams
{
    //    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    //    [dictionary setValue:self.infoContent forKey:@"infoContent"];
    //    [dictionary setValue:self.infoType forKey:@"infoType"];
    return nil;
}

-(void)parseResponseResult:(NSString *)responseStr jsonObject:(id)responseJsonObject
{
    NSDictionary *deserializedDictionary = (NSDictionary *)responseJsonObject;
    NSLog(@"BookVoiceChooseVersion jsonObject ==> %@",responseStr);
    id returnJsonId = [deserializedDictionary objectForKey:@"data"];
    if ([returnJsonId isKindOfClass:[NSDictionary class]]){
        NSLog(@"BookVoiceChooseVersion returnJsonId ==> %@",returnJsonId);
        
        id versionListArray = ![[returnJsonId objectForKey:@"versionList"] isKindOfClass:[NSNull class]] ? [returnJsonId objectForKey:@"versionList"] : nil;

        if ([versionListArray isKindOfClass:[NSArray class]]) {
            self.mVersionListObjects = [[NSMutableArray alloc] init];
            NSArray *array = (NSArray *) versionListArray;
            for (int i = 0; i < array.count; i ++) {
                id obj = [array objectAtIndex:i];
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    VersionListObject *mVersionListObject = [VersionListObject withObject:obj];
                    [self.mVersionListObjects addObject:mVersionListObject];
                }
            }

        }
        //       self.mSNString = ![[returnJsonId objectForKey:@"sn"] isKindOfClass:[NSNull class]] ? [returnJsonId objectForKey:@"sn"] : @"";
    }
}

@end
