//
//  checkMessageCodeService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/9/18.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "HttpInterface.h"

@interface CheckMessageCodeService : HttpInterface<HttpInterfaceDelegate>

@property (nonatomic,strong) NSString *userToken;

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUserToken:(NSString *) userToken
setSMSCode:(NSString *) smsCode;

@end
