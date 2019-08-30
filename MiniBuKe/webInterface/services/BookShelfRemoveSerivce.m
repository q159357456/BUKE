//
//  BookShelfRemoveSerivce.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/26.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BookShelfRemoveSerivce.h"

@interface BookShelfRemoveSerivce ()

@property (nonatomic,strong) NSString *ids;

@end

@implementation BookShelfRemoveSerivce

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN
    setIds:(NSString *) ids
{
    self = [super init];
    if (self) {
        self.delegate = self;
        
        self.isPostRequestMethod = YES;
        
        //@"http://120.77.206.31:8080/book/category";
        
        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,[NSString stringWithFormat:@"/book/shelf/remove/%@",ids]];
        
        
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
    [dictionary setValue:self.ids forKey:@"ids"];
    return dictionary;
}

-(void)parseResponseResult:(NSString *)responseStr jsonObject:(id)responseJsonObject
{
    NSDictionary *deserializedDictionary = (NSDictionary *)responseJsonObject;
    //NSLog(@"StaticIndexService jsonObject ==> %@",responseStr);
    id returnJsonId = [deserializedDictionary objectForKey:@"data"];
    if ([returnJsonId isKindOfClass:[NSDictionary class]]){
        NSLog(@"returnJsonId ==> %@",returnJsonId);
        
        NSDictionary *returnJsonDictionary = (NSDictionary *)returnJsonId;
        
//        id bookCategoryId = [returnJsonDictionary objectForKey:@"babyBookList"];
//
//        if ([bookCategoryId isKindOfClass:[NSArray class]]) {
//            NSArray *mArray = (NSArray *)bookCategoryId;
//
//            self.dataArray = [[NSMutableArray alloc] init];
//
//            for (int i = 0; i < mArray.count; i ++) {
//                NSDictionary *mDic = [mArray objectAtIndex:i];
//
//                BabyBookListObject *obj = [BabyBookListObject withObject:mDic];
//                //                obj.bookType = @"1";
//                [self.dataArray addObject:obj];
//            }
//        }
        
        
    }
}

@end
