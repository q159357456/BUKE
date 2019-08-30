//
//  OperatorServerHttpService.m
//  JTShopManage
//
//  Created by ren fei on 13-10-8.
//  Copyright (c) 2013年 JTShopManage. All rights reserved.
//

#import "OperatorServerHttpService.h"

@interface OperatorServerHttpService ()

@property (nonatomic,strong) NSString *identification;
@property (nonatomic,strong) NSString *password;

@end

@implementation OperatorServerHttpService

-(id) init:(NSString *) identification
setPassword:(NSString *) password
setOnSuccess:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
{
    self = [super init];
    if (self) {
        // Initialize self.
        self.delegate = self;
        self.url = [NSString stringWithFormat:@"http://wx.139icq.com/jtnet.aspx?"];
        
        //self.userId = [NSString stringWithFormat:@"%li",userId];
        self.identification = identification;
        self.password = password;
        onSuccess = onSuccessBlock;
        onError = onErrorBlock;
    }
    return self;
}

//构建请求属性
- (NSMutableDictionary *) buildRequestParams
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:@"getjs" forKey:@"cty"];
    [dictionary setValue:self.identification forKey:@"uname"];
    [dictionary setValue:self.password forKey:@"pa"];
    
    //    ASIFormDataRequest *formDataRequest = [ASIFormDataRequest requestWithURL:nil];
    //    [dictionary setValue:[formDataRequest encodeURL:[formDataRequest encodeURL:self.contentText]] forKey:@"info"];
    
    return dictionary;
}

//解析结果
- (void) parseResponseResult:(NSString *) responseStr
                  jsonObject:(id)responseJsonObject
{
    //NSLog(@"=> 子类解析 => %@",responseStr);
    
    
    NSDictionary *deserializedDictionary = (NSDictionary *)responseJsonObject;
    
    id returnJsonId = [deserializedDictionary objectForKey:@"result"];
    if ([returnJsonId isKindOfClass:[NSDictionary class]]){
        NSDictionary *returnJsonDictionary = (NSDictionary *)returnJsonId;
        id objListId = [returnJsonDictionary objectForKey:@"netlist"];
        if ([objListId isKindOfClass:[NSArray class]]){
            self.netList = [NSMutableArray array];
            NSArray *objListIdArray = (NSArray *) objListId;
            for (int i = 0; i < objListIdArray.count; i ++) {
                NSDictionary *dictionary = (NSDictionary *)[objListIdArray objectAtIndex:i];
                
//                OperatorServer *operatorServer = [OperatorServer operatorServerWithObject:dictionary];
//                NSLog(@"name =》%@ | ip1 => %@ | ip2 => %@ | wnet => %i",operatorServer.name,operatorServer.ip1,operatorServer.ip2,operatorServer.wnet);
//                [self.netList addObject:operatorServer];
            }
        }
        
                
    }
    
}
@end
