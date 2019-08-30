//
//  AppKeySecretService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/6/12.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpInterface.h"
#import "XbkKeySecret.h"

@interface AppKeySecretService : HttpInterface<HttpInterfaceDelegate>

@property (nonatomic,strong) XbkKeySecret *mXbkKeySecret;

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
   setType:(NSString *) type
setUserId:(NSString *) userId;

@end
