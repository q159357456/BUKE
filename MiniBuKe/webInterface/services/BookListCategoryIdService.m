//
//  BookListCategoryIdService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/16.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BookListCategoryIdService.h"
#import "BooklistObjet.h"

@interface BookListCategoryIdService ()

@property (nonatomic,strong) NSString *page;
@property (nonatomic,strong) NSString *pageNum;

@end

@implementation BookListCategoryIdService

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
    setCid:(NSString *)cid
   setPage:(NSString *)page
setPageNum:(NSString *)pageNum
{
    self = [super init];
    if (self) {
        self.delegate = self;
        
        self.pageNum = pageNum;
        self.page = page;
        //self.isPostRequestMethod = YES;
        
        //@"http://120.77.206.31:8080/book/category";
        
        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,[NSString stringWithFormat:@"/book/list/%@/%@/%@",cid,page,pageNum]];
        
        //self.USER_TOKEN = USER_TOKEN;
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
        
        id bookCategoryId = [returnJsonDictionary objectForKey:@"booklist"];
        
        if ([bookCategoryId isKindOfClass:[NSArray class]]) {
            NSArray *bookCategoryArray = (NSArray *)bookCategoryId;
            self.dataArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < bookCategoryArray.count; i ++) {
                NSDictionary *dictionary = (NSDictionary *)[bookCategoryArray objectAtIndex:i];
                
                BooklistObjet *mBooklistObjet = [BooklistObjet withObject:dictionary];
                [self.dataArray addObject:mBooklistObjet];
                
                //[self.scssxstjObjects addObject:obj];
            }
        }
    }
}

@end
