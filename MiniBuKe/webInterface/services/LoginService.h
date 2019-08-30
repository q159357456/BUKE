//
//  LoginService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/7/10.
//  Copyright © 2018年 lucky. All rights reserved.
//

#import "HttpInterface.h"
#import "LoginResult.h"

@interface LoginService : HttpInterface<HttpInterfaceDelegate>

@property (nonatomic,strong) LoginResult *mLoginResult;

-(id) init:(OnSuccess) onSuccessBlock setOnError:(OnError) onErrorBlock setAccount:(NSString *)account setPassword:(NSString *) password;

@end
