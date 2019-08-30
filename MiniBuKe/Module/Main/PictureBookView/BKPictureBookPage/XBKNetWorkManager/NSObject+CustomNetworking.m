//
//  NSObject+CustomNetworking.m
//  PictureBook
//
//  Created by Don on 2018/5/7.
//  Copyright © 2018年 Don. All rights reserved.
//
#import "NSObject+CustomNetworking.h"
#import "XBKNetWorkManager.h"

#define kTimeoutInterval   10.0

@implementation NSObject (CustomNetworking)

+ (instancetype)RequestNetWithType:(BKRequestType)requestType tokenFlag:(NSString*)tokenFlagstr Path:(NSString *)path parameters:(NSDictionary *)parameters isCache:(BOOL)isCache  withTime:(float)time progress:(void(^)(NSProgress *downloadProgress))downloadProgress completionHandler:(void(^)(id responseObj, NSError *error))completionHandler{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //让AF接受除了JSON以外的数据类型:
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/plain", @"text/json", @"text/javascript", @"application/json", nil];
    
    //设置请求头
    if(tokenFlagstr.length){
//        [manager.requestSerializer setValue:APP_DELEGATE.mLoginResult.token forHTTPHeaderField:@"USER_TOKEN"];
        [manager.requestSerializer setValue:APP_DELEGATE.mLoginResult.token forHTTPHeaderField:tokenFlagstr];
    }
    UIDevice *device = [UIDevice currentDevice];
    NSString *deviceName = [device model];
    [manager.requestSerializer setValue:deviceName forHTTPHeaderField:@"User-Agent"];
    NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [manager.requestSerializer setValue:app_Version forHTTPHeaderField:@"version"];

    //请求超时时间
    manager.requestSerializer.timeoutInterval = kTimeoutInterval;
    if (requestType == BKRequestType_Post){
        return [manager POST:path parameters:parameters progress:downloadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            completionHandler(responseObject, nil);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            completionHandler(nil, error);
            
        }];
        
    }else if (requestType == BKRequestType_Delete){
        return [manager DELETE:path parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            completionHandler(responseObject, nil);

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            completionHandler(nil, error);
            

        }];
        
    }else{
        return [manager GET:path parameters:parameters progress:downloadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            completionHandler(responseObject, nil);

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            completionHandler(nil, error);

        }];

    }
}

+ (instancetype)RequestPostPicWithType:(NSArray*)array Path:(NSString *)path parameters:(NSDictionary *)parameters isCache:(BOOL)isCache  withTime:(float)time progress:(void(^)(NSProgress *downloadProgress))downloadProgress completionHandler:(void(^)(id responseObj, NSError *error))completionHandler{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = kTimeoutInterval;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    //设置请求头
    [manager.requestSerializer setValue:APP_DELEGATE.mLoginResult.token forHTTPHeaderField:@"USER_TOKEN"];
    UIDevice *device = [UIDevice currentDevice];
    NSString *deviceName = [device model];
    [manager.requestSerializer setValue:deviceName forHTTPHeaderField:@"User-Agent"];
    NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [manager.requestSerializer setValue:app_Version forHTTPHeaderField:@"version"];
    
    return  [manager POST:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
        // 这里的_photoArr是你存放图片的数组
        for (int i = 0; i < array.count; i++) {
            
            NSData *imageData = [XBKNetWorkManager compressImage:array[i] toByte:200*1024];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"iOS_app_Bookneeded_%@_%d.jpeg", dateString,i];
            /*
             *该方法的参数
             1. appendPartWithFileData：要上传的照片[二进制流]
             2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
             3. fileName：要保存在服务器上的文件名
             4. mimeType：上传的文件的类型
             */
            [formData appendPartWithFileData:imageData name:@"fileList" fileName:fileName mimeType:@"image/jpeg"]; //
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"---上传进度--- %@",uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"```上传成功``` %@",responseObject);
        return  completionHandler(responseObject, nil);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"xxx上传失败xxx %@", error);
        return completionHandler(nil, error);
    }];
}

+ (void)RequestNetAndIsJSONParameter:(BOOL)IsJSONParameter With:(BKRequestType)requestType tokenFlag:(NSString*)tokenFlagstr Path:(NSString *)path parameters:(NSDictionary *)parameters isCache:(BOOL)isCache  withTime:(float)time progress:(void(^)(NSProgress *downloadProgress))downloadProgress completionHandler:(void(^)(id responseObj, NSError *error))completionHandler{
    
    if (IsJSONParameter) {//只提交json参数请求
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        if (requestType == BKRequestType_Post){
            NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:path parameters:parameters error:nil];
            request.timeoutInterval = kTimeoutInterval;
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            if (tokenFlagstr.length) {
                [request setValue:APP_DELEGATE.mLoginResult.token forHTTPHeaderField:tokenFlagstr];
            }
            UIDevice *device = [UIDevice currentDevice];
            NSString *deviceName = [device model];
            [request setValue:deviceName forHTTPHeaderField:@"User-Agent"];
            NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            [request setValue:app_Version forHTTPHeaderField:@"version"];
            
            NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                return completionHandler(responseObject,error);
            }];
            [task resume];
            
        }else if (requestType == BKRequestType_Get){
            NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:path parameters:parameters error:nil];
            request.timeoutInterval = kTimeoutInterval;
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            if (tokenFlagstr.length) {
                [request setValue:APP_DELEGATE.mLoginResult.token forHTTPHeaderField:tokenFlagstr];
            }
            UIDevice *device = [UIDevice currentDevice];
            NSString *deviceName = [device model];
            [request setValue:deviceName forHTTPHeaderField:@"User-Agent"];
            NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            [request setValue:app_Version forHTTPHeaderField:@"version"];
            
            NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                return completionHandler(responseObject,error);
            }];
            [task resume];
        }
        else if (requestType == BKRequestType_Delete){
            NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"DELETE" URLString:path parameters:parameters error:nil];
            request.timeoutInterval = kTimeoutInterval;
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            if (tokenFlagstr.length) {
                [request setValue:APP_DELEGATE.mLoginResult.token forHTTPHeaderField:tokenFlagstr];
            }
            UIDevice *device = [UIDevice currentDevice];
            NSString *deviceName = [device model];
            [request setValue:deviceName forHTTPHeaderField:@"User-Agent"];
            NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            [request setValue:app_Version forHTTPHeaderField:@"version"];
            
            NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                return completionHandler(responseObject,error);
            }];
            [task resume];
        }
    }else{//表单提交参数
        [self RequestNetWithType:requestType tokenFlag:tokenFlagstr Path:path parameters:parameters isCache:isCache withTime:time progress:(void(^)(NSProgress *downloadProgress))downloadProgress completionHandler:(void(^)(id responseObj, NSError *error))completionHandler];
    }
    
}
@end
