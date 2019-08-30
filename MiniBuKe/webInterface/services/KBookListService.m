//
//  KBookListService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/16.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "KBookListService.h"
#import "KBookListModel.h"

@interface KBookListService ()

@end

@implementation KBookListService

-(id)init:(OnSuccess)onSuccessBlock setOnError:(OnError)onErrorBlock setUSER_TOKEN:(NSString *)USER_TOKEN setPage:(NSInteger)page setPageNum:(NSInteger)pageNum
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.isPostRequestMethod = YES;
        
        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,[NSString stringWithFormat:@"/book/kbook/list/%ld/%ld",page,pageNum]];
        
        self.USER_TOKEN = USER_TOKEN;
        NSLog(@"url ==> %@",self.url);
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
    NSLog(@"SeriesBookService jsonObject ==> %@",responseStr);
    id returnJsonId = [deserializedDictionary objectForKey:@"data"];
    if ([returnJsonId isKindOfClass:[NSDictionary class]]){
        NSLog(@"returnJsonId ==> %@",returnJsonId);
        
        
        NSDictionary *returnJsonDictionary = (NSDictionary *)returnJsonId;
        id bookCategoryId = [returnJsonDictionary objectForKey:@"KbookList"];

        if ([bookCategoryId isKindOfClass:[NSArray class]]) {
            NSArray *bookCategoryArray = (NSArray *)bookCategoryId;
            NSMutableArray *mutableArray = [NSMutableArray array];
            
            for (NSDictionary *kDic in bookCategoryArray) {
                
                KBookListModel *model = [KBookListModel parseDataByDictionary:kDic];
                
                [mutableArray addObject:model];
            }
            
            self.dataArray = [NSArray arrayWithArray:mutableArray];
        }
    }
}


@end
