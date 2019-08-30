//
//  OJBabyInfoUpLoadService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/10/31.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpInterface.h"
#import "OJBabyInfoUpLoadService.h"
NS_ASSUME_NONNULL_BEGIN

@interface OJBabyInfoUpLoadService : HttpInterface<HttpInterfaceDelegate>
-(id)initWithOnSuccess:(OnSuccess)onSuccessBlock setOnError:(OnError)onErrorBlock setToken:(NSString *)token setDictionary:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
