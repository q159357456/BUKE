//
//  FetchBabyInfoService.h
//  MiniBuKe
//
//  Created by chenheng on 2018/5/31.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "HttpInterface.h"

@interface FetchBabyInfoService : HttpInterface<HttpInterfaceDelegate>

@property(nonatomic,copy) NSDictionary *babyDic;

-(id) init:(OnSuccess) onSuccessBlock
setOnError:(OnError) onErrorBlock
setUSER_TOKEN:(NSString *) USER_TOKEN;

@end
