//
//  AppKeySecretService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/6/12.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "AppKeySecretService.h"
#import "XbkKeySecret.h"

@implementation AppKeySecretService

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setType:(NSString *) type
setUserId:(NSString *) userId
{
    self = [super init];
    if (self) {
        self.delegate = self;
        
//        self.isPostRequestMethod = YES;
//        self.isPostBody = YES;
        
        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,[NSString stringWithFormat:@"/pub/appKeySecret?type=%@&userId=%@",type,userId]];
        
        
        //self.userId = userId;
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
    NSLog(@"AppKeySecretService jsonObject ==> %@",responseStr);
    id returnJsonId = [deserializedDictionary objectForKey:@"data"];
    if ([returnJsonId isKindOfClass:[NSDictionary class]]){
       NSLog(@"AppKeySecretService returnJsonId ==> %@",returnJsonId);
        id xbkKeySecretArray = ![[returnJsonId objectForKey:@"xbkKeySecret"] isKindOfClass:[NSNull class]] ? [returnJsonId objectForKey:@"xbkKeySecret"] : nil;
        
        if ([xbkKeySecretArray isKindOfClass:[NSArray class]]) {
            NSArray *array = (NSArray *) xbkKeySecretArray;
            for (int i = 0; i < array.count; i ++) {
                id obj = [array objectAtIndex:i];
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    self.mXbkKeySecret = [XbkKeySecret withObject:obj];
                }
            }
            
        }
//       self.mSNString = ![[returnJsonId objectForKey:@"sn"] isKindOfClass:[NSNull class]] ? [returnJsonId objectForKey:@"sn"] : @"";
    }
}

@end
