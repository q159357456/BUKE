//
//  KBookPageService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/19.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "KBookPageService.h"

@implementation KBookPageService

-(id)init:(OnSuccess)onSuccessBlock setOnError:(OnError)onErrorBlock setUSER_TOKEN:(NSString *)USER_TOKEN setBookId:(NSInteger)bookId setPageNum:(NSInteger)pageNum setGroupId:(NSInteger)groupId
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.isPostRequestMethod = NO;
        
        self.url = [NSString stringWithFormat:@"%@%@%ld/%ld/%ld",SERVER_URL,@"/book/kbook/page/",bookId,pageNum,groupId];
        
        self.USER_TOKEN = USER_TOKEN;
        NSLog(@"url ==> %@",self.url);
        onSuccess = onSuccessBlock;
        onError = onErrorBlock;
    }
    return self;
}


#pragma mark - HttpInterfaceDelegate

-(NSMutableDictionary *)buildRequestParams
{
    return nil;
}

-(void)parseResponseResult:(NSString *)responseStr jsonObject:(id)responseJsonObject
{
    NSDictionary *deserializedDictionary = (NSDictionary *)responseJsonObject;
    NSLog(@"KBookPageService jsonObject ==> %@",responseStr);
    id returnJsonId = [deserializedDictionary objectForKey:@"data"];
    if ([returnJsonId isKindOfClass:[NSDictionary class]]){
        NSLog(@"returnJsonId ==> %@",returnJsonId);
        
        
        NSDictionary *returnJsonDictionary = (NSDictionary *)returnJsonId;
        id bookCategoryId = [returnJsonDictionary objectForKey:@"bookPage"];
        
        if ([bookCategoryId isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *bookCategoryDic = (NSDictionary *)bookCategoryId;
            
            self.bookPageObject = [KBookPageObject withObject:bookCategoryDic];
            
        }
    }
}


@end
