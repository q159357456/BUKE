//
//  WeChatManager.h
//  MiniBuKe
//
//  Created by chenheng on 2018/5/21.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WXApi.h>
#import "WechatUserInfo.h"
typedef NS_ENUM(NSUInteger,PayContent){
    
    Pay_Member = 0,
    Pay_Course,
    Pay_1288 
};
@protocol WeChatManagerDelegate

-(void) wechatLoginSuccessWithDictionary:(NSDictionary *)dic;

/**拉起微信登录成功回调code*/
-(void)wechatLoginWithCode:(NSString*)code;
/**拉起微信登录失败回调*/
-(void)wechatLoginError;

@end


@interface WeChatManager : NSObject<WXApiDelegate>

@property(nonatomic,assign) id delegate;

@property(nonatomic,copy)NSString * unfinishedResult;
@property(nonatomic,assign)PayContent payContent;
+(instancetype) sharedManager;

+(void)sendAuthRequest;

+(void)weChatLoginWithWechatInfo:(WechatUserInfo *)info;

+ (void)weiXinPayWithDic:(NSDictionary *)wechatPayDic;

@end
