//
//  GetUpdateSoftwareInfoService.m
//  MiniBuKe
//
//  Created by chenheng on 2018/5/22.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "GetUpdateSoftwareInfoService.h"

@interface GetUpdateSoftwareInfoService ()

@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *versionNumber;

@end

@implementation GetUpdateSoftwareInfoService

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN
 setUserId:(NSString *) userId
setVersionNumber:(NSString *) versionNumber
{
    self = [super init];
    if (self) {
        self.delegate = self;
        
        self.isPostRequestMethod = YES;
        self.isPostBody = YES;
        self.userId = userId;
        self.versionNumber = versionNumber;
        
        NSLog(@"versionNumber ==> %@",versionNumber);
        
        //@"http://120.77.206.31:8080/book/category";
        
        self.url = [NSString stringWithFormat:@"%@%@",SERVER_URL,[NSString stringWithFormat:@"/pub/queryVersion"]];
        
       
        self.USER_TOKEN = USER_TOKEN;
        NSLog(@"url ==> %@",self.url);
        onSuccess = onSuccessBlock;
        onError = onErrorBlock;
    }
    return self;
}

//"deviceType": "string",
//"userId": "string",
//"verNumb": "string"
-(NSMutableDictionary *)buildRequestParams
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:@"2" forKey:@"deviceType"];
    [dictionary setValue:self.userId forKey:@"userId"];
    [dictionary setValue:self.versionNumber forKey:@"verNumb"];
    return dictionary;
}

-(void)parseResponseResult:(NSString *)responseStr jsonObject:(id)responseJsonObject
{
    NSDictionary *deserializedDictionary = (NSDictionary *)responseJsonObject;
    NSLog(@"GetUpdateSoftwareInfoService jsonObject ==> %@",responseStr);
    id returnJsonId = [deserializedDictionary objectForKey:@"data"];
    
    
    if ([returnJsonId isKindOfClass:[NSDictionary class]]){
       NSLog(@"returnJsonId ==> %@",returnJsonId);
        
        NSString *versionInfo = ![[returnJsonId objectForKey:@"versionInfo"] isKindOfClass:[NSNull class]] ? [returnJsonId objectForKey:@"versionInfo"] : @"";
        
        NSDictionary *vervionDic = [self dictionaryWithJsonString:versionInfo];
        
        if ([vervionDic isKindOfClass:[NSDictionary class]]){
            self.mVersionInfo = [VersionInfo withObject:vervionDic];
        }
        NSLog(@"versionInfo ===> %@",versionInfo);
//       self.mSNString = ![[returnJsonId objectForKey:@"sn"] isKindOfClass:[NSNull class]] ? [returnJsonId objectForKey:@"sn"] : @"";
    }
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
