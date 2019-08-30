//
//  LoginResult.m
//  MiniBuKe
//
//  Created by zhangchunzhe on 2018/2/26.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "LoginResult.h"
@interface LoginResult()


@end

@implementation LoginResult
- (instancetype)init{
    if (self = [super init]) {
        self.tokenDTO = [[LogintokenDTO alloc]init];
    }
    return self;
}

+ (LoginResult *) withLoginResultJson:(NSDictionary *) jsonDic
{
    LoginResult *mLoginResult = nil;
    if (jsonDic != nil) {
        mLoginResult = [[LoginResult alloc] init];
        
        mLoginResult.imageUlr = ![[jsonDic objectForKey:@"imageUrl"] isKindOfClass:[NSNull class]] ? [jsonDic objectForKey:@"imageUrl"] : @"";
        mLoginResult.nickName = ![[jsonDic objectForKey:@"nickName"] isKindOfClass:[NSNull class]] ? [jsonDic objectForKey:@"nickName"] : @"";
        mLoginResult.SN = ![[jsonDic objectForKey:@"sn"] isKindOfClass:[NSNull class]] ? [jsonDic objectForKey:@"sn"] : @"";
        mLoginResult.userName = ![[jsonDic objectForKey:@"userName"] isKindOfClass:[NSNull class]] ? [jsonDic objectForKey:@"userName"] : @"";
        mLoginResult.userId = ![[jsonDic objectForKey:@"userId"] isKindOfClass:[NSNull class]] ? [jsonDic objectForKey:@"userId"] : @"";
        mLoginResult.wxNickName = ![[jsonDic objectForKey:@"wxNickName"] isKindOfClass:[NSNull class]] ? [jsonDic objectForKey:@"wxNickName"] : @"";
        mLoginResult.bindWx = [[jsonDic objectForKey:@"bindWx"]integerValue];
//        mLoginResult.token = ![[jsonDic objectForKey:@"token"] isKindOfClass:[NSNull class]] ? [jsonDic objectForKey:@"token"] : @"";
        mLoginResult.appellativeName = ![[jsonDic objectForKey:@"appellativeName"] isKindOfClass:[NSNull class]] ? [jsonDic objectForKey:@"appellativeName"] : @"";
        mLoginResult.hasBabyInfo = ![[jsonDic objectForKey:@"hasBabyInfo"] isKindOfClass:[NSNull class]] ? [jsonDic objectForKey:@"hasBabyInfo"] : @"";
        mLoginResult.wxImageUrl = ![[jsonDic objectForKey:@"wxImageUrl"] isKindOfClass:[NSNull class]] ? [jsonDic objectForKey:@"wxImageUrl"] : @"";
        mLoginResult.tokenDTO = [LogintokenDTO withtokenDTOResultJson:[jsonDic objectForKey:@"tokenDTO"]];
        mLoginResult.token = mLoginResult.tokenDTO.accessToken;
        
        NSLog(@"imageUlr = %@,nickName = %@,SN = %@,userName = %@,userId = %@,token = %@,wenickName=%@",mLoginResult.imageUlr,mLoginResult.nickName,mLoginResult.SN,mLoginResult.userName,mLoginResult.userId,mLoginResult.token,mLoginResult.wxNickName);
    }
    
    return mLoginResult;
}

@end

@implementation LogintokenDTO

+ (LogintokenDTO *) withtokenDTOResultJson:(NSDictionary *) jsonDic{
    LogintokenDTO *tolenDTO = nil;
    if (jsonDic != nil) {
        tolenDTO = [[LogintokenDTO alloc] init];
        tolenDTO.accessToken = ![[jsonDic objectForKey:@"accessToken"] isKindOfClass:[NSNull class]] ? [jsonDic objectForKey:@"accessToken"] : @"";
        tolenDTO.refreshToken = ![[jsonDic objectForKey:@"refreshToken"] isKindOfClass:[NSNull class]] ? [jsonDic objectForKey:@"refreshToken"] : @"";
        tolenDTO.scope = ![[jsonDic objectForKey:@"scope"] isKindOfClass:[NSNull class]] ? [jsonDic objectForKey:@"scope"] : @"";
        tolenDTO.tokenType = ![[jsonDic objectForKey:@"tokenType"] isKindOfClass:[NSNull class]] ? [jsonDic objectForKey:@"tokenType"] : @"";
        tolenDTO.expiresIn = ![[jsonDic objectForKey:@"expiresIn"] isKindOfClass:[NSNull class]] ? [jsonDic objectForKey:@"expiresIn"] : @"";

    }
    
    return tolenDTO;
}


@end
