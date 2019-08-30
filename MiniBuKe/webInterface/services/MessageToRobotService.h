//
//  MessageToRobotService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/5/2.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "HttpInterface.h"

@interface MessageToRobotService : HttpInterface<HttpInterfaceDelegate>


-(id)initWithUerToken:(NSString *)token setContent:(NSString *)content setImtype:(NSString *)imtype setTime:(NSInteger)time setOnSuccess:(OnSuccess)onSuccessBlock setOnError:(OnError)onErrorBlock;

@end
