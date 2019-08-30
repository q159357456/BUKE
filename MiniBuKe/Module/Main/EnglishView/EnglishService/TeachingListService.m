//
//  TeachingListService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/9/19.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "TeachingListService.h"
#import "English_Header.h"
@implementation TeachingListService
-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN TeachingId:(NSString*)teachingId AgeId:(NSString*)ageId Page:(NSInteger)page
{
    
    self = [super init];
    if (self) {
        self.delegate = self;
        //GET /teaching/list/{page}/{pageNum}/{teachingId}/{ageId}
        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,[NSString stringWithFormat:@"/teaching/list/%ld/%d/%@/%@",(long)page,PAGENUM,teachingId,ageId]];
        self.USER_TOKEN = USER_TOKEN;
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
    NSLog(@"TeachingListService ==> %@",deserializedDictionary);
    id returnJsonId = [[deserializedDictionary objectForKey:@"data"] objectForKey:@"booklist"];
    if ([returnJsonId isKindOfClass:[NSArray class]]){
        self.dataArray = [TeachingProperties AnalyticDic_Aarry:(NSArray *)returnJsonId];


    }
}
@end
