//
//  BKNewLoginRequestManage.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/26.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKNewLoginRequestManage.h"
#import "AFNetworking.h"
#import "NSObject+CustomNetworking.h"
#import "CommonUsePackaging.h"

#define deviceId [[BaiduMobStat defaultStat] getTestDeviceId]
@implementation BKNewLoginRequestManage
/**APP微信登录接口*/
+(void)requestLoginWxAppWithCode:(NSString*)code AndFinish:(void(^)(id responsed,NSError *error))completionHandler{

    NSString *path = [NSString stringWithFormat:@"%@%@%@",NewLoginSERVER_URL,cloudUser,@"/login/wxApp"];
//    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:code forKey:@"code"];
    [params setObject:deviceId forKey:@"deviceId"];
    [params setObject:@"2" forKey:@"deviceType"];
    [params setObject:[UIDevice currentDevice].systemVersion forKey:@"osVer"];
    [params setObject:[BKUtils iphoneType] forKey:@"phone"];
    
    [self RequestNetAndIsJSONParameter:YES With:BKRequestType_Post tokenFlag:@"" Path:path parameters:params isCache:NO withTime:0 progress:nil completionHandler:^(id responseObj, NSError *error) {
        return completionHandler(responseObj,error);
    }];
}

/**手机+验证码登录接口*/
+(void)requestLoginWithPhone:(NSString*)phoneNumber WithCode:(NSString*)code WithUnionId:(NSString*)unionId AndFinish:(void(^)(id responsed,NSError *error))completionHandler{
    
    NSString *path = [NSString stringWithFormat:@"%@%@%@",NewLoginSERVER_URL,cloudUser,@"/login"];
//    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:deviceId forKey:@"deviceId"];
    [params setObject:@"2" forKey:@"deviceType"];
    [params setObject:[UIDevice currentDevice].systemVersion forKey:@"osVer"];
    [params setObject:[BKUtils iphoneType] forKey:@"phone"];
    [params setObject:code forKey:@"verificationCode"];
    [params setObject:phoneNumber forKey:@"userName"];
    if(unionId.length){
        [params setObject:unionId forKey:@"unionId"];
    }

    [self RequestNetAndIsJSONParameter:YES With:BKRequestType_Post tokenFlag:@"" Path:path parameters:params isCache:NO withTime:0 progress:nil completionHandler:^(id responseObj, NSError *error) {
        return completionHandler(responseObj,error);
    }];
}

/**自动登录刷新token接口*/
+(void)requestRefreshTokenWithtoken:(NSString*)refreshToken AndFinish:(void(^)(id responsed,NSError *error))completionHandler{
    
    NSString *path = [NSString stringWithFormat:@"%@%@%@",NewLoginSERVER_URL,cloudUser,@"/login/token"];
//    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:deviceId forKey:@"deviceId"];
    [params setObject:@"2" forKey:@"deviceType"];
    [params setObject:[UIDevice currentDevice].systemVersion forKey:@"osVer"];
    [params setObject:[BKUtils iphoneType] forKey:@"phone"];
    [params setObject:refreshToken forKey:@"refreshToken"];
    
    [self RequestNetAndIsJSONParameter:YES With:BKRequestType_Post tokenFlag:@"" Path:path parameters:params isCache:NO withTime:0 progress:nil completionHandler:^(id responseObj, NSError *error) {
        return completionHandler(responseObj,error);
    }];
}

/**发送短信验证码接口*/
+(void)resquestSendVerificationCodeWithPhoneNumber:(NSString*)number AndFinish:(void(^)(id responsed,NSError *error))completionHandler{
    
    NSString *path = [NSString stringWithFormat:@"%@%@?",SERVER_URL,@"/user/v2/getVerificationCode"];
    NSDictionary *dic = @{@"phone":number,
                          @"random":[CommonUsePackaging getRandomNumber],
                          @"timestamp":[CommonUsePackaging getNowTimeTimestamp],
                          signappId_Key:signappId,
                          signappKey_Key:signappKey
                          };
    NSString *str = [CommonUsePackaging getEncryptionSinWithDic:dic];
    path = [path stringByAppendingString:str];
    NSLog(@"%@",path);
    [self RequestNetAndIsJSONParameter:NO With:BKRequestType_Get tokenFlag:@"" Path:path parameters:nil isCache:NO withTime:0 progress:nil completionHandler:^(id responseObj, NSError *error) {
        return completionHandler(responseObj,error);
    }];
}

/**绑定微信*/
+(void)requestBindWeChartWithCode:(NSString*)code AndFinish:(void(^)(id responsed,NSError *error))completionHandler{

    NSString *path = [NSString stringWithFormat:@"%@%@%@",NewLoginSERVER_URL,cloudUser,@"/bind/appWx"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:code forKey:@"code"];

    [self RequestNetAndIsJSONParameter:YES With:BKRequestType_Post tokenFlag:tokenFlagAuthorization Path:path parameters:params isCache:NO withTime:0 progress:nil completionHandler:^(id responseObj, NSError *error) {
        return completionHandler(responseObj,error);
    }];
}
/**更新绑定微信*/
+(void)requestBindWeChartTXWithCode:(NSString*)code AndFinish:(void(^)(id responsed,NSError *error))completionHandler{
    NSString *path = [NSString stringWithFormat:@"%@%@%@",NewLoginSERVER_URL,cloudUser,@"/bind/appWx/tx"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:code forKey:@"code"];
    [self RequestNetAndIsJSONParameter:YES With:BKRequestType_Post tokenFlag:tokenFlagAuthorization Path:path parameters:params isCache:NO withTime:0 progress:nil completionHandler:^(id responseObj, NSError *error) {
        return completionHandler(responseObj,error);
    }];
}

/**解绑微信*/
+(void)requestunBindWeChartAndFinish:(void(^)(id responsed,NSError *error))completionHandler{
    NSString *path = [NSString stringWithFormat:@"%@%@%@",NewLoginSERVER_URL,cloudUser,@"/unbind/wx"];
    [self RequestNetAndIsJSONParameter:NO With:BKRequestType_Post tokenFlag:tokenFlagAuthorization Path:path parameters:nil isCache:NO withTime:0 progress:nil completionHandler:^(id responseObj, NSError *error) {
        return completionHandler(responseObj,error);
    }];
    
}

@end
