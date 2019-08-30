//
//  TeachingDetailService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/9/18.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "TeachingDetailService.h"

@implementation TeachingDetailService
-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN TeachingId:(NSString*)teachingId
{
    self = [super init];
    if (self) {
        self.delegate = self;
        //GET /teaching/detail/{id}
        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,[NSString stringWithFormat:@"/teaching/detail/%@",teachingId]];
        self.USER_TOKEN = USER_TOKEN;
        NSLog(@"eachingDetailService ==> %@",self.url);
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
    NSLog(@"EnglishSeriesBookService ==> %@",deserializedDictionary);
    id returnJsonId = [[deserializedDictionary objectForKey:@"data"] objectForKey:@"teachingDetail"];
    if ([returnJsonId isKindOfClass:[NSDictionary class]]){
        self.teaching_detail = [TeachingDetail get_teaching_detail:(NSDictionary*)returnJsonId];
        
        
    }
}
@end
