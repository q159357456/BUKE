//
//  GetVerificationCodeService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/8/3.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "HttpInterface.h"

@interface GetVerificationCodeService : HttpInterface<HttpInterfaceDelegate>


-(id) initWithOnSuccess:(OnSuccess)onSuccessBlock setOnError:(OnError)onErrorBlock setPhoneNum:(NSString *)phoneNum;



@end
