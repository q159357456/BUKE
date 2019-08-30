//
//  BKNetworkManager.h
//  MiniBuKe
//
//  Created by zhangchunzhe on 2018/2/26.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BKNetworkManager : NSObject

// 用户登陆
+(void)userLogin:(NSDictionary*)dic successBlock:(void (^)(id responseObject))successBlock failBlock:(void (^)(int code,NSString *errorStr)) failedBlock;

// 用户注册
+(void)userRegister:(NSDictionary*)dic successBlock:(void (^)(id responseObject))successBlock failBlock:(void (^)(int code,NSString *errorStr)) failedBlock;

// 获取手机短信验证码
+(void)userSMSCode:(NSDictionary*)dic successBlock:(void (^)(id responseObject))successBlock failBlock:(void (^)(int code,NSString *errorStr)) failedBlock;

// 获取手机短信验证码
+(void)userRegisterSMSCode:(NSDictionary*)dic successBlock:(void (^)(id responseObject))successBlock failBlock:(void (^)(int code,NSString *errorStr)) failedBlock;

// 修改密码
+(void)userChangePassword:(NSDictionary*)dic successBlock:(void (^)(id responseObject))successBlock failBlock:(void (^)(int code,NSString *errorStr)) failedBlock;

//获取用户Token
+(void)getUserTokenByPhone:(NSDictionary*)dic successBlock:(void (^)(id responseObject))successBlock failBlock:(void (^)(int code,NSString *errorStr)) failedBlock;

// 修改密码
+(void)checkSmsCode:(NSDictionary*)dic successBlock:(void (^)(id responseObject))successBlock failBlock:(void (^)(int code,NSString *errorStr)) failedBlock;


@end
