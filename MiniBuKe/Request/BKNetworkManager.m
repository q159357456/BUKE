//
//  BKNetworkManager.m
//  MiniBuKe
//
//  Created by zhangchunzhe on 2018/2/26.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKNetworkManager.h"
#import "AFNetworking.h"
#import "RequestApiHeader.h"
#import "ImportHeader.h"

@implementation BKNetworkManager


+(AFHTTPSessionManager*)createHttpRequestManager{
    return [BKNetworkManager createHttpRequestManager:@{}];
}

+(AFHTTPSessionManager*)createHttpRequestManager:(NSDictionary*)heads{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = 20;
    config.timeoutIntervalForResource = 20;
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:SERVER_URL] sessionConfiguration:config];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSArray* allKeys = [heads allKeys];
    
    for (NSString *key in allKeys) {
        [manager.requestSerializer setValue:[heads objectForKey:key] forHTTPHeaderField:key];
    }
    
    return manager;
}



+(void)POST:(NSDictionary*)param url:(NSString*)url successBlock:(void (^)(id responseObject))successBlock failBlock:(void (^)(int errorCode,NSString *errorStr)) failedBlock{
   
    AFHTTPSessionManager *manager = [BKNetworkManager createHttpRequestManager];
    
    url = [NSString stringWithFormat:@"%@?userToken=%@&pwd=%@",url,[param objectForKey:@"userToken"],[param objectForKey:@"pwd"]];
    NSLog(@"updatePasswordurl => %@",url);
    NSLog(@"请求的地址：%@ %@",SERVER_URL,url);
    NSLog(@"请求的参数：%@",param);
    [manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"返回的结果：%@",responseObject);
        NSDictionary *resDic = responseObject;
        if([[resDic objectForKey:@"success"] boolValue]){
            if([[resDic allKeys] containsObject:@"data"]){
                successBlock([resDic objectForKey:@"data"]);
            }else{
                successBlock(@"");
            }
        }else{
            failedBlock([[resDic objectForKey:@"success"] intValue],[resDic objectForKey:@"message"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.description);
        if ([error.description containsString:@"Error Domain"]) {
            failedBlock(0,@"网络异常");
        }else{
            failedBlock(0,error.description);
        }
    }];
}


+(void)GET:(NSDictionary*)param url:(NSString*)url successBlock:(void (^)(id responseObject))successBlock failBlock:(void (^)(int errorCode,NSString *errorStr)) failedBlock{
    
    AFHTTPSessionManager *manager = [BKNetworkManager createHttpRequestManager];
    NSLog(@"请求的地址：%@ %@",SERVER_URL,url);
    NSLog(@"请求的参数：%@",param);
    [manager GET:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"返回的结果：%@",responseObject);
        NSDictionary *resDic = responseObject;
        if([[resDic objectForKey:@"success"] boolValue]){
            if([[resDic allKeys] containsObject:@"data"]){
                successBlock([resDic objectForKey:@"data"]);
            }else{
                successBlock(@"");
            }
        }else{
            failedBlock([[resDic objectForKey:@"success"] intValue],[resDic objectForKey:@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.description);
        failedBlock(0,error.description);
    }];
}



    
+(void)userLogin:(NSDictionary*)dic successBlock:(void (^)(id responseObject))successBlock failBlock:(void (^)(int code,NSString *errorStr)) failedBlock {

    /** 注：登录时需要上服设备信息，因此在登录时，要加上设备信息参数。
     deviceId：设备唯一ID
     deviceType：1：android,2:iphone
     osVer：设备OS的版本号
     phone：设备型号
     */
    NSMutableDictionary *dics = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dics setValue:@"123123" forKey:@"deviceId"];
    [dics setValue:@"2" forKey:@"deviceType"];
    [dics setValue:[UIDevice currentDevice].systemVersion forKey:@"osVer"];
    [dics setValue:[BKUtils iphoneType] forKey:@"phone"];
    [BKNetworkManager POST:dics url:USER_LOGIN successBlock:successBlock failBlock:failedBlock];
}

+(void)userRegister:(NSDictionary *)dic successBlock:(void (^)(id))successBlock failBlock:(void (^)(int code,NSString *))failedBlock{
    [BKNetworkManager POST:dic url:USER_REGISTER successBlock:successBlock failBlock:failedBlock];
}

+(void)userSMSCode:(NSDictionary *)dic successBlock:(void (^)(id))successBlock failBlock:(void (^)(int code,NSString *))failedBlock{
    [BKNetworkManager GET:dic url:USER_SMS_CODE successBlock:successBlock failBlock:failedBlock];
}

+(void)userRegisterSMSCode:(NSDictionary *)dic successBlock:(void (^)(id))successBlock failBlock:(void (^)(int, NSString *))failedBlock{
    [BKNetworkManager GET:dic url:USER_REGISTER_SMS_CODE successBlock:successBlock failBlock:failedBlock];
}

+(void)userChangePassword:(NSDictionary *)dic successBlock:(void (^)(id))successBlock failBlock:(void (^)(int code,NSString *))failedBlock{
    [BKNetworkManager POST:dic url:USER_CHANGE_PWD successBlock:successBlock failBlock:failedBlock];
}


+(void)checkSmsCode:(NSDictionary *)dic successBlock:(void (^)(id))successBlock failBlock:(void (^)(int code,NSString *))failedBlock{
    [BKNetworkManager GET:dic url:USER_SMS_CHECK successBlock:successBlock failBlock:failedBlock];
}

+(void)getUserTokenByPhone:(NSDictionary *)dic successBlock:(void (^)(id))successBlock failBlock:(void (^)(int code,NSString *))failedBlock{
     [BKNetworkManager GET:dic url:USER_GET_TOKEN successBlock:successBlock failBlock:failedBlock];
}
@end
