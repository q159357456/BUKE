//
//  InstensiveService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/5.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "InstensiveService.h"

@implementation InstensiveService
-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN Bookid:(NSString*)bookid{
    
    self = [super init];
    if (self) {
        self.delegate = self;
        //GET /book/theme/detail/{id}
        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,[NSString stringWithFormat:@"/book/theme/detail/%@",bookid]];
        self.USER_TOKEN = USER_TOKEN;
//        NSLog(@"InstensiveService ==> %@",self.url);
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
//    NSLog(@"InstensiveService ==> %@",deserializedDictionary);
    id returnJsonId = [[deserializedDictionary objectForKey:@"data"] objectForKey:@"bookDetail"];
//    NSLog(@"TeachingAge===>%@",returnJsonId);
    if ([returnJsonId isKindOfClass:[NSDictionary class]]){
        self.instensiveDetailModel = [InstensiveDetailModel getIntensiveDetail:returnJsonId];
        
    }
}
@end
