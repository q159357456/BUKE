//
//  BookDetailService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/17.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BookDetailService.h"
#import "BookDetailObject.h"

@implementation BookDetailService

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
    setCid:(NSString *) mid
{
    self = [super init];
    if (self) {
        self.delegate = self;
        
        //self.isPostRequestMethod = YES;
        
        //@"http://120.77.206.31:8080/book/category";
        
        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,[NSString stringWithFormat:@"/book/robot/read/detail/%@",mid]];
        
        self.USER_TOKEN = APP_DELEGATE.mLoginResult.token;
        NSLog(@"url ==> %@",self.url);
        onSuccess = onSuccessBlock;
        onError = onErrorBlock;
    }
    return self;
}

-(NSMutableDictionary *)buildRequestParams
{
    //    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    //    [dictionary setValue:self.page forKey:@"page"];
    //    [dictionary setValue:self.pageNum forKey:@"pageNum"];
    //    return dictionary;
    return nil;
}

-(void)parseResponseResult:(NSString *)responseStr jsonObject:(id)responseJsonObject
{
    NSDictionary *deserializedDictionary = (NSDictionary *)responseJsonObject;
    NSLog(@"SeriesBookService jsonObject ==> %@",responseStr);
    id returnJsonId = [deserializedDictionary objectForKey:@"data"];
    if ([returnJsonId isKindOfClass:[NSDictionary class]]){
        NSLog(@"returnJsonId ==> %@",returnJsonId);
        
        NSDictionary *returnJsonDictionary = (NSDictionary *)returnJsonId;
        
        id bookCategoryId = [returnJsonDictionary objectForKey:@"bookDetail"];
        
        if ([bookCategoryId isKindOfClass:[NSDictionary class]]) {
            NSDictionary *mNSDictionary = (NSDictionary *)bookCategoryId;
            self.mBookDetailObject = [BookDetailObject withObject:mNSDictionary];
            
        }
    }
}

@end
