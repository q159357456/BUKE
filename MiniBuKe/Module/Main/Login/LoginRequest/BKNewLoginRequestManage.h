//
//  BKNewLoginRequestManage.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/26.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKNewLoginRequestManage : NSObject

/**APP微信登录接口*/
+(void)requestLoginWxAppWithCode:(NSString*)code AndFinish:(void(^)(id responsed,NSError *error))completionHandler;
/**手机+验证码登录绑定接口*/
+(void)requestLoginWithPhone:(NSString*)phoneNumber WithCode:(NSString*)code WithUnionId:(NSString*)unionId AndFinish:(void(^)(id responsed,NSError *error))completionHandler;
/**自动登录刷新token接口*/
+(void)requestRefreshTokenWithtoken:(NSString*)refreshToken AndFinish:(void(^)(id responsed,NSError *error))completionHandler;
/**发送短信验证码接口*/
+(void)resquestSendVerificationCodeWithPhoneNumber:(NSString*)number AndFinish:(void(^)(id responsed,NSError *error))completionHandler;
/**绑定微信*/
+(void)requestBindWeChartWithCode:(NSString*)code AndFinish:(void(^)(id responsed,NSError *error))completionHandler;
/**更新绑定微信*/
+(void)requestBindWeChartTXWithCode:(NSString*)code AndFinish:(void(^)(id responsed,NSError *error))completionHandler;
/**解绑微信*/
+(void)requestunBindWeChartAndFinish:(void(^)(id responsed,NSError *error))completionHandler;

@end

NS_ASSUME_NONNULL_END
