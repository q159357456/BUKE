//
//  LoginResult.h
//  MiniBuKe
//
//  Created by zhangchunzhe on 2018/2/26.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BaseEntity.h"
@class LogintokenDTO;

@interface LoginResult : BaseEntity

@property (nonatomic,copy) NSString *imageUlr;
@property (nonatomic,copy) NSString *nickName;
@property (nonatomic,copy) NSString *SN;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *token;
@property (nonatomic,copy) NSString *appellativeName;
@property (nonatomic,copy) NSString *hasBabyInfo;
@property (nonatomic,strong) LogintokenDTO *tokenDTO;
@property (nonatomic,copy) NSString *wxNickName;//微信昵称
@property (nonatomic,assign) BOOL bindWx; //是否绑定微信
@property (nonatomic,copy) NSString *wxImageUrl;//微信头像

+ (LoginResult *) withLoginResultJson:(NSDictionary *) jsonDic;

@end

@interface LogintokenDTO : NSObject

@property (nonatomic,copy)  NSString *accessToken;
@property (nonatomic,copy)  NSString *refreshToken;
@property (nonatomic,copy)  NSString *scope;
@property (nonatomic,copy)  NSString *tokenType;
@property (nonatomic,copy)  NSString *expiresIn;

+ (LogintokenDTO *) withtokenDTOResultJson:(NSDictionary *) jsonDic;

@end
