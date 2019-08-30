//
//  GetUserInfoByPhoneService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/9/18.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "GetUserInfoByPhoneService.h"

@implementation GetUserInfoByPhoneService

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
  setPhone:(NSString *) phone
{
    self = [super init];
    if (self) {
        self.delegate = self;
        
        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,[NSString stringWithFormat:@"/user/getUserInfoByPhone?phone=%@",phone]];
        
        NSLog(@"url ==> %@",self.url);
        onSuccess = onSuccessBlock;
        onError = onErrorBlock;
    }
    return self;
}

- (NSMutableDictionary *)buildRequestParams {
//    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
//    [dictionary setValue:self.infoContent forKey:@"infoContent"];
    return nil;
}

- (void)parseResponseResult:(NSString *)responseStr jsonObject:(id)responseJsonObject {
    NSDictionary *deserializedDictionary = (NSDictionary *)responseJsonObject;
    NSLog(@"GetUserInfoByPhoneService ==> %@",responseStr);
    id returnJsonId = [deserializedDictionary objectForKey:@"data"];
    if ([returnJsonId isKindOfClass:[NSDictionary class]]){
        NSLog(@"returnJsonId ==> %@",returnJsonId);
        
        
        NSDictionary *returnJsonDictionary = (NSDictionary *)returnJsonId;
        self.userToken = ![[returnJsonDictionary objectForKey:@"userToken"] isKindOfClass:[NSNull class]] ? [returnJsonDictionary objectForKey:@"userToken"] : @"";
//
//        if ([bookCategoryId isKindOfClass:[NSArray class]]) {
//            NSArray *bookCategoryArray = (NSArray *)bookCategoryId;
//            self.dataArray = [[NSMutableArray alloc] init];
//            for (int i = 0; i < bookCategoryArray.count; i ++) {
//                NSDictionary *dictionary = (NSDictionary *)[bookCategoryArray objectAtIndex:i];
//                AboutInfo *mAboutInfo = [AboutInfo withObject:dictionary];
//                [self.dataArray addObject:mAboutInfo];
//            }
//        }
    }
}

@end
