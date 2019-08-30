//
//  PushDeviceTokenService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/8/8.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "HttpInterface.h"

@interface PushDeviceTokenService : HttpInterface<HttpInterfaceDelegate>

-(id) initWithOnSuccess:(OnSuccess)onSuccessBlock setOnError:(OnError)onErrorBlock setDictionary:(NSDictionary *)dictionary;


@end
