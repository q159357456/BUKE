//
//  FetchBannerPicService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/11.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "FetchBannerPicService.h"
#import "FetchBannerPicObjec.h"

@implementation FetchBannerPicService

-(id)init:(OnSuccess)onSuccessBlock setOnError:(OnError)onErrorBlock
setFetchBannerPicServiceType:(FetchBannerPicServiceType) type
{
    self = [super init];
    if (self) {
        self.delegate = self;
        
        //@"http://120.77.206.31:8080/book/category";
        
        self.url = [NSString stringWithFormat:@"%@%@%d",SERVER_URL,@"/pub/fetchBannerPic/",type];
        NSLog(@"url ==> %@",self.url);
        onSuccess = onSuccessBlock;
        onError = onErrorBlock;
    }
    return self;
}

-(void)parseResponseResult:(NSString *)responseStr jsonObject:(id)responseJsonObject
{
    NSDictionary *deserializedDictionary = (NSDictionary *)responseJsonObject;
    NSLog(@"FetchBannerPicService jsonObject ==> %@",responseStr);
    id returnJsonId = [deserializedDictionary objectForKey:@"data"];
    if ([returnJsonId isKindOfClass:[NSDictionary class]]){
        NSLog(@"returnJsonId ==> %@",returnJsonId);
        
        
        NSDictionary *returnJsonDictionary = (NSDictionary *)returnJsonId;
        id bookCategoryId = [returnJsonDictionary objectForKey:@"pics"];
        
        if ([bookCategoryId isKindOfClass:[NSArray class]]) {
            NSArray *bookCategoryArray = (NSArray *)bookCategoryId;
            self.array = [[NSMutableArray alloc] init];
            for (int i = 0; i < bookCategoryArray.count; i ++) {
                NSDictionary *dictionary = (NSDictionary *)[bookCategoryArray objectAtIndex:i];
                
                FetchBannerPicObjec *mFetchBannerPicObjec = [FetchBannerPicObjec withObject:dictionary];
                [self.array addObject:mFetchBannerPicObjec];
                
                //[self.scssxstjObjects addObject:obj];
            }
        }
    }
}

-(NSMutableDictionary *)buildRequestParams
{
    return nil;
}

@end
