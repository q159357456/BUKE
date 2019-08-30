//
//  SendAudioToRobotSerive.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/24.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "SendAudioToRobotSerive.h"

@interface SendAudioToRobotSerive ()

@property (nonatomic,strong) NSArray *urlList;

@end

@implementation SendAudioToRobotSerive

-(id)init:(OnSuccess)onSuccessBlock setOnError:(OnError)onErrorBlock setUSER_TOKEN:(NSString *)USER_TOKEN setAudioUrlList:(NSArray *)urlList
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.urlList = urlList;
        
        //@"http://120.77.206.31:8080/book/category";
        
        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,[NSString stringWithFormat:@"/rongyun/sendAudioToRobot"]];
        
        self.USER_TOKEN = USER_TOKEN;
        NSLog(@"url ==> %@",self.url);
        onSuccess = onSuccessBlock;
        onError = onErrorBlock;
        
    }
    return self;
}


-(NSArray *)buildRequestParams
{
    return self.urlList;
}

-(void)parseResponseResult:(NSString *)responseStr jsonObject:(id)responseJsonObject
{
    NSDictionary *deserializedDictionary = (NSDictionary *)responseJsonObject;
    //NSLog(@"StaticIndexService jsonObject ==> %@",responseStr);
    id returnJsonId = [deserializedDictionary objectForKey:@"data"];
    if ([returnJsonId isKindOfClass:[NSDictionary class]]){
        NSLog(@"returnJsonId ==> %@",returnJsonId);
        
        NSDictionary *returnJsonDictionary = (NSDictionary *)returnJsonId;
        
//        id bookCategoryId = [returnJsonDictionary objectForKey:@"historyBookList"];
//
//        if ([bookCategoryId isKindOfClass:[NSArray class]]) {
//            NSArray *mArray = (NSArray *)bookCategoryId;
//
//            self.dataArray = [[NSMutableArray alloc] init];
//
//            for (int i = 0; i < mArray.count; i ++) {
//                NSDictionary *mDic = [mArray objectAtIndex:i];
//
//                SeriesBookObject *obj = [SeriesBookObject withObject:mDic];
//                obj.bookType = @"1";
//                [self.dataArray addObject:obj];
//            }
//
//
//        }
    }
}
@end
