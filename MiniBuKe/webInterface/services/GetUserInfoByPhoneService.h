//
//  GetUserInfoByPhoneService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/9/18.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "HttpInterface.h"

@interface GetUserInfoByPhoneService : HttpInterface<HttpInterfaceDelegate>

@property (nonatomic,strong) NSString *userToken;

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setPhone:(NSString *) phone;

@end
