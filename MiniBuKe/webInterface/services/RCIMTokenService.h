//
//  RCIMTokenService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/11.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "RCIMTokenService.h"
#import "HttpInterface.h"
@interface RCIMTokenService : HttpInterface<HttpInterfaceDelegate>

@property(nonatomic,copy)NSString *RCtoken;

-(id) init:(NSString *)usrid
setUserName:(NSString *)usrName
setUserAvatar:(NSString *)usrAvatar
setOnSuccess:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock;

@end
