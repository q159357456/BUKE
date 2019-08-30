//
//  RequestApiHeader.h
//  MiniBuKe
//
//  Created by zhangchunzhe on 2018/2/26.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#ifndef RequestApiHeader_h
#define RequestApiHeader_h

#define EN_MODULE_SHOW YES

#ifdef DEBUG
#define SERVER_URL @"https://dev.xiaobuke.com"
#define RCIM_KEY    @"25wehl3u29nxw" //融云APP_KEY(devloper)
#define UMChannelName @"Test Debug"
#define NewLoginSERVER_URL @"https://dev-api.xiaobuke.com"
#define H5SERVER_URL @"https://dev-api.xiaobuke.com"
#define BeforeHandEnv_URL @"https://dev-api.xiaobuke.com"
#else
#define SERVER_URL @"https://api-jd.xiaobuke.com/legacy"
#define RCIM_KEY    @"qd46yzrfqhclf"//(pro)
#define UMChannelName @"App Store"
#define NewLoginSERVER_URL @"https://api-jd.xiaobuke.com"
#define H5SERVER_URL @"https://api-jd.xiaobuke.com"
#define BeforeHandEnv_URL @"https://api-jd.xiaobuke.com"
#endif
#define LocalHost_URL @"http://192.168.0.246"
#define buglyId @"39c04c6391"
#define buglyKey @"fc7b9cc9-5eca-48b6-9f6d-4d3760fcccc0"
#define XG_ACCESS_ID 2200322509
#define XG_ACCESS_KEY @"IJ5YAR7164AN"
#define signappId_Key @"appKey"
#define signappId @"ojdkfjlfdew_="
#define signappKey_Key @"key"
#define signappKey @"ojfgsldncdkvcqlqmszg"
#define TENCENT_SDK_APPID 1400163731
#define TENCENT_ACCOUNT_TYPE @"36862"

#define tokenFlagAuthorization @"Authorization"
#define tokenFlagUSER_TOKEN @"USER_TOKEN"
#define cloudUser @"/user"
#define cloudPay  @"/pay"
#define WECHAT_LOGIN @"/user/loginByWeChat"
#define USER_LOGIN @"/user/login" //登陆
#define USER_REGISTER @"/user/register" // 注册
#define USER_SMS_CODE @"/user/sendForgetPwdSmsCode" // 忘记密码获取验证码
#define USER_CHANGE_PWD @"/user/updatePassport" //修改密码
#define USER_GET_TOKEN @"/user/getUserInfoByPhone" // 根据手机号获取Token
#define USER_SMS_CHECK @"/user/checkMessageCode" // 根据手机号获取Token
#define USER_REGISTER_SMS_CODE @"/user/getVerificationCode"
#define USER_REGISTER_AGREEMENT_URL @"http://www.xiaobuke.com/agreement.html"
#define HttpRequest_URL [NSString string]

#endif /* RequestApiHeader_h */
