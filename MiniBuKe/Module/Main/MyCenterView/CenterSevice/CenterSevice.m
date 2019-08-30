//
//  CenterSevice.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/30.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "CenterSevice.h"
#import "AFNetworking.h"
#import "NSObject+CustomNetworking.h"
#import "XBKNetWorkManager.h"
@implementation CenterSevice
//获取优惠券信息(GET)
+(void)pay_goods:(NSString*)goodsid AndFinish:(CompletionHandler)completionHandler
{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *path = [NSString stringWithFormat:@"%@%@%@/%@",NewLoginSERVER_URL,cloudPay,@"/goods",goodsid];
//     NSLog(@"NSString *path:%@",path);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:goodsid forKey:@"id"];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:path parameters:nil error:nil];
    request.timeoutInterval = 10.f;
    [request setValue:APP_DELEGATE.mLoginResult.token forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        NSLog(@"-----responseObject===%@+++++",responseObject);
        return completionHandler(responseObject,error);
    }];
    
    [task resume];
}
//预支付订单(POST)
+(void)pay_wx_order:(NSString*)goodsId UserDisId:(NSString*)userDisId AndFinish:(CompletionHandler)completionHandler
{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *path = [NSString stringWithFormat:@"%@%@%@",NewLoginSERVER_URL,cloudPay,@"/wx/order"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:goodsId forKey:@"goodsId"];
    if (userDisId.length>0) {
        [params setObject:userDisId forKey:@"userDisId"];
    }
    
    NSLog(@"path:%@",path);
    NSLog(@"params:%@",params);
    NSLog(@"Authorization:%@",APP_DELEGATE.mLoginResult.token);
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:path parameters:params error:nil];
    request.timeoutInterval = 10.f;
    [request setValue:APP_DELEGATE.mLoginResult.token forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        NSLog(@"-----responseObject===%@+++++",responseObject);
        return completionHandler(responseObject,error);
    }];
    
    [task resume];
}
//获取默认收货地址(GET)
+(void)pay_address:(CompletionHandler)completionHandler
{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *path = [NSString stringWithFormat:@"%@%@%@",NewLoginSERVER_URL,cloudPay,@"/address/"];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:path parameters:nil error:nil];
    request.timeoutInterval = 10.f;
    [request setValue:APP_DELEGATE.mLoginResult.token forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        NSLog(@"-----responseObject===%@+++++",responseObject);
        return completionHandler(responseObject,error);
    }];
    
    [task resume];
}
//分享生成图片(GET)
+(void)user_invitation_share:(CompletionHandler)completionHandler
{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *path = [NSString stringWithFormat:@"%@%@%@",NewLoginSERVER_URL,cloudUser,@"/invitation/share"];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:path parameters:nil error:nil];
    request.timeoutInterval = 10.f;
    [request setValue:APP_DELEGATE.mLoginResult.token forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        NSLog(@"-----responseObject===%@+++++",responseObject);
        return completionHandler(responseObject,error);
    }];
    
    [task resume];
}

//分享URL(/v1/invitation/share/{sort})
+(void)v1_invitation_share:(NSInteger)sort CompletionHandler:(CompletionHandler)completionHandler{
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *path = [NSString stringWithFormat:@"%@%@%ld",NewLoginSERVER_URL,@"/v1/invitation/share/",sort];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:path parameters:nil error:nil];
    request.timeoutInterval = 10.f;
    [request setValue:APP_DELEGATE.mLoginResult.token forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        //        NSLog(@"-----responseObject===%@+++++",responseObject);
        return completionHandler(responseObject,error);
    }];
    
    [task resume];
}

//加或者修改用户收货地址(POST)
+(void)post_pay_addressAdressData:(NSDictionary*)params CompletionHandler:(CompletionHandler)completionHandler{
    
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *path = [NSString stringWithFormat:@"%@%@%@",NewLoginSERVER_URL,cloudPay,@"/address/"];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:path parameters:params error:nil];
    request.timeoutInterval = 10.f;
    [request setValue:APP_DELEGATE.mLoginResult.token forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        //        NSLog(@"-----responseObject===%@+++++",responseObject);
        return completionHandler(responseObject,error);
    }];
    
    [task resume];
}

//拉取宝贝信息(GET )
+(void)user_fetchBabyInfo:(CompletionHandler)completionHandler
{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *path = [NSString stringWithFormat:@"%@%@%@",SERVER_URL,cloudUser,@"/fetchBabyInfo"];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:path parameters:nil error:nil];
    request.timeoutInterval = 10.f;
    [request setValue:APP_DELEGATE.mLoginResult.token forHTTPHeaderField:@"USER_TOKEN"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        //        NSLog(@"-----responseObject===%@+++++",responseObject);
        return completionHandler(responseObject,error);
    }];
    
    [task resume];
}
//上传宝贝头像获得(POST)
+(void)user_uploadBabyAvatar:(NSArray*)data CompletionHandler:(CompletionHandler)completionHandler
{
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_URL,@"/file/upload"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    //设置请求头
    [manager.requestSerializer setValue:APP_DELEGATE.mLoginResult.token forHTTPHeaderField:@"USER_TOKEN"];
    UIDevice *device = [UIDevice currentDevice];
    NSString *deviceName = [device model];
    [manager.requestSerializer setValue:deviceName forHTTPHeaderField:@"User-Agent"];
    NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [manager.requestSerializer setValue:app_Version forHTTPHeaderField:@"version"];
    
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
        // 这里的_photoArr是你存放图片的数组
        for (int i = 0; i < data.count; i++) {
            
            NSData *imageData = [XBKNetWorkManager compressImage:data[i] toByte:200*1024];
            
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
            [formData appendPartWithFileData:imageData name:@"datfile" fileName:fileName mimeType:@"image/jpeg"]; //
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"---上传进度--- %@",uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
 
         completionHandler(responseObject, nil);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"xxx上传失败xxx %@", error);
         completionHandler(nil, error);
    }];
}
//更新宝贝信息(POST)
+(void)user_updateBabyInfo:(NSDictionary*)params CompletionHandler:(CompletionHandler)completionHandler
{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *path = [NSString stringWithFormat:@"%@%@%@",SERVER_URL,cloudUser,@"/updateBabyInfo"];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:path parameters:params error:nil];
    request.timeoutInterval = 10.f;
    [request setValue:APP_DELEGATE.mLoginResult.token forHTTPHeaderField:@"USER_TOKEN"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {

        return completionHandler(responseObject,error);
    }];
    
    [task resume];
}
//上传宝贝信息(POST)
+(void)user_uploadBabyInfo:(NSDictionary*)params CompletionHandler:(CompletionHandler)completionHandler{
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *path = [NSString stringWithFormat:@"%@%@%@",SERVER_URL,cloudUser,@"/uploadBabyInfo"];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:path parameters:params error:nil];
    request.timeoutInterval = 10.f;
    [request setValue:APP_DELEGATE.mLoginResult.token forHTTPHeaderField:@"USER_TOKEN"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        return completionHandler(responseObject,error);
    }];
    
    [task resume];
    
}

//app获取标签分类GET /pub/tag/list/{type}
+(void)pub_tag_list_type:(NSString*)type CompletionHandler:(CompletionHandler)completionHandler
{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *path = [NSString stringWithFormat:@"%@/pub/tag/list/%@",SERVER_URL,type];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:path parameters:nil error:nil];
    request.timeoutInterval = 10.f;
    [request setValue:APP_DELEGATE.mLoginResult.token forHTTPHeaderField:@"USER_TOKEN"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        //        NSLog(@"-----responseObject===%@+++++",responseObject);
        return completionHandler(responseObject,error);
    }];
    
    [task resume];
}
//机器人电池量(GET)
+(void)pub_robot_battery:(CompletionHandler)completionHandler
{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *path = [NSString stringWithFormat:@"%@/pub/robot/battery",SERVER_URL];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:path parameters:nil error:nil];
    request.timeoutInterval = 10.f;
    [request setValue:APP_DELEGATE.mLoginResult.token forHTTPHeaderField:@"USER_TOKEN"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        //        NSLog(@"-----responseObject===%@+++++",responseObject);
        return completionHandler(responseObject,error);
    }];
    
    [task resume];
}

//机器人是否联网(GET)
+(void)robot_isOnline:(CompletionHandler)completionHandler
{
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSString *deviceId = APP_DELEGATE.mLoginResult.SN?:@"";
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *path = [NSString stringWithFormat:@"%@/robot/isOnline?deviceId=%@",SERVER_URL,deviceId];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:path parameters:nil error:nil];
    request.timeoutInterval = 10.f;
    [request setValue:APP_DELEGATE.mLoginResult.token forHTTPHeaderField:@"USER_TOKEN"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        //        NSLog(@"-----responseObject===%@+++++",responseObject);
        return completionHandler(responseObject,error);
    }];
    
    [task resume];
}
@end
