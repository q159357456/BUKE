//
//  WeChatManager.m
//  MiniBuKe
//
//  Created by chenheng on 2018/5/21.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "WeChatManager.h"
#import "MBProgressHUD+XBK.h"
#import "AFNetworking.h"
#import "BKNewLoginRequestManage.h"
#import "CommonUsePackaging.h"
#import "BKPaySuccessCtr.h"
#import "PayResultController.h"
@implementation WeChatManager


+(instancetype)sharedManager
{
    static WeChatManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WeChatManager alloc] init];
    });
    
    return manager;
}

+(void)sendAuthRequest
{
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.openID = WXLOGIN_APPID;
    [WXApi sendReq:req];
}

//微信回调的结果
-(void)onResp:(BaseResp *)resp
{
    NSLog(@"[SendAuthResp class]==>%@",NSStringFromClass(resp.class));
    if ([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp *res = (SendAuthResp *)resp;
        switch (res.errCode) {
            case 0:
                if (res.code && res.code.length != 0) {
//                   [self loginSuccessByCode:res.code];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(wechatLoginWithCode:)]) {
                        [self.delegate wechatLoginWithCode:res.code];
                    }
                }

                break;
            case -2:
                //用户取消
                if (self.delegate && [self.delegate respondsToSelector:@selector(wechatLoginError)]) {
                    [self.delegate wechatLoginError];
                }else{
                    
                    [MBProgressHUD showText:@"用户取消授权"];
                }
                break;
            case -4:
                //用户拒绝授权
                if (self.delegate && [self.delegate respondsToSelector:@selector(wechatLoginError)]) {
                    [self.delegate wechatLoginError];
                }else{
                    [MBProgressHUD showText:@"用户拒绝授权"];
                }
                break;

            default:
                break;
        }

    }else if ([resp isKindOfClass:[SendMessageToWXResp class]]){
        //
    }
    else
    {
        
            switch (resp.errCode) {
                case WXSuccess:
                {

                    if (self.payContent == Pay_Member) {
                        self.unfinishedResult = nil;
                        PayResultController *vc = [[PayResultController alloc]init];
                        vc.SuccessTxt = @"恭喜你成为尊享会员";
                        vc.isSuccess = YES;
                        [APP_DELEGATE.navigationController pushViewController:vc animated:NO];
                        
                    }else if (self.payContent == Pay_Course){
                        self.unfinishedResult = nil;
                        PayResultController *vc = [[PayResultController alloc]init];
                        vc.SuccessTxt = @"恭喜你成购买课程，立即查看吧";
                        vc.isSuccess = YES;
                        [APP_DELEGATE.navigationController pushViewController:vc animated:NO];
                    }
                    else
                    {
                       self.unfinishedResult = nil;
                       BKPaySuccessCtr *vc = [[BKPaySuccessCtr alloc]init];
                       [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
                    }
                   
                }
                    break;
                case WXErrCodeCommon:
                {
                    //普通错误类型
                    NSLog(@"普通错误类型--%@",resp.description);
                    [CommonUsePackaging showSystemHint:@"resp.description"];
                    PayResultController *vc = [[PayResultController alloc]init];
                    vc.isSuccess = NO;
                    [APP_DELEGATE.navigationController pushViewController:vc animated:NO];
                }
                    break;
                    
                case WXErrCodeUserCancel:
                {
                    NSLog(@"---用户取消");
//                    [MobClick event:EVENT_Custom_108];
                    [CommonUsePackaging showSystemHint:@"已取消支付!"];
    
                }
                    break;
                case WXErrCodeAuthDeny:
                {
                    NSLog(@"用户拒绝授权");
                    [CommonUsePackaging showSystemHint:@"用户拒绝授权!"];
                }
                    break;
                case WXErrCodeUnsupport:
                {
                    //微信不支持
                    NSLog(@"---微信不支持");
                     [CommonUsePackaging showSystemHint:@"微信不支持!"];
                    
                }
                    break;
                    
                default:
                {
                    //支付失败
                    NSLog(@"支付失败--%@",resp.description);
                    [CommonUsePackaging showSystemHint:resp.description];
                    PayResultController *vc = [[PayResultController alloc]init];
                    vc.isSuccess = NO;
                    [APP_DELEGATE.navigationController pushViewController:vc animated:NO];
                }
                    break;
            }
            
        }
    
}

-(void)loginSuccessByCode:(NSString *)code
{
    [self loginAFNWithCode:code];
}

-(void)loginAFNWithCode:(NSString *)code
{
    __weak typeof(*&self) weakSelf = self;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json",@"text/plain",nil];
    
    [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code&connect_redirect=1",WXLOGIN_APPID,WXLOGIN_APPSECRET,code] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic %@",dic);
        
        NSString *access_token = [dic objectForKey:@"access_token"];
        NSString *openid = [dic objectForKey:@"openid"];
        
        [[NSUserDefaults standardUserDefaults] setObject:access_token forKey:@"access_token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [weakSelf requestUserInfoByToken:access_token andOpenid:openid];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %@",error.localizedFailureReason);
    }];
}

-(void)requestUserInfoByToken:(NSString *)accessToken andOpenid:(NSString *)openid
{
    __weak typeof(*&self) weakSelf = self;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openid] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic  ==== %@",dic);
        
        WechatUserInfo *info = [WechatUserInfo parseInfoByDictionary:dic];
        
        if (info != nil) {
            [weakSelf weChatLoginWithInfo:info];
            
            NSData *infoData = [NSKeyedArchiver archivedDataWithRootObject:info];
            [[NSUserDefaults standardUserDefaults] setObject:infoData forKey:@"WechatUserInfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %ld",(long)error.code);
    }];
}

+(void)weChatLoginWithWechatInfo:(WechatUserInfo *)info
{
    [[WeChatManager sharedManager] weChatLoginWithInfo:info];
}

-(void)weChatLoginWithInfo:(WechatUserInfo *)info
{
    if (info != nil) {
        __weak typeof(*&self) weakSelf = self;
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json",@"text/plain",nil];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",SERVER_URL,@"/user/loginByWeChat"];
        NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
        NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:accessToken forKey:@"accessToken"];
        [params setObject:uuid forKey:@"deviceId"];
        [params setObject:@"2" forKey:@"deviceType"];
        [params setObject:info.headimgurl forKey:@"imageUrl"];
        [params setObject:info.nickname forKey:@"nickName"];
        [params setObject:info.openid forKey:@"openId"];
        [params setObject:info.unionid forKey:@"unionId"];
        [params setObject:[UIDevice currentDevice].systemVersion forKey:@"osVer"];
        [params setObject:[BKUtils iphoneType] forKey:@"phone"];
        
        NSLog(@"urlStr ---> %@",urlStr);
        NSLog(@"params ---> %@",params);
        
        [MBProgressHUD showMessage:@"登录中..."];
        
        [manager POST:urlStr parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [MBProgressHUD hideHUD];
//            [MBProgressHUD showText:@"登录成功"];
            
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSLog(@"dic  ==== %@",dic);
            id dataObject = [dic objectForKey:@"data"];
            
            if ([dataObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dataDic = (NSDictionary *)dataObject;
                if ([weakSelf.delegate respondsToSelector:@selector(wechatLoginSuccessWithDictionary:)]) {
                    [weakSelf.delegate wechatLoginSuccessWithDictionary:dataDic];
                }
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showText:@"登录失败"];
            NSLog(@"error %ld",(long)error.code);
        }];
    }
    
}

+ (void)weiXinPayWithDic:(NSDictionary *)wechatPayDic {
    NSLog(@"wechatPayDic==>%@",wechatPayDic);
    NSDictionary * dic = wechatPayDic[@"data"];
    PayReq *req = [[PayReq alloc] init];
    req.openID =dic [@"appId"];
    req.partnerId = dic [@"mchId"];
    req.prepayId = [dic  objectForKey:@"prepayId"];
    req.package = dic [@"packages"];
    req.nonceStr = [dic  objectForKey:@"nonceStr"];
    req.timeStamp = [[dic  objectForKey:@"timestamp"] intValue];
    req.sign = [dic  objectForKey:@"sign"];
    
    [WXApi sendReq:req];
}
@end
