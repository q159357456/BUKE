//
//  StaticIndexService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/20.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "HttpInterface.h"

@class StaticIndexObject;

@interface StaticIndexService : HttpInterface<HttpInterfaceDelegate>

@property (nonatomic,strong) StaticIndexObject *mStaticIndexObject;

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN;

@end
